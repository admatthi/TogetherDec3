//
//  EditProfileViewController.swift
//  Together
//
//  Created by Alek Matthiessen on 11/12/18.
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

var thumbnailurls = [String:String]()
var selectedthumbnailurl = String()
var selectedvideourl = String()
var thumbnails = [String:UIImage]()

var selectedshareurl = String()

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    @IBOutlet weak var lilthumbnail: UIImageView!
    @IBOutlet weak var programname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorlabel.alpha = 1
        tableView.alpha = 0
        lowercasename = selectedname
        selectedid = uid

  
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        queryforhighlevelinfo()

        dateFormatter.dateFormat = "MMM dd"
        thumbnails.removeAll()


        thisdate = dateFormatter.string(from: date)
        
        
//        locked = true
        
        if uid == selectedid {
            
            locked = false
        }
        
        selectedprogramname = selectedprogramname.uppercased()
        
        programname.text = selectedname.uppercased()
        programname.addCharacterSpacing()
        programname.sizeToFit()
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        //        cta.text = "Join \(firstname)'s FAM"
        
        ref = Database.database().reference()
        
//        queryforpersonalinfo()
//
//        queryforids { () -> () in
//
//            self.queryforinfo()
//
//        }
        
        locked = false
       
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(EditProfileViewController.refresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor  = mypink
        tableView.addSubview(refreshControl)
        
        activityIndicator.alpha = 1
        activityIndicator.color = mypink
        activityIndicator.startAnimating()
        //
     
        
        queryforids { () -> () in
            
            self.queryforinfo()
            
        }
        //
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()

    @objc func refresh() {
        // Code to refresh table view
        
        videodates.removeAll()
        videoids.removeAll()
                videolinks.removeAll()
        videodescriptions.removeAll()
        videotitles.removeAll()
        thumbnails.removeAll()
        thumbnailurls.removeAll()
        videodaytitles.removeAll()
        tableView.alpha = 0
        activityIndicator.alpha = 1
        activityIndicator.color = mypink
        activityIndicator.startAnimating()
        
        
        queryforids { () -> () in
            
            self.queryforinfo()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

//        if thumbnails.count ==  1 {
//
//            tableView.alpha = 1
//            activityIndicator.alpha = 0
//            activityIndicator.stopAnimating()
//            tableView.reloadData()
//
//        } else {
//
//            if thumbnails["0"] == nil {
//
//                 queryforhighlevelinfo()

//            }
        
//            tableView.alpha = 0
    
//        }
        
      
        
    }
    
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var subs: UILabel!
    func queryforhighlevelinfo() {
        
        ref?.child("Influencers").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var author2 = value?["Domain"] as? String {
                
                selectedshareurl = author2
                
            }
            
            if var author2 = value?["Subscribers"] as? String {
                
                selectedsubs = author2
                
            }
            
            if var author2 = value?["Name"] as? String {
                
                selectedname = author2
                self.programname.text = selectedname.uppercased()
                self.programname.addCharacterSpacing()
                self.programname.sizeToFit()

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
                    
                    
                }
                
                
            }
            
            
        })
        
        
    }
    
    @IBOutlet weak var errorlabel: UILabel!
    @IBOutlet weak var subslabel: UILabel!
    
    @IBOutlet weak var postslabel: UILabel!
    func queryforids(completed: @escaping (() -> ()) ) {
        
        activityIndicator.alpha = 0
        tableView.alpha = 0
        errorlabel.alpha = 1
        
        var functioncounter = 0
        
        videoids.removeAll()
        videolinks.removeAll()
        videodescriptions.removeAll()
        videotitles.removeAll()
        thumbnails.removeAll()
        videodaytitles.removeAll()
        
        ref?.child("Influencers").child(uid).child("Plans").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                self.activityIndicator.alpha = 1
                self.errorlabel.alpha = 0
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    videoids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
                        
                        
                        videoids = videoids.sorted()
                        videoids = videoids.reversed()
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    
   
                
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var videotitles = [String:String]()
    func queryforinfo() {
        
        var functioncounter = 0
        
        for each in videoids {
            ref?.child("Influencers").child(uid).child("Plans").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var author2 = value?["URL"] as? String {
                    videolinks[each] = author2
                    
                
                }
                
                if var author2 = value?["Description"] as? String {
                    videodescriptions[each] = author2
                    
                }
                
                if var author2 = value?["ProgramName"] as? String {
                    self.programname.text = author2
                    selectedprogramname = author2
                    self.programname.addCharacterSpacing()
                }
                
              
                
                if var author2 = value?["DayTitle"] as? String {
                    self.videodaytitles[each] = author2
                    
                }
                if var author2 = value?["Times"] as? String {
                    videotimes[each] = author2
                    
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
                    thumbnailurls[each] = profileUrl
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    thumbnails[each] = UIImage(data: data!)
                    
                    functioncounter += 1
                }
                
                print(functioncounter)
                
                
                
                if functioncounter == videoids.count {
                    
          
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
    
//    override func viewDidDisappear(_ animated: Bool) {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Plans", for: indexPath) as! PlansTableViewCell
//
//        cell.playerView.player?.pause()
//
////    }
//    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
//        let asset = AVAsset(url: URL(string: url)!)
//        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
//        assetImgGenerate.appliesPreferredTrackTransform = true
//        //Can set this to improve performance if target size is known before hand
//        //assetImgGenerate.maximumSize = CGSize(width,height)
//        let time = CMTimeMakeWithSeconds(1.0, 600)
//        do {
//            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
//            let thumbnail = UIImage(cgImage: img)
//
//            thumbnails[url] = thumbnail
//
//            return thumbnail
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if indexPath.row == 0 {
//
//            selectedtitle = "Welcome!"
//            selectedthumbnailurl = thumbnailurls["0"]!
//            selectedvideourl = videolinks["0"]!
//            self.performSegue(withIdentifier: "EditToPurchase", sender: self)
//
//        } else {
        
//            selectedthumbnailurl = thumbnailurls[videoids[indexPath.row-1]]!
//            selectedvideo = videolinks[videoids[indexPath.row]]!
        
        if indexPath.row != 0 {
            selectedvideoid = videoids[indexPath.row-1]
            selectedtitle = videotitles[videoids[indexPath.row-1]]!
//            selecteddaytitle = videodaytitles[videoids[indexPath.row]]!
        selecteddate = videodates[videoids[indexPath.row-1]]!

            self.performSegue(withIdentifier: "EditToWatch", sender: self)
            
        } else {
            
            
        }
//        }
        
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if thumbnails.count > 0 {
            
            return thumbnails.count+1
            
        } else {
            
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 200
            
        } else {
            
            return UITableViewAutomaticDimension
        }
    }
    
    var videodaytitles = [String:String]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plans", for: indexPath) as! PlansTableViewCell
        
        //        cell.subscriber.tag = indexPath.row
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.thumbnail.layer.cornerRadius = 10.0
        cell.thumbnail.layer.masksToBounds = true
        //
        cell.selectionStyle = .none
        
        if thumbnails.count > indexPath.row-1{

            if indexPath.row == 0 {
                
                cell.bigpic.alpha = 1
                cell.postslabel.alpha = 1
                cell.sublabel.alpha = 1
                cell.pitch.alpha = 1
                
                cell.thumbnail.alpha = 0
                
                cell.titlelabel.alpha = 0
                cell.timeago.alpha = 0
                cell.name.alpha = 0
                cell.lockimage.alpha = 0
                cell.profilepic.alpha = 0
                
            } else {
                
                cell.bigpic.alpha = 0
                cell.postslabel.alpha = 0
                cell.sublabel.alpha = 0
                cell.pitch.alpha = 0
                cell.lockimage.alpha = 1
                cell.profilepic.alpha = 1
                cell.thumbnail.alpha = 1
                
                cell.titlelabel.alpha = 1
                cell.timeago.alpha = 1
                cell.name.alpha = 1
                
                cell.thumbnail.image = thumbnails[videoids[indexPath.row-1]]
                
                cell.titlelabel.text = videotitles[videoids[indexPath.row-1]]
                cell.timeago.text = videodates[videoids[indexPath.row-1]]
                cell.timeago.text = videodates[videoids[indexPath.row-1]]?.uppercased()
            }
            
            tableView.alpha = 1
            errorlabel.alpha = 0
            activityIndicator.alpha = 0
    
            cell.timeago.addCharacterSpacing()
            cell.name.text = selectedname.uppercased()
            cell.name.addCharacterSpacing()
            cell.profilepic.image = myselectedimage
            cell.bigpic.image = myselectedimage
            cell.pitch.text = selectedpitch
            refreshControl.endRefreshing()
            cell.postslabel.text = String(videoids.count)

            //            cell.titlelabel.sizeToFit()
            //            cell.timeago.text = "\(videodaytitles[videoids[indexPath.row]]!)"
            
            //            cell.isUserInteractionEnabled = true
            
            
        } else {
            
            tableView.alpha = 0
            
        }
        
        cell.lockimage.image = UIImage(named: "Play")

        cell.plabel.addCharacterSpacing()
        cell.slabel.addCharacterSpacing()
        return cell
        
        //            cell.layer.borderWidth = 1.0
        //            cell.layer.borderColor = UIColor.lightGray.cgColor
        //            cell.subscriber.addTarget(self, action: #selector(tapJoin(sender:)), for: .touchUpInside)
        
        
        
        
        
    }
    
    @objc func tapDown(sender: UIButton){
        
      self.performSegue(withIdentifier: "EditToUpload", sender: self)
        
        
    }
    
    
    
    @objc func tapStory(sender: UIButton){
        
        selectedid = uid
        
        self.performSegue(withIdentifier: "InfluencerToPurchase", sender: self)
        
    }
    
    
    @IBAction func tapLogout(_ sender: Any) {
        
//        try! Auth.auth().signOut()
//
//        self.performSegue(withIdentifier: "Logout5", sender: self)
       
    }
}
