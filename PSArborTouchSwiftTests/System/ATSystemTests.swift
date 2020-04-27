//
//  ATSystemTests.swift
//  SystemRigTests
//
//  Created by arnaud on 07/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics
import SystemRig

class ATSystemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetNode() {
        let system = ATSystem()
        let node1 = ATNode(name: "a", userData: [:])
        let node2 = ATNode(name: "b", userData: [:])
        let node3 = ATNode(name: "c", userData: [:])
        let node4 = ATNode(name: "d", userData: [:])
        
        system.state.setNames(with: node1, for: node1.name!)
        system.state.setNames(with: node2, for: node2.name!)
        system.state.setNames(with: node3, for: node3.name!)
        system.state.setNames(with: node4, for: node4.name!)
        
        let name = "c"
        let node = system.getNode(with: name)
        XCTAssert(node == node3)
    }
    
    func testAddNode() {
        let system = ATSystem()
        let node1 = ATNode(name: "a", userData: [:])
        let node2 = ATNode(name: "b", userData: [:])
        let node3 = ATNode(name: "c", userData: [:])
        let node4 = ATNode(name: "d", userData: [:])
        
        system.state.setNames(with: node1, for: node1.name!)
        system.state.setNames(with: node2, for: node2.name!)
        system.state.setNames(with: node3, for: node3.name!)
        system.state.setNames(with: node4, for: node4.name!)

        let newNode = system.addNode(with: "e", and: [:])
        XCTAssert(newNode! == system.state.getNodeFromNames(for: "e"))

    }
}
