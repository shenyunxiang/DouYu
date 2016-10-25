//
//  MainViewController.swift
//  DouYuZB
//
//  Created by 沈云翔 on 16/10/18.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Me")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func addChildVC(storyName:String){
        //1.通过storyBoard获取控制器
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()
        
        self.addChildViewController(childVC!)
    }


}


