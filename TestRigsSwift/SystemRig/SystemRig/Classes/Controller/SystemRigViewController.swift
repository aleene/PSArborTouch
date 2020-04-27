//
//  SystemRigViewController.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//
//  Translated to Swift by Arnaud Leene on 03/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import UIKit
import CoreGraphics

class SystemRigViewController: UIViewController {

// MARK: - constants
    
    private struct Constant {
        static let Inset = CGFloat(20.0)
        static let DebugDrawing = true
        static let GestureLimit = CGFloat(500.0)
        static let ScaleFactor = CGFloat(20.0)
    }
    
// MARK: - interface elements
    
    @IBOutlet weak var debugView: ATSystemDebugView!
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        system?.start(unpause: true)
    }
    
    @IBAction func pruneButtonTapped(_ sender: UIButton) {
        system?.removeNode(with: "e")
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        _ = system?.addEdge(fromNode: "a", toNode: "e", with: [:])
        system?.start(unpause: true)
    }

// MARK: - public variables
    
    private var system: ATSystem?

// MARK: - viewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.system = ATSystem()

        self.system?.viewBounds = self.view.bounds
        self.system?.viewPadding = UIEdgeInsets(top: Constant.Inset,
                                                left: Constant.Inset,
                                                bottom: Constant.Inset,
                                                right: Constant.Inset)
        self.system?.delegate = self

            
        self.debugView.system = system
        self.debugView.isDebugDrawing = Constant.DebugDrawing
            
            // add some nodes to the graph and watch it go...
        _ = system?.addEdge(fromNode: "a", toNode: "b", with: [:])
        _ = system?.addEdge(fromNode: "a", toNode: "c", with: [:])
        _ = system?.addEdge(fromNode: "a", toNode: "d", with: [:])
        _ = system?.addEdge(fromNode: "a", toNode: "e", with: [:])

        _ = system?.addEdge(fromNode: "e", toNode: "f", with: [:])
        _ = system?.addEdge(fromNode: "e", toNode: "g", with: [:])
        _ = system?.addEdge(fromNode: "e", toNode: "h", with: [:])

        _ = system?.addEdge(fromNode: "h", toNode: "j", with: [:])
        _ = system?.addEdge(fromNode: "h", toNode: "k", with: [:])
        _ = system?.addEdge(fromNode: "h", toNode: "l", with: [:])
            
        //_ = system?.addEdge(fromNode: "x", toNode: "y", with: [:])
        //_ = system?.addEdge(fromNode: "y", toNode: "z", with: [:])
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPiece))
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        self.debugView.addGestureRecognizer(panGesture)

    }
    

    private func fromScreen(_ p: CGPoint) -> CGPoint {
        
        let size = self.debugView.bounds.size
        
        guard size != .zero else { return .zero }
        
        var s = p - size.halved
        s = (s / size)!
        return s * Constant.ScaleFactor
    }


}

// MARK: - UIGestureRecognizerDelegate protocol

extension SystemRigViewController : UIGestureRecognizerDelegate {
    // shift the piece's center by the pan amount
    // reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position

    @objc func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
        let piece = gestureRecognizer.view

        switch gestureRecognizer.state {
        case .began, .changed:
            let translation = gestureRecognizer.translation(in: piece)
            if let node = self.system?.nearestNode(to: translation, within: Constant.GestureLimit),
                let position = node.position {
                node.position = CGPoint(x:position.x + translation.x, y:position.y + translation.y)
                
                self.system?.start(unpause: true)
            }
            
            gestureRecognizer.setTranslation(.zero, in: piece)
        
        default: break
        }

    }

}

// MARK: - ATDebugRendering protocol

extension SystemRigViewController : ATDebugRendering {
    
    func redraw() {
        self.debugView.setNeedsDisplay()
    }

}
