//
//  GrowingMenuItem.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-28.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

protocol GrowingButtonItemDelegate: class {
    func didPressButton(_ provider: SocialMediaProvider)
}

class GrowingMenuItem: UIButton {
    
    weak var delegate: GrowingButtonItemDelegate?
    private var image: UIImage?
    private(set) var provider: SocialMediaProvider?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(frame: CGRect, image: UIImage?, provider: SocialMediaProvider) {
        self.init(frame: frame)
        self.image = image
        self.provider = provider
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFrames()
    }
    
    private func configureFrames() {
        layer.cornerRadius = frame.height / 2
    }
    
    private func commonInit() {
        guard let image = image else { return }
        setImage(image, for: .normal)
        clipsToBounds = false
        layer.masksToBounds = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let provider = provider else { return }
        delegate?.didPressButton(provider)
    }
    
}
