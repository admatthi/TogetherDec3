//
//  WatchViewController.swift
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
import AVKit

var lowercasename = String()

class WatchViewController: UIViewController {
    @IBAction func tapBack(_ sender: Any) {
        
        
                self.dismiss(animated: true, completion: {
        
                })
        
    }
    
    @IBOutlet weak var influencername: UILabel!
    @IBOutlet weak var playerView: PlayerViewClass!

    @IBOutlet weak var tapwelcome: UIButton!
    @IBOutlet weak var profileimage: UIImageView!
    
    @IBAction func tapWelcome(_ sender: Any) {
        
        let alert = UIAlertController(title: "Make Welcome Video?", message: "Are you sure you'd like to make this your welcome video?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
                //                self.playerView.player?.pause()
               
                ref?.child("Influencers").child(selectedid).updateChildValues(["ProPic" : selectedthumbnailurl, "Purchase" : selectedvideo])

                
                ref?.child("Influencers").child(selectedid).child("Plans").child(selectedvideoid).removeValue()

                ref!.child("Influencers").child(selectedid).child("Plans").childByAutoId().updateChildValues(["Date" : thisdate, "Thumbnail" : thumbnailurls["0"], "Title" : "", "URL" : videolinks["0"]])
                
                self.performSegue(withIdentifier: "WatchToNav", sender: self)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var tapdelete: UIButton!
    var counter = 0
    var vids = [String:URL]()
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBAction func tapRight(_ sender: Any) {
        
 
        tapnext()
        
    }
    @IBAction func tapLeft(_ sender: Any) {
        
    
         tapleft()
    }
    
    func showcounter() {
        
        if counter == 0 {
            
            b1.image = UIImage(named: "FullFill")
            b2.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
        }
        
        if counter == 1 {
            
            b2.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
        }
        
        
        if counter == 2 {
            
            b3.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
        }
        
        if counter == 3 {
            
            b4.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
            
        }
        
        if counter == 4 {
            
            b5.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
            
        }
        
        if counter == 5 {
            
            b6.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
            
        }
        
        if counter == 6 {
            
            b7.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
            
        }
        
        if counter == 7 {
            
            b8.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
            b9.image = UIImage(named: "HalfFill")
        }
        
        if counter == 8 {
            
            b9.image = UIImage(named: "FullFill")
            b1.image = UIImage(named: "HalfFill")
            b2.image = UIImage(named: "HalfFill")
            b4.image = UIImage(named: "HalfFill")
            b5.image = UIImage(named: "HalfFill")
            b6.image = UIImage(named: "HalfFill")
            b7.image = UIImage(named: "HalfFill")
            b8.image = UIImage(named: "HalfFill")
            b3.image = UIImage(named: "HalfFill")
        }
        
        if counter >= 9 {
            
            
        }
        
    }

    @IBOutlet weak var lilimage: UIButton!
    
    @IBOutlet weak var name: UILabel!
    func showcount() {
        
            if vidids.count == 0 {
                
                b1.alpha = 0
                b2.alpha = 0
                b3.alpha = 0
                b4.alpha = 0
                b5.alpha = 0
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0

            }
            
            if vidids.count == 1 {
                b1.alpha = 0
                b2.alpha = 0
                b3.alpha = 0
                b4.alpha = 0
                b5.alpha = 0
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
       
            }
            
            
            if vidids.count == 2 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 0
                b4.alpha = 0
                b5.alpha = 0
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
            }
            
            if vidids.count == 3 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 0
                b5.alpha = 0
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
            }
            
            if vidids.count == 4 {
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 0
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
                
            }
            
            if vidids.count == 5 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 1
                b6.alpha = 0
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
            }
            
            if vidids.count == 6 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 1
                b6.alpha = 1
                b7.alpha = 0
                b8.alpha = 0
                b9.alpha = 0
                
            }
            
            if vidids.count == 7 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 1
                b6.alpha = 1
                b7.alpha = 1
                b8.alpha = 0
                b9.alpha = 0
            }
            
            if vidids.count == 8 {
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 1
                b6.alpha = 1
                b7.alpha = 1
                b8.alpha = 1
                b9.alpha = 0
                
            }
            
            if vidids.count >= 9 {
                
                
                b1.alpha = 1
                b2.alpha = 1
                b3.alpha = 1
                b4.alpha = 1
                b5.alpha = 1
                b6.alpha = 1
                b7.alpha = 1
                b8.alpha = 1
                b9.alpha = 1
            }
    }
    
    func tapnext() {
        
        playerView.player?.pause()
        playerView.slideInFromRight()
        if counter < vids.count-1 {
            
            playerView.player!.replaceCurrentItem(with: nil)

            print(counter)
            
            counter += 1
            
//            let progress = (Float(counter)/Float(vids.count-1))
//            self.progressView.setProgress(Float(progress), animated:true)
            
            showcounter()
            
            
//            self.tv3.text = textviewdics[vidids[counter]]
//
//            if textviewdics[vidids[counter]] != " " {
//
//                tv3.alpha = 1
//
//            } else {
//
//                tv3.alpha = 0
//            }
            
            let playerVC = AVPlayerViewController()
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:vids[vidids[counter]]!))
            
            
            self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
            
            self.playerView.playerLayer.player = self.avPlayer
            
            self.playerView.player?.play()
            
            
        }
        
        
    }
    
    func tapleft() {
        
        playerView.player?.pause()

        playerView.slideInFromLeft()
        if counter > 0 && vids.count > 0 {
            
            counter -= 1
            
//            self.tv3.text = textviewdics[vidids[counter]]
//
//            if textviewdics[vidids[counter]] != " " {
//
//                tv3.alpha = 1
//
//            } else {
//
//                tv3.alpha = 0
//            }
            showcounter()

            playerView.player!.replaceCurrentItem(with: nil)

            let playerVC = AVPlayerViewController()
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:vids[vidids[counter]]!))
            
            let progress = (Float(counter)/Float(vids.count-1))
            self.progressView.setProgress(Float(progress), animated:true)
            self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
            
            self.playerView.playerLayer.player = self.avPlayer
            
            self.playerView.player?.play()
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        playerView.player!.replaceCurrentItem(with: nil)

        if playerView.player?.isPlaying == true {
            
            playerView.player?.pause()
            
            NotificationCenter.default.removeObserver(Notification.Name.AVPlayerItemDidPlayToEndTime)
        }
    }
    
    @IBAction func tapDelete(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you'd like to remove this video?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
//                self.playerView.player?.pause()
 ref?.child("Influencers").child(selectedid).child("Plans").child(selectedvideoid).removeValue()

            self.performSegue(withIdentifier: "WatchToNav", sender: self)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var videotitle: UILabel!
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
            print("done")
            
            self.playerView.player?.play()
            
        }
        
    }
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    var avPlayer = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelabel.text = selectedtitle
//        titlelabel.sizeToFit()

        datelabel.text = selecteddate.uppercased()
        datelabel.addCharacterSpacing()
        textviewdics.removeAll()
        showcounter()
        vids.removeAll()
        lilimage.setBackgroundImage(selectedimage, for: .normal)
        name.text = selectedname.uppercased()
        name.addCharacterSpacing()
//        name.sizeToFit()
        
        lilimage.layer.masksToBounds = false
        lilimage.layer.cornerRadius = lilimage.frame.height/2
        lilimage.clipsToBounds = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(WatchViewController.playerItemDidReachEnd),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
//        tv3.textAlignment = .center

        
        ref = Database.database().reference()
//
//        influencername.text = selectedtitle
//        videotitle.text = "\(selecteddaytitle)"
//        profileimage.image = myselectedimage
//
//        profileimage.layer.masksToBounds = true
//        profileimage.layer.cornerRadius = 5.0
//        tv3.textColor = UIColor.white
//
//        tv3.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        
        queryforids { () -> () in
        
            self.queryforinfo()
        
        }
        
        

        if uid == selectedid {
            
            tapdelete.alpha = 1
            
        } else {
            
            tapdelete.alpha = 0
//            tapwelcome.alpha = 0
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(WatchViewController.handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(WatchViewController.handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(WatchViewController.handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(WatchViewController.handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var b1: UIImageView!
    @IBOutlet weak var b2: UIImageView!

    @IBOutlet weak var b3: UIImageView!

    @IBOutlet weak var b4: UIImageView!

    @IBOutlet weak var b5: UIImageView!

    @IBOutlet weak var b6: UIImageView!

    @IBOutlet weak var b7: UIImageView!

    @IBOutlet weak var b8: UIImageView!

    @IBOutlet weak var b9: UIImageView!


    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            
            tapleft()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            tapnext()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
    }
    
    var textviewdics = [String:String]()
    
    @IBOutlet weak var tv3: UILabel!
    var vidids = [String]()
    func queryforids(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        
        vids.removeAll()
        vidids.removeAll()
        ref?.child("Influencers").child(selectedid).child("Plans").child(selectedvideoid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    if ids != "Date" && ids != "Thumbnail" && ids != "Title" && ids != "DayTitle" {
                        
                        self.vidids.append(ids)
                    
                        print(functioncounter)
                        print(snapDict.count)
                    }
                    
                    functioncounter += 1

                    
                    if functioncounter == snapDict.count {
                        self.showcount()
                        self.vidids = self.vidids.sorted()
                        completed()
                        
                    }
                    
                    
                }
                
            }
            
        })
    }

    func queryforinfo() {
        
        var functioncounter = 0
        
        for each in vidids {
            
            
            ref?.child("Influencers").child(selectedid).child("Plans").child(selectedvideoid).child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(each)
                var value = snapshot.value as? NSDictionary
                
                if var author2 = value?["Title"] as? String {
                    
//                    self.textviewdics[each] = author2
//                    self.tv3.alpha = 1
//                    self.tv3.text = self.textviewdics[self.vidids[0]]

                } else {
                    
//                    self.textviewdics[each] = " "
//                    self.tv3.alpha = 0

                }
                if var author2 = value?["URL"] as? String {
                    
                    let videourl = URL(string: author2)

                    self.vids[each] = videourl!

                
                    if self.vids.count == 1 {


                    
                        self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:self.vids[self.vidids[0]]!))
                        print(each)
                        print(videourl)
                        print(self.vids)
                    self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
                    self.playerView.playerLayer.player = self.avPlayer
                    
                    self.playerView.player?.play()
                        
                    self.counter = 0
                        
                    }
                    
                    print(self.vids)
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

}
