//
//  CGPointExtensionTests.swift
//  SystemRigTests
//
//  Created by arnaud on 06/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import XCTest
import CoreGraphics

class CGPointExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdd() {
        let point1 = CGPoint(x: 5.0, y: 2.0)
        let point2 = CGPoint(x: 3.0, y: 4.0)
        let newPoint = point1.add(point2)
        XCTAssert(newPoint.x == 8.0)
        XCTAssert(newPoint.y == 6.0)
        
        // TODO: why can this not be tested?
        //let newPoint2 = point1 + point2
        //XCTAssert(newPoint.x == 8.0)
        //XCTAssert(newPoint.y == 6.0)
    }

    func testSubtract() {
        let point1 = CGPoint(x: 5.0, y: 2.0)
        let point2 = CGPoint(x: 3.0, y: 4.0)
        let newPoint = point1.subtract(point2)
        XCTAssert(newPoint.x == 2.0)
        XCTAssert(newPoint.y == -2.0)
    }

    func testMultiply() {
        let point1 = CGPoint(x: 5.0, y: 2.0)
        let point2 = CGPoint(x: 3.0, y: 4.0)
        let newPoint = point1.multiply(by: point2)
        XCTAssert(newPoint.x == 15.0)
        XCTAssert(newPoint.y == 8.0)
    }

    func testScale() {
        let point1 = CGPoint(x: 5.0, y: 2.0)
        let scale = CGFloat(3.0)
        let newPoint = point1.scale(by: scale)
        XCTAssert(newPoint.x == 15.0)
        XCTAssert(newPoint.y == 6.0)
    }
    
    func testScaleBySize() {
        let point = CGPoint(x: 5.0, y: 2.0)
        let size = CGSize(width: 5.0, height: 2.0 )
        let newPoint = point.divideSize(size)
        XCTAssert(newPoint!.x == 1.0)
        XCTAssert(newPoint!.y == 1.0)
    }

    func testDivide() {
        let point1 = CGPoint(x: 9.0, y: 3.0)
        let scale = CGFloat(3.0)
        let newPoint = point1.divide(by: scale)
        XCTAssert(newPoint != nil)
        XCTAssert(newPoint!.x == 3.0)
        XCTAssert(newPoint!.y == 1.0)
    }

    func testDistance() {
        let point1 = CGPoint(x: 5.0, y: 2.0)
        let point2 = CGPoint(x: 2.0, y: 6.0)
        let distance = point1.distance(to: point2)
        XCTAssert(distance == 5.0)
    }

    func testMagnitude() {
        let point1 = CGPoint(x: 3.0, y: 4.0)
        let distance = point1.magnitude
        XCTAssert(distance == 5.0)
    }

    func testNormal() {
        let point1 = CGPoint(x: 3.0, y: 4.0)
        let newPoint = point1.normal()
        XCTAssert(newPoint.x == 3.0)
        XCTAssert(newPoint.y == -4.0)
    }

    func testNormalize() {
        let point1 = CGPoint(x: 3.0, y: 4.0)
        let newPoint = point1.normalize()
        XCTAssert(newPoint != nil)
        XCTAssert(newPoint!.x == 0.6)
        XCTAssert(newPoint!.y == 0.8)
    }
    
    func testRandom() {
        // This should create a point around (0.00 within a circle of size radius
        let radius = CGFloat(3.0)
        let newPoint = CGPoint.random(radius: radius)
        // test extremities
        XCTAssert(newPoint!.x >= -3.0)
        XCTAssert(newPoint!.x <= 3.0)
        XCTAssert(newPoint!.y >= -3.0)
        XCTAssert(newPoint!.y <= 3.0)
        // test circle
        XCTAssert(newPoint!.magnitude <= 3.0)
    }

    func testRandomNegativeWithNegativeRadius() {
        // This should create a point around (0.00 within a circle of size radius
        let radius = CGFloat(-3.0)
        let newPoint = CGPoint.random(radius: radius)
        XCTAssert(newPoint == nil)
    }
    func testNearPoint() {
        let radius = CGFloat(3.0)
        let point = CGPoint(x: 1.0, y: 2.0)
        let newPoint = point.nearPoint(radius: radius)
        // test extremities
        let newCircle = newPoint!.subtract(point)
        XCTAssert(newPoint!.x >= -2.0)
        XCTAssert(newPoint!.x <= 4.0)
        XCTAssert(newPoint!.y >= -1.0)
        XCTAssert(newPoint!.y <= 5.0)
        // The point should lie within a circle of radius around point.
        XCTAssert(newCircle.magnitude <= radius)
    }
    
    func testNearPointWithNegativeRadius() {
        let radius = CGFloat(-3.0)
        let point = CGPoint(x: 1.0, y: 2.0)
        let newPoint = point.nearPoint(radius: radius)
        XCTAssert(newPoint == nil)
    }
    
    func testTopLeft() {
        let currentTopLeft = CGPoint(x: 3.0, y: 2.0)
        
        var point = CGPoint(x: 1.0, y: 4.0)
        var newPoint = currentTopLeft.replaceWithPointIfSmaller(point: point)
        XCTAssert(newPoint.x == 1.0)
        XCTAssert(newPoint.y == 2.0)
        
        point = CGPoint(x: 2.0, y: 5.0)
        newPoint = currentTopLeft.replaceWithPointIfSmaller(point: point)
        XCTAssert(newPoint.x == 2.0)
        XCTAssert(newPoint.y == 2.0)
        
        point = CGPoint(x: 4.0, y: 1.0)
        newPoint = currentTopLeft.replaceWithPointIfSmaller(point: point)
        XCTAssert(newPoint.x == 3.0)
        XCTAssert(newPoint.y == 1.0)
        
        point = CGPoint(x: 1.0, y: 1.0)
        newPoint = currentTopLeft.replaceWithPointIfSmaller(point: point)
        XCTAssert(newPoint.x == 1.0)
        XCTAssert(newPoint.y == 1.0)
    }
    
    func testScaleInRect() {
        let point = CGPoint(x: 70.0, y: 40.0)
        let rect = CGRect(x: 50.0, y: 10.0, width: 20.0, height: 30.0)
        var newPoint = point.subtract(rect.origin).divideSize(rect.size)
        XCTAssert(newPoint!.x == 1.0)
        XCTAssert(newPoint!.y == 1.0)
        newPoint = point.scaleInRect(rect)
        XCTAssert(newPoint!.x == 1.0)
        XCTAssert(newPoint!.y == 1.0)

    }
    
    func testEnsureMinimumDimensionLargeEnough() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 80.0)
        let dimension = CGFloat(10.0)
        let newRect = rect.ensureMinimumDimension(dimension)
        XCTAssert(newRect!.origin.x == 0.0)
        XCTAssert(newRect!.origin.y == 0.0)
        XCTAssert(newRect!.size.width == 100.0)
        XCTAssert(newRect!.size.height == 80.0)
    }
    
    func testEnsureMinimumDimensionToSmall() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 80.0)
        let dimension = CGFloat(200.0)
        let newRect = rect.ensureMinimumDimension(dimension)
        XCTAssert(newRect!.origin.x == -50.0)
        XCTAssert(newRect!.origin.y == -60.0)
        XCTAssert(newRect!.size.width == 200.0)
        XCTAssert(newRect!.size.height == 200.0)
    }

    func testTween() {
        let startRect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 80.0)
        let endRect = CGRect(x: 10.0, y: 8.0, width: 200.0, height: 160.0)
        let scale = CGFloat(0.1)
        let newRect = startRect.tweenTo(rect:endRect, with: scale)
        XCTAssert(newRect.origin.x == 1.0)
        XCTAssert(newRect.origin.y == 0.8)
        XCTAssert(newRect.size.width == 110.0)
        XCTAssert(newRect.size.height == 88.0)
    }
    
    
    func testQuadrantContaining() {
        let rect = CGRect(x:20, y:30, width: 100, height: 80)
        var point = CGPoint(x: 80, y: 90)
        XCTAssert(rect.quadrant(containing: point) == .bottomRight)
        point = CGPoint(x: 50, y: 90)
        XCTAssert(rect.quadrant(containing: point) == .bottomLeft)
        point = CGPoint(x: 80, y: 60)
        XCTAssert(rect.quadrant(containing: point) == .topRight)
        point = CGPoint(x: 50, y: 60)
        XCTAssert(rect.quadrant(containing: point) == .topLeft)
    }
}
