//
//  ViewController.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/19.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SCCycleScrollViewDelegate {

    private var scrollView: UIScrollView!
    
    private var sccyleScrollView: SCCycleScrollView!
    
    private var sccyleTitleScrollView: SCCycleScrollView!
    
    private var revert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SCCycleScrollView轮播图"
 
        createBackgroundView()
        
        //图 + 文字
        createImageScrollView()
        
        //本地图片
        createImage()
        
        //纯文字
        createTitleScrollView()

    }
    
    //本地图片
    func createImage() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "1.jpg",
            "2.jpg",
            "3.jpg",
            "4.jpg",
            "5.jpg",
            "6.jpg"
            ] as [AnyObject]
        
        let cycleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: imageArray,placeholderImage: placeholderImage)
        
        cycleScrollView.imageArray = imageArray
        
        cycleScrollView.scrollDirection = .vertical
        
        cycleScrollView.pageControlBottomMargin = 15
        
        cycleScrollView.pageControlRightMargin = (UIScreen.main.bounds.width - cycleScrollView.pageControlSize.width) / 2.0
        
        scrollView.addSubview(cycleScrollView)
    }
    
    private func createBackgroundView() {
    
        let imageView = UIImageView(image: UIImage(named: "scene"))
        
        imageView.frame = view.bounds

        
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        
        [imageView, scrollView].forEach(view.addSubview(_:))
    }

    
    //图 + 文字
    private func createImageScrollView() {
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")

        let imageArray = [
            "https://cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https://cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https://cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        let titleArray = [
            "感谢您的支持",
            "如果发现代码出现bug",
            "请联系QQ:767616124",
            "或发至邮箱：s787753577@163.com",
            "轮播图持续维护中..."
        ]
        
        let sccyleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, placeholderImage: placeholderImage)
        
        sccyleScrollView.imageArray = imageArray as [AnyObject]
        
        sccyleScrollView.titleArray = titleArray
 
        sccyleScrollView.titleFont = UIFont.systemFont(ofSize: 16)
        
        sccyleScrollView.titleColor = UIColor.orange
        
        self.sccyleScrollView = sccyleScrollView
        
        sccyleScrollView.delegate = self
        
        sccyleScrollView.pageControlBottomMargin = 46
        
        sccyleScrollView.pageControlRightMargin = (UIScreen.main.bounds.width - sccyleScrollView.pageControlSize.width) / 2.0
        
        
        scrollView.addSubview(sccyleScrollView)
    }
    
    //纯文字
    private func createTitleScrollView() {
    
        let frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.width, height: 40)

        let titleArray = [
            "感谢您的支持",
            "如果发现代码出现bug",
            "请联系QQ:767616124",
            "或发至邮箱：s787753577@163.com",
            "轮播图持续维护中..."
        ]
        
        let sccyleTitleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, titleArray: titleArray)

        sccyleTitleScrollView.imageArray = nil
        
        sccyleTitleScrollView.scrollDirection = .vertical
        
        sccyleTitleScrollView.titleLeftMargin = 15
        
        sccyleTitleScrollView.titleContainerAlpha = 0.5
        
        sccyleTitleScrollView.titleContainerBackgroundColor = UIColor.black
        
        sccyleTitleScrollView.titleColor = UIColor.white
        
        sccyleTitleScrollView.timeInterval = 2.0
        
        self.sccyleTitleScrollView = sccyleTitleScrollView

        sccyleTitleScrollView.delegate = self
        
        scrollView.addSubview(sccyleTitleScrollView)

    }

    
    //MARK: - SCCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didSelectItemAt index: Int) {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll2ItemAt index: Int) {
//        print("scroll: \(index)")
    }
    
    
}

