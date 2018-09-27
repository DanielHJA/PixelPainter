//
//  ColorPickerViewController.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit
import ChromaColorPicker

protocol ColorPickerDelegate: class {
    func didChooseColor(_ color: UIColor)
}

class ColorPickerViewController: UIViewController {

    weak var delegate: ColorPickerDelegate?
    
    private lazy var colorPicker: ChromaColorPicker = {
        let temp = ChromaColorPicker()
        temp.delegate = self
        temp.hexLabel.textColor = UIColor.white
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return temp
    }()
    
    private lazy var colorPickerCenterXConstraint: NSLayoutConstraint = {
        let temp = colorPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        temp.isActive = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        colorPicker.isHidden = false
        view.addConstraint(colorPickerCenterXConstraint)
        colorPickerCenterXConstraint.constant = -view.frame.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateColorPicker()
    }
    
    private func animateColorPicker() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let wSelf = self else { return }
            wSelf.colorPickerCenterXConstraint.constant = 0
            wSelf.view.layoutIfNeeded()
        }, completion: nil)
    }

}

extension ColorPickerViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        delegate?.didChooseColor(color)
        dismiss(animated: true, completion: nil)
    }
}
