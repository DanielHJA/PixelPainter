//
//  Tile.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

class Tile: UIView {
    
    var color: UIColor = UIColor.white {
        didSet {
            backgroundColor = color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFrames()
    }
    
    private func configureFrames() {
        
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
}
