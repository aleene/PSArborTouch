//
//  ATSystemStateTests.swift
//  SystemRigTests
//
//  Created by arnaud on 08/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics
import SystemRig

class ATSystemStateTests: XCTestCase {

    override func setUp() {
        
    }

    func testInit() {
        let systemState = ATSystemState()
        XCTAssert(systemState.nodes.isEmpty)
        XCTAssert(systemState.edges.isEmpty)
        XCTAssert(systemState.adjacency.isEmpty)
        XCTAssert(systemState.names.isEmpty)
    }
    
    func testNodes() {
        var systemState = ATSystemState()
        let node1 = ATNode(name: "a", userData: [:])
        let node2 = ATNode(name: "b", userData: [:])
        let node3 = ATNode(name: "c", userData: [:])
        let node4 = ATNode(name: "d", userData: [:])
        systemState.setNodes(with: node1, for: node1.index)
        systemState.addToNodes(node2)
        systemState.setNodes(with: node3, for: node3.index)
        systemState.addToNodes(node4)
        XCTAssert(systemState.nodes.count == 4)
        XCTAssert(systemState.getNodeFromNodes(for: node1.index) == node1)
        systemState.removeNodeFromNodes(for: node4.index)
        XCTAssert(systemState.getNodeFromNodes(for: node4.index) == nil)
    }
    
    func testNodeNames() {
        var systemState = ATSystemState()
        let node1 = ATNode(name: "a", userData: [:])
        let node2 = ATNode(name: "b", userData: [:])
        let node3 = ATNode(name: "c", userData: [:])
        let node4 = ATNode(name: "d", userData: [:])
        systemState.setNames(with: node1, for: "a")
        systemState.addToNames(node2)
        systemState.setNames(with: node3, for: node3.name)
        systemState.addToNames(node4)
        XCTAssert(systemState.names.count == 4)
        XCTAssert(systemState.getNodeFromNames(for: node1.name) == node1)
        systemState.removeNodeFromNames(for: node4.name)
        XCTAssert(systemState.getNodeFromNames(for: node4.name) == nil)

    }

}
