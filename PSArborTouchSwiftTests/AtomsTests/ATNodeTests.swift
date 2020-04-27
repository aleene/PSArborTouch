//
//  ATNodeTests.swift
//  SystemRigTests
//
//  Created by arnaud on 06/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig
import CoreGraphics

class ATNodeTests: XCTestCase {

    override func setUp() {
        UniqueCount.manager.reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() {
        var node1 = ATNode()
        node1 = ATNode()
        node1 = ATNode()
        node1 = ATNode()
        XCTAssert(node1.index == 4)
        XCTAssert(node1.name == "")
        XCTAssert(node1.mass == 1.0)
        XCTAssert(node1.position!.x == 0)
        XCTAssert(node1.position!.y == 0)
        XCTAssert(node1.isFixed == false)
        XCTAssert(node1.userData.isEmpty)

    }

    func testInitWithPosition() {
        let node = ATNode(name:"a", mass: CGFloat(5.0), position: CGPoint(x: 5.0, y: -6.0), fixed: true )
        XCTAssert(node.name == "a")
        XCTAssert(node.mass == CGFloat(5.0))
        XCTAssert(node.position!.x == 5.0)
        XCTAssert(node.position!.y == -6.0)
        XCTAssert(node.isFixed == true)
        XCTAssert(node.index == 1)

    }

    func testInitWithUserData() {
        let node = ATNode(name:"a", userData: ["test":"drie"] )
        XCTAssert(node.name == "a")
        XCTAssert(node.mass == 1.0)
        XCTAssert(node.position!.x == 0)
        XCTAssert(node.position!.y == 0)
        XCTAssert(node.isFixed == false)
        XCTAssert(node.userData.first!.key == "test")
        XCTAssert(node.userData.first!.value == "drie")
        XCTAssert(node.index == 1)
    }

    func testEquatable() {
        let node1 = ATNode()
        let node2 = ATNode()
        XCTAssert(node1 == node1)
        XCTAssert(node1 != node2)
    }
    
}
