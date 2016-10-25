//
//  CollectionNormalViewCell.swift
//  DouYuZB
//
//  Created by 沈云翔 on 2016/10/23.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

import UIKit

class CollectionNormalViewCell: UICollectionViewCell {

    @IBOutlet weak var preImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preImageView.layer.cornerRadius = 5
        preImageView.layer.masksToBounds = true
        
    }

}
