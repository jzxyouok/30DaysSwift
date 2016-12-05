//
//  MenuTransitionManager.swift
//  SlideMenu
//
//  Created by ChenZuo on 2016/12/5.
//  Copyright © 2016年 ChenZuo. All rights reserved.
//

import UIKit

@objc protocol MenuTransitionManagerDelegate{
    func dismiss()
}
/**======================================================
 UIViewControllerAnimatedTransitioning,自定义转场动画
 */
class MenuTransitionManager: NSObject ,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var duration = 0.5
    var isPresenting = false
    var delegate:MenuTransitionManagerDelegate?
    
    var snapshot:UIView? {
        didSet {
            if let _delegate = delegate {
                let tapGesturRecognizer = UITapGestureRecognizer(target: _delegate, action: #selector(MenuTransitionManagerDelegate.dismiss))
                snapshot?.addGestureRecognizer(tapGesturRecognizer)
            }
        }
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let container = transitionContext.containerView
        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)
        let moveUp = CGAffineTransform(translationX: 0, y: -50)
        
        if isPresenting {
            toView?.transform = moveUp
            snapshot = fromView?.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView!)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(), animations: {
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView?.transform = CGAffineTransform.identity
            }else{
                self.snapshot?.transform = CGAffineTransform.identity
                fromView?.transform = moveUp
            }
        }, completion: { finished in
            transitionContext.completeTransition(true)
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }

}
