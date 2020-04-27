//
//  ATBarnesHutBranchTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATBarnesHutBranchTests: XCTestCase {

    func testInit() {
        let bhbt = ATBarnesHutBranch()
        XCTAssert(bhbt.bounds == CGRect.zero)
        XCTAssert(bhbt.mass == CGFloat.zero)
        XCTAssert(bhbt.position == CGPoint.zero)
        XCTAssert(bhbt.allQuadrantObjects.count == 4)
        XCTAssert(bhbt.quadrantObject[.topRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.topLeft]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomLeft]! == .undefined)
    }
    
    func testInitConvenience() {
        let bounds = CGRect(x: 2.0, y: 3.0, width: 4.0, height: 5.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 7.0, y: 8.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        XCTAssert(bhbt.bounds.origin.x == 2.0)
        XCTAssert(bhbt.bounds.origin.y == 3.0)
        XCTAssert(bhbt.bounds.size.width == 4.0)
        XCTAssert(bhbt.bounds.size.height == 5.0)
        XCTAssert(bhbt.mass == 6.0)
        XCTAssert(bhbt.position.x == 7.0)
        XCTAssert(bhbt.position.y == 8.0)
        XCTAssert(bhbt.allQuadrantObjects.count == 4)
        XCTAssert(bhbt.quadrantObject[.topRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.topLeft]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomLeft]! == .undefined)
    }

    func testReset() {
        let bounds = CGRect(x: 2.0, y: 3.0, width: 4.0, height: 5.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 7.0, y: 8.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        bhbt.reset()
        XCTAssert(bhbt.bounds == CGRect.zero)
        XCTAssert(bhbt.mass == CGFloat.zero)
        XCTAssert(bhbt.position == CGPoint.zero)
        XCTAssert(bhbt.allQuadrantObjects.count == 4)
        XCTAssert(bhbt.quadrantObject[.topRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.topLeft]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomRight]! == .undefined)
        XCTAssert(bhbt.quadrantObject[.bottomLeft]! == .undefined)
    }
    
    func testQuadrantContainingParticle() {
        let bounds = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 80.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 4.0, y: 5.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        let particle = ATParticle(name: "test", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let test = bhbt.quadrant(containing: particle)
        XCTAssert(test == .topLeft)
    }

    func testQuadrantObjectForParticle() {
        let bounds = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 80.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 4.0, y: 5.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        let particle2 = ATParticle(name: "test", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        bhbt.quadrantObject[.topLeft] = .particle(particle2)
        let particle = ATParticle(name: "test", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let test = bhbt.quadrantObjectFor(particle)
        XCTAssert(test == .particle(particle2))
    }
    
    func testAllQuadrantObjects() {
        let bounds = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 80.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 4.0, y: 5.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        let particleTL = ATParticle(name: "topLeft", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let particleTR = ATParticle(name: "topRight", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let particleBL = ATParticle(name: "bottomLeft", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let particleBR = ATParticle(name: "bottomRight", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        bhbt.quadrantObject[.topLeft] = .particle(particleTL)
        bhbt.quadrantObject[.topRight] = .particle(particleTR)
        bhbt.quadrantObject[.bottomLeft] = .particle(particleBL)
        bhbt.quadrantObject[.bottomRight] = .particle(particleBR)
        let result: [ATBarnesHutNode] = bhbt.allQuadrantObjects
        var index = result.firstIndex(of: .particle(particleTL))
        XCTAssert(index != nil)
        index = result.firstIndex(of: .particle(particleTR))
        XCTAssert(index != nil)
        index = result.firstIndex(of: .particle(particleBR))
        XCTAssert(index != nil)
        index = result.firstIndex(of: .particle(particleBL))
        XCTAssert(index != nil)
    }
    
    func testAllQuadrantBranches() {
        let bounds = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 80.0)
        let mass = CGFloat(6.0)
        let position = CGPoint(x: 4.0, y: 5.0)
        let bhbt = ATBarnesHutBranch(bounds: bounds, mass: mass, position: position)
        let particleTL = ATParticle(name: "topLeft", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let particleTR = ATParticle(name: "topRight", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let particleBL = ATParticle(name: "bottomLeft", mass: 0.0, position: CGPoint(x: 30, y: 50), fixed: false)
        let branchBR = ATBarnesHutBranch()
        bhbt.quadrantObject[.topLeft] = .particle(particleTL)
        bhbt.quadrantObject[.topRight] = .particle(particleTR)
        bhbt.quadrantObject[.bottomLeft] = .particle(particleBL)
        bhbt.quadrantObject[.bottomRight] = .tree(branchBR)
        let result: [ATBarnesHutNode] = bhbt.allQuadrantObjects
        let index = result.firstIndex(of: .tree(branchBR))
        XCTAssert(index != nil)
    }

}
