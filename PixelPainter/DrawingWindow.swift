//
//  DrawingWindow.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

protocol DrawingWindowDelegate: class {
    func saveState()
}

class DrawingWindow: UIView {
    
    weak var delegate: DrawingWindowDelegate?
    private var multiplier: Int = 20
    private(set) var tiles = [[Tile]]()
    private var tileSize: CGFloat = 0.0
    private(set) var currentColor: UIColor = UIColor.black
    var eraserIsActive: Bool = false
    
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
        let _ = (tiles.flatMap { $0 }).forEach { $0.removeFromSuperview() }
        tiles.removeAll()
        
        var tempTiles = [Tile]()
        
        for a in 0..<multiplier {
            for b in 0..<multiplier {
                let tile = Tile()
                tempTiles.append(tile)
                addSubview(tile)
                tile.translatesAutoresizingMaskIntoConstraints = false
                let sizePercentage = (bounds.height / CGFloat(multiplier)) / bounds.height
                tile.heightAnchor.constraint(equalTo: heightAnchor, multiplier: sizePercentage).isActive = true
                tile.widthAnchor.constraint(equalTo: tile.heightAnchor).isActive = true
                
                if a == 0 {
                    tile.topAnchor.constraint(equalTo: topAnchor).isActive = true
                } else {
                    tile.topAnchor.constraint(equalTo: tiles[a-1].first!.bottomAnchor).isActive = true
                }
                
                if b == 0 {
                    tile.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                } else {
                    tile.leadingAnchor.constraint(equalTo: tempTiles[b-1].trailingAnchor).isActive = true
                }
            }
            
            tiles.append(tempTiles)
            tempTiles.removeAll()
        }
    }
    
    func restart() {
        setupTiles()
    }
}

extension DrawingWindow {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedView = touchedView(touches, with: event) else { return }

        if !eraserIsActive {
            touchedView.color = currentColor
        } else {
            touchedView.color = UIColor.white
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedView = touchedView(touches, with: event) else { return }
        
        if eraserIsActive {
            touchedView.color = UIColor.white
        } else {
            touchedView.color = currentColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.saveState()
    }
    
    private func touchedView(_ touches: Set<UITouch>, with event: UIEvent?) -> Tile? {
        guard let touch = touches.first else { return nil }
        let location = touch.location(in: self)
        guard let touchedView = self.hitTest(location, with: event) as? Tile else { return nil }
        return touchedView
    }
}

extension DrawingWindow: ColorPickerDelegate {
    func didChooseColor(_ color: UIColor) {
        currentColor = color
    }
}
