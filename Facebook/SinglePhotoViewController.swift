//
//  SinglePhotoViewController.swift
//  Facebook
//
//  Created by viramesh on 2/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageShown: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var actionBar: UIImageView!
    
    
    var imageToBeShown:UIImage!
    var toDismiss:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: 320, height: 569)
        scrollView.delegate = self
        
        imageShown.image = imageToBeShown
        imageShown.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    @IBAction func doneBtnDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

   
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        if(!scrollView.zooming) {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.doneBtn.alpha = 0
                self.actionBar.alpha = 0
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        var alpha:CGFloat!
        if(!scrollView.zooming && scrollView.zoomScale == 1.0) {
            if(scrollView.contentOffset.y < 0) {
                alpha = 1 - ((-1 * scrollView.contentOffset.y) / 150)
                mainView.backgroundColor = UIColor(white: 0, alpha: alpha)
                imageShown.alpha = alpha
            }
            
            else if(scrollView.contentOffset.y > 0) {
                alpha = 1 - ((scrollView.contentOffset.y) / 150)
                mainView.backgroundColor = UIColor(white: 0, alpha: alpha)
                imageShown.alpha = alpha
            }
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
            
            println(scrollView.zooming.description)
            if(scrollView.zoomScale == 1.0) {
                if(scrollView.contentOffset.y > 50 || scrollView.contentOffset.y < -50) {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.mainView.alpha = 0
                        }, completion: { (Bool) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                    })
                
                }
                else {
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.doneBtn.alpha = 1
                        self.actionBar.alpha = 1
                        self.imageShown.alpha = 1
                    })
                }
            }
    }
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        // This method is called when the scrollview finally stops scrolling.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageShown
    }
    
    
    func showImage() {
        imageShown.alpha = 1
    }

}
