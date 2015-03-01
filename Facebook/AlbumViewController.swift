//
//  AlbumViewController.swift
//  Facebook
//
//  Created by viramesh on 2/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = true

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var landingImg:Int = 0
    
    var landingImgX: CGFloat = 9
    var landingImgY: [CGFloat] = [73, 112, 112, 112, 313]
    var landingImgW: CGFloat = 302
    var landingImgH: [CGFloat] = [454, 202, 202, 202, 202]
    
    var atEdge:Bool = false
    var shouldDismiss:Bool = false
    
    var destinationVC:SinglePhotoViewController!
    var singlePhotoToBeShown:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        scrollView.contentSize.height = 1590
        scrollView.contentSize.width = 320
        
        switch(landingImg) {
            case 1: scrollView.contentOffset = CGPoint(x: 0,y: 0)
                    break

            case 2: scrollView.contentOffset = CGPoint(x: 0,y: 457)
                    break
         
            case 3: scrollView.contentOffset = CGPoint(x: 0,y: 710)
                    break
         
            case 4: scrollView.contentOffset = CGPoint(x: 0,y: 962)
                    break
         
            case 5: scrollView.contentOffset = CGPoint(x: 0,y: 1014)
                    break
            
            default: scrollView.contentOffset = CGPoint(x: 0,y: 0)
        }
            
            
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        if(scrollView.contentOffset.y==0 || scrollView.contentOffset.y==1014) {
            atEdge = true
        }
        else {
            atEdge = false
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if(atEdge) {
            if(scrollView.contentOffset.y<0) {
                var alpha = 1 - ((-1 * scrollView.contentOffset.y) / 100)
                mainView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: alpha)
                headerView.alpha = alpha
                shouldDismiss = true
            }
                
            else if(scrollView.contentOffset.y>1014) {
                var alpha = 1 - ((scrollView.contentOffset.y - 1014) / 100)
                mainView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: alpha)
                headerView.alpha = alpha
                shouldDismiss = true
                
            }
                
            else {
                mainView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
                headerView.alpha = 1
                shouldDismiss = false
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
            
        if(shouldDismiss) {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.mainView.alpha = 0
                }, completion: { (Bool) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    @IBAction func photoDidTap(sender: AnyObject) {
        singlePhotoToBeShown = sender.view as UIImageView
        performSegueWithIdentifier("photoSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        destinationVC = segue.destinationViewController as SinglePhotoViewController
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.transitioningDelegate = self
        destinationVC.imageToBeShown = singlePhotoToBeShown.image!
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var window = UIApplication.sharedApplication().keyWindow
        var tempImageView = UIImageView(frame: singlePhotoToBeShown.frame)
        tempImageView.center.y = tempImageView.center.y - scrollView.contentOffset.y
        tempImageView.image = singlePhotoToBeShown.image
        tempImageView.clipsToBounds = singlePhotoToBeShown.clipsToBounds
        tempImageView.contentMode = singlePhotoToBeShown.contentMode
        
        
        if (isPresenting) {
            window?.addSubview(tempImageView)
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                tempImageView.frame = self.destinationVC.imageShown.frame
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    self.destinationVC.showImage()
                    tempImageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                //fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            }
        }
    }

}
