//
//  ViewController.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var transitionManager: TransitionManager = {
        return TransitionManager(duration: 0.3)
    }()
    
    private lazy var drawingWindow: DrawingWindow = {
        let temp = DrawingWindow()
        view.insertSubview(temp, aboveSubview: backgroundImageView)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        temp.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        return temp
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage(named: Constants.Images.background)
        temp.contentMode = .scaleAspectFill
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var colorPicker: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.colorPicker), style: .plain, target: self, action: #selector(presentColorPicker(_:))) 
    }()
    
    private lazy var screenshotItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.camera), style: .plain, target: self, action: #selector(presentColorPicker(_:)))
    }()
    
    private lazy var restartItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.remove), style: .plain, target: self, action: #selector(presentColorPicker(_:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pixler"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = colorPicker
        backgroundImageView.isHidden = false
        drawingWindow.isHidden = false
    }

    @objc private func presentColorPicker(_ sender: UIBarButtonItem) {
        let vc = ColorPickerViewController()
        vc.delegate = drawingWindow
        vc.transitioningDelegate = transitionManager
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
}

