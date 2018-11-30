//
//  SCCycleScrollView.swift
//  SCCycleScrollView
//
//  Created by 童世超 on 2017/6/19.
//  Copyright © 2017年 童世超. All rights reserved.
//

import UIKit

public enum CycleScrollViewCellStyle: String{
    case image   = "图片"
    case title   = "文字"
    case mix     = "图片和文字"
    case custom  = "自定义"
}

public enum CycleScrollViewPageControlStyle: String{
    case classic = "系统样式"
    case none    = "无"
    case custom  = "自定义"
}

open class SCCycleScrollView: UIView {
    
    //MARK: - SCCycleScrollView属性接口
    //>>>>>>>>>>>>>>>>>>>>>>  SCCycleScrollView属性接口 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    /// 占位图片
    open var placeholderImage: UIImage?
    
    /// cell类型：图片类型和文字类型
    open var cellType: CycleScrollViewCellStyle?
    
    /// SCCycleScrollView代理
     open var delegate: SCCycleScrollViewDelegate? {
        didSet {
            registerCell()
        }
    }
    
    /// 轮播图滚动方向,默认水平
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    /// 定时时间间隔,默认1.0秒
    open var timeInterval: CGFloat = 1.0
    
    /// 只有一张图片时是否隐藏pageControl,默认隐藏
    open var isHiddenOnlyPage: Bool = true
    
    //MARK: - title属性接口
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
    
    //MARK: - pageControl属性接口
    //>>>>>>>>>>>>>>>>>>>>>>  pageControl属性接口 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 当前指示器样式,默认系统自带
    open var pageControlStyle: CycleScrollViewPageControlStyle = .classic
    
    /// 当前指示器颜色,默认白色
    open var currentPageIndicatorTintColor: UIColor = UIColor.white
    
    /// 非选中指示器颜色,默认亮灰色
    open var pageIndicatorTintColor: UIColor = UIColor.lightGray
    
    open var pageControlOrigin: CGPoint = CGPoint(x: 0, y: 0) {
        
        didSet {
            if pageControlStyle == .classic {
                pageControl.frame.origin = pageControlOrigin
            }
        }
    }

    /// 外界获取pageControl的size(只读)
    open var pageControlSize: CGSize {
        get {
            if pageControlStyle == .classic {
                return pageControl.frame.size
            } else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>  数据源 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 图片数据源
    open var imageArray: [AnyObject]? {
        didSet {
            
            guard let cellType = cellType else { return }
            
            switch cellType {
     
            case .title://如果是文字轮播，直接返回，防止出错
                return
            case .mix, .image, .custom:
                if let images = imageArray, images.count > 0 {
                    if pageControlStyle == .classic {
                        if images.count >= 2 {
                            pageControl.isHidden = false
                        }
                        pageControl.numberOfPages = images.count
                        pageControl.frame.size.width = pageControl.size(forNumberOfPages: pageControl.numberOfPages).width
                    }
                    internalImageArray = imageArray
                } else { //[] 或 nil
                    internalImageArray = [""]  as [AnyObject]
                }
                
                if cellType == .mix {
                    configureInternalTitleArray()
                }
            }
            setNeedsLayout()
            collectionView.reloadData()
        }
    }
    
    /// 文字数据源
    open var titleArray: [String]? {
        didSet {

            //如果是图片轮播，直接返回，防止出错
            if cellType == .image { return }
            
            if let array = titleArray, array.count > 0 {
                internalTitleArray = titleArray
            } else { //[] 或 nil
                internalTitleArray = [""]
            }
            
            if cellType == .mix {
                configureInternalTitleArray()
            } else {
                setNeedsLayout()
                collectionView.reloadData()
            }
            
        }
    }
    
    //MARK: - 私有属性
    //////////////////////  私有属性  //////////////////////

    fileprivate var currentPage: Int = 0
    fileprivate var timer: Timer?
    fileprivate var internalImageArray: [AnyObject]?
    fileprivate var internalTitleArray: [String]?
    
    //MARK: - 方法
    //>>>>>>>>>>>>>>>>>>>>>> 方法 >>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /// 创建图片
    ///
    /// - Parameters:
    ///   - frame: 轮播图位置
    ///   - delegate: SCCycleScrollView代理
    ///   - imageArray: 图片数据源,默认值nil
    ///   - placeholderImage: 占位图片
    /// - Returns: 返回SCCycleScrollView对象
    open class func cycleScrollView(frame: CGRect,
                                 delegate: SCCycleScrollViewDelegate?,
                               imageArray: [AnyObject]? = nil,
                         pageControlStyle: CycleScrollViewPageControlStyle = .classic,
                         placeholderImage: UIImage?) -> SCCycleScrollView {
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        cycleScrollView.pageControlStyle = pageControlStyle
        cycleScrollView.placeholderImage = placeholderImage
        cycleScrollView.delegate = delegate
        cycleScrollView.cellType = .image
        cycleScrollView.imageArray = imageArray
        
        return cycleScrollView
    }
    
    /// 创建文字轮播图
    ///
    /// - Parameters:
    ///   - frame: 轮播图位置
    ///   - delegate: SCCycleScrollView代理
    ///   - titleArray: 文字数据源,默认值nil
    /// - Returns: 返回SCCycleScrollView对象
    open class func cycleScrollView(frame: CGRect,
                                 delegate: SCCycleScrollViewDelegate?,
                               titleArray: [String]? = []) -> SCCycleScrollView {
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        cycleScrollView.pageControlStyle = .none
        cycleScrollView.cellType = .title
        cycleScrollView.delegate = delegate
        cycleScrollView.titleArray = titleArray
        
        return cycleScrollView
    }
    
    /// 创建图片和文字轮播图
    ///
    /// - Parameters:
    ///   - frame: 轮播图位置
    ///   - delegate: SCCycleScrollView代理
    ///   - imageArray: 图片数据源,默认值nil
    ///   - titleArray: 文字数据源,默认值nil
    ///   - placeholderImage: 占位图片
    /// - Returns: 返回SCCycleScrollView对象
    open class func cycleScrollView(frame: CGRect,
                                 delegate: SCCycleScrollViewDelegate?,
                               imageArray: [AnyObject]? = nil,
                               titleArray: [String]? = [],
                         pageControlStyle: CycleScrollViewPageControlStyle = .classic,
                         placeholderImage: UIImage?) -> SCCycleScrollView {
        
        let cycleScrollView = SCCycleScrollView(frame: frame)
        cycleScrollView.pageControlStyle = pageControlStyle
        cycleScrollView.placeholderImage = placeholderImage
        cycleScrollView.cellType = .mix
        cycleScrollView.delegate = delegate
        cycleScrollView.imageArray = imageArray
        cycleScrollView.titleArray = titleArray

        return cycleScrollView
    }
    
    //MARK: - Event
    @objc private func roll() {
        
        currentPage = currentPage + 1
        
        let count = (cellType != .title) ? internalImageArray!.count: internalTitleArray!.count
        switch scrollDirection {
        case .horizontal:
            if collectionView.contentOffset.x == CGFloat(count * String.cycleCount - 1) * self.frame.size.width {
                currentPage = currentPage / 2
            }
        case .vertical:
            if collectionView.contentOffset.y == CGFloat(count * String.cycleCount - 1) * self.frame.size.height {
                currentPage = currentPage / 2
            }
        }
        
        let indexPath = IndexPath(item: currentPage, section:0)
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
    }
    
    //MARK: - Logic
    private func registerCell() {
        let validationResult: AnyClass? = self.delegate?.cellType?(for: self)
        let respondsValidation = self.delegate?.responds(to: #selector(SCCycleScrollViewDelegate.cellType(for:)))
        let respondsConfigure = self.delegate?.responds(to: #selector(SCCycleScrollViewDelegate.configureCollectionViewCell(cell:atIndex:for:)))
    
        guard let _ = respondsConfigure, let _ = respondsValidation, let _ = validationResult, cellType == .custom else {
            return
        }
        self.collectionView.register(validationResult.self, forCellWithReuseIdentifier: .cycleScrollViewID)
    }
    
    private func configureCycleScrollView(scrollEnabled: Bool, pageHidden: Bool, timerBlock: (() -> Void)) {
        
        flowLayout.scrollDirection = scrollDirection
        
        switch self.cellType {
        case .image?, .mix?, .custom?:
            //经过imageArray的处理保证了internalImageArray一定非空
            currentPage = String.cycleCount * internalImageArray!.count / 2
        case .title?:
            //经过titleArray的处理保证了internalTitleArray一定非空
            currentPage = String.cycleCount * internalTitleArray!.count / 2
            collectionView.backgroundColor = UIColor.clear
        case .none:
            break
        }
        
        let indexPath = IndexPath(item: currentPage, section:0)
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
        collectionView.isScrollEnabled = scrollEnabled
        if pageControlStyle == .classic && (cellType != .title) {
            pageControl.isHidden = pageHidden
        }
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
    
    //配置cell
    private func configureCell(cell: SCCycleScrollViewCell, atIndexPath indexPath: IndexPath, scrollViewStyle: CycleScrollViewCellStyle) {
        if scrollViewStyle == .title {
            if let count = internalTitleArray?.count, count > 0 {
                cell.title = internalTitleArray?[indexPath.row % count]
            }
        } else if scrollViewStyle == .mix {
            cell.placeholderImage = placeholderImage
            if let count = internalImageArray?.count, count > 0 {
                cell.image = internalImageArray?[indexPath.row % count] as? String
                cell.title = internalTitleArray?[indexPath.row % count]
            }
        }
        
        cell.titleFont = titleFont
        cell.titleColor = titleColor
        cell.titleLeftMargin = titleLeftMargin
        cell.titleContainerAlpha = titleContainerAlpha
        cell.titleContainerBackgroundColor = titleContainerBackgroundColor
    }
    
    fileprivate func setupTimer() {
        guard timer == nil else { return }
        timer = Timer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(roll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func invalidateTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    private func initial() {
        //不加会不正常，这个是automaticallyAdjustsScrollViewInsets的影响
        addSubview(UIView())
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        flowLayout.itemSize = self.frame.size
        collectionView.frame = frame
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        switch self.cellType {
        case .image?, .mix?: //图片, 图片+文字
            guard let count = internalImageArray?.count, count > 1 else {
                configureCycleScrollView(scrollEnabled: false, pageHidden: isHiddenOnlyPage, timerBlock: invalidateTimer)
                return
            }
        case .title?: //文字
            guard let count = internalTitleArray?.count, count > 1 else {
                configureCycleScrollView(scrollEnabled: false, pageHidden: isHiddenOnlyPage, timerBlock: invalidateTimer)
                return
            }
        case .custom?:
            guard let count = internalImageArray?.count, count > 1 else {
                configureCycleScrollView(scrollEnabled: false, pageHidden: isHiddenOnlyPage, timerBlock: invalidateTimer)
                return
            }
        case .none:
            break
        }
        
        configureCycleScrollView(scrollEnabled: true, pageHidden: false, timerBlock: setupTimer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - GET
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect.null, collectionViewLayout: UICollectionViewLayout())
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        //清除collectionView背景色，否则文字背景条的透明度不起作用
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SCCycleScrollViewCell.self, forCellWithReuseIdentifier: .cycleScrollViewID)
        addSubview(collectionView)
        return collectionView
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 6)
        let pageControl = UIPageControl(frame: frame)
        pageControl.currentPageIndicatorTintColor = UIColor.white //默认指示器颜色
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        addSubview(pageControl)
        return pageControl
    }()
}

//MARK: - UICollectionViewDataSource UICollectionViewDataSource
extension SCCycleScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (cellType != .title) ? (internalImageArray!.count) : (internalTitleArray!.count)
        return count * String.cycleCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cycleScrollViewID, for: indexPath)
        
        
        let respondsConfigure = self.delegate?.responds(to: #selector(SCCycleScrollViewDelegate.configureCollectionViewCell(cell:atIndex:for:)))
        let respondsValidation = self.delegate?.responds(to: #selector(SCCycleScrollViewDelegate.cellType(for:)))
        
        var validationResult: AnyClass?
        
        if let respondsValidation = respondsValidation, respondsValidation {
            validationResult = self.delegate?.cellType?(for: self)
        }
        
        if let respondsConfigure = respondsConfigure,
           let respondsValidation = respondsValidation,
           let _ = validationResult,
           respondsConfigure && respondsValidation,
           cellType == .custom {
            return cell
        }
        
        /***********************************自带cell配置*********************************************/
        
        let cycyleScrollViewCell = cell as! SCCycleScrollViewCell
        
        if let type = cellType {
            switch type {
            case .image:
                if let count = internalImageArray?.count, count > 0 {
                    cycyleScrollViewCell.image = internalImageArray?[indexPath.row % count] as? String
                }
            case .title:
                configureCell(cell: cycyleScrollViewCell, atIndexPath: indexPath, scrollViewStyle: type)
            case .mix:
                configureCell(cell: cycyleScrollViewCell, atIndexPath: indexPath, scrollViewStyle: type)
            default:
                break
            }
            
            cycyleScrollViewCell.cellType = cellType
        }
        
        return cycyleScrollViewCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = (cellType != .title) ? (internalImageArray!.count) : (internalTitleArray!.count)
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
        
        guard let count = internalImageArray?.count, count > 0 else {
            return
        }
        
        if pageControlStyle == .classic {
            pageControl.currentPage = currentPage % count
        } else if pageControlStyle == .custom {
            self.delegate?.cycleScrollView?(self, didScroll: scrollView, atIndex: currentPage % count)
        }
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let count = (cellType != .title) ? (internalImageArray!.count) : (internalTitleArray!.count)
        
        delegate?.cycleScrollView?(self, didScroll2ItemAt: currentPage % count)
    }
}

fileprivate extension String {
    static let cycleScrollViewID = "SCCycleScrollViewID"
    static let cycleCount = 1000
}

 @objc public protocol SCCycleScrollViewDelegate: NSObjectProtocol {
    
    @objc optional func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didSelectItemAt index: Int)
    
    @objc optional func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll2ItemAt index: Int)
    
    
    //如果实现自定义pageControl实现此代理方法
    @objc optional func cycleScrollView(_ cycleScrollView: SCCycleScrollView, didScroll scrollView: UIScrollView, atIndex index: NSInteger)
    
    
    //如果自定义cell需要实现下面两个代理方法
    @objc optional func configureCollectionViewCell(cell: UICollectionViewCell, atIndex index: NSInteger,  for cycleScrollView: SCCycleScrollView)
    
    @objc optional func cellType(for cycleScrollView: SCCycleScrollView) -> AnyClass
}
