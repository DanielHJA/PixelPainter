//
//  Alert.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-28.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

public enum ScreenshotStatus {
    case success, failure, permission
}

class Alert {

    class func screenShotAlertWithStatus(_ status: ScreenshotStatus, viewController: UIViewController) {
     
        switch status {
        case .success:
            
            let controller = UIAlertController(title: "Saved", message: "Your drawing has been saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Great!", style: .default, handler: nil)
            controller.addAction(okAction)
            viewController.present(controller, animated: true, completion: nil)
            
        case .failure:
            
            let controller = UIAlertController(title: "Save failed", message: "Your drawing was not saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(okAction)
            
        case .permission:
            
            let controller = UIAlertController(title: "Permission needed", message: "You need to give permission to the Photo Library in order to save your drawing", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let permissionAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                self.openSettings()
            }
            
            controller.addAction(cancelAction)
            controller.addAction(permissionAction)
            viewController.present(controller, animated: true, completion: nil)
        }
    }
    
    class func confirmAlert(viewController: UIViewController, completion: @escaping ()->()) {
        let controller = UIAlertController(title: "Remove drawing", message: "This action will remove your current drawing", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    private class func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(url)
        }
    }

}
