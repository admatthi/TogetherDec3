//
//  VideoViewController.swift
//  Together
//
//  Created by Alek Matthiessen on 11/15/18.
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
import Purchases

var selecteddate = String()
var selectedvideoid = String()
var selecteddaytitle = String()

class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var attrs = [
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
    
    var attrs2 = [NSAttributedStringKey.font : UIFont(name: "AvenirNext-Bold", size: 17.0),
                  NSAttributedStringKey.foregroundColor : UIColor.black] as [NSAttributedStringKey : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    var attributedString2 = NSMutableAttributedString(string:"")
    
    var purchases = RCPurchases(apiKey: "FGJnVYVvOyPbLGjantsVNfffhvDwnyGz")

    @IBAction func tapBuy(_ sender: Any) {
        
        FBSDKAppEvents.logEvent("Trial Pressed")
        
        purchases.entitlements { entitlements in
            guard let pro = entitlements?["Subscriptions"] else { return }
            guard let monthly = pro.offerings["Monthly"] else { return }
            guard let product = monthly.activeProduct else { return }
            self.purchases.makePurchase(product)
            
            
        }
        
//        ref?.child("Users").child(uid).child("Requested").child(selectedid).updateChildValues(["Title" : "x"])
    }
    
    @IBOutlet weak var dahkness: UIImageView!
    @IBAction func tapTerms(_ sender: Any) {
        
        if let url = NSURL(string: "https://938152110718650409.weebly.com/privacy-policy.html"
            ) {
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        if linkedin {
            
            self.performSegue(withIdentifier: "VideoToExplore", sender: self)
            
        } else {
            
                self.dismiss(animated: true, completion: {
        
                })
            
        }
    }
    @IBOutlet weak var tapback: UIButton!
    
    @IBAction func tapCircle(_ sender: Any) {
        
        if locked {
            
            self.performSegue(withIdentifier: "VideoToPurchase", sender: self)
            
        } else {
            
            
        }
    }
    @IBAction func tapSubscribe(_ sender: Any) {
        
        if locked {
            
            self.performSegue(withIdentifier: "VideoToPurchase", sender: self)

        } else {
            
            
        }
    }
    @IBOutlet weak var tapcircle: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var subscribers: UILabel!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var monthlabel: UILabel!
    @IBOutlet weak var subscriblabel: UILabel!
    @IBOutlet weak var postlabel: UILabel!
    @IBOutlet weak var tapsubscribe: UIButton!
    @IBOutlet weak var programname: UILabel!
    @IBOutlet weak var lockimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tapsubscribe.layer.masksToBounds = true
//        tapsubscribe.layer.cornerRadius = 5.0
//
//        subscriblabel.addCharacterSpacing()
//        postlabel.addCharacterSpacing()
        
        
        lowercasename = selectedname

        tapbuy.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.25)
        tapbuy.layer.borderColor = UIColor.white.cgColor
        tapbuy.layer.borderWidth = 2.0
        tapbuy.layer.cornerRadius = 22.0
        tapbuy.layer.masksToBounds = true
        
        
        tapterms.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        let buttonTitleStr = NSMutableAttributedString(string:"By continuing, you accept our Terms of Use & Privacy Policy", attributes:attrs)
        attributedString.append(buttonTitleStr)
        tapterms.setAttributedTitle(attributedString, for: .normal)
        tapterms.setTitleColor(.black, for: .normal)
        queryforname()

        if linkedin  {
            
            tapback.alpha = 0
            

        } else {
            
            tapback.alpha = 1
            selectedname = selectedname.uppercased()

        }
        
        collectionView.layer.cornerRadius = 5.0
        collectionView.layer.masksToBounds = true
        tapsubscribe.addTextSpacing(2.0)
        
        activityIndicator.color = mypink

        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
        hide()
        collectionView.alpha = 0
        errorlabel.alpha = 0
        programname.text = selectedname
        programname.addCharacterSpacing()
        programname.sizeToFit()
        

        //        collectionView.rowHeight = UICollectionViewAutomaticDimension
        
        //        cta.text = "Join \(firstname)'s FAM"
        
        locked = true

        
        ref = Database.database().reference()
        
        queryforids { () -> () in
            
            self.queryforinfo()
            
        }
        if Auth.auth().currentUser == nil {
            // Do smth if user is not logged in
//            collectionView.isUserInteractionEnabled = false
            locked = true
            tapbuy.alpha = 1
            tapterms.alpha = 1
            taptermsbs.alpha = 1
            dahkness.alpha = 1
            
        } else {
         
        
            if uid == selectedid || myprojectids.contains(selectedid)  || selectedid == unlockedid  {
                
//                collectionView.isUserInteractionEnabled = true
                locked = false
                tapbuy.alpha = 0
                tapterms.alpha = 0
                taptermsbs.alpha = 0
                dahkness.alpha = 0
       
            } else {
                
                locked = true
                tapbuy.alpha = 1
                tapterms.alpha = 1
                taptermsbs.alpha = 1
                dahkness.alpha = 1
                
            }
            
//            queryforpurchased()
            
        }
        
        
        collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func hide() {
        
        tapbuy.alpha = 0
        tapterms.alpha = 0
        taptermsbs.alpha = 0
   
    }
    
    func show() {
        
        tapbuy.alpha = 1
        tapterms.alpha = 1
        taptermsbs.alpha = 1

    }
    
  
    @IBOutlet weak var tapbuy: UIButton!
    @IBOutlet weak var tapterms: UIButton!
    
    @IBOutlet weak var taptermsbs: UILabel!
    func queryforids(completed: @escaping (() -> ()) ) {
        
        collectionView.alpha = 0
        errorlabel.alpha = 1
        activityIndicator.alpha = 0
        show()
        var functioncounter = 0
        
        
        videoids.removeAll()
        videolinks.removeAll()
        videodescriptions.removeAll()
        videotitles.removeAll()
        thumbnails.removeAll()
        videodates.removeAll()
        videodaytitles.removeAll()
        ref?.child("Influencers").child(selectedid).child("Plans").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                self.errorlabel.alpha = 0
                self.activityIndicator.alpha = 1
                self.hide()
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
    
    @IBOutlet weak var lilthumbnail: UIImageView!
    func queryforname() {
        
        ref?.child("Influencers").child(selectedid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var author2 = value?["Name"] as? String {
                selectedname = author2
                lowercasename = author2
                selectedname = selectedname.uppercased()
                self.programname.text = selectedname
                self.programname.addCharacterSpacing()
                
            }
            
            
            if var profileUrl2 = value?["ProPic"] as? String {
                // Create a storage reference from the URL
                
                var sup = ""
                
                if profileUrl2 == "" {
                    
                    self.lilthumbnail.alpha = 0
                    
                } else {
                    
                    let url = URL(string: profileUrl2)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    selectedimage = UIImage(data: data!)!
                    
                    
                }
                
                
            }
            
            if var author2 = value?["Domain"] as? String {
                
                selectedshareurl = author2
                
            }
            
            if var author2 = value?["Price"] as? String {
                
                self.tapbuy.setTitle("Buy Now ($50)", for: .normal)
                
                self.taptermsbs.text = "Account will be charged for renewal within 24-hours prior to the end of the current period for $50. Payment will be charged to iTunes Account at confirmation of purchase. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable To learn more, check out our terms of use."
                
            }
            
            if var author2 = value?["Subscribers"] as? String {
                
                selectedsubs = author2
                
            }
            
            if var author2 = value?["Pitch"] as? String {
                
                selectedpitch = author2
                
            } else {
                
                selectedpitch = "This is where I'll be posting all my meal plans and workouts days before Instagram!"
            }
            
        })
        
    }
    
    var videotitles = [String:String]()
    var videodaytitles = [String:String]()
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
                
                if var author2 = value?["DayTitle"] as? String {
                    self.videodaytitles[each] = author2
                    
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
                    
                    self.collectionView.reloadData()
                    
                }
                
                
            })
            
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    /*
     @IBOutlet weak var collectionView: UICollectionView!
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            
            thumbnails[url] = thumbnail
            
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if locked {
            

        } else {
                
//            selectedvideo = videolinks[videoids[indexPath.row]]!
            selectedvideoid = videoids[indexPath.row-1]
            selecteddate = videodates[videoids[indexPath.row-1]]!
            selectedtitle = videotitles[videoids[indexPath.row-1]]!
//            selecteddaytitle = videodaytitles[videoids[indexPath.row]]!
            
        self.performSegue(withIdentifier: "VideoToWatch", sender: self)
         
        }
        
        
    }
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if thumbnails.count > 0 {
            
        return thumbnails.count
            
    } else {
            
        return 0
    }
        
    
    }
    
    @IBOutlet weak var errorlabel: UILabel!
    
    @IBAction func tapShare(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Share This Profile", style: .default, handler: { action in
            switch action.style{
            case .default:
                
                let text = "\(selectedname) on FAM"
                
                var image = UIImage()
                if thumbnails.count > 0 {
                    
                    image = thumbnails[videoids[0]]!
                    
                } else {
                    
                    image = UIImage(named: "FamLogo")!
                    
                }
                let myWebsite = NSURL(string: selectedshareurl)
                let shareAll : Array = [myWebsite] as [Any]
                
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                
                activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.saveToCameraRoll, UIActivityType.assignToContact]
                
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        present(alert, animated: true)
        

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "People", for: indexPath) as! PeopleCollectionViewCell
        //        cell.subscriber.tag = indexPath.row

        
        cell.authorname.addCharacterSpacing()
        
        
        //        cell.subscriber.tag = indexPath.row
        
        //        cell.pricelabel.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        //        cell.pricelabel.layer.cornerRadius = 5.0
        //        cell.pricelabel.layer.masksToBounds = true
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.thumbnail.layer.cornerRadius = 10.0
        cell.thumbnail.layer.masksToBounds = true
//
        if thumbnails.count > indexPath.row{
            
            
                cell.thumbnail.image = thumbnails[videoids[indexPath.row]]
                
                cell.textlabel.text = videotitles[videoids[indexPath.row]]
//                cell.timeago.text = videodates[videoids[indexPath.row]]
//                cell.timeago.text = videodates[videoids[indexPath.row]]?.uppercased()
            
            cell.authorname.text = "DAY \(indexPath.row+1)"
            }
            
            collectionView.alpha = 1
            errorlabel.alpha = 0
            activityIndicator.alpha = 0
            show()
        
            
//            cell.titlelabel.sizeToFit()
//            cell.timeago.text = "\(videodaytitles[videoids[indexPath.row]]!)"

//            cell.isUserInteractionEnabled = true
        
        if locked {
            
            if indexPath.row == 0 {
                
//                cell.lockimage.alpha = 1
//                cell.lockimage.image = UIImage(named: "Play")

            } else {
                
                cell.lockimage.alpha = 1
                cell.lockimage.image = UIImage(named: "Lock")
            }
          
            
        } else {
            
            
            if indexPath.row == 0 {
                
                cell.lockimage.alpha = 0
                
            } else {
                
                cell.lockimage.alpha = 1

            }

            cell.lockimage.image = UIImage(named: "Play")
            tapbuy.alpha = 0
            tapterms.alpha = 0
            taptermsbs.alpha = 0
            dahkness.alpha = 0
            
        }
        
        cell.authorname.addCharacterSpacing()
            return cell
        
            //            cell.layer.borderWidth = 1.0
            //            cell.layer.borderColor = UIColor.lightGray.cgColor
            //            cell.subscriber.addTarget(self, action: #selector(tapJoin(sender:)), for: .touchUpInside)
            
   
    
        
        
    }
//
//    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.row == 0 {
//
//            return 200
//
//        } else {
//
//            return UICollectionViewAutomaticDimension
//        }
//    }
    var buttonspressedup = [String:String]()
    
    @objc func tapJoin(sender: UIButton){
        
        let buttonTag = sender.tag
        
        
        self.performSegue(withIdentifier: "SaleToBuy", sender: self)
    }
    
    @objc func tapDown(sender: UIButton){
        let buttonTag = sender.tag
        
        
        //            collectionView.reloadData()
    }
    
}


