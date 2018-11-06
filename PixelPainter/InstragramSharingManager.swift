
//
//  InstragramSharingManager.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-10-01.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

class InstragramSharingManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    class func presentShareDialogIn(_ controller: UIViewController, photo: UIImage) {
        guard let instagramURL = URL(string: "instagram://app") else { return }
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            print("Unable to open Instagram")
        }
        // Not working, hooks seem to be outdated
//        savePhoto(photo) { success, result, error in
//            if success {
//                if UIApplication.shared.canOpenURL(instagramURL) {
//                    presentDialogInController(controller, path: result)
//                } else {
//                    print("Unable to open Instagram")
//                }
//            } else {
//                print("Save photo failed")
//            }
//        }
    }
    
    class func presentDialogInController(_ controller: UIViewController, path: URL?) {
        guard let url = path else { return }
        let documentsController = UIDocumentInteractionController()
        documentsController.url = url
        documentsController.annotation = ["InstragramCaption":"Testing"]
        documentsController.uti = "com.instagram.exclusivegram"
        documentsController.presentOpenInMenu(from: CGRect(x: 0, y: 0, width: 200, height: 200), in: controller.view, animated: true)
    }
    
    class func savePhoto(_ photo: UIImage, completion: @escaping (_ success: Bool, _ result: URL?, _ error: Error?) -> ()) {
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let data = photo.jpegData(compressionQuality: 1.0)
            let savePath = URL(fileURLWithPath: (documentsPath as NSString).appendingPathComponent("instagramImage.igo"))
            
            do {
                try data?.write(to: savePath, options: [])
                completion(true, savePath, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil, error)
            }
        }
    }
}
