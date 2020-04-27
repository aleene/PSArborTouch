//
//  ATEdgeTests.swift
//  SystemRigTests
//
//  Created by arnaud on 06/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATEdgeTests: XCTestCase {

    override func setUp() {
        UniqueCount.manager.reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() {
        var edge1 = ATEdge()
        edge1 = ATEdge()
        edge1 = ATEdge()
        edge1 = ATEdge()
        XCTAssert(edge1.index == -4)
        XCTAssert(edge1.source == nil)
        XCTAssert(edge1.target == nil)
        XCTAssert(edge1.length == 1.0)
        XCTAssert(edge1.userData.isEmpty)
    }

    func testInitWithLength() {
        let node1 = ATNode(name: "a", mass: 3, position: CGPoint(x: 1, y: 2), fixed: false)
        let node2 = ATNode(name: "b", mass: 2, position: CGPoint(x: 3, y: 8), fixed: false)
        let edge = ATEdge(source: node1, target: node2, length:3.0)
        XCTAssert(edge.index == -1)
        XCTAssert(edge.source == node1)
        XCTAssert(edge.target == node2)
        XCTAssert(edge.length == 3)
        XCTAssert(edge.userData.isEmpty)
    }
    
    func testInitWithUerData() {
        let node1 = ATNode(name: "a", mass: 3, position: CGPoint(x: 1, y: 2), fixed: false)
        let node2 = ATNode(name: "b", mass: 2, position: CGPoint(x: 3, y: 8), fixed: false)
        let edge = ATEdge(source: node1, target: node2, userData:["test":"drie"])
        XCTAssert(edge.index == -1)
        XCTAssert(edge.source == node1)
        XCTAssert(edge.target == node2)
        XCTAssert(edge.length == 1.0)
        XCTAssert(edge.userData.first!.key == "test")
        XCTAssert(edge.userData.first!.value == "drie")
    }

    func testEquatable() {
        let node1 = ATNode(name: "a", mass: 3, position: CGPoint(x: 1, y: 2), fixed: false)
        let node2 = ATNode(name: "b", mass: 2, position: CGPoint(x: 3, y: 8), fixed: false)
        let edge1 = ATEdge(source: node1, target: node2, length:3.0)
        let edge2 = ATEdge(source: node2, target: node1, length:5.0)
        XCTAssert(edge1 == edge1)
        XCTAssert(edge1 != edge2)
    }
    
    func testDistanceOnXAxis() {
        let node1 = ATNode(name: "a", mass: 3, position: CGPoint(x: 0, y: 0), fixed: false)
        let node2 = ATNode(name: "b", mass: 2, position: CGPoint(x: 5, y: 0), fixed: false)
        let node3 = ATNode(name: "c", mass: 2, position: CGPoint(x: 2, y:2), fixed: false)
        let edge = ATEdge(source: node1, target: node2, userData:[:])
        let distance = edge.distance(to:node3)
        XCTAssert(distance! == 2.0)
    }
    
    func testDistanceOnYAxis() {
        let node1 = ATNode(name: "a", mass: 3, position: CGPoint(x: 0, y: 0), fixed: false)
        let node2 = ATNode(name: "b", mass: 2, position: CGPoint(x: 0, y: 5), fixed: false)
        let node3 = ATNode(name: "c", mass: 2, position: CGPoint(x: 2, y:3), fixed: false)
        let edge = ATEdge(source: node1, target: node2, userData:[:])
        let distance = edge.distance(to:node3)
        XCTAssert(distance! == 2.0)
    }

}
