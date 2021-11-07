//
//  ConversationViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class ConversationViewController: UIViewController {

    
    @IBOutlet weak var NoConverstion: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var conversation = [Conversation]()
    var logInObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.layer.cornerRadius = 35
        tableview.clipsToBounds = true
        tableview.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
     
        // Do any additional setup after loading the view.
        validateAuth()
        fetchConversations()
        StartlistenForCoverstion()
        
        logInObserver = NotificationCenter.default.addObserver(forName: .DidLogInNotification, object: nil, queue: .main, using: {
            [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.StartlistenForCoverstion()
        })
       
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        logInObserver = NotificationCenter.default.addObserver(forName: .DidLogInNotification, object: nil, queue: .main, using: {
            [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.StartlistenForCoverstion()
        })

       }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           tableview.frame = view.bounds
       }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    func StartlistenForCoverstion() {
       
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        if let observer = logInObserver{
            NotificationCenter.default.removeObserver(observer)
        }
        DatabaseManger.shared.getAllConversations(for: uid, completion: { [weak self] result in
            switch result{
            case .success(let cov):
                guard !cov.isEmpty else {
                 
                    self?.NoConverstion.isHidden = false
                    print("there is no cinv")
                    return
                }
                print("cover")
                self?.conversation = cov
              
                self?.NoConverstion.isHidden = true
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
            case .failure(let error):
              
                self?.NoConverstion.isHidden = false
                debugPrint(error)
            }
            
        })
    }
    func validateAuth(){
      
       if Auth.auth().currentUser?.uid == nil{
        let desCV = storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
                    desCV.modalPresentationStyle = .fullScreen
                    present(desCV, animated: false, completion: nil)
        }
       
    }
    private func fetchConversations(){
           // fetch from firebase and either show table or label
        tableview.isHidden = false
      
       }
    
    
    @IBAction func didTapComposeButton(_ sender: UIBarButtonItem) {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            strongSelf.createNewConversation(result: result)
            
        
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated: true)
        tableview.isHidden = false

    }
    
    func createNewConversation(result : [String: String]){
        guard let name = result["name"],  let uid = result["uid"] else {
            return
        }
        let vc = ChatViewController(uid: uid, id:nil)
        vc.title = name
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
