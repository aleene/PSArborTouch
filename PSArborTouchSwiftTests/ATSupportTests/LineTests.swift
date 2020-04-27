//
//  LineTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics

class LineTests: XCTestCase {

    func testDistanceOnYAxis() {
        var line = Line()
        line.start = CGPoint(x: 0, y: 0)
        line.end = CGPoint(x: 0, y: 5)
        let distance = line.distance(to: CGPoint(x: 2, y:3))
        XCTAssert(distance == 2.0)
    }

    func testDistanceOnXAxis() {
        var line = Line()
        line.start = CGPoint(x: 0, y: 2)
        line.end = CGPoint(x: 5, y: 2)
        let distance = line.distance(to: CGPoint(x: 2, y:4))
        XCTAssert(distance == 2.0)
    }

}
