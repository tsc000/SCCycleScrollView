//
//  SecondViewController.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/21.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, SCCycleScrollViewDelegate {

    private var scCycle1: SCCycleScrollView!
    
    private var scCycle2: SCCycleScrollView!
    
    private var revert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        var frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 200)
    
        scCycle1 = createImageScrollView(frame: frame)
        
        frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 200)
        
        scCycle2 = createImageScrollView(frame: frame)

        createButton()
    }
    
    //图 + 文字
    private func createImageScrollView(frame: CGRect) -> SCCycleScrollView {
        
        let placeholderImage = UIImage(named: "swift.jpeg")
        
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
        
        let sccyleScrollView = SCCycleScrollView.cycleScrollView(frame: frame, delegate: self, imageArray: nil, titleArray: nil, placeholderImage: placeholderImage)
        
        sccyleScrollView.imageArray = imageArray as [AnyObject]
        
        sccyleScrollView.titleArray = titleArray
        
        sccyleScrollView.titleFont = UIFont.systemFont(ofSize: 16)
        
        sccyleScrollView.titleColor = UIColor.orange
        
        sccyleScrollView.pageControlOrigin = CGPoint(x: (sccyleScrollView.frame.width - sccyleScrollView.pageControlSize.width) / 2.0, y: sccyleScrollView.frame.height - sccyleScrollView.pageControlSize.height - 10 - 46);
        
        view.addSubview(sccyleScrollView)
        
        return sccyleScrollView
        
        
    }

    private func createButton() {
        let button = UIButton()
        
        button.setTitle("切换", for: .normal)
        
        button.setTitleColor(UIColor.blue, for: .normal)
        
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        
        button.frame = CGRect(x: (view.frame.width - 40 ) / 2.0, y: 520, width: 40, height: 40)
        
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

            revert = false
        } else {
            scCycle2.imageArray = ["https://cdn.pixabay.com/photo/2015/02/18/21/44/seeds-641520_960_720.jpg" as AnyObject]
 
            scCycle2.titleArray = []
            
            revert = true
        }
        
    }

}
