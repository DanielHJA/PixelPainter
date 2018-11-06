//
//  GrowingMenu.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-28.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

enum SocialMediaProvider {
    case facebook, instragram, twitter
}

protocol GrowingButtonDelegate: class {
    func showingButton(_ showing: Bool)
    func didPressButton(_ provider: SocialMediaProvider)
}

class GrowingMenuButton: UIView {
    
    weak var delegate: GrowingButtonDelegate?
    private var items = [GrowingMenuItem]()
    private var layoutYConstraints = [NSLayoutConstraint]()
    private var isOpen: Bool = false
    
    private lazy var button: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = UIColor.green
        temp.layer.borderColor = UIColor.white.cgColor
        temp.layer.borderWidth = 1.0
        temp.setImage(UIImage(named: "share"), for: .normal)
        temp.addTarget(self, action: #selector(touchBegan), for: .touchDown)
        temp.addTarget(self, action: #selector(touchEnded), for: .touchUpInside)
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return temp
    }()
    
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
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    private func commonInit() {
        setupMenuitems()
    }
    
    private func setupMenuitems() {
        let facebook = GrowingMenuItem(frame: CGRect.zero, image: UIImage(named: "facebook"), provider: .facebook)
        let instragram = GrowingMenuItem(frame: CGRect.zero, image: UIImage(named: "instagram"), provider: .instragram)
//        let twitter = GrowingMenuItem(frame: CGRect.zero, image: UIImage(named: "twitter"), provider: .twitter)
        
        facebook.delegate = self
        instragram.delegate = self
//        twitter.delegate = self
        
        let facebookYConstraint = facebook.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        let instragramYConstraint = instragram.centerYAnchor.constraint(equalTo: button.centerYAnchor)
//        let twitterYConstraint = instragram.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        
        layoutYConstraints = [facebookYConstraint, instragramYConstraint]
        items = [facebook, instragram]
        setConstraintsForView(items)
        
        addConstraints(layoutYConstraints)
        NSLayoutConstraint.activate(layoutYConstraints)
 
        items.forEach { $0.isHidden = false }
    }
    
    private func setConstraintsForView(_ views: [UIView]) {
        for view in views {
            insertSubview(view, belowSubview: button)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
            view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }
    
    private func animate() {
        for (index, constraint) in layoutYConstraints.enumerated() {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: { [unowned self] in
                if self.isOpen {
                    self.layoutYConstraints[(self.layoutYConstraints.count - 1) - index].constant = 0
                } else {
                    constraint.constant = -self.button.frame.height * (CGFloat(self.layoutYConstraints.count) - CGFloat(index)) - (CGFloat(self.layoutYConstraints.count) - CGFloat(index)) * 10.0
                }
                self.layoutIfNeeded()
            }) { (completion) in
            }
        }
        isOpen = !isOpen
        delegate?.showingButton(isOpen)
    }
    
    @objc private func touchBegan() {
        button.layer.transform = CATransform3DScale(layer.transform, 0.9, 0.9, 1.0)
    }

    @objc private func touchEnded() {
        button.layer.transform = CATransform3DScale(layer.transform, 1.0, 1.0, 1.0)
        animate()
    }
    
}

extension GrowingMenuButton: GrowingButtonItemDelegate {
    func didPressButton(_ provider: SocialMediaProvider) {
        animate()
        delegate?.didPressButton(provider)
    }
}

extension GrowingMenuButton {
    func close() {
        animate()
    }
}
