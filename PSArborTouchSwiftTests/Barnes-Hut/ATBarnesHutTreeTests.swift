//
//  ATBarnesHutTreeTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATBarnesHutTreeTests: XCTestCase {

    func testInit() {
        let bht = ATBarnesHutTree()
        XCTAssert(bht.bounds == CGRect.zero)
        XCTAssert(bht.theta == 0.4)
    }
    
    func testUpdate () {
        let bounds = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)
        let theta = CGFloat(5.0)
        let bht = ATBarnesHutTree()
        bht.update(bounds: bounds, theta: theta)
        XCTAssert(bht.bounds.origin.x == 1.0)
        XCTAssert(bht.bounds.origin.y == 2.0)
        XCTAssert(bht.bounds.size.width == 3.0)
        XCTAssert(bht.bounds.size.height == 4.0)
        XCTAssert(bht.theta == 5.0)
    }
    
    func testInsert() {}
    
    func testApplyForces() {}
    
}
