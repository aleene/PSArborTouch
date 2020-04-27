//
//  ATKernelDebugView.m
//  PSArborTouch - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 29/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
////
//  Translated to Swift by Arnaud Leene on 12/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import UIKit
import CoreGraphics

class ATKernelDebugView: UIView {

    // MARK: - constants
    
    private struct Constant {
        static let ViewScaleFactor = CGFloat(0.05)
        struct Tree {
            static let LineWidth = CGFloat(1.0)
            struct BarnesHutTree {
                static let LineColor = UIColor.yellow.cgColor
            }
            struct TweensCurrent {
                static let LineColor = UIColor.blue.cgColor
            }
            struct TweensTarget {
                static let LineColor = UIColor.green.cgColor
            }
        }
        struct Spring {
            static let LineWidth = CGFloat(2.0)
            static let LineColor = UIColor.gray.cgColor
        }
        struct Particle {
            // The size of the square around the particle
            static let Inset = -CGFloat(5.0)
            static let LineWidth = CGFloat(2.0)
            static let LineColor = UIColor.red.cgColor
        }
    }

    //
    //  ATKernelDebugView.m
    //  PSArborTouch - Kernel Test / Debug Rig
    //
    //  Created by Ed Preston on 29/09/11.
    //  Copyright 2015 Preston Software. All rights reserved.
    //

    //#import "ATKernelDebugView.h"
    //#import "ATPhysics.h"
    //#import "ATBarnesHutTree.h"
    //#import "ATBarnesHutBranch.h"
    //#import "ATSpring.h"
    //#import "ATParticle.h"

// MARK: - public variables
    
    public var system: ATSystem?
    public var isDebugDrawing: Bool = false

    override func layoutSubviews() {
        self.system?.viewBounds = self.bounds;
    }

    override func draw(_ rect: CGRect) {
        
        guard let validSystem = system else { return }
        let validPhysics = validSystem.physics
        guard let context = UIGraphicsGetCurrentContext() else { return }
                        
        if isDebugDrawing {
                        
        // Drawing code for the barnes-hut trees

            // yellow line
            context.setStrokeColor(Constant.Tree.BarnesHutTree.LineColor)
            context.setLineWidth(Constant.Tree.LineWidth)
                        
            recursiveDrawBranches(branch: validPhysics.bhTree.root, in: context)
                            
            // green line
            context.setStrokeColor(Constant.Tree.TweensTarget.LineColor)
            context.setLineWidth(Constant.Tree.LineWidth)
            drawOutline(with: context, and: scale(validSystem.tweenBoundsTarget))
                        
            // blue line
            context.setStrokeColor(Constant.Tree.TweensCurrent.LineColor)
            context.setLineWidth(Constant.Tree.LineWidth)
            drawOutline(with: context, and: scale(validSystem.tweenBoundsCurrent))
        }

        // Drawing code for springs
            
        // black line with alpha
        context.setStrokeColor(Constant.Spring.LineColor)
        context.setLineWidth(Constant.Spring.LineWidth)
        for spring in validPhysics.springs {
            drawSpring(spring, in: context)
        }

        // Drawing code for particle centers

        // red line
        context.setStrokeColor(Constant.Particle.LineColor)
        context.setLineWidth(Constant.Particle.LineWidth)
        for particle in validPhysics.particles {
            drawParticle(particle, in: context)
        }
    }


    // MARK: - private scaling functions
    
    private func sizeToScreen(_ size: CGSize) -> CGSize {
        let scaledSize = self.bounds.size.scale(by: Constant.ViewScaleFactor)
        return size.multiply(size: scaledSize)
    }

    private func pointToScreen(_ p: CGPoint) -> CGPoint {
        
        let mid = self.bounds.size.halved.asCGPoint
        let scale = self.bounds.size.scale(by: Constant.ViewScaleFactor).asCGPoint
        
        return p * scale + mid
    }

    private func scale(_ rect: CGRect) -> CGRect {
        return CGRect(origin: pointToScreen(rect.origin),
                      size: sizeToScreen(rect.size))
    }

    // MARK: - private drawing functions
    
    private func drawLineWith(context: CGContext, from: CGPoint, to: CGPoint) {
        context.beginPath()
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
    }

    private func drawOutline(with context: CGContext, and rect: CGRect) {
        context.beginPath()
        context.addRect(rect)
        context.strokePath()
    }

    func recursiveDrawBranches(branch: ATBarnesHutBranch?, in context: CGContext) {
        guard let validBranch = branch else { return }
        
        drawOutline(with: context, and: scale(validBranch.bounds))

        validBranch.allQuadrantBranches.forEach({ self.recursiveDrawBranches(branch: $0, in:context) })
        
    }

    private func drawSpring(_ spring: ATSpring, in context: CGContext) {
        guard let position1 = spring.point1?.position else { return }
        guard let position2 = spring.point2?.position else { return }
        
        drawLineWith(context: context, from: pointToScreen(position1), to: pointToScreen(position2))
    }

    private func drawParticle(_ particle: ATParticle, in context: CGContext) {
        // Translate the particle position to screen coordinates
        guard let position = particle.position else { return }
        
        let pOrigin = pointToScreen(position)
        // Create an empty rect at particle center
        var strokeRect = CGRect(x: pOrigin.x, y: pOrigin.y, width: .zero, height: .zero)
        // Expand the rect around the center
        strokeRect = strokeRect.insetBy(dx: Constant.Particle.Inset,
                                        dy: Constant.Particle.Inset)
        // Draw the rect
        context.stroke(strokeRect)
    }


//    @end
}
