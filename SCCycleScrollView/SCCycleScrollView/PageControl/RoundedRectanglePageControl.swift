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
    var pageHeight: CGFloat = 10
    var currentPageWidth: CGFloat = 20
    
    private func setupSubviews() {

        var lastView: UIView = UIView()
        for i in 0..<numberOfPages {
        
            var width = pageHeight
            var x: CGFloat = 0
            if i == currentPage {
                width = currentPageWidth
            }

            if i == 0 {
                x = lastView.frame.maxX
            } else {
                x = lastView.frame.maxX + 10
            }
            
            let frame = CGRect(x: x, y: 0, width: width, height: pageHeight)
            
            let view = setupDotView(frame: frame, tag: i + 1000)
            if i == currentPage {
                view.backgroundColor = UIColor.red
                
            }
            lastView = view
            addSubview(view)
        }
        frame.size = CGSize(width: CGFloat(numberOfPages - 1) * (pageHeight + minimumInteritemSpacing) + currentPageWidth, height: pageHeight)
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
    
    private func setupDotView(frame: CGRect, tag: NSInteger, backgroundColor: UIColor = UIColor.white) -> UIView {
        let dotView = UIView()
        dotView.frame = frame
        dotView.tag = tag
        dotView.layer.cornerRadius = pageHeight / 2
        dotView.layer.masksToBounds = true
        dotView.backgroundColor = backgroundColor
        return dotView
    }
    
}
