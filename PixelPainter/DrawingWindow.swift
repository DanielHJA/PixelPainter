//
//  DrawingWindow.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

class DrawingWindow: UIView {
    
    private var multiplier: Int = 20
    private var tiles = [Tile]()
    private var tileSize: CGFloat = 0.0
    
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
        
        if tiles.isEmpty {
            setupTiles()
        }
    }
    
    private func configureFrames() {
        tileSize = bounds.width / CGFloat(multiplier)
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
    }
    
    private func setupTiles() {
        for a in 0..<multiplier {
            for b in 0..<multiplier {
                let tile = Tile()
                tiles.append(tile)
                addSubview(tile)
                tile.translatesAutoresizingMaskIntoConstraints = false
                tile.heightAnchor.constraint(equalToConstant: tileSize).isActive = true
                tile.widthAnchor.constraint(equalToConstant: tileSize).isActive = true
                tile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: tileSize * CGFloat(b)).isActive = true
                tile.topAnchor.constraint(equalTo: topAnchor, constant: tileSize * CGFloat(a)).isActive = true
            }
        }
    }
}

extension DrawingWindow {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        guard let touchedView = self.hitTest(location, with: event) as? Tile else { return }
        
    }
}
