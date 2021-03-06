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

class MyFamViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var errorlabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = mypink
        ref = Database.database().reference()
        
        headerlabel.addCharacterSpacing()


        if Auth.auth().currentUser == nil {
            // Do smth if user is not logged in
            
            
        collectionView.alpha = 0
        errorlabel.alpha = 1
        activityIndicator.alpha = 0
            
        } else {
            
            
            activityIndicator.alpha = 1
            activityIndicator.startAnimating()
            errorlabel.alpha = 0
            
            queryforids { () -> () in
                
                self.queryforinfo()
                
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
        var videotitles = [String:String]()
    

    
 

  
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var subscribers = [String:String]()
    
 
    func queryforids(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        
        myprojectids.removeAll()
        mydescriptions.removeAll()
        mynames.removeAll()
        myprogramnames.removeAll()
        myprices.removeAll()
        mytoppics.removeAll()
        myimages.removeAll()
        mysubscribers.removeAll()
        
        collectionView.alpha = 0
        errorlabel.alpha = 1
        activityIndicator.alpha = 0
        ref?.child("Users").child(uid).child("Requested").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    myprojectids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        for each in myprojectids {
            
            
            ref?.child("Influencers2").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var author2 = value?["Subscribers"] as? String {
                    mysubscribers[each] = author2
                    
                }
                
                if var name = value?["Channel Name"] as? String {
                    myprogramnames[each] = name
                    
                }
                
                if var name = value?["Name"] as? String {
                    mynames[each] = name
                    
                }
                
                if var views = value?["Price"] as? String {
                    myprices[each] = views
                    
                }
                
                
                
                
                if var profileUrl = value?["ProPic"] as? String {
                    // Create a storage reference from the URL
                    
                    let url = URL(string: profileUrl)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    selectedimage = UIImage(data: data!)!
                    
                    myimages[each] = selectedimage
                    
                    functioncounter += 1
                    
                }
                
                
                
                print(functioncounter)
                
                
                
                if functioncounter == myprojectids.count {
                    
                    self.activityIndicator.alpha = 0
                    self.activityIndicator.stopAnimating()
                    self.errorlabel.alpha = 0
                    self.collectionView.alpha = 1
                    self.collectionView.reloadData()
                    
                }
                
                
            })
            
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedid = myprojectids[indexPath.row]
        myselectedimage = myimages[myprojectids[indexPath.row]]!
        selectedname = mynames[myprojectids[indexPath.row]]!
        //        selectedprogramnames = programnames[projectids[indexPath.row]]!
        
            self.performSegue(withIdentifier: "MyFamToVideo", sender: self)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if myimages.count > 0 {
            
            return myimages.count
            
        } else {
            
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "People", for: indexPath) as! PeopleCollectionViewCell
        
        //        cell.subscriber.tag = indexPath.row
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        
        if myimages.count > indexPath.row && mynames.count > indexPath.row{
            
            
            //            cell.layer.borderWidth = 1.0
            //            cell.layer.borderColor = UIColor.lightGray.cgColor
            //            cell.subscriber.addTarget(self, action: #selector(tapJoin(sender:)), for: .touchUpInside)
            
            cell.thumbnail.layer.cornerRadius = 10.0
            cell.thumbnail.layer.masksToBounds = true
            cell.textlabel.text = myprogramnames[myprojectids[indexPath.row]]
            cell.authorname.text = mynames[myprojectids[indexPath.row]]?.uppercased()
            cell.authorname.addCharacterSpacing()
            
            cell.thumbnail.image = myimages[myprojectids[indexPath.row]]
//            cell.subscribers.text = "\(mysubscribers[myprojectids[indexPath.row]]!) subscribers"
            
            
            
            
        } else {
            
            
        }
        
        
        return cell
    }
}
