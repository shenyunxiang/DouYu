//
//  SY_PageTitleView.swift
//  DouYuZB
//
//  Created by 沈云翔 on 16/10/20.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : NSObjectProtocol {
    func pageTitleView(titleView: SY_PageTitleView, selectedIndex index : Int)
}

private let kScrollLineH : CGFloat = 2
private let ktitleLabNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let ktitleLabSelectedColor : (CGFloat, CGFloat, CGFloat) = (255, 128 , 0 )

class SY_PageTitleView: UIView {

    private var titles : [String]?
    fileprivate var currentIndex = 0
    
    weak var delegate: PageTitleViewDelegate?

    private lazy var scrollView : UIScrollView = {
        let scrolView = UIScrollView()
        scrolView.showsHorizontalScrollIndicator = false
        scrolView.scrollsToTop = false
        scrolView.bounces = false
        return scrolView
    }()
    
    fileprivate lazy var scrollLine : UIView = {
       let line = UIView()
        line.backgroundColor = UIColor.orange
        return line
    }()
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //MARK: 自定义构造函数
    init(frame:CGRect, titles:[String]) {
        self.titles = titles;
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        
        addSubview(scrollView)
        scrollView.frame = bounds
        
        setTitleLables()
        
        setupBottomLineAndScrollLine()
        
    }
    
    private func setTitleLables(){
        
        let labelW : CGFloat = frame.width / CGFloat((titles?.count)!)
        let labelH : CGFloat = frame.height - kScrollLineH
        
        for (index, title) in (titles?.enumerated())! {
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            
            if index == 0 {
                label.textColor = UIColor(r: ktitleLabSelectedColor.0,
                                          g: ktitleLabSelectedColor.1,
                                          b: ktitleLabSelectedColor.2)
            }else {
                label.textColor = UIColor(r: ktitleLabNormalColor.0,
                                          g: ktitleLabNormalColor.1,
                                          b: ktitleLabNormalColor.2)
            }
            
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: 0, width: labelW, height: labelH)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLableClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollLine(){
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH,width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        guard let firstTitleLabel = titleLabels.first else {
            return
        }
        scrollLine.frame = CGRect(x: firstTitleLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstTitleLabel.frame.size.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
        
    }
    
    
}
//MARK:-点击事件
extension SY_PageTitleView{
    @objc fileprivate func titleLableClick(tapGes: UITapGestureRecognizer){
        guard let currentTitleLab = tapGes.view as?UILabel else {
            return
        }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentTitleLab.tag == currentIndex { return }
        
        let oldLable = titleLabels[currentIndex]
        
        currentTitleLab.textColor = UIColor(r: ktitleLabSelectedColor.0,
                                            g: ktitleLabSelectedColor.1,
                                            b: ktitleLabSelectedColor.2)
        oldLable.textColor = UIColor(r: ktitleLabNormalColor.0,
                                     g: ktitleLabNormalColor.1,
                                     b: ktitleLabNormalColor.2)
        
        
        currentIndex = currentTitleLab.tag
        
        let scrollLineX = CGFloat(currentTitleLab.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//MARK: 对外暴露的方法
extension SY_PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveToalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX     = moveToalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色渐变
        let colorDelta = (ktitleLabSelectedColor.0 - ktitleLabNormalColor.0,
                          ktitleLabSelectedColor.1 - ktitleLabNormalColor.1,
                          ktitleLabSelectedColor.2 - ktitleLabNormalColor.2)
        sourceLabel.textColor = UIColor(r: ktitleLabSelectedColor.0 - colorDelta.0 * progress,
                                        g: ktitleLabSelectedColor.1 - colorDelta.1 * progress,
                                        b: ktitleLabSelectedColor.2 - colorDelta.2 * progress)
        
        targetLabel.textColor = UIColor(r: ktitleLabNormalColor.0 + colorDelta.0 * progress,
                                        g: ktitleLabNormalColor.1 + colorDelta.1 * progress,
                                        b: ktitleLabNormalColor.2 +  colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}

