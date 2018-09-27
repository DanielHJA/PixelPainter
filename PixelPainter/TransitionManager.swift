//
//  TransitionManager.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

enum Status {
    case present, dismiss
}

class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var duration: Double
    
    init(duration: Double) {
        self.duration = duration
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return Controller(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(duration: duration, status: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(duration: duration, status: .dismiss)
    }
    
}

class Controller: UIPresentationController {
    
    private lazy var closeTapGesture: UITapGestureRecognizer = {
        let temp = UITapGestureRecognizer(target: self, action: #selector(close))
        temp.numberOfTapsRequired = 1
        return temp
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.view.addGestureRecognizer(closeTapGesture)
    }
    
    @objc private func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: Double
    var status: Status
    
    init(duration: Double, status: Status) {
        self.duration = duration
        self.status = status
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
    
        guard let fromView = fromVC.view else { return }
        guard let toView = toVC.view else { return }
   
        if status == .present {
            
            toView.alpha = 0
            toView.frame = container.bounds
            container.addSubview(toView)
            
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1.0
            }) { (completion) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        } else {
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
            }) { (completion) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
