//
//  ATEnergyTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATEnergyTests: XCTestCase {

    func testInit() {
        let energy = ATEnergy()
        XCTAssert(energy.sum == CGFloat.zero)
        XCTAssert(energy.max == CGFloat.zero)
        XCTAssert(energy.mean == CGFloat.zero)
        XCTAssert(energy.count == 0)
    }
    
    func testInitWithVariables() {
        let energy = ATEnergy(sum: 3.0, max:4.0, mean: 5.0, count: 6)
        XCTAssert(energy.sum == 3.0)
        XCTAssert(energy.max == 4.0)
        XCTAssert(energy.mean == 5.0)
        XCTAssert(energy.count == 6)
    }
    
    func testSetSum() {
        var energy = ATEnergy()
        energy.sum = 3.0
        XCTAssert(energy.sum == 3.0)
    }

    func testSetMax() {
        var energy = ATEnergy()
        energy.max = 3.0
        XCTAssert(energy.max == 3.0)
    }

    func testSetMean() {
        var energy = ATEnergy()
        energy.mean = 3.0
        XCTAssert(energy.mean == 3.0)
    }

    func testSetCount() {
        var energy = ATEnergy()
        energy.count = 3
        XCTAssert(energy.count == 3)
    }

}
