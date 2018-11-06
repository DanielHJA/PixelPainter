//
//  FacebookSharingManager.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-10-01.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit
import FacebookShare

class FacebookSharingManager {
    
    class func presentShareDialogIn(_ controller: UIViewController, photo: UIImage) {
        let photo = Photo(image: photo, userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        
        do {
            try ShareDialog.show(from: controller, content: content)
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
