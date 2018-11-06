//
//  PixelPainterTests.swift
//  PixelPainterTests
//
//  Created by Daniel Hjärtström on 2018-09-27.
//  Copyright © 2018 Sog. All rights reserved.
//

import XCTest
@testable import PixelPainter

class PixelPainterTests: XCTestCase {

    private var drawingWindow: DrawingWindow!
    
    override func setUp() {
        drawingWindow = DrawingWindow()
    }
    
    func testStartupTilesAreWhite() {
        for item in drawingWindow.tiles {
            if item.backgroundColor != UIColor.white.withAlphaComponent(0.8) {
                XCTFail()
            }
        }
        XCTAssert(true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
