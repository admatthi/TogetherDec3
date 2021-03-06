//
//  UploadViewController.swift
//  Together
//
//  Created by Alek Matthiessen on 11/11/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FBSDKCoreKit
import MobileCoreServices
import AVFoundation
import AVKit
import Photos
import YPImagePicker

var videoURL : NSURL?
var thisdate = String()
var videodates = [String:String]()
var yourprogramname = String()
var mythumbnail = UIImage()
var yourpropic = UIImage()
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var loadinglabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var vids = [URL]()

    var uploadcounter = 1234
    var subtitletext = String()
    var textview3 = String()
    var snaplabel = String()

    @IBAction func tapShare(_ sender: Any) {
        
        self.view.endEditing(true)
        labelbackground.alpha = 0
        counter = 0
        tapcancel.alpha = 0
        tapshare.alpha = 0
        tv3.alpha = 0
        playerView.alpha = 0
        tapplay.alpha = 0
        if tv3.text != "" {
            
            snaplabel = tv3.text

        } else {
            
            snaplabel = " "

        }
        headerlabel.text = "Uploading...This May Take A Moment."
        headerlabel.alpha = 1
//        headerlabel.addCharacterSpacing()
        
        if playerView.player?.isPlaying == true {
            
            playerView.player?.pause()
            
        } else {
            
        }
        
        activityIndicator.alpha = 1
        activityIndicator.color = mypink
        activityIndicator.startAnimating()
        loadinglabel.alpha = 1
        
        self.loadthumbnail()
        
        if videoURL != nil {
        for each in vids {
            
//        videoURL = vids[counter] as NSURL
            
        videoURL = each as NSURL

            
        let data = Data()


        let storage = Storage.storage()
        let storageRef = storage.reference()
        let currentUser = Auth.auth().currentUser

        uid = (currentUser?.uid)!
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "y-MM-dd H:m:ss" //Specify your format that you want

        var mystring = videoURL!.absoluteString
        let localFile = URL(string: mystring!)

        let timestamp = NSDate().timeIntervalSince1970

        let randomString = UUID().uuidString
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(randomString)
        
//        let metaData = StorageMetadata()
//
//        metaData.contentType = "image/jpg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: localFile!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription)

                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            
//            metadata.download
     
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription)
                    return
                }
               
                print(downloadURL)
                
                let mystring4 = downloadURL.absoluteString

                var selectedindex = self.vids.firstIndex(of: each)
                var storedvalue = String(selectedindex!+1234)
                print(storedvalue)
                print(selectedindex)

//                self.strDate = dateFormatter.string(from: date)
                ref!.child("Influencers").child(uid).child("Plans").child(self.strDate).child(storedvalue).updateChildValues(["URL" : mystring4])
                
                    self.counter += 1
                    
                    if self.counter == self.vids.count {
                        
                        self.performSegue(withIdentifier: "SegueTo2nd", sender: self)
                        
                    }
                
            }
                
            }
        }
            
        } else {
            
            
          

            
            
        }
    }
    
    var mystring2 = String()
    
    var strDate = String()
    func loadthumbnail() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let currentUser = Auth.auth().currentUser
        
        //        let metaData = StorageMetadata()
        //
        //        metaData.contentType = "image/jpg"
        
        uid = (currentUser?.uid)!
        
      
        
        
        var whatthough = UIImageJPEGRepresentation(mythumbnail, 1.0)
        
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        ref!.child("Influencers").child(uid).child("Plans").child(self.strDate).updateChildValues(["Title" : snaplabel, "Date" : thisdate])

        // Create a reference to the file you want to upload
        let randomString = UUID().uuidString
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(randomString)
        
        let uploadTask = riversRef.putData(whatthough!, metadata: metaData) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription)
                
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            
            //            metadata.download
            
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription)
                    return
                }
                
                print(downloadURL)
                
                self.mystring2 = downloadURL.absoluteString
                

                ref!.child("Influencers").child(uid).child("Plans").child(self.strDate).updateChildValues(["Thumbnail" : self.mystring2])

                    //                self.activityIndicator.alpha = 0
//                self.activityIndicator.stopAnimating()
//                self.loadinglabel.alpha = 0
                
                self.nextViewNumber = 1
                
                if self.uploadcounter == self.vids.count {
                    
                    self.performSegue(withIdentifier: "SegueTo2nd", sender: self)

                }
                
                if self.vids.count == 0 {
                    
                    var selectedindex = 1
                    var storedvalue = String(selectedindex+1234)
                    print(storedvalue)
                    print(selectedindex)
                    ref!.child("Influencers").child(uid).child("Plans").child(self.strDate).child(storedvalue).updateChildValues(["URL" : "Image"])
                    
                    self.performSegue(withIdentifier: "SegueTo2nd", sender: self)

                }
                
//                DispatchQueue.main.async {
//                    
//                    self.performSegue(withIdentifier: "UploadToProfile", sender: self)
//                    
//                    
//                    
//                }
                
            }
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var tapplay: UIButton!
    @IBAction func btnSelectVideo_Action(_ sender: Any) {
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        imagePickerController.mediaTypes = [kUTTypeMovie as String]
//        present(imagePickerController, animated: true, completion: nil)
        
        playerView.player?.pause()
        tapplay.alpha = 0
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.title = "Choose Video"
    }
    @IBOutlet weak var playerView: PlayerViewClass!
    
    @IBOutlet weak var labelbackground: UILabel!
    @IBOutlet weak var tv2: UITextView!
    @IBOutlet weak var tv: UITextView!
    
    var avPlayer = AVPlayer()
    
   
    /*
     @IBAction func tapCancel(_ sender: Any) {
     
     
     }
     // MARK: - Navigation
     @IBOutlet weak var tapcancel: UIButton!
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tapCancel(_ sender: Any) {
        
        let alert = UIAlertController(title: "Discard?", message: "Are you sure you'd like to discard this draft?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
                self.tapplay.alpha = 0
                
                self.tv3.text = "Write a caption..."
                self.tv3.textColor = UIColor.lightGray
                self.tabBarController?.tabBar.isHidden = false
                self.tapcancel.alpha = 0
                self.tapshare.alpha = 0
                //        tapnew.alpha = 1
                self.headerlabel.alpha = 1
                            self.playerView.player?.replaceCurrentItem(with: nil)
                self.view.endEditing(true)

            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
      
        
    }
    
    @IBOutlet weak var tapcancel: UIButton!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    var selectedItems = [YPMediaItem]()

    @IBOutlet weak var subtitle: UITextView!
    @IBOutlet weak var programname: UILabel!
    @IBAction func tapBack(_ sender: Any) {
    
        showPicker()
        
    }
    var selectedImageV = UIImage()

    var counter = 0
    
    @IBAction func tapLeft(_ sender: Any) {
        
        tapleft()
        
        self.view.endEditing(true)

    }
    @IBAction func tapRight(_ sender: Any) {
        
        tapnext()
                    self.view.endEditing(true)

        
    }
    
    var textviewdics = [Int:String]()
    
    func tapnext() {
        
        playerView.player?.pause()

        if counter < vids.count-1 {
            
            
            counter += 1
            
            let playerVC = AVPlayerViewController()
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:vids[counter]))
            
            
            self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
            
            self.playerView.playerLayer.player = self.avPlayer
            
            self.playerView.player?.play()
                        
            
        }
    
      
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if tv3.textColor == mygray {
            tv3.text = ""
            tv3.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tv3.text.isEmpty {
            tv3.text = "Write a caption..."
            tv3.textColor = UIColor.lightGray
        }
    }
    
    func tapleft() {
        
        playerView.player?.pause()

        if counter > 0 && vids.count > 0 {
            
            
            counter -= 1
            
            let playerVC = AVPlayerViewController()
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:vids[counter]))
            
            
            self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
            
            self.playerView.playerLayer.player = self.avPlayer
            
            self.playerView.player?.play()
            
        }
        
        
    }
    @IBAction func tapPlay(_ sender: Any) {
        
        tapplay.setImage(nil, for: .normal)
        
        if playerView.player?.isPlaying == true {
            
            playerView.player?.pause()
            
        } else {
            
            playerView.player?.play()

        }
        
    }
   func showPicker() {
        var config = YPImagePickerConfiguration()

        config.library.mediaType = .photoAndVideo

        config.shouldSaveNewPicturesToAlbum = false

        config.video.compression = AVAssetExportPresetMediumQuality

        config.startOnScreen = .library

        config.screens = [.library, .video]

        config.video.libraryTimeLimit = 500.0
        
        config.showsCrop = .rectangle(ratio: (1/1))
        
        config.wordings.libraryTitle = "Choose Media"

        config.hidesBottomBar = false
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 12
        let picker = YPImagePicker(configuration: config)
        vids.removeAll()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            for item in items {
                switch item {
                case .photo(let photo):
                    
                    mythumbnail = photo.image
                    
                    let imageView = UIImageView(image: mythumbnail)
                    imageView.frame = self.playerView.frame
                    imageView.layer.cornerRadius = 5.0
                    imageView.layer.masksToBounds = true
                    self.view.addSubview(imageView)
                    self.headerlabel.alpha = 1
                    self.tapcancel.alpha = 0.5
                    self.tabBarController?.tabBar.isHidden = true
                    self.tapplay.alpha = 1
                    self.tapshare.alpha = 1
                    self.counter += 1
                    
                case .video(let video):
                    
                if self.counter == 0 {
                    
                        mythumbnail = video.thumbnail

                }
                    //
                
                    let videoURL = video.url
                    self.vids.append(videoURL)
                    let playerVC = AVPlayerViewController()
                    self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url:self.vids[0]))
                
                self.textviewdics.removeAll()
                
                
                self.playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
                
                self.playerView.playerLayer.player = self.avPlayer
                
                self.playerView.player?.pause()
                self.headerlabel.alpha = 1
                self.tapcancel.alpha = 0.5
                self.tabBarController?.tabBar.isHidden = true
                self.tapplay.alpha = 1
                self.tapshare.alpha = 1
                self.counter += 1

                    
                }
            }
        picker.dismiss(animated: true, completion: nil)
            
    }
        
        
    
        present(picker, animated: true, completion: nil)

    }
    
    func showResults() {
        if selectedItems.count > 0 {
            let gallery = YPSelectionsGalleryVC(items: selectedItems) { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
            let navC = UINavigationController(rootViewController: gallery)
            self.present(navC, animated: true, completion: nil)
        } else {
            print("No items selected yet.")
        }
    }
    @IBOutlet weak var propic: UIImageView!

    @IBOutlet weak var tapnew: UIButton!
    @IBOutlet weak var tapshare: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        
        counter = 0
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "y-MM-dd H:m:ss" //Specify your format that you want
        strDate = dateFormatter.string(from: date)
        


        
    }
    
    private var nextViewNumber = Int()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueTo2nd" {
            
            let nextView = segue.destination as! TabInfluencerViewController
            
            switch (nextViewNumber) {
            case 1:
                nextView.selectedIndex = 2
                
            case 2:
                nextView.selectedIndex = 1
                
            default:
                break
            }
        }
    }

    @IBOutlet weak var headerlabel: UILabel!
    override func viewDidDisappear(_ animated: Bool) {
        
        if playerView.player?.isPlaying == true {
            
            playerView.player?.pause()
            
        } else {
            
        }
    }

    @IBOutlet weak var tv3: UITextView!
    
    override func viewDidLoad() {
        
       playerView.layer.cornerRadius = 5.0
        playerView.layer.masksToBounds = true
        self.tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UploadViewController.playerItemDidReachEnd),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        imagePickerController.mediaTypes = [kUTTypeMovie as String]
//        present(imagePickerController, animated: true, completion: nil)
        
        
//        tapnew.alpha = 1
        tapshare.alpha = 0
        tapcancel.alpha = 0
        
        ref = Database.database().reference()
    
        self.activityIndicator.alpha = 0
        self.loadinglabel.alpha = 0
        tapplay.alpha = 0
        tv3.text = "Write a caption..."
        tv3.textColor = mygray
//        subtitle.text = "Subtitle..."
//        subtitle.textColor = .white
//        tv2.text = "Title..."
//        tv2.textColor = .white
//        tv3.textColor = UIColor.white
//
//        tv3.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
//        tv3.alpha = 0

//        tapplay.alpha = 1
        queryforinfo()
        headerlabel.text = "UPLOAD"
        headerlabel.addCharacterSpacing()
//        self.addLineToView(view: tv2, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)

//        propic.layer.masksToBounds = false
//        propic.layer.cornerRadius = propic.frame.height/2
//        propic.clipsToBounds = true
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS" //Specify your format that you want
        strDate = dateFormatter.string(from: date)
      
        dateFormatter.dateFormat = "MMM dd"

        thisdate = dateFormatter.string(from: date)
        
        
     
        //            imgView.image = thumbnail
//        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
//
//        let asset = AVURLAsset(url: videoURL as! URL , options: nil)
//        let imgGenerator = AVAssetImageGenerator(asset: asset)
//        imgGenerator.appliesPreferredTrackTransform = true
//        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//        let thumbnail = UIImage(cgImage: cgImage)
        //            imgView.image = thumbnail
        
//        let avPlayer = AVPlayer(url: videoURL! as URL)
//        
//        playerView.playerLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
//        
//        playerView.playerLayer.player = avPlayer
//        
//        playerView.player?.pause()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(UploadViewController.handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(UploadViewController.handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(UploadViewController.handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(UploadViewController.handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
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
    

    @IBOutlet weak var tapshowtv: UIButton!
    @IBAction func tapShowTV(_ sender: Any) {

        if tv3.alpha == 1 {

            tv3.alpha = 0
            
            self.view.endEditing(true)

        } else {

            tv3.alpha = 1


//            tv3.becomeFirstResponder()

        }


    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
            print("done")
            
            self.playerView.player?.play()
            
        }
        
    }
//
//    func getThumbnailFrom(path: URL) -> UIImage? {
//
//        do {
//
//            let asset = AVURLAsset(url: path , options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//            mythumbnail = UIImage(cgImage: cgImage)
//
////            tapplay.setBackgroundImage(mythumbnail, for: .normal)
//
//            loadthumbnail()
//
//            mythumbnail = cropToBounds(image: mythumbnail, width: 375, height: 667)
//
//            return mythumbnail
//
//
//
//        } catch let error {
//
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//
//        }
//
//    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        
        
        ref?.child("Influencers").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var author2 = value?["ProgramName"] as? String {
                
                yourprogramname = author2
//                self.programname.text = yourprogramname

                
            }
            
            if var productimagee = value?["ProPic"] as? String {
                
                if productimagee.hasPrefix("http://") || productimagee.hasPrefix("https://") {
                    
                    let url = URL(string: productimagee)
                    
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    
                    if data != nil {
                        
                        let productphoto = UIImage(data: (data)!)
                        
//                        yourpropic = productphoto!
//                        self.propic.image = yourpropic
//                        self.programname.text = yourprogramname
                        
                    }
                    
                    
                }
            }
            
            
        })
        
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
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
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }


}
