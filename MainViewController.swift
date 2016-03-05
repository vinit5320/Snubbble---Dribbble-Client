//
//  MainViewController.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var shots : [Shot]!
    var boxView = UIView()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth = CGFloat()
    
    @IBOutlet var topGradientView: UIView!
    
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        let attributes = [NSFontAttributeName : UIFont(name: FontPack.fontName, size: 19)!, NSForegroundColorAttributeName : UIColor.blackColor()]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        shots = [Shot]()
        let api = DribbbleAPI()
        api.loadShots("https://api.dribbble.com/v1/shots", completion: didLoadShots)
        addSavingPhotoView()
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("removeLoad"), userInfo: nil, repeats: true)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        screenWidth = screenSize.width
    }
    
    func didLoadShots(shots: [Shot]){
        self.shots = shots
        tableView.reloadData()
    }
    
    func addSavingPhotoView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.blackColor()
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.whiteColor()
        textLabel.text = "Loading Shots"
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    func removeLoad() {
        //When button is pressed it removes the boxView from screen
        boxView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate + UITableViewDataSource Implementations
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 281
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("shotCell", forIndexPath: indexPath) as! MainTableViewCell
        if shots.isEmpty {
            cell.shotNameLabel.text = ""
            cell.minsAgoLabel.text = ""
            cell.gradientLayer.hidden = true
        } else {
            let shot = shots[indexPath.row]
            cell.gradientLayer.hidden = false
            cell.shotNameLabel.text = shot.title+" by "+shot.user.name
            
            let imgURL = NSURL(string: shot.imageUrl)

            cell.mainImageView.image = nil
            
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(imgURL, options: [], progress: nil, completed: {[weak self] (image, data, error, finished) in
                if let wSelf = self {
                    // do what you want with the image/self
                    
                    var newImage = self!.imageResize(image, sizeChange: CGSizeMake(self!.screenWidth, ((self!.screenWidth * 300)/400)))
                    cell.mainImageView.image = newImage
                }
                })
            
            
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image:UIImage = UIImage(data: data!)!
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        var contentColor:MDContentColor = image.md_imageContentColor()
                        
                        if( contentColor == MDContentColor.Light ) {
                            // background is light, so use dark text
                            cell.minsAgoLabel.textColor = UIColor.blackColor()
                            cell.minsAgoLabel.text = shot.date
                            cell.minsAgoLabel.shadowColor = UIColor.whiteColor()
                            cell.minsAgoLabel.shadowOffset = CGSizeMake(0, 0)
                            cell.minsAgoLabel.layer.shadowRadius = 3.0
                            cell.minsAgoLabel.layer.shadowOpacity = 0.5
                            cell.minsAgoLabel.layer.masksToBounds = false
                            cell.minsAgoLabel.layer.shouldRasterize = true
                        }
                        else {
                            // background is dark, so use light text
                            cell.minsAgoLabel.textColor = UIColor.whiteColor()
                            cell.minsAgoLabel.text = shot.date
                            cell.minsAgoLabel.shadowColor = UIColor.blackColor()
                            cell.minsAgoLabel.shadowOffset = CGSizeMake(0, 0)
                            cell.minsAgoLabel.layer.shadowRadius = 3.0
                            cell.minsAgoLabel.layer.shadowOpacity = 0.5
                            cell.minsAgoLabel.layer.masksToBounds = false
                            cell.minsAgoLabel.layer.shouldRasterize = true
                        }
                    })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
        
            let profURL = NSURL(string: shot.user.avatarUrl)
            cell.profileImageView.sd_setImageWithURL(profURL, completed: nil)

        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("shotCell") as! MainTableViewCell
        //self.navigationController?.pushViewController(detailView, animated: true)
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // !!!
        return scaledImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
