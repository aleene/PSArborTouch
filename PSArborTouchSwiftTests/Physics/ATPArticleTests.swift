//
//  ATPArticleTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATPArticleTests: XCTestCase {

    func testInit() {
        let particle = ATParticle()
        XCTAssert(particle.velocity == CGPoint.zero)
        XCTAssert(particle.force == CGPoint.zero)
        XCTAssert(particle.tempMass == CGFloat.zero)
        XCTAssert(particle.connections == 0)
    }
    
    func testInitWithVariables() {
        let particle = ATParticle(velocity: CGPoint(x: 3.0, y: 4.0),
                                  force:CGPoint(x: 1.0, y: 2.0),
                                  tempMass: 5.0)
        XCTAssert(particle.velocity.x == 3.0)
        XCTAssert(particle.velocity.y == 4.0)
        XCTAssert(particle.force.x == 1.0)
        XCTAssert(particle.force.y == 2.0)
        XCTAssert(particle.tempMass == 5.0)
        XCTAssert(particle.connections == 0)
    }

    func testApplyForce() {
        let particle = ATParticle(velocity: CGPoint(x: 3.0, y: 4.0),
                                  force:CGPoint(x: 1.0, y: 2.0),
                                  tempMass: 5.0)
        // note that the default node mass is used
        particle.apply(CGPoint(x: 1.0, y: 1.0))
        XCTAssert(particle.force.x == 2.0)
        XCTAssert(particle.force.y == 3.0)
    }
}
