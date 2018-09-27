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
