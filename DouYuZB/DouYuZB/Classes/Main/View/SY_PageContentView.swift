//
//  SY_PageContentView.swift
//  DouYuZB
//
//  Created by 沈云翔 on 16/10/20.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : NSObjectProtocol {
    func pageContentView(pageContentView: SY_PageContentView, progress: CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let cellIndetifierId = "cellIndetifierId"

class SY_PageContentView: UIView {

    fileprivate var childVcs : [UIViewController]?
    private var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbiScrollDelegate : Bool = false
    var delegate : PageContentViewDelegate?
    
    
    fileprivate lazy var collectionView : UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIndetifierId)
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parenViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parenViewController
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI(){
    
        for childVc in childVcs! {
            parentViewController?.addChildViewController(childVc)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SY_PageContentView : UICollectionViewDataSource {
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifierId, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let chlidVc = childVcs?[indexPath.item]
        chlidVc?.view.frame = cell.bounds
        cell.contentView.addSubview((chlidVc?.view)!)
        
        return cell
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (childVcs?.count)!
    }
    
    
    
}

extension SY_PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbiScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbiScrollDelegate {
            return
        }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //判断是左滑还是右滑
        let currnetOffsetX = scrollView.contentOffset.x
        let scrollViewW    = scrollView.bounds.size.width
        if currnetOffsetX > startOffsetX { //左滑
            progress = (currnetOffsetX / scrollViewW) - floor(currnetOffsetX / scrollViewW)
            
            sourceIndex = Int(currnetOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= (childVcs?.count)! {
                targetIndex = (childVcs?.count)! - 1
            }
            
            if currnetOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else { // 右滑
            progress = 1 - ((currnetOffsetX / scrollViewW) - floor(currnetOffsetX / scrollViewW))
            targetIndex = Int(currnetOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >=  (childVcs?.count)! {
                sourceIndex = (childVcs?.count)! - 1
            }
        }
        
//        print("progress:\(progress) taretIndex:\(targetIndex) sourceIndex: \(sourceIndex)")
        
        delegate?.pageContentView(pageContentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }

    
}

extension SY_PageContentView {
    func setCurentIndex(currentIndex:Int) {
        
        isForbiScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
