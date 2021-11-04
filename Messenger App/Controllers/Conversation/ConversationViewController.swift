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

    

    @IBOutlet weak var tableview: UITableView!
    var conversation = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
      
        // Do any additional setup after loading the view.
        validateAuth()
        fetchConversations()
        print("ViewdidLoad")
        StartlistenForCoverstion()
        
       
       
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        print("viewdidAppear")
        
            
          
        
       }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           tableview.frame = view.bounds
       }

    
    func StartlistenForCoverstion() {
       
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        DatabaseManger.shared.getAllConversations(for: uid, completion: { [weak self] result in
            switch result{
            case .success(let cov):
                guard !cov.isEmpty else {
                  
                    self!.tableview.isHidden = true
                    return
                }
                print("cover")
                self?.conversation = cov
                
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
            case .failure(let error):
                self!.tableview.isHidden = true
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
            print("\(result)")
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated: true)
        tableview.isHidden = false

    }
    
    func createNewConversation(result : [String: String]){
        guard let name = result["name"], let email = result["email"] , let uid = result["uid"] else {
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
