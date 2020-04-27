//
//  CGScaleTests.swift
//  SystemRigTests
//
//  Created by arnaud on 08/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics
import UIKit
import PSArborTouchSwift

class CGSizeExtensionTests: XCTestCase {

    func testScale() {
        let size = CGSize(width: 100.0, height: 40.0)
        let newSize = size.scale(by: 0.25)
        XCTAssert(newSize.width == 25.0)
        XCTAssert(newSize.height == 10.0)

    }
    
    func testHalved() {
        let size = CGSize(width: 100.0, height: 40.0)
        let newSize = size.halved
        XCTAssert(newSize.width == 50.0)
        XCTAssert(newSize.height == 20.0)

    }

    func testSubtract(value: CGFloat) {
        let size = CGSize(width: 100.0, height: 40.0)
        let point = size.reduce(by: 10.0)
        XCTAssert(point.x == 90.0)
        XCTAssert(point.y == 30.0)

    }

    func testReduce() {
        let size = CGSize(width: 100.0, height: 100.0)
        let padding = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let newSize = size.pad(with: padding)
        XCTAssert(newSize.width == 80.0)
        XCTAssert(newSize.height == 80.0)

    }
    
    func testToViewScale() {
        let size = CGSize(width: 100.0, height: 100.0)
        let viewSize = CGSize(width: 300.0, height: 500.0)
        let screenSize = CGSize(width: 200.0, height: 400.0)
        // scaleWidth = 0.5, scaleHeight = 0.25
        // uniformScale = 300.
        let viewMode = ATViewConversion.scale
        let newSize = size.toView(viewSize: viewSize, screenSize: screenSize, viewMode: viewMode)
        XCTAssert(newSize.width == 150.0)
        XCTAssert(newSize.height == 75.0)
    }
    
    func testToViewStretch() {
        let size = CGSize(width: 100.0, height: 100.0)
        let viewSize = CGSize(width: 300.0, height: 600.0)
        let screenSize = CGSize(width: 200.0, height: 400.0)
        // scaleWidth = 0.5, scaleHeight = 0.25
        let viewMode = ATViewConversion.stretch
        let newSize = size.toView(viewSize: viewSize, screenSize: screenSize, viewMode: viewMode)
        XCTAssert(newSize.width == 150.0)
        XCTAssert(newSize.height == 150.0)
    }

    func testQuadrantContaining() {
        let size = CGSize(width: 100, height: 80)
        var point = CGPoint(x: 60, y: 60)
        XCTAssert(size.quadrant(containing: point) == .bottomRight)
        point = CGPoint(x: 30, y: 60)
        XCTAssert(size.quadrant(containing: point) == .bottomLeft)
        point = CGPoint(x: 60, y: 30)
        XCTAssert(size.quadrant(containing: point) == .topRight)
        point = CGPoint(x: 30, y: 30)
        XCTAssert(size.quadrant(containing: point) == .topLeft)
    }
}
