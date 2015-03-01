//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = true
    
    var imgTapped:Int = 0
    var imgViewTapped:UIImageView!
    
    var toFrame:CGRect!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
    
    @IBAction func photoDidTap(sender: UITapGestureRecognizer) {
        imgTapped = (sender.view as UIImageView).tag
        imgViewTapped = (sender.view as UIImageView)
        performSegueWithIdentifier("albumSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationVC = segue.destinationViewController as AlbumViewController
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.transitioningDelegate = self
        destinationVC.landingImg = imgTapped
        
        toFrame = CGRect(x: destinationVC.landingImgX,
            y: destinationVC.landingImgY[imgTapped-1],
            width: destinationVC.landingImgW,
            height: destinationVC.landingImgH[imgTapped-1])
        
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
        var tempImageView = UIImageView(frame: imgViewTapped.frame)
        tempImageView.center.y = tempImageView.center.y + 110
        tempImageView.image = imgViewTapped.image
        tempImageView.clipsToBounds = imgViewTapped.clipsToBounds
        tempImageView.contentMode = imgViewTapped.contentMode
        
        if (isPresenting) {

            window?.addSubview(tempImageView)
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                tempImageView.frame = self.toFrame
                UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    toViewController.view.alpha = 1
                    }) { (finished: Bool) -> Void in
                        tempImageView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                }
            }, completion: nil)
            
            
            
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            }
        }
    }
}
