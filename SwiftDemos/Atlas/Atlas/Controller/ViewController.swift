//
//  ViewController.swift
//  Atlas
//
//  Created by arnaud on 17/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: - interface
    
    @IBOutlet fileprivate weak var atlasCanvasView: AtlasCanvasView!
   
// MARK: - public variables

    /// Needed in order to show UIMenuController
    override var canBecomeFirstResponder: Bool {
        true
    }

// MARK: - private variables
    
    private var _system = ATSystem()

// MARK: - private functions
    
    private func loadMapData() {
        guard let path = Bundle.main.path(forResource: "usofa", ofType: "json") else {
            print("Please include america.json in the project resources.");
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
        
            do {
                let mapJson = try decoder.decode(Map.self, from:data)
                /* It is not necessary to add the nodes, edges is enough
                if let nodes = mapJson.nodes {
                    for node in nodes {
                        _ = _system.addNode(with: node.key, and: [:])
                    }
                }
                */
                if let edges = mapJson.edges {
                    for edge in edges {
                        for country in edge.value {
                            _ = _system.addEdge(fromNode: edge.key, toNode: country.key, with: [:])
                        }
                    }
                }
            } catch let error {
                print (error.localizedDescription)
                print("Could not parse JSON file.");

            }
        } catch let error {
            print (error.localizedDescription)
            print("Could not load NSData from file.");
        }

    }

    private func addGestureRecognizers(to view: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(for:)))
        panGestureRecognizer.maximumNumberOfTouches = 2
        panGestureRecognizer.delegate = self
        atlasCanvasView.addGestureRecognizer(panGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(showTouchMenu(for:)))
        atlasCanvasView.addGestureRecognizer(longPressGestureRecognizer)

    }

// MARK: - @objc methods
    
    /// display a menu with a single item to allow the simulation to be reset
    @objc func showTouchMenu(for longPressGestureRecognizer: UILongPressGestureRecognizer) {
        guard let validView = longPressGestureRecognizer.view else { return }
        switch longPressGestureRecognizer.state {
        case .began:
            let menuController = UIMenuController.shared
            let debugMenuItem = UIMenuItem(title: "Debug", action: #selector(debugHandler(for:)))
            let location = longPressGestureRecognizer.location(in: validView)
            self.becomeFirstResponder()
            menuController.menuItems = [debugMenuItem]
            menuController.showMenu(from: validView, rect: CGRect(origin: location, size: .zero))
                
        default: break
        }

    }

    @objc func debugHandler(for menuController: UIMenuController) {
        self.atlasCanvasView.isDebugDrawing = !self.atlasCanvasView.isDebugDrawing
    }
    
//TODO: is this working. Code does not seem right
    @objc func panHandler(for panGestureRecognizer: UIPanGestureRecognizer) {
        // move the closest node from the touch position
        let node: ATNode?
        guard let view = panGestureRecognizer.view else { return }

        let translation = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:

            node = _system.nearestNode(to: translation, within: 30.0)
            node?.isFixed = true
        case .changed:
            //node.position = [system_ fromViewPoint:translation];
            //node?.position = _system.fromView(point: translation)
                break;
        //default:
        default:
            //node?.isFixed = false
            //node.fixed = NO;
                
            // [node setTempMass:100.0];
                
           break;
        }
        
        // start the simulation
        _system.start(unpause: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure simulation parameters, (take a copy, modify it, update the system when done.)
        var params = ATSystemParams()
        params.repulsion = 1000.0;
        params.stiffness = 600.0;
        params.friction  = 0.5;
        params.precision = 0.4;
        params.useBarnesHut = false
        
        _system.parameters = params
        // Setup the view bounds
        _system.viewBounds = self.atlasCanvasView.bounds
        // leave some space at the bottom and top for text
        _system.viewPadding = UIEdgeInsets(top: 60.0, left: 60.0, bottom: 60.0, right: 60.0)
        // have the ‘camera’ zoom somewhat slowly as the graph unfolds
        _system.viewTweenStep = 0.2
        // set this controller as the system's delegate
        _system.delegate = self
        // DEBUG
        self.atlasCanvasView.system = _system
        //self.canvas.debugDrawing = NO;  // Do long press gesture to toggle.
        self.atlasCanvasView.isDebugDrawing = true
        self.addGestureRecognizers(to: self.atlasCanvasView)
   
        // load the map data
        self.loadMapData()

        _system.start(unpause: true)

    }

}

// MARK: - ATDebugRendering protocol

extension ViewController : ATDebugRendering {
    
    func redraw() {
        self.atlasCanvasView.setNeedsDisplay()
    }

}

// MARK: - UIGestureRecognizerDelegate protocol

extension ViewController: UIGestureRecognizerDelegate {
    
    /// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously prevent other gesture recognizers from recognizing simultaneously
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let validView = gestureRecognizer.view else { return false }
        guard let validOtherView = otherGestureRecognizer.view else { return false }
        
        // if the gesture recognizers's view isn't ours, don't allow simultaneous recognition
        guard validView == self.atlasCanvasView else { return false }
        
        // if the gesture recognizers are on different views, don't allow simultaneous recognition
        guard validView == validOtherView else { return false }
        
        // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
        if gestureRecognizer is UILongPressGestureRecognizer
        || otherGestureRecognizer is UILongPressGestureRecognizer { return false }
        
        // if either of the gesture recognizers is the pan, don't allow simultaneous recognition
        if gestureRecognizer is UIPanGestureRecognizer
            || otherGestureRecognizer is UIPanGestureRecognizer { return false }
        
        return true

    }
}
