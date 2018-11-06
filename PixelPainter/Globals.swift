//
//  Globals.swift
//  PixelPainter
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import UIKit

extension NSObject {
    func isPortrait() -> Bool {
        let temp = UIDevice.current.orientation
        return temp.isPortrait
    }
}

extension UIView {
    func screenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image(actions: { (context) in
            layer.render(in: context.cgContext)
        })
    }
}

extension NSObject {
    func background(completion: @escaping ()->()) {
        DispatchQueue.global().async(group: nil, qos: .background) {
            completion()
        }
    }
    
    func userInitiated(completion: @escaping ()->()) {
        DispatchQueue.global().async(group: nil, qos: .userInitiated) {
            completion()
        }
    }
    
    func userInteractive(completion: @escaping ()->()) {
        DispatchQueue.global().async(group: nil, qos: .userInteractive) {
            completion()
        }
    }
    
    func utility(completion: @escaping ()->()) {
        DispatchQueue.global().async(group: nil, qos: .utility) {
            completion()
        }
    }
    
    func main(completion: @escaping ()->()) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
