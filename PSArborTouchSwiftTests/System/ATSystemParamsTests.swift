//
//  ATSystemParamsTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics
import SystemRig

class ATSystemParamsTests: XCTestCase {

    func testInit() {
        let params = ATSystemParams()
        XCTAssert(params.repulsion == CGFloat(1000.0))
        XCTAssert(params.stiffness == CGFloat(600.0))
        XCTAssert(params.friction == CGFloat(0.5))
        XCTAssert(params.deltaTime == CGFloat(0.02))
        XCTAssert(params.gravity == true)
        XCTAssert(params.precision == CGFloat(0.6))
        XCTAssert(params.timemout == CGFloat(20.0))
    }

    func testRepulsion() {
        var params = ATSystemParams()
        params.repulsion = CGFloat(50.0)
        XCTAssert(params.repulsion == CGFloat(50.0))
    }
    func testStiffness() {
        var params = ATSystemParams()
        params.stiffness = CGFloat(50.0)
        XCTAssert(params.stiffness == CGFloat(50.0))
    }

    func testFriction() {
        var params = ATSystemParams()
        params.friction = CGFloat(50.0)
        XCTAssert(params.friction == CGFloat(50.0))
    }

    func testDeltaTime() {
        var params = ATSystemParams()
        params.deltaTime = CGFloat(50.0)
        XCTAssert(params.deltaTime == CGFloat(50.0))
    }

    func testGravity() {
        var params = ATSystemParams()
        params.gravity = false
        XCTAssert(params.gravity == false)
    }

    func testPrecision() {
        var params = ATSystemParams()
        params.precision = CGFloat(50.0)
        XCTAssert(params.precision == CGFloat(50.0))
    }

    func testTimemout() {
        var params = ATSystemParams()
        params.timemout = CGFloat(50.0)
        XCTAssert(params.timemout == CGFloat(50.0))
    }

}
