//
//  SCCycleScrollView.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/19.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit

public enum CycleScrollViewCellType: String{
    case Image = "图片或有文字"
    case OnlyTitle = "只有文字"
}

open class SCCycleScrollView: UIView {
    
    //////////////////////  私有属性  //////////////////////
    
    fileprivate weak var collectionView: UICollectionView!
    
    private var flowLayout: UICollectionViewFlowLayout!
    
    fileprivate weak var pageControl: UIPageControl!
    
    fileprivate var placeholderImage: UIImage?
    
    fileprivate var SCCycleScrollViewID = "SCCycleScrollViewID"
    
    fileprivate var currentPage: Int = 0
    
    fileprivate var timer: Timer?
    
    fileprivate let cycleCount = 1000
    
    fileprivate var internalImageArray: [AnyObject]?
    
    fileprivate var internalTitleArray: [String]?
    
    //>>>>>>>>>>>>>>>>>>>>>>  SCCycleScrollView属性接口 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// SCCycleScrollView代理
    weak open var delegate: SCCycleScrollViewDelegate?
    
    /// 轮播图滚动方向,默认水平
    open var scrollDirection: UICollectionViewScrollDirection = .horizontal
    
    /// 定时时间间隔,默认1.0秒
    open var timeInterval: CGFloat = 1.0
    
    //>>>>>>>>>>>>>>>>>>>>>>  title属性接口 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 文字颜色,默认非纯白(在图片类型和文字类型中通用)
    open var titleColor: UIColor = UIColor(red: 0xe5 / 255.0, green: 0xf0 / 255.0, blue: 0xf4 / 255.0, alpha: 1.0)
    
    /// 文字大小,默认18(在图片类型和文字类型中通用)
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    /// 文字左侧边距,默认10
    open var titleLeftMargin: CGFloat = 10
    
    /// 文字背景条颜色,默认黑色
    open var titleContainerBackgroundColor: UIColor? = UIColor.black
    
    /// 文字背景条透明度,默认0.6
    open var titleContainerAlpha: CGFloat = 0.6
    
    //>>>>>>>>>>>>>>>>>>>>>>  pageControl属性接口 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 当前指示器颜色,默认白色
    open var currentPageIndicatorTintColor: UIColor = UIColor.white
    
    /// 非选中指示器颜色,默认亮灰色
    open var pageIndicatorTintColor: UIColor = UIColor.lightGray
    
    /// pageControl底部边距,默认0
    open var pageControlBottomMargin: CGFloat = 0
    
    /// pageControl右侧边距,默认0
    open var pageControlRightMargin: CGFloat = 0
    
    /// 只有一张图片时是否隐藏pageControl,默认隐藏
    open var isHiddenOnlyPage: Bool = true
    
    /// 外界获取pageControl的size(只读)
    open var pageControlSize: CGSize {
        get {
            return pageControl.frame.size
        }
    }
    
    /// cell类型：图片类型和文字类型
    open var cellType: CycleScrollViewCellType?
    
    //>>>>>>>>>>>>>>>>>>>>>>  数据源 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 图片数据源
    open var imageArray: [AnyObject]? {
        didSet {
            
            //如果是文字轮播，直接返回，防止出错
            if cellType == .OnlyTitle { return }
            
            if let images = imageArray, images.count > 0 {
                pageControl.numberOfPages = images.count
                
                pageControl.frame.size.width = pageControl.size(forNumberOfPages: pageControl.numberOfPages).width
                
                internalImageArray = imageArray
                
            } else { //[] 或 nil
                internalImageArray = [""]  as [AnyObject]
            }

            configureInternalTitleArray()
            
            setNeedsLayout()
            
            collectionView.reloadData()
        }
    }
    
    /// 文字数据源
    open var titleArray: [String]? {
        didSet {

            if let array = titleArray, array.count > 0 {
                internalTitleArray = titleArray
            } else { //[] 或 nil
                internalTitleArray = [""]
            }
            
            if cellType == .Image {

                configureInternalTitleArray()
                
            } else {
                setNeedsLayout()
                
                collectionView.reloadData()
            }
            
        }
    }
    
    //>>>>>>>>>>>>>>>>>>>>>> 方法 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 创建图片和文字轮播图
    ///
    /// - Parameters:
    ///   - frame: 轮播图位置
    ///   - delegate: SCCycleScrollView代理
    ///   - imageArray: 图片数据源,默认值nil
    ///   - titleArray: 文字数据源,默认值nil
    ///   - placeholderImage: 占位图片
    /// - Returns: 返回SCCycleScrollView对象
    open class func cycleScrollView(frame: CGRect, delegate: SCCycleScrollViewDelegate?, imageArray: [AnyObject]? = nil, titleArray: [String]? = [], placeholderImage: UIImage?) -> SCCycleScrollView {
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        
        cycleScrollView.delegate = delegate
        
        cycleScrollView.placeholderImage = placeholderImage
        
        cycleScrollView.cellType = .Image
        
        cycleScrollView.imageArray = imageArray
        
        cycleScrollView.titleArray = titleArray

        return cycleScrollView
    }
    
    /// 创建文字轮播图
    ///
    /// - Parameters:
    ///   - frame: 轮播图位置
    ///   - delegate: SCCycleScrollView代理
    ///   - titleArray: 文字数据源,默认值nil
    /// - Returns: 返回SCCycleScrollView对象
    open class func cycleScrollView(frame: CGRect, delegate: SCCycleScrollViewDelegate, titleArray: [String]? = []) -> SCCycleScrollView {
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        
        cycleScrollView.delegate = delegate
        
        cycleScrollView.cellType = .OnlyTitle
        
        cycleScrollView.titleArray = titleArray

        return cycleScrollView
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        if cellType == .Image {
            //图片和文字
            guard let count = internalImageArray?.count, count > 1 else {
                
                configureCycleScrollView(scrollEnabled: false, pageHidden: isHiddenOnlyPage, timerBlock: invalidateTimer)
                
                return
            }
            
        } else {
            //文字
            guard let count = internalTitleArray?.count, count > 1 else {
                
                configureCycleScrollView(scrollEnabled: false, pageHidden: isHiddenOnlyPage, timerBlock: invalidateTimer)
                
                return
            }
        }
        
        configureCycleScrollView(scrollEnabled: true, pageHidden: !isHiddenOnlyPage, timerBlock: setupTimer)
        
    }
    
    private func configureCycleScrollView(scrollEnabled: Bool, pageHidden: Bool, timerBlock: (() -> Void)) {
        
        flowLayout.scrollDirection = scrollDirection
        
        // pageControl只和cell类型有关和滚动方向无关
        if cellType == .Image {
            //pageControl高度是33,
            pageControl.frame.origin.x = self.frame.width - pageControl.frame.width - pageControlRightMargin
            
            pageControl.frame.origin.y = self.frame.height - pageControl.frame.height - pageControlBottomMargin + 15
            
            //经过imageArray的处理保证了internalImageArray一定非空
            currentPage = cycleCount * internalImageArray!.count / 2
        } else {
            //经过titleArray的处理保证了internalTitleArray一定非空
            currentPage = cycleCount * internalTitleArray!.count / 2
        }
        
        let indexPath = IndexPath(item: currentPage, section:0)
        
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
        
        collectionView.isScrollEnabled = scrollEnabled
        
        pageControl.isHidden = pageHidden
        
        timerBlock()
    }
    
    /// 根据internalImageArray配置internalTitleArray
    private func configureInternalTitleArray() {
        
        if internalTitleArray == nil { internalTitleArray = [] }
        
        //将文字数组个数和图片数组个数设置成一致，只能比其多，不能少
        if internalImageArray!.count > internalTitleArray!.count {
            
            for _ in 0..<(internalImageArray!.count - internalTitleArray!.count) {
                
                internalTitleArray?.append("")
                
            }
            
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initial()
    }
    
    @objc private func roll() {
        
        currentPage = currentPage + 1
        
        let count = cellType == .Image ? internalImageArray!.count: internalTitleArray!.count
        
        switch scrollDirection {
        case .horizontal:
            
            if collectionView.contentOffset.x == CGFloat(count * cycleCount - 1) * self.frame.size.width {
                
                currentPage = currentPage / 2
                
            }
            
        case .vertical:
            
            if collectionView.contentOffset.y == CGFloat(count * cycleCount - 1) * self.frame.size.height {
                
                currentPage = currentPage / 2
                
            }
            
        }
        
        let indexPath = IndexPath(item: currentPage, section:0)
        
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        
    }
    
    fileprivate func setupTimer() {
        guard timer == nil else { return }
        
        timer = Timer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(roll), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func invalidateTimer() {
        guard timer != nil else { return }
        
        timer?.invalidate()
        
        timer = nil
    }
    
    private func setupUI() {
        setupCollectionView()
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 37)
        
        let pageControl = UIPageControl(frame: frame)
        
        //默认指示器颜色
        pageControl.currentPageIndicatorTintColor = UIColor.white
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        self.pageControl = pageControl
        
        addSubview(pageControl)
    }
    
    private func setupCollectionView() {

        //不加会不正常，这个是automaticallyAdjustsScrollViewInsets的影响
        addSubview(UIView())
        
        flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = self.frame.size
        
        flowLayout.minimumLineSpacing = 0
        
        flowLayout.minimumInteritemSpacing = 0
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        collectionView.isPagingEnabled = true
        
        collectionView.scrollsToTop = false
        
        //清除collectionView背景色，否则文字背景条的透明度不起作用
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.bounces = false

        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SCCycleScrollViewCell.self, forCellWithReuseIdentifier: SCCycleScrollViewID)
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        self.collectionView = collectionView
        
        addSubview(collectionView)
    }
    
    private func initial() {
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - UICollectionViewDataSource UICollectionViewDataSource
extension SCCycleScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = cellType == .Image ? (internalImageArray!.count) : (internalTitleArray!.count)
        
        return count * cycleCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCCycleScrollViewID, for: indexPath) as! SCCycleScrollViewCell
        
        if let type = cellType {
            switch type {
            case .Image:
                
                cell.placeholderImage = placeholderImage
                
                if let count = internalImageArray?.count, count > 0 {
                    
                    cell.image = internalImageArray?[indexPath.row % count] as? String
                    
                    cell.title = internalTitleArray?[indexPath.row % count]
  
                }
                
            case .OnlyTitle:
                
                if let count = internalTitleArray?.count, count > 0 {
                    
                    cell.title = internalTitleArray?[indexPath.row % count]

                }
                
            }
            
            cell.titleFont = titleFont
            
            cell.titleColor = titleColor
            
            cell.titleLeftMargin = titleLeftMargin
            
            cell.titleContainerAlpha = titleContainerAlpha
            
            cell.titleContainerBackgroundColor = titleContainerBackgroundColor
            
            cell.cellType = cellType
        }
        
        
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let count = cellType == .Image ? (internalImageArray!.count) : (internalTitleArray!.count)
        
        delegate?.cycleScrollView?(self, didSelectItemAt: indexPath.row % count)
    }
}

//MARK: - UIScrollViewDelegate
extension SCCycleScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollDirection == .horizontal {
            currentPage = Int((scrollView.contentOffset.x + scrollView.frame.width / 2.0) / scrollView.frame.width)
        } else {
            currentPage = Int((scrollView.contentOffset.y + scrollView.frame.height / 2.0) / scrollView.frame.height)
        }
        
        if let count = internalImageArray?.count, count > 0 {
            pageControl.currentPage = currentPage % count
        }
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        setupTimer()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let count = cellType == .Image ? (internalImageArray!.count) : (internalTitleArray!.count)
        
        ///.........为毛加个？
        delegate?.cycleScrollView?(self, didScroll2ItemAt: currentPage % count)
        
    }
}

 @objc public protocol SCCycleScrollViewDelegate: NSObjectProtocol {
    
    @objc optional func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didSelectItemAt index: Int)
    
    @objc optional func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll2ItemAt index: Int)
}
