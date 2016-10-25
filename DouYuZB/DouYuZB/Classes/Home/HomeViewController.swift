//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by 沈云翔 on 16/10/18.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
     lazy var pageTitleView : SY_PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏" , "娱乐" ,"趣玩"]
        let titleView = SY_PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    lazy var pageContentView : SY_PageContentView = { [weak self] in
        let contentH = kScreenH - kNavigationBarH - kStatusBarH - kTitleViewH - kTabbarH
        let cotentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
       let pageContentView = SY_PageContentView(frame: cotentFrame, childVcs: childVcs, parenViewController: self)
        pageContentView.delegate = self
        return pageContentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 设置UI界面
extension HomeViewController{
    
    public func setupUI(){
        //1.设置导航栏
        setupNav()
        //2.添加 pageTitleView
        self.view.addSubview(pageTitleView)
        //3.添加 pageContentView
        self.view.addSubview(pageContentView)
        
    }
    
    private func setupNav(){
        //1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        let normalImageArr = ["btn_search", "Image_scan", "image_my_history"]
        let selectedImageArr = ["btn_search_clicked", "Image_scan_click", "Image_my_history_click"]
        var tempArr = [UIBarButtonItem]()
        
        for index in 0...(normalImageArr.count - 1){
            let temp = UIBarButtonItem(imageName: normalImageArr[index], highImageName: selectedImageArr[index], size: size)
            tempArr.append(temp)
        }
        
        navigationItem.rightBarButtonItems = tempArr
    }
}

//MARK: 添加PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate {
    
    func pageTitleView(titleView: SY_PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurentIndex(currentIndex: index)
    }
    
}
//MARK: 添加PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(pageContentView: SY_PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
