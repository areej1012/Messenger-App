//
//  NewConversationViewController.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import UIKit
import JGProgressHUD
import MessageKit

class NewConversationViewController: UIViewController  {
    var completion : (([String:String])-> (Void))?
    var users = [[String:String]]()
    var results = [[String:String]]()
    var isFetch = false
     let spinner = JGProgressHUD(style: .dark)
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users....."
        return searchBar
    }()
    
     let tableview : UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
   
     let NoResult : UILabel = {
        let result = UILabel()
        result.text = "No Results"
        result.textAlignment = .center
        result.textColor = .gray
        result.font = .systemFont(ofSize: 18, weight: .medium)
        result.isHidden = true
        return result
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addSubview(tableview)
        view.addSubview(NoResult)
        tableview.dataSource = self
        tableview.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        view.backgroundColor = .white
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
      
    }
    override func viewDidLayoutSubviews() {
        tableview.frame = view.bounds
        NoResult.frame = CGRect(x: view.frame.width / 4 , y: (view.frame.height-200), width: view.frame.width/2, height: 200)
    }
   @objc private  func dismissSelf(){
        dismiss(animated: true, completion: nil)
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
