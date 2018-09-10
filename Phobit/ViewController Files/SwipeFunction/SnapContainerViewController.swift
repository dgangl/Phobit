//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    // custom. starts always with middle view.
    var currentPage = 1 {
        willSet {
            if newValue != currentPage {
                handleVCChange(new: newValue, old: currentPage)
            }
        }
        
        didSet {
            update()
        }
    }    
    
    // delegate stuff
    var leftDelegate: SnapDelegate?
    var middleDelegate: SnapDelegate?
    var rightDelegate: SnapDelegate?
    
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    class func containerViewWith(_ leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
        
        setupDelegates()
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc: middleVc,
                                                                               topVc: topVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height)
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 3 * view.width
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMove(toParentViewController: self)
        middleVertScrollVc.didMove(toParentViewController: self)
        rightVc.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    
    // wird eigentlich nur gebraucht, wenn wir noch einen vertikalen view hätten
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
        
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
        }
        currentPage = classifyOffset(offset: scrollView.contentOffset)
    }
    
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(page)
        }) { (_) in
            self.currentPage = self.classifyOffset(offset: self.scrollView.contentOffset)
        }
    }
    
    
    ///////////////////////////////////////////////
    //Custom Methods to enable the Authentication//
    ///////////////////////////////////////////////
    
    func classifyOffset(offset: CGPoint) -> Int {

        switch offset.x {
        case CGFloat(0):
            return 0
        case CGFloat(375):
            return 1
        case CGFloat(750):
            return 2
        case let x where (x > 350 && currentPage == 0) || (x < 350 && currentPage == 2):
            return 1 // we scroll through page 1
        default:
            return currentPage // the transition is in progress.
        }
    }
    
    func isScrollEnabled() -> Bool {
        return scrollView.isScrollEnabled
    }
    
    // replaces view did load, but also checks for the lock status
    func update() {
        
        if currentPage == 1 {
            let lock = Authentifizierung.getAuthStatus()
            scrollView.isScrollEnabled = !lock
            
            if lock {
                scrollToPage(1)
            }
        } else {
            scrollView.isScrollEnabled = true
        }
        /*print(currentPage)*/
    }
    
    
    func handleVCChange(new: Int, old: Int) {
        switch new {
        case 0:
            leftDelegate?.viewAppears()
        case 1:
            middleDelegate?.viewAppears()
        case 2:
            rightDelegate?.viewAppears()
        default:
            print("error")
        }
        
        switch old {
        case 0:
            leftDelegate?.viewDisappears()
        case 1:
            middleDelegate?.viewDisappears()
        case 2:
            rightDelegate?.viewDisappears()
        default:
            print("error")
        }
    }
    
    
    
    func setupDelegates() {
        guard let lvc = leftVc as? LeftViewController, let rvc = rightVc as? RightViewController, let mvc = middleVc as? MiddleViewController else {
            print("could not set one or more delegate \(#line, #file)")
            return
        }
        
        leftDelegate = lvc
        middleDelegate = mvc
        rightDelegate = rvc
    }
}
