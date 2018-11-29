//
//  RoundedRectanglePageControl.swift
//  SCCycleScrollView
//
//  Created by tongshichao on 2018/11/29.
//  Copyright © 2018 童世超. All rights reserved.
//

import UIKit

class RoundedRectanglePageControl: UIView {

    var numberOfPages: NSInteger = 0 {
        didSet {
            
        }
    }
    
    var currentPage: NSInteger = 0 {
        didSet {
            removeSubviews()
            setupSubviews()
        }
    }
    
    var pageIndicatorColor: UIColor = UIColor.white
    var currentPageIndicatorColor: UIColor = UIColor.lightGray
    var minimumInteritemSpacing: CGFloat = 10
    var height: CGFloat = 10
    var currentWidth: CGFloat = 20
    
    private func setupSubviews() {
        for i in 0..<numberOfPages {
            let view = setupDotView(tag: i + 1000)
            addSubview(view)
        }
        
        
    }
    
    private func removeSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDotView(tag: NSInteger) -> UIView {
        let dotView = UIView()
        dotView.tag = tag
        dotView.backgroundColor = pageIndicatorColor
        return dotView
    }
    
}
