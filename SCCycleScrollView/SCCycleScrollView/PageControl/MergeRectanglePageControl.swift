//
//  MergeRectanglePageControl.swift
//  SCCycleScrollView
//
//  Created by tongshichao on 2018/12/3.
//  Copyright © 2018 童世超. All rights reserved.
//

import UIKit

class MergeRectanglePageControl: UIView {

    var numberOfPages: NSInteger = 0
    
    var currentPage: NSInteger = 0 {
        didSet {
            removeSubviews()
            setupSubviews()
        }
    }
    
    var pageIndicatorColor: UIColor = UIColor.white
    var currentPageIndicatorColor: UIColor = UIColor.white
    var minimumInteritemSpacing: CGFloat = 8
    var pageHeight: CGFloat = 5
    var currentPageWidth: CGFloat = 12
    
    private func setupSubviews() {
        
        var lastView: UIView = UIView()
        
        let width = CGFloat(currentPage) * (currentPageWidth + minimumInteritemSpacing) + currentPageWidth
        let frame1 = CGRect(x: 0, y: 0, width: width, height: pageHeight)
        let firstView = setupDotView(frame: frame1, tag: 0 + 1000, backgroundColor: pageIndicatorColor)
        addSubview(firstView)
        for i in (currentPage + 1)..<numberOfPages {
            
            var x: CGFloat = 0
            
            if i == currentPage + 1 {
                x = firstView.frame.maxX + minimumInteritemSpacing
            } else {
                x = lastView.frame.maxX + minimumInteritemSpacing
            }
            
            let frame = CGRect(x: x, y: 0, width: currentPageWidth, height: pageHeight)
            
            let view = setupDotView(frame: frame, tag: i + 1000, backgroundColor: pageIndicatorColor)
            if i == currentPage {
                view.backgroundColor = currentPageIndicatorColor
            }
            lastView = view
            addSubview(view)
        }
        frame.size = CGSize(width: CGFloat(numberOfPages - 1) * (currentPageWidth + minimumInteritemSpacing) + currentPageWidth, height: pageHeight)
    }
    
    private func removeSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
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
