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
    
    private var revert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SCCycleScrollView轮播图"
//        let vc = SecondViewController()
//        navigationController?.pushViewController(vc, animated: false)
        createBackgroundView()

//
////        //图 + 文字
//        createImageScrollView()
//
//        //本地图片
//        createImage()
//
//        //纯文字
//        createTitleScrollView()

    }
    
    private func createBackgroundView() {
    
        let imageView = UIImageView(image: UIImage(named: "scene"))
        
        imageView.frame = view.bounds

        
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        
        [imageView, scrollView].forEach(view.addSubview(_:))
        
        let titleArray = ["图+文字", "网络图", "本地图", "纯文字",
                          "自定义cell", "自定义指示器", "全部自定义", "数据源切换"
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
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll2ItemAt index: Int) {
        print("scroll: \(index)")
    }
    
    func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll scrollView: UIScrollView, atIndex index: NSInteger) {
        pageControl.currentPage = index
        
        pageControl.frame.origin = CGPoint(x: (cycleScrollView.frame.width - pageControl.frame.width) / 2.0, y: cycleScrollView.frame.height - 10 - pageControl.pageHeight)
    }
    
}

