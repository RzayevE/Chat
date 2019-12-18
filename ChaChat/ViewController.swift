//
//  ViewController.swift
//  ChaChat
//
//  Created by Elnur Rzayev on 10/1/18.
//  Copyright © 2018 Elnur Rzayev. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var ref : DatabaseReference!
    private var _refHandle : DatabaseHandle!
    var messages : [DataSnapshot]! = [DataSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        configureDatabase()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        LOGOUT
     /*  let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            print("Error Signing Out!")
        }*/
//        LOGIN
        if (Auth.auth().currentUser == nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "firebaseLoginViewController")
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    @IBAction func sendButton(_ sender: UIButton) {
        let data = [Constants.MessageFields.text: textField.text! as String]
        sendMessage(data: data)
        configureDatabase()
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            print("Error Signing Out!")
        }
        if (Auth.auth().currentUser == nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "firebaseLoginViewController")
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
        
    }
    
//    MESSAGING START
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let data = [Constants.MessageFields.text: textField.text! as String]
        sendMessage(data: data)
        print("Ended editing")
        configureDatabase()
        self.view.endEditing(true)
        return true
    }
    
    deinit {
        self.ref?.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    func configureDatabase(){
        ref = Database.database().reference()
        
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { (snapshot)->Void in
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    func sendMessage(data: [String: String]){
        var packet = data
        packet[Constants.MessageFields.dateTime] = Utilities().getDate()
        self.ref.child("messages").childByAutoId().setValue(packet)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let messageSnap : DataSnapshot! = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String, String>
        if let text = message[Constants.MessageFields.text] as String! {
            cell.textLabel?.text = text
        }
        if let subtext = message[Constants.MessageFields.dateTime]{
            cell.detailTextLabel?.text = subtext
        }
        textField.text = ""
        return cell
    }
//    MESSAGING END
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

}

