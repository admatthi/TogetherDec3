//
//  AboutViewController.swift
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
import AVFoundation

var headlines = [String:String]()
var responses2 = [String:String]()
var aboutids = [String]()

class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var programname: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension

        //        cta.text = "Join \(firstname)'s FAM"
        
        ref = Database.database().reference()
        
        programname.text = selectedprogramname
        
//        profilepic.layer.masksToBounds = false
//        profilepic.layer.cornerRadius = profilepic.frame.height/2
//        profilepic.clipsToBounds = true
        
        queryforids { () -> () in
            
            self.queryforinfo()
            
        }
        // Do any additional setup after loading the view.
    }
    
    func queryforids(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        
        responses2.removeAll()
        headlines.removeAll()
        aboutids.removeAll()
        
        ref?.child("Influencers").child(selectedid).child("About").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    aboutids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        aboutids.sort()
                        
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        for each in aboutids {
            
            
            ref?.child("Influencers").child(selectedid).child("About").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var author2 = value?["Headline"] as? String {
                    headlines[each] = author2
                    
                }
                
                if var author2 = value?["Response"] as? String {
                    responses2[each] = author2
                    
                }
                
                functioncounter += 1
                
                print(functioncounter)
                
                
                
                if functioncounter == aboutids.count {
                    
                    self.tableView.reloadData()
                    
                }
                
                
            })
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if responses2.count > 0 {
            
            return responses2.count+1
            
        } else {
            
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "About", for: indexPath) as! AboutTableViewCell
        
        if responses2.count > indexPath.row-1 {
            
            if indexPath.row == 0 {
                
//                cell.pitch.text = ""
                cell.headline.alpha = 1
                cell.longdescription.alpha = 1
                cell.tapjoin2.alpha = 0
                cell.headline.text = headlines[aboutids[indexPath.row]]
                
                cell.longdescription.text = responses2[aboutids[indexPath.row]]
                
                
            } else {
                
                if indexPath.row == responses2.count{
                    

                    cell.headline.alpha = 1
                    cell.longdescription.alpha = 1
                    
                    cell.headline.alpha = 0
                    cell.longdescription.alpha = 0
                    cell.tapjoin2.alpha = 1
                    
                } else {
                
//                    cell.pitch.text = ""

                cell.headline.alpha = 1
                cell.longdescription.alpha = 1
                cell.tapjoin2.alpha = 0
                cell.headline.text = headlines[aboutids[indexPath.row]]
                
                cell.longdescription.text = responses2[aboutids[indexPath.row]]
                
                }
            }
        } else {
            
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
            return UITableViewAutomaticDimension
            
    }
    
}

var selectedpitch = String()
var selectedsubs = String()
