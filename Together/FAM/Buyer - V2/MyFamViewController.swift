//
//  MyFamViewController.swift
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


var myprojectids = [String]()
var mydescriptions = [String:String]()
var myprogramnames = [String:String]()
var myprices = [String:String]()
var mytoppics = [String:UIImage]()
var mynames = [String:String]()
var myimages = [String:UIImage]()
var mypink = UIColor(red:0.96, green:0.10, blue:0.47, alpha:1.0)
var mysubscribers = [String:String]()
var unlockedid = String()

class MyFamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var errorlabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = mypink
        ref = Database.database().reference()
        
        headerlabel.addCharacterSpacing()


        if Auth.auth().currentUser == nil {
            // Do smth if user is not logged in
            
            
        tableView.alpha = 0
        errorlabel.alpha = 1
        activityIndicator.alpha = 0
            
        } else {
            
            
            activityIndicator.alpha = 1
            activityIndicator.startAnimating()
            errorlabel.alpha = 0
            
            if myprojectids.count == 0 {
                
            
            queryforids { () -> () in
                
                self.queryforids2 { () -> () in
                    
                    self.queryforinfo()
                    
                }
                
            }
                
            } else {
                
                selectedid = myprojectids[0]
                queryforhighlevelinfo()
                queryforids2 { () -> () in
                    
                    self.queryforinfo()
                    
                }
            
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
        var videotitles = [String:String]()
    
    func queryforhighlevelinfo() {
        
        ref?.child("Influencers").child(selectedid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var author2 = value?["Domain"] as? String {
                
                selectedshareurl = author2
                
            }
            
            if var author2 = value?["Subscribers"] as? String {
                
                selectedsubs = author2
                
            }
            
            if var author2 = value?["Name"] as? String {
                
                selectedname = author2
                
                
            }
            
            if var author2 = value?["Pitch"] as? String {
                
                selectedpitch = author2
                
            } else {
                
                selectedpitch = "This is where I'll be posting all my meal plans and workouts days before Instagram!"
            }
            
            if var profileUrl2 = value?["ProPic"] as? String {
                // Create a storage reference from the URL
                
                
                if profileUrl2 == "" {
                    
                    
                } else {
                    
                    
                    let url = URL(string: profileUrl2)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    selectedimage = UIImage(data: data!)!
//                    self.tableView.reloadData()
                    
                }
                
                
            }
            
            
        })
        
        
    }
        
    func queryforids2(completed: @escaping (() -> ()) ) {
        
        tableView.alpha = 0
        errorlabel.alpha = 1
        var functioncounter = 0
        
        
        videoids.removeAll()
        videolinks.removeAll()
        videodescriptions.removeAll()
        videotitles.removeAll()
        thumbnails.removeAll()
        videodates.removeAll()
        ref?.child("Influencers").child(selectedid).child("Plans").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                self.errorlabel.alpha = 0
                self.activityIndicator.alpha = 1
                for each in snapDict {
                    
                    let ids = each.key
                    
                    videoids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        videoids = videoids.sorted()
                        videoids = videoids.reversed()
                        
                        //                        self.posts.text = "\(videoids.count)"
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        for each in videoids {
            
            
            ref?.child("Influencers").child(selectedid).child("Plans").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var author2 = value?["URL"] as? String {
                    videolinks[each] = author2
                    
                    
                    
                }
                
                if var author2 = value?["Description"] as? String {
                    videodescriptions[each] = author2
                    
                }
                
                if var author2 = value?["Title"] as? String {
                    self.videotitles[each] = author2
                    
                }
                
            
                
                
                if var author2 = value?["Date"] as? String {
                    
                    videodates[each] = author2
                    
                }
                
                if var profileUrl = value?["Thumbnail"] as? String {
                    // Create a storage reference from the URL
                    
                    let url = URL(string: profileUrl)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    thumbnails[each] = UIImage(data: data!)
                    
                    functioncounter += 1
                }
                
                print(functioncounter)
                
                if var author2 = value?["Domain"] as? String {
                    
                    selectedshareurl = author2
                    
                }
                
                if functioncounter == videoids.count {
                    
                    self.tableView.reloadData()
                    
                }
                
                
            })
            
        }
    }


    func queryforids(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        tableView.alpha = 0
        errorlabel.alpha = 1
        activityIndicator.alpha = 0
        ref?.child("Users").child(uid).child("Requested").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    myprojectids.append(ids)

                    functioncounter += 1
                    myprojectids[0] = selectedid
                    self.queryforhighlevelinfo()
                    completed()

                    
                    
                }
                
            }
            
        })
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var subscribers = [String:String]()
    
 
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   
                
                //            selectedvideo = videolinks[videoids[indexPath.row]]!
                selectedvideoid = videoids[indexPath.row]
                selecteddate = videodates[videoids[indexPath.row]]!
                selectedtitle = videotitles[videoids[indexPath.row]]!
                //            selecteddaytitle = videodaytitles[videoids[indexPath.row]]!
                
                self.performSegue(withIdentifier: "VideoToWatch2", sender: self)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if thumbnails.count > 0 {
            
            return thumbnails.count
            
        } else {
            
            return 0
        }
        
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plans", for: indexPath) as! PlansTableViewCell
        
        //        cell.subscriber.tag = indexPath.row
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.thumbnail.layer.cornerRadius = 10.0
        cell.thumbnail.layer.masksToBounds = true
        //
        cell.selectionStyle = .none
        
        if thumbnails.count > indexPath.row {
            
                
                cell.titlelabel.alpha = 1
                cell.timeago.alpha = 1
                cell.name.alpha = 1
                
                cell.thumbnail.image = thumbnails[videoids[indexPath.row]]
                
                cell.titlelabel.text = videotitles[videoids[indexPath.row]]
                cell.timeago.text = videodates[videoids[indexPath.row]]
                cell.timeago.text = videodates[videoids[indexPath.row]]?.uppercased()
            
                tableView.alpha = 1
                errorlabel.alpha = 0
                activityIndicator.alpha = 0
            cell.profilepic.alpha = 1
            cell.thumbnail.alpha = 1
            
            cell.titlelabel.alpha = 1
            cell.timeago.alpha = 1
            cell.name.alpha = 1
            cell.profilepic.image = selectedimage
                cell.timeago.addCharacterSpacing()
                cell.name.text = selectedname.uppercased()
                cell.name.addCharacterSpacing()
            }
            
        

            
            //            cell.titlelabel.sizeToFit()
            //            cell.timeago.text = "\(videodaytitles[videoids[indexPath.row]]!)"
            
            //            cell.isUserInteractionEnabled = true
            
        
        
        return cell
        
        //            cell.layer.borderWidth = 1.0
        //            cell.layer.borderColor = UIColor.lightGray.cgColor
        //            cell.subscriber.addTarget(self, action: #selector(tapJoin(sender:)), for: .touchUpInside)
        
        
        
        
        
    }
}
