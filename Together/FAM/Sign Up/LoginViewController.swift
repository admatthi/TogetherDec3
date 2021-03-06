//
//  LoginViewController.swift
//  Together
//
//  Created by Alek Matthiessen on 11/8/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FBSDKCoreKit

class LoginViewController: UIViewController, UITextFieldDelegate     {

    @IBOutlet weak var header: UILabel!
    @IBAction func tapLogin(_ sender: Any) {
        
        login()
    }
    @IBAction func tapSignUp(_ sender: Any) {
        
        signup()
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
//                self.dismiss(animated: true, completion: {
//        
//                })
    }
    
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    
    func login() {
        
        var email = "\(emailtf.text!)"
        var password = "\(passwordtf.text!)"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                
                
                self.errorlabel.alpha = 1
                self.errorlabel.text = error.localizedDescription
                
                
                
                return
                
            } else {
                
                uid = (Auth.auth().currentUser?.uid)!
                
                let date = Date()
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yy"
                var todaysdate =  dateFormatter.string(from: date)
                
//
//                ref!.child("Users").child(uid).child("Purchased").child(selectedid).updateChildValues(["Title": "x"])
//            ref?.child("Users").child(uid).updateChildValues(["Email" : email, "Purchased" : true])
                
                
                self.queryforinfo()
            }
            
        }
        
    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var author2 = value?["Approved"] as? String {
                
                if author2 == "False" {
                    
                    self.queryforids()

                    DispatchQueue.main.async {
                        
                        //                    purchased = true
                        
                        self.performSegue(withIdentifier: "LoginToDiscover", sender: self)
                        
                    }
                    
                } else {
                    
                    isInfluencer = true
                    
                    
                    DispatchQueue.main.async {
                        
                        //                    purchased = true
                        
                        self.performSegue(withIdentifier: "LoginToInfluencer", sender: self)
                        
                    }
                        
                }
                
            } else {
                
            }
            
            
        })
        
    }
    
    @IBOutlet weak var errorlabel: UILabel!
    func signup() {
        
        
        var email = "\(emailtf.text!)"
        var password = "\(passwordtf.text!)"
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                
                self.errorlabel.alpha = 1
                self.errorlabel.text = error.localizedDescription
                self.login()
                return
                
            } else {
                
                uid = (Auth.auth().currentUser?.uid)!
                
//                ref!.child("Users").child(uid).child("Purchased").child(selectedid).updateChildValues(["Title": "x"])
                
                let date = Date()
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yy"
                var todaysdate =  dateFormatter.string(from: date)
                let thirtyDaysAfterToday = Calendar.current.date(byAdding: .day, value: +30, to: date)!
                let thirty = dateFormatter.string(from: thirtyDaysAfterToday)
                
//                self.addstaticbooks()
                ref?.child("Users").child(uid).updateChildValues(["Email" : email, "Password" : password, "Purchased" : true, "Approved" : "False"])
                
                
                
                
                DispatchQueue.main.async {
                    
//                    purchased = true
                    
                    self.performSegue(withIdentifier: "LoginToDiscover", sender: self)
                }
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func queryforids() {
        
        var functioncounter = 0
        
        ref?.child("Users").child(uid).child("Requested").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    myprojectids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    @IBOutlet weak var tapcreate: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.addCharacterSpacing()
        // Do any additional setup after loading the view.
        
        self.addLineToView(view: emailtf, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)

        self.addLineToView(view: passwordtf, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)

        
        ref = Database.database().reference()
        
        emailtf.delegate = self
        passwordtf.delegate = self
        emailtf.becomeFirstResponder()
        tapcreate.addTextSpacing(2.0)
//        tapcreate.layer.cornerRadius = 22.0
//        tapcreate.layer.masksToBounds = true
        
        errorlabel.alpha = 0
        
        FBSDKAppEvents.logEvent("LoginScreen")
        
        
    }
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
}

