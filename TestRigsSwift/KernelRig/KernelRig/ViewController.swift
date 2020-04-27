//
//  ViewController.swift
//  KernelRig
//
//  Created by arnaud on 12/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

// MARK: - constants
        
    private struct Constant {
        static let Inset = CGFloat(20.0)
        static let DebugDrawing = true
        static let GestureLimit = CGFloat(500.0)
        static let ScaleFactor = CGFloat(20.0)
    }

// MARK: - interface elements
            
    @IBOutlet weak var debugView: ATKernelDebugView!
    
    private var system: ATSystem?

// MARK: - viewController lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.system = ATSystem()

        self.system?.viewBounds = self.view.bounds
        self.system?.viewPadding = UIEdgeInsets(top: Constant.Inset,
                                                left: Constant.Inset,
                                                bottom: Constant.Inset,
                                                right: Constant.Inset)
        self.system?.delegate = self

            
        self.debugView.system = system
        self.debugView.isDebugDrawing = Constant.DebugDrawing
        
        
        //ATParticle  *_particle2;
        //ATParticle  *_particle3;
        //ATParticle  *_particle4;
        //ATSpring    *_spring1;
        //ATSpring    *_spring2;
        //ATSpring    *_spring3;
        //ATSpring    *_spring4;
        //ATSpring    *_spring5;
        
        //CGPoint pos = CGPointMake(0.3, 0.3);
        
        //_particle1 = [[ATParticle alloc] initWithName:@ mass:1.0 position:pos fixed:NO];
        //[_kernel addParticle:_particle1];
        let particle1 = ATParticle(name: "Node 1", mass: 1.0, position: CGPoint(x: 0.3, y: 0.3), fixed: false)
        system?.add(particle: particle1)

        //pos = CGPointMake(-0.7, -0.5);
        //_particle2 = [[ATParticle alloc] initWithName:@"Node 2" mass:1.0 position:pos fixed:NO];
        //[_kernel addParticle:_particle2];
        let particle2 = ATParticle(name: "Node2", mass: 1.0, position: CGPoint(x: -0.7, y: -0.5), fixed: false)
        system?.add(particle: particle2)

        //pos = CGPointMake(0.4, -0.5);
        //_particle3 = [[ATParticle alloc] initWithName:@"Node 3" mass:1.0 position:pos fixed:NO];
        //[_kernel addParticle:_particle3];
        let particle3 = ATParticle(name: "Node3", mass: 1.0, position: CGPoint(x: 0.4, y: -0.5), fixed: false)
        system?.add(particle: particle3)

        //pos = CGPointMake(-1.0, -1.0);
        //_particle4 = [[ATParticle alloc] initWithName:@"Node 4" mass:1.0 position:pos fixed:YES];
        //[_kernel addParticle:_particle4];
        let particle4 = ATParticle(name: "Node2", mass: 1.0, position: CGPoint(x: -1.0, y: -1.0), fixed: false)
        system?.add(particle: particle4)

        
        //_spring1 = [[ATSpring alloc] initWithSource:_particle1 target:_particle2 length:1.0];
        //[_kernel addSpring:_spring1];
        system?.add(spring: ATSpring(source: particle1, target: particle2, length: 1.0))
        //_spring2 = [[ATSpring alloc] initWithSource:_particle2 target:_particle3 length:1.0];
        //[_kernel addSpring:_spring2];
        system?.add(spring: ATSpring(source: particle2, target: particle3, length: 1.0))

        //_spring3 = [[ATSpring alloc] initWithSource:_particle3 target:_particle1 length:1.0];
        //[_kernel addSpring:_spring3];
        system?.add(spring: ATSpring(source: particle3, target: particle1, length: 1.0))

        //_spring4 = [[ATSpring alloc] initWithSource:_particle4 target:_particle1 length:1.0];
        //[_kernel addSpring:_spring4];
        system?.add(spring: ATSpring(source: particle4, target: particle1, length: 1.0))

        //_spring5 = [[ATSpring alloc] initWithSource:_particle2 target:_particle4 length:1.0];
        //[_kernel addSpring:_spring5];
        system?.add(spring: ATSpring(source: particle2, target: particle4, length: 1.0))
    }

    @IBAction func go(_ sender: UIButton) {
        system?.start(unpause: true)
    }

}

// MARK: - ATDebugRendering protocol

extension ViewController : ATDebugRendering {
    
    func redraw() {
        self.debugView.setNeedsDisplay()
    }

}
