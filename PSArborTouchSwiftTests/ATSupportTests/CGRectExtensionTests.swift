//
//  CGRectExtensionTests.swift
//  SystemRigTests
//
//  Created by arnaud on 19/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics

class CGRectExtensionTests: XCTestCase {


    func testSet() {
        var topLeft = CGPoint(x: 0.0, y: 10.0)
        var bottomRight = CGPoint(x: 5.0, y: 20.0)
        var rect = CGRect.set(topLeft: topLeft, bottomRight: bottomRight)
        XCTAssert(rect != nil)
        XCTAssert(rect!.origin.x == 0.0)
        XCTAssert(rect!.origin.y == 10.0)
        XCTAssert(rect!.size.width == 5.0)
        XCTAssert(rect!.size.height == 10.0)
        topLeft = CGPoint(x: 5.0, y: 10.0)
        bottomRight = CGPoint(x: 0.0, y: 20.0)
        rect = CGRect.set(topLeft: topLeft, bottomRight: bottomRight)
        XCTAssert(rect == nil)

    }

    func testInclude() {
        let point = CGPoint(x: -5.0, y:3.0)
        let rect = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 6.0)
        let newRect = rect.include(point)
        XCTAssert(newRect != nil)
        XCTAssert(newRect!.origin.x == -5.0)
        XCTAssert(newRect!.origin.y == 0.0)
        XCTAssert(newRect!.size.width == 15.0)
        XCTAssert(newRect!.size.height == 6.0)

    }
}
