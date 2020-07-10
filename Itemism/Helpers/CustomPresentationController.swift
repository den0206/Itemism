//
//  CustomPresentationController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/10.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class CustomPresentationController : UIPresentationController {
    
    //MARK: - Parts
       
       var popView : UIView = {
           let view = UIView()
           view.backgroundColor = .systemGroupedBackground
           return view
       }()
       
       let margin = (x: CGFloat(30), y: CGFloat(220.0))
       
       override func presentationTransitionWillBegin() {
           guard let containerView = containerView else {return}
           
           self.popView.frame = containerView.bounds
           
           let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBackGroung))
           self.popView.addGestureRecognizer(tap)
           
           self.popView.backgroundColor = .black
           self.popView.alpha = 0.0
           containerView.addSubview(popView)
           
           presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
               self.popView.alpha = 0.7
           }, completion: nil)
       }
       
       
       
       override func dismissalTransitionWillBegin() {
           
           presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
               self.popView.alpha = 0.0
           }, completion: nil)
           
           
       }
       
       override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
           return CGSize(width: parentSize.width - margin.x, height: parentSize.height - margin.y)
       }
       
       override var frameOfPresentedViewInContainerView: CGRect {
           var presentedViewFrame = CGRect()
           let containerBounds = containerView!.bounds
           let chledContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
           
           presentedViewFrame.size = chledContentSize
           presentedViewFrame.origin.x = margin.x / 2.0
           presentedViewFrame.origin.y = margin.y / 2.0
           
           
           return presentedViewFrame

       }
       
       override func containerViewWillLayoutSubviews() {
         self.popView.frame = containerView!.bounds
         presentedView?.frame = frameOfPresentedViewInContainerView
         presentedView?.layer.cornerRadius = 10
         presentedView?.clipsToBounds = true
       }
       
       
       
       //MARK: - Actions
       
       @objc func tappedBackGroung() {
           presentedViewController.dismiss(animated: true, completion: nil)
       }
}
