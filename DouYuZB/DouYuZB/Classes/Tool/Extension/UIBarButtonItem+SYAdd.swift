//
//  UIBarButtonItem+SYAdd.swift
//  DouYuZB
//
//  Created by 沈云翔 on 16/10/18.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(imageName:String, highImageName:String = "", size:CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        
        if size != CGSize.zero {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        } else {
            btn.sizeToFit()
        }

        self.init(customView:btn)
        
    }
    
   
    
    
}

