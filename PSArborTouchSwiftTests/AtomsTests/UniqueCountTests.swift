//
//  UniqueCountTests.swift
//  SystemRigTests
//
//  Created by arnaud on 06/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import SystemRig

class UniqueCountTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUniqueCountForNodes() {
        // reset the counter to have an independent test
        UniqueCount.manager.reset()
        var count = UniqueCount.manager.nextNodeCount
        count = UniqueCount.manager.nextNodeCount
        count = UniqueCount.manager.nextNodeCount
        count = UniqueCount.manager.nextNodeCount
        XCTAssert(count == 4)
    }

    func testUniqueCountForEdges() {
        // reset the counter to have an independent test
        UniqueCount.manager.reset()
        var count = UniqueCount.manager.nextEdgeCount
        count = UniqueCount.manager.nextEdgeCount
        count = UniqueCount.manager.nextEdgeCount
        count = UniqueCount.manager.nextEdgeCount
        XCTAssert(count == -4)
    }

}
