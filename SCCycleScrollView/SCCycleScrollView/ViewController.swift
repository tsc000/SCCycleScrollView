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
    
    private var pageControl: RoundedRectanglePageControl!
    private var rPageControl: RectanglePageControl!
    private var mPageControl: MergeRectanglePageControl!
    
    private var sccyleScrollView: SCCycleScrollView!
    private var sccyleScrollView1: SCCycleScrollView!
    private var sccyleScrollView2: SCCycleScrollView!
    
    private var revert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SCCycleScrollView轮播图"

        createBackgroundView()
        createImageScrollView()
        createTmallScrollView()
        createJingdongImage()
    }
    
    @objc private func createImageScrollView() {
        let frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https://cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/535/104.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/30/46.jpg"
            ] as [AnyObject]
        
        let titleArray = [
            "感谢您的支持",
            "如果发现代码出现bug",
            "请联系QQ:767616124",
            "或发至邮箱：s787753577@163.com",
            "轮播图持续维护中..."
        ]
        
        let sccyleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, titleArray: nil, pageControlStyle:. custom, placeholderImage: placeholderImage)
        
        sccyleScrollView.imageArray = imageArray as [AnyObject]
        
        sccyleScrollView.titleArray = titleArray
        
        sccyleScrollView.titleFont = UIFont.systemFont(ofSize: 16)
        
        sccyleScrollView.titleColor = UIColor.orange
        sccyleScrollView.center = view.center
        self.sccyleScrollView = sccyleScrollView
        
        pageControl = RoundedRectanglePageControl(frame: CGRect.null)
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPageWidth = 40
        pageControl.currentPageIndicatorColor = UIColor.red
        pageControl.minimumInteritemSpacing = 10
        sccyleScrollView.addSubview(pageControl)
    
        scrollView.addSubview(sccyleScrollView)
    }
    
    @objc private func createTmallScrollView() {
        let frame = CGRect(x: 0, y: sccyleScrollView.frame.maxY + 10, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https://cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https://cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/535/104.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/30/46.jpg"
            ] as [AnyObject]
    
        let sccyleScrollView1 = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, titleArray: nil, pageControlStyle:. custom, placeholderImage: placeholderImage)
        
        sccyleScrollView1.imageArray = imageArray as [AnyObject]
        
        self.sccyleScrollView1 = sccyleScrollView1
        
        rPageControl = RectanglePageControl(frame: CGRect.null)
        rPageControl.numberOfPages = imageArray.count
        
        rPageControl.currentPageWidth = 17
        rPageControl.minimumInteritemSpacing = 3
        rPageControl.pageHeight = 3
        
        sccyleScrollView1.addSubview(rPageControl)
        
        scrollView.addSubview(sccyleScrollView1)
    }
    
    //京东
    @objc func createJingdongImage() {
        
        let frame = CGRect(x: 0, y: sccyleScrollView1.frame.maxY + 10, width: UIScreen.main.bounds.width, height: 200)
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
        let imageArray = [
            "https:cdn.pixabay.com/photo/2016/07/16/13/50/sun-flower-1521851_960_720.jpg",
            "https:cdn.pixabay.com/photo/2014/08/11/23/10/bud-416110_960_720.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/535/104.jpg",
            "http://t2.hddhhn.com/uploads/tu/201707/30/46.jpg"
            ] as [AnyObject]
        
        let sccyleScrollView2 = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, pageControlStyle: .custom, placeholderImage: placeholderImage)
        
        sccyleScrollView2.imageArray = imageArray
        sccyleScrollView2.scrollDirection = .horizontal
        
        mPageControl = MergeRectanglePageControl(frame: CGRect.null)
        mPageControl.numberOfPages = imageArray.count

        sccyleScrollView2.addSubview(mPageControl)
        scrollView.addSubview(sccyleScrollView2)
    }
    
    private func createBackgroundView() {
    
        let imageView = UIImageView(image: UIImage(named: "scene"))
        
        imageView.frame = view.bounds

        
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        
        [imageView, scrollView].forEach(view.addSubview(_:))
        
        let titleArray = ["图+文字", "网络图", "本地图", "纯文字",
                          "自定义cell", "自定义指示器", "全部自定义", "数据源切换",
                          "天猫PageControl", "京东PageControl"
                          ]
        
        let width: CGFloat = UIScreen.main.bounds.size.width / 4.0 - 5
        for i in 0..<titleArray.count {
            
            let x: CGFloat = CGFloat(i % 4) * (width + 5)
            let y: CGFloat = CGFloat(i / 4) * (40 + 5) + 70
            createButton(tag: 1000 + i, frame: CGRect(x: x, y: y, width: width, height: 40), title: titleArray[i])
        }
        
    }
    
    private func createButton(tag: NSInteger, frame: CGRect, title: String) {
        let button = UIButton()
        
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonDidClick(_:)), for: .touchUpInside)
        button.frame = frame
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        scrollView.addSubview(button)
    }
    
    @objc func buttonDidClick(_ sender: UIButton) {
        
        let vc = SecondViewController()
        vc.injectedTag = sender.tag
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - SCCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didSelectItemAt index: Int) {
//        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll2ItemAt index: Int) {
        print("scroll: \(index)")
    }
    
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll scrollView: UIScrollView, atIndex index: NSInteger) {
        
        if cycleScrollView == sccyleScrollView {
            pageControl.currentPage = index
            
            pageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - pageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 50 - pageControl.pageHeight)
        } else if cycleScrollView == sccyleScrollView1 {
            
            rPageControl.currentPage = index
            
            rPageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - rPageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 10 - rPageControl.pageHeight)
        } else {
            mPageControl.currentPage = index
            
            mPageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - mPageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 10 - mPageControl.pageHeight)
        }

    }
    
}

