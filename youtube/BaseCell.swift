//
//  BaseCell.swift
//  swift_myyoutube
//
//  Created by Paul Dong on 16/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
