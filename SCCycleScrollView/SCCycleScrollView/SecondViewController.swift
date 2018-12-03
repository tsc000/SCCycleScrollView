//
//  SecondViewController.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/21.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, SCCycleScrollViewDelegate {

    
    var injectedTag: NSInteger = 0
    
    private var sccyleScrollView: SCCycleScrollView!
    private var sccyleTitleScrollView: SCCycleScrollView!
    private var scCycle1: SCCycleScrollView!
    private var scCycle2: SCCycleScrollView!
    private var scCycle3: SCCycleScrollView!

    private var pageControl: RoundedRectanglePageControl!
    private var rPageControl: RectanglePageControl!
    private var mPageControl: MergeRectanglePageControl!
    
    private var revert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let methodString = ["createImageScrollView", "createNetImage", "createImage", "createTitleScrollView",
                            "createCustomCellScrollView", "createCustomPagecontrol", "createCustomPagecontrolAndCell", "createChangeImage",
                            "createTmallImage", "createJingdongImage"
                            ]
        let selector = Selector(methodString[injectedTag - 1000])
        perform(selector)
        
    }
    
    //图 + 文字
    @objc private func createImageScrollView() {
        let frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 200)
        
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
        
        let sccyleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: nil, imageArray: nil, titleArray: nil, placeholderImage: placeholderImage)
        
        sccyleScrollView.imageArray = imageArray as [AnyObject]
        
        sccyleScrollView.titleArray = titleArray
        
        sccyleScrollView.titleFont = UIFont.systemFont(ofSize: 16)
        
        sccyleScrollView.titleColor = UIColor.orange
        sccyleScrollView.center = view.center
        self.sccyleScrollView = sccyleScrollView
        
//        sccyleScrollView.delegate = self
        
        sccyleScrollView.pageControlOrigin = CGPoint(x: (sccyleScrollView.frame.width - sccyleScrollView.pageControlSize.width) / 2.0, y: sccyleScrollView.frame.height - 40 - sccyleScrollView.pageControlSize.height - 6);

        view.addSubview(sccyleScrollView)
    }
    
    //网络图片
    @objc func createNetImage() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https://cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https://cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https://cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        let cycleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: nil, imageArray: nil, placeholderImage: placeholderImage)
        
        cycleScrollView.imageArray = imageArray
        cycleScrollView.center = view.center
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.pageControlOrigin = CGPoint(x: (cycleScrollView.frame.width - cycleScrollView.pageControlSize.width) / 2.0, y: cycleScrollView.frame.height - cycleScrollView.pageControlSize.height - 10);
    
        view.addSubview(cycleScrollView)
    }
    
    //本地图片
    @objc func createImage() {
        
        let frame = CGRect(x: 0, y: 484, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "1.jpg",
            "2.jpg",
            "3.jpg",
            "4.jpg",
            "5.jpg",
            "6.jpg"
            ] as [AnyObject]
        
        scCycle3 = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, placeholderImage: placeholderImage)
        scCycle3.imageArray = imageArray
        scCycle3.scrollDirection = .vertical
        scCycle3.pageControlOrigin = CGPoint(x: (scCycle3.frame.width - scCycle3.pageControlSize.width) / 2.0, y: scCycle3.frame.height - scCycle3.pageControlSize.height - 10);
        scCycle3.center = view.center
        
        view.addSubview(scCycle3)
    }
    
    //纯文字
    @objc private func createTitleScrollView() {
        
        let frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.width, height: 80)
        
        let titleArray = [
            "感谢您的支持",
            "如果发现代码出现bug",
            "请联系QQ:767616124",
            "或发至邮箱：s787753577@163.com",
            "轮播图持续维护中..."
        ]
        
        let sccyleTitleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: nil, titleArray: titleArray)
        
        sccyleTitleScrollView.imageArray = nil
        
        sccyleTitleScrollView.scrollDirection = .vertical
        
        sccyleTitleScrollView.titleLeftMargin = 15
        
        sccyleTitleScrollView.titleContainerAlpha = 0.5
        
        sccyleTitleScrollView.titleContainerBackgroundColor = UIColor.black
        
        sccyleTitleScrollView.titleColor = UIColor.white
        
        sccyleTitleScrollView.timeInterval = 2.0
        
        self.sccyleTitleScrollView = sccyleTitleScrollView
        view.backgroundColor = UIColor.orange
//        sccyleTitleScrollView.delegate = self
        sccyleTitleScrollView.center = view.center
        view.addSubview(sccyleTitleScrollView)
        
    }
    
    //自定义cell
    @objc private func createCustomCellScrollView() -> SCCycleScrollView {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        let imageArray = [
            "http://jbcdn1.b0.upaiyun.com/2015/09/031814sbu.jpg",
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
        
        let sccyleScrollView = SCCycleScrollView(frame: frame)
        sccyleScrollView.cellType = .custom
        sccyleScrollView.delegate = self
        
        sccyleScrollView.imageArray = imageArray as [AnyObject]
        
        sccyleScrollView.titleArray = titleArray
        
        sccyleScrollView.titleFont = UIFont.systemFont(ofSize: 16)
        
        sccyleScrollView.titleColor = UIColor.orange
        
        sccyleScrollView.pageControlOrigin = CGPoint(x: (sccyleScrollView.frame.width - sccyleScrollView.pageControlSize.width) / 2.0, y: sccyleScrollView.frame.height - sccyleScrollView.pageControlSize.height - 20);
        sccyleScrollView.center = view.center
        view.addSubview(sccyleScrollView)
        
        return sccyleScrollView
        
    }

    //自定义pagecontrol
    @objc func createCustomPagecontrol() {
        
        
         let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
         
         let placeholderImage = UIImage(named: "swift.jpeg")
         
         let imageArray = [
         "https:cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
         "https:cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
         "https:cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
         "https:cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
         ] as [AnyObject]
         
         let cycleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, pageControlStyle: .custom, placeholderImage: placeholderImage)
         
         cycleScrollView.imageArray = imageArray
         cycleScrollView.center = view.center
         cycleScrollView.scrollDirection = .horizontal
         cycleScrollView.pageControlOrigin = CGPoint(x: (cycleScrollView.frame.width - cycleScrollView.pageControlSize.width) / 2.0, y: cycleScrollView.frame.height - cycleScrollView.pageControlSize.height - 10);
         
         pageControl = RoundedRectanglePageControl(frame: CGRect.null)
//         pageControl.backgroundColor = UIColor.clear
         pageControl.numberOfPages = imageArray.count
         pageControl.currentPageWidth = 40
         cycleScrollView.addSubview(pageControl)
         view.addSubview(cycleScrollView)
    }
    
    //自定义pagecontrol 和cell
    @objc func createCustomPagecontrolAndCell() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let imageArray = [
            "https:cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https:cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https:cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https:cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        cycleScrollView.cellType = .custom
        cycleScrollView.pageControlStyle = .custom
        cycleScrollView.delegate = self
        
        cycleScrollView.imageArray = imageArray
        cycleScrollView.center = view.center
        cycleScrollView.scrollDirection = .horizontal
        cycleScrollView.pageControlOrigin = CGPoint(x: (cycleScrollView.frame.width - cycleScrollView.pageControlSize.width) / 2.0, y: cycleScrollView.frame.height - cycleScrollView.pageControlSize.height - 10);
        
        pageControl = RoundedRectanglePageControl(frame: CGRect.null)
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPageWidth = 40
        cycleScrollView.addSubview(pageControl)
        view.addSubview(cycleScrollView)
    }
    
    //切换数据源
    @objc func createChangeImage() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https://cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https://cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https://cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        scCycle2 = SCCycleScrollView.cycleScrollView(frame: frame, delegate: nil, imageArray: nil, placeholderImage: placeholderImage)
        
        scCycle2.imageArray = imageArray
        scCycle2.center = view.center
        scCycle2.scrollDirection = .vertical
        scCycle2.pageControlOrigin = CGPoint(x: (scCycle2.frame.width - scCycle2.pageControlSize.width) / 2.0, y: scCycle2.frame.height - scCycle2.pageControlSize.height - 10);
        
        view.addSubview(scCycle2)
        
        createButton()
    }
    
    
    //天猫
    @objc func createTmallImage() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https:cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https:cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https:cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https:cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        let cycleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, pageControlStyle: .custom, placeholderImage: placeholderImage)
        
        cycleScrollView.imageArray = imageArray
        cycleScrollView.center = view.center
        cycleScrollView.scrollDirection = .horizontal
        cycleScrollView.pageControlOrigin = CGPoint(x: (cycleScrollView.frame.width - cycleScrollView.pageControlSize.width) / 2.0, y: cycleScrollView.frame.height - cycleScrollView.pageControlSize.height - 10);
        
        rPageControl = RectanglePageControl(frame: CGRect.null)

        rPageControl.numberOfPages = imageArray.count
        rPageControl.currentPageWidth = 17
        rPageControl.minimumInteritemSpacing = 3
        rPageControl.pageHeight = 3
        
        cycleScrollView.addSubview(rPageControl)
        view.addSubview(cycleScrollView)
    }
    
    //京东
    @objc func createJingdongImage() {
        
        let frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https:cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https:cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "https:cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
            "https:cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
            ] as [AnyObject]
        
        let cycleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, pageControlStyle: .custom, placeholderImage: placeholderImage)
        
        cycleScrollView.imageArray = imageArray
        cycleScrollView.center = view.center
        cycleScrollView.scrollDirection = .horizontal
        
        mPageControl = MergeRectanglePageControl(frame: CGRect.null)
        
        mPageControl.numberOfPages = imageArray.count
//        mPageControl.currentPageWidth = 17
//        mPageControl.minimumInteritemSpacing = 3
//        mPageControl.pageHeight = 3
        
        cycleScrollView.addSubview(mPageControl)
        view.addSubview(cycleScrollView)
    }
    
    private func createButton() {
        let button = UIButton()
        
        button.setTitle("切换", for: .normal)
        
        button.setTitleColor(UIColor.blue, for: .normal)
        
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        
        button.frame = CGRect(x: (view.frame.width - 40 ) / 2.0, y: 700, width: 40, height: 40)
        
        view.addSubview(button)
    }
    
    @objc private func buttonDidClick() {
        
        if revert {
            scCycle2.imageArray = [
                "http://jbcdn1.b0.upaiyun.com/2015/09/031814sbu.jpg",
                "https://cdn.pixabay.com/photo/2013/11/26/01/45/flower-218485_960_720.jpg",
                "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
                "https://cdn.pixabay.com/photo/2016/10/03/17/11/cosmos-flower-1712177_960_720.jpg",
                "https://cdn.pixabay.com/photo/2015/06/13/19/00/dandelion-808255_960_720.jpg"
                ] as [AnyObject]
            
            scCycle2.titleArray = [
                "感谢您的支持",
                "如果发现代码出现bug",
                "请联系QQ:767616124",
                "或发至邮箱：s787753577@163.com",
                "轮播图持续维护中..."
            ]
            scCycle2.pageControlOrigin = CGPoint(x: (scCycle2.frame.width - scCycle2.pageControlSize.width) / 2.0, y: scCycle2.frame.height - scCycle2.pageControlSize.height - 10 );
            revert = false
        } else {
            scCycle2.imageArray = ["http://t2.hddhhn.com/uploads/tu/20150700/v45jx3rpefz.jpg" as AnyObject]
            scCycle2.isHiddenOnlyPage = false
            scCycle2.titleArray = []
            scCycle2.pageControlOrigin = CGPoint(x: (scCycle2.frame.width - scCycle2.pageControlSize.width) / 2.0, y: scCycle2.frame.height - scCycle2.pageControlSize.height - 10 );
            revert = true
        }
        
    }
    

    //下面两个是处定义cell代理
    func configureCollectionViewCell(cell: UICollectionViewCell, atIndex index: NSInteger, for cycleScrollView: SCCycleScrollView) {
        let customCell = cell as! CustomCollectionViewCell
        
        
    }

    func cellType(for cycleScrollView: SCCycleScrollView) -> AnyClass {
        return CustomCollectionViewCell.self
    }
    
    //下面自定义Pagecontrol代理
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll scrollView: UIScrollView, atIndex index: NSInteger) {
        
        if pageControl != nil {
            pageControl.currentPage = index
            
            pageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - pageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 20 - pageControl.pageHeight)
        } else if rPageControl != nil {
            
            rPageControl.currentPage = index
            
            rPageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - rPageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 10 - rPageControl.pageHeight)
        } else {
            mPageControl.currentPage = index
            
            mPageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - mPageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 10 - mPageControl.pageHeight)
        }
        
    }
}
