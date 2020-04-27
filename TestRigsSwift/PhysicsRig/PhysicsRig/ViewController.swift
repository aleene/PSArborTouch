//
//  ViewController.swift
//  PhysicsRig
//
//  Created by arnaud on 14/04/2020.
//  Copyright © 2020 Hovering Above. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

// MARK: constants
    
    private struct Constant {
        static let ScaleFactor = CGFloat(10.0)
        struct Reset {
            static let Position1 = CGPoint(x: 0.3, y: 0.3)
            static let Position2 = CGPoint(x: -0.7, y: -0.5)
            static let Position3 = CGPoint(x: 0.4, y: -0.5)
            static let Position4 = CGPoint(x: -1.0, y: -1.0)
        }
        struct TimeIntervalInMilliSeconds {
            static let Repeating = 50
            static let Leeway = 25
        }
    }
    
// MARK: - interface - buttons
    
    @IBAction func updatePhysicsButtonTapped(_ sender: UIButton) {
        self.statusLabel.text = "STEPPING"
        self.stepPhysics()
    }
    
    @IBAction func startPhysicsButtonTapped(_ sender: UIButton) {
        self.start()
    }
    
    @IBAction func stopPhysicsButtonTapped(_ sender: UIButton) {
        self.stop()
    }
    
    @IBAction func resetPhysicsButtonTapped(_ sender: UIButton) {
        self.reset()
    }

// MARK: - interface - status
        
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var meanLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var updateCounterLabel: UILabel!

    @IBAction func barnesHutWitchTapped(_ sender: UISwitch) {
        debugView.isDebugDrawing = sender.isOn ? true : false
        _integrator?.theta = sender.isOn ? 0.4 : 0.0
    }
    
// MARK: - interface - particles
    
    @IBOutlet weak var particle1NameLabel: UILabel!
    @IBOutlet weak var particle1MassLabel: UILabel!
    @IBOutlet weak var particle1PositionLabel: UILabel!
    @IBOutlet weak var particle1isFixedLabel: UILabel!
    
    @IBOutlet weak var particle2NameLabel: UILabel!
    @IBOutlet weak var particle2MassLabel: UILabel!
    @IBOutlet weak var particle2PositionLabel: UILabel!
    @IBOutlet weak var particle2isFixedLabel: UILabel!
    
    @IBOutlet weak var debugView: ATPhysicsDebugView!
        
// MARK: - public variables

    /// Need in order to show UIMenuController
    override var canBecomeFirstResponder: Bool {
        true
    }
    
// MARK: - private variables
    
    // This app is NOT using the ATSystem!!!
    private var _integrator: ATPhysics?
    
    private var _particle1 = ATParticle(name: "Node 1",
                                        mass: 1.0,
                                        position: .zero,
                                        fixed: false)
    private var _particle2 = ATParticle(name: "Node 2",
                                        mass: 1.0,
                                        position: .zero,
                                        fixed: false)
    private var _particle3 = ATParticle(name: "Node 3",
                                        mass: 1.0,
                                        position: .zero,
                                        fixed: false)
    private var _particle4 = ATParticle(name: "Node 4",
                                        mass: 1.0,
                                        position: .zero,
                                        fixed: false)
        
    private var _particle1View = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    private var _particle2View = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    private var _particle3View = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    private var _particle4View = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

    private var _queue = DispatchQueue(label: "com.prestonsoft.psarbortouch")
    private var _timer: DispatchSourceTimer?
    private var _counter: Int = 0
    private var _isRunning = false
    
    private var _pieceForRest: UIView?
    
// MARK: - Private physics functions

    private func reset() {
        _particle1.position = Constant.Reset.Position1
        _particle2.position = Constant.Reset.Position2
        _particle3.position = Constant.Reset.Position3
        _particle4.position = Constant.Reset.Position4
        self.placeParticles()
        self.debugView.setNeedsDisplay()
    }
    
    private func start() {
        _timer?.setEventHandler(handler: { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self.stepPhysics()
            })
        })
        
        self.statusLabel?.text = "RUNNING"
        _particle1.position = self.fromScreen(_particle1View.center)
        _particle2.position = self.fromScreen(_particle2View.center)
        _particle3.position = self.fromScreen(_particle3View.center)
        _particle4.position = self.fromScreen(_particle4View.center)
        
        if !_isRunning {
            _isRunning = !_isRunning
            _timer?.resume()
        }
    }
    
    private func stop() {
        self.statusLabel.text = "STOPPED"
        
        if _isRunning {
            _isRunning = !_isRunning
            _timer?.suspend()
        }
    }

    private func stepPhysics() {
        
        guard var validIntegrator = _integrator else { return }
        // Run physics loop.  Stop timer if it returns NO on update.
        guard validIntegrator.isUpdated() else {
            self.stop()
            return
        }
        
        self.sumLabel.text = String(format:"%f",  validIntegrator.energy.sum)
        self.maxLabel.text = String(format:"%f", validIntegrator.energy.max)
        self.meanLabel.text = String(format:"%f", validIntegrator.energy.mean)
        self.countLabel.text = String(format:"%d", validIntegrator.energy.count)

        self.particle1NameLabel.text = _particle1.name
        self.particle1MassLabel.text = String(format: "%f", _particle1.mass)
        if let validX = _particle1.position?.x,
            let validY = _particle1.position?.y {
            self.particle1PositionLabel.text = String(format: "x = %f, y = %f", validX, validY)
        }
        self.particle1isFixedLabel.text = _particle1.isFixed ? "YES" : "NO"

        self.particle2NameLabel.text = _particle2.name
        self.particle2MassLabel.text = String(format: "%f", _particle2.mass)
        if let validX = _particle2.position?.x,
            let validY = _particle2.position?.y {
            self.particle2PositionLabel.text = String(format: "x = %f, y = %f", validX, validY)
        }
        self.particle2isFixedLabel.text = _particle2.isFixed ? "YES" : "NO"
        
        self.placeParticles()
        
        _counter += 1
        self.updateCounterLabel.text = "\(_counter)"
        
        self.debugView.setNeedsDisplay()
    }

// MARK: - setup Gesture Recognizers

    private func addGestureRecognizers(to view: UIView) {
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(ViewController.rotate(_:)))
        rotateGesture.delegate = self
        view.addGestureRecognizer(rotateGesture)

        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(ViewController.pinch(_:)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
            
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.pan(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 2
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
            
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
// MARK: - Touch handling
    
    /// shift the piece's center by the pan amount
    /// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {

        guard let view = gestureRecognizer.view else { return }

        switch gestureRecognizer.state {
        case .began, .changed:
            let translation = gestureRecognizer.translation(in: view)
            view.center = view.center + translation
            gestureRecognizer.setTranslation(.zero, in: view)
        default: break
        }
        
        self.start()
    }

    /// rotate the piece by the current rotation
    /// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        self.adjustAnchorPoint(for: gestureRecognizer)
        guard let validView = gestureRecognizer.view else { return }

        switch gestureRecognizer.state {
        case .began, .changed:
            gestureRecognizer.view?.transform = validView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        default: break
        }
    }
    
    /// scale the piece by the current scale
    /// reset the gesture recognizer's scale to 0 after applying so the next callback is a delta from the current scale
    @objc func pinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        guard let validView = gestureRecognizer.view else { return }
        self.adjustAnchorPoint(for: gestureRecognizer)
        switch gestureRecognizer.state {
        case .began, .changed:
            gestureRecognizer.view?.transform = validView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            gestureRecognizer.scale = 1
        default: break
        }
    }

    /// display a menu with a single item to allow the piece's transform to be reset
    @objc func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let validView = gestureRecognizer.view else { return }
        switch gestureRecognizer.state {
        case .began:
            validView.isUserInteractionEnabled = true
            becomeFirstResponder()
            let menuItem = UIMenuItem.init(title: "Reset", action: #selector(ViewController.resetView(_:)))
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            //self.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.menuItems = [menuItem]
            menuController.showMenu(from: validView, rect: CGRect(origin: location, size: .zero))
            _pieceForRest = validView
        default: break
        }
    }
    
    // scale and rotation transforms are applied relative to the layer's anchor point
    // this method moves a gesture recognizer's view's anchor point between the user's fingers
    //- (void) adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    private func adjustAnchorPoint(for gestureRecognizer: UIGestureRecognizer) {
        //if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        switch gestureRecognizer.state {
        case .began:
            //UIView *piece = gestureRecognizer.view;
            guard let view = gestureRecognizer.view else { break }
            guard view.bounds.size != .zero else { break }
            //CGPoint locationInView = [gestureRecognizer locationInView:piece];
            let locationInView = gestureRecognizer.location(in: view)
            //CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
            let locationInSuperView = gestureRecognizer.location(in:view.superview)
            //piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
            view.layer.anchorPoint = (locationInView / view.bounds.size)!
            //piece.center = locationInSuperview;
            view.center = locationInSuperView
        default: break
        }
    }

    /// animate back to the default anchor point and transform
// TODO: is not working as it should, it does not resturn to the right posiiton.
    @objc func resetView(_ menuController: UIMenuController) {
        guard let locationInSuperView = _pieceForRest?.convert(_pieceForRest!.bounds.halved.asCGPoint, to: _pieceForRest?.superview) else { return }
        _pieceForRest?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        _pieceForRest?.center = locationInSuperView
        self.debugView.addSubview(_pieceForRest!)

        _pieceForRest?.transform = CGAffineTransform.identity
    }


// MARK: - viewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _integrator = ATPhysics()
            
            
        _integrator?.deltaTime = 0.02
        _integrator?.stiffness = 1000.0
        _integrator?.repulsion = 600.0
        _integrator?.friction = 0.5
        
        _integrator?.gravity = false
        
        _integrator?.add(particle: _particle1)
        _integrator?.add(particle: _particle2)
        _integrator?.add(particle: _particle3)
        _integrator?.add(particle: _particle4)
        
        _integrator?.add(spring: ATSpring(source: _particle1, target: _particle2, length: 1.0))
        _integrator?.add(spring: ATSpring(source: _particle2, target: _particle3, length: 1.0))
        _integrator?.add(spring: ATSpring(source: _particle3, target: _particle1, length: 1.0))
        _integrator?.add(spring: ATSpring(source: _particle4, target: _particle1, length: 1.0))
        _integrator?.add(spring: ATSpring(source: _particle2, target: _particle4, length: 1.0))

        _particle1View.backgroundColor = .blue
        self.addGestureRecognizers(to: _particle1View)
        self.debugView.addSubview(_particle1View)
        
        _particle2View.backgroundColor = .green
        self.addGestureRecognizers(to: _particle2View)
        self.debugView.addSubview(_particle2View)
        
        _particle3View.backgroundColor = .red
        self.addGestureRecognizers(to: _particle3View)
        self.debugView.addSubview(_particle3View)
        
        _particle4View.backgroundColor = .orange
        self.addGestureRecognizers(to: _particle4View)
        self.debugView.addSubview(_particle4View)
        
        debugView.physics = _integrator
        debugView.isDebugDrawing = true

        _timer = DispatchSource.makeTimerSource(queue: _queue)
        _timer?.schedule(deadline: DispatchTime.now(),
                         repeating: DispatchTimeInterval.milliseconds(Constant.TimeIntervalInMilliSeconds.Repeating),
                         leeway: DispatchTimeInterval.milliseconds(Constant.TimeIntervalInMilliSeconds.Leeway))

        _isRunning = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        _timer?.cancel()
        _timer?.resume()
    }

// MARK: - private functions

    private func placeParticles() {
        if let validPosition = _particle1.position {
            _particle1View.center = self.toScreen(validPosition)
        }
        if let validPosition = _particle2.position {
            _particle2View.center = self.toScreen(validPosition)
        }
        if let validPosition = _particle3.position {
            _particle3View.center = self.toScreen(validPosition)
        }
        if let validPosition = _particle4.position {
            _particle4View.center = self.toScreen(validPosition)
        }
    }
    
    private func fromScreen(_ p: CGPoint) -> CGPoint {
        
        let size = self.debugView.bounds.size
        guard size != .zero else { return .zero }
        
        var s = p - size.halved // mid
        s = (s / size)!
        return s * Constant.ScaleFactor
    }

    private func toScreen(_ p: CGPoint) -> CGPoint {
        guard Constant.ScaleFactor != .zero else {
            print("ViewController.toScreen(_:) - scale facor is zero")
            return .zero
        }
        
        let mid = self.debugView.bounds.size.halved.asCGPoint
        let scale = self.debugView.bounds.size / Constant.ScaleFactor

        return p * scale!.asCGPoint + mid
    }
}
// MARK: - UIGestureRecognizerDelegate extension

extension ViewController: UIGestureRecognizerDelegate {
 
    /// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously prevent other gesture recognizers from recognizing simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
        if gestureRecognizer.view != _particle1View
        && gestureRecognizer.view != _particle2View
        && gestureRecognizer.view != _particle3View
        && gestureRecognizer.view != _particle4View {
            return false
        }
        // if the gesture recognizers are on different views, don't allow simultaneous recognition
        if gestureRecognizer.view != otherGestureRecognizer.view {
            return false
        }
        // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
        if gestureRecognizer is UILongPressGestureRecognizer
            || otherGestureRecognizer is UILongPressGestureRecognizer {
            return false
        }
        return true;

    }

}
