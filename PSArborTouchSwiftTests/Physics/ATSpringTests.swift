//
//  ATSpringTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATSpringTests: XCTestCase {

    func testInit() {
        let spring = ATSpring()
        XCTAssert(spring.stiffness == 1000.0)
    }
    
    func testSetStiffness() {
        let spring = ATSpring()
        spring.stiffness = 3.0
        XCTAssert(spring.stiffness == 3.0)

    }
}
