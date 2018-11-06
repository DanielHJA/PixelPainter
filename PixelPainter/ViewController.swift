//
//  ViewController.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit
import Photos
import TwitterKit

class ViewController: UIViewController {
    
    private var currentImage: UIImage?
    
    private lazy var transitionManager: TransitionManager = {
        return TransitionManager(duration: 0.3)
    }()
    
    private lazy var sharebutton: GrowingMenuButton = {
        let temp = GrowingMenuButton()
        temp.delegate = self
        view.insertSubview(temp, aboveSubview: drawingWindow)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        temp.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        return temp
    }()
    
    private lazy var drawingWindow: DrawingWindow = {
        let temp = DrawingWindow()
        temp.delegate = self
        view.insertSubview(temp, aboveSubview: backgroundImageView)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        temp.heightAnchor.constraint(equalTo: temp.widthAnchor).isActive = true
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
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var dimView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        temp.addGestureRecognizer(dimViewTapGestureRecognizer)
        temp.alpha = 0.7
        view.insertSubview(temp, belowSubview: sharebutton)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var dimViewTapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(dismissDimview))
    }()
    
    private lazy var colorItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.colorPicker), style: .plain, target: self, action: #selector(presentColorPicker(_:))) 
    }()
    
    private lazy var screenshotItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.camera), style: .plain, target: self, action: #selector(screenShot(_:)))
    }()
    
    private lazy var restartItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.remove), style: .plain, target: self, action: #selector(restart(_:)))
    }()
    
    private lazy var eraseItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Constants.Icons.eraser), style: .plain, target: self, action: #selector(erase(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pixler"
        view.backgroundColor = UIColor.white
        setBarButtonItems()
        backgroundImageView.isHidden = false
        drawingWindow.isHidden = false
        sharebutton.isHidden = false
    }
    
    private func setBarButtonItems() {
        navigationItem.rightBarButtonItems = [colorItem, screenshotItem]
        navigationItem.leftBarButtonItems = [restartItem, eraseItem]
    }
    
    @objc private func dismissDimview() {
        sharebutton.close()
    }
    
}

// Selectors
extension ViewController {
    
    @objc private func presentColorPicker(_ sender: UIBarButtonItem) {
        let vc = ColorPickerViewController()
        vc.delegate = drawingWindow
        vc.transitioningDelegate = transitionManager
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func screenShot(_ sender: UIBarButtonItem) {
        currentImage = self.drawingWindow.screenshot()
        guard let image = currentImage else {
            Alert.screenShotAlertWithStatus(.failure, viewController: self)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func erase(_ sender: UIBarButtonItem) {
        drawingWindow.eraserIsActive = !drawingWindow.eraserIsActive
        if drawingWindow.eraserIsActive {
            eraseItem.tintColor = UIColor.blue
        } else {
            eraseItem.tintColor = UIColor.white
        }
    }
    
    @objc private func restart(_ sender: UIBarButtonItem) {
        Alert.confirmAlert(viewController: self) { [unowned self] in
            self.drawingWindow.restart()
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        saveImageNotifierWithError(error)
    }
    
    private func saveImageNotifierWithError(_ error: Error?) {
        let auth = PHPhotoLibrary.authorizationStatus()
        
        switch auth {
        case .denied, .restricted:
            Alert.screenShotAlertWithStatus(.permission, viewController: self)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                guard let wSelf = self else { return }
                wSelf.saveImageNotifierWithError(nil)
            }
        case .authorized:
            if error != nil {
                Alert.screenShotAlertWithStatus(.failure, viewController: self)
            } else {
                Alert.screenShotAlertWithStatus(.success, viewController: self)
            }
        }
    }
}

// NOT WORKING
extension ViewController: GrowingButtonDelegate {
    
    func showingButton(_ showing: Bool) {
        dimView.isHidden = !showing
        if showing {
            navigationItem.rightBarButtonItems?.removeAll()
            navigationItem.leftBarButtonItems?.removeAll()
        } else {
            setBarButtonItems()
        }
    }
    
    func didPressButton(_ provider: SocialMediaProvider) {
        guard let image = currentImage else { return }
        switch provider {
        case .facebook:
            FacebookSharingManager.presentShareDialogIn(self, photo: image)
        case .instragram:
          InstragramSharingManager.presentShareDialogIn(self, photo: image)
        case .twitter:
            break
        }
    }
}

extension ViewController: DrawingWindowDelegate {
    func saveState() {
        currentImage = self.drawingWindow.screenshot()
    }
    
}
