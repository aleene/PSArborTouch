//
//  EcholaliaViewController.m
//  Echolalia - PSArborTouch Example
//
//  Created by Ed Preston on 3/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "EcholaliaViewController.h"

#import "EcholaliaCanvasView.h"

#import "PSArborTouch.h"
#import "CJSONDeserializer.h"


@interface EcholaliaViewController ()

- (void) loadBirdData;

- (void) addGestureRecognizersToCanvas:(UIView *)canvas;
- (void) showLongTouchMenu:(UILongPressGestureRecognizer *)gestureRecognizer;
//- (void) resetHandler:(UIMenuController *)controller;
- (void) debugHandler:(UIMenuController *)controller;
- (void) panHandler:(UIPanGestureRecognizer *)gestureRecognizer;
//- (void) rotateHandler:(UIRotationGestureRecognizer *)gestureRecognizer;
//- (void) pinchHandler:(UIPinchGestureRecognizer *)gestureRecognizer;

@end

@implementation EcholaliaViewController

@synthesize canvas = canvas_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create our particle system
    system_ = [[ATSystem alloc] init];
    
    // Configure simulation parameters, (take a copy, modify it, update the system when done.)
    ATSystemParams *params = system_.parameters;
    
    params.repulsion = 1000.0;
    params.stiffness = 800.0;
    params.friction  = 0.5;
    params.precision = 0.4;
    
    system_.parameters = params;
    
    // Setup the view bounds
    system_.viewBounds = self.canvas.bounds;
    
    // leave some space at the bottom and top for text
    system_.viewPadding = UIEdgeInsetsMake(60.0, 60.0, 60.0, 60.0);
    
    // have the ‘camera’ zoom somewhat quickly as the graph unfolds 
    system_.viewTweenStep = 0.4;
    
    // set this controller as the system's delegate
    system_.delegate = self;
    
    // DEBUG
    self.canvas.system = system_;
    self.canvas.debugDrawing = NO;  // Do long press gesture to toggle.
    
    // load the bird data
    [self loadBirdData];
    
    // start the simulation
    [system_ start:YES];
    
    // set up touch event handling
    [self addGestureRecognizersToCanvas:self.canvas];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Data Loading

-(void) loadBirdData
{
    // Find the file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"usofa" ofType:@"json"];
    if (filePath) {
        // Load data in the file
        NSData *theJSONData = [NSData dataWithContentsOfFile:filePath];
        if (theJSONData) {
            // Parse the file
            NSError *theError = nil;
            NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData 
                                                                                          error:&theError];
            if (theObject) {
                
                // Add Nodes and Edges
                
                // Issue with concurrent loading is the potential for duplicate nodes. Load the nodes first.
                // For example, node creation might be in the GCD queue but when we query if it exists, it
                // has not made it there yet.
                
                NSDictionary *nodes = theObject[@"nodes"];
                
                [nodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    
                    [system_ addNode:key withData:nil];
                    
                }];
                
                // Comment out the code above to see this example.
                // Instead of loading the nodes, lets just load the edges and have the system construct
                // the nodes when it finds they have not been previously defined.  Not the optimal way to 
                // go about things but easy.
                
                NSDictionary *edges = theObject[@"edges"];
                
                // Lets see how the system handles concurrent graph loading (NSEnumerationConcurrent)
                // The simulation should handle this correctly.
                [edges enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
                    
                    NSString *source = key;
                    NSDictionary *targets = obj;
                    
                    // How about an extra measure of concurrency within the concurrency.
                    [targets enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
                        
                        // DEBUG: Enable to see the concurrency in all its glory
                        //                        NSLog(@"Source %@ -> %@", source, key);
                        
                        // Create the edge, and by proxy, create the nodes
                        [system_ addEdgeFromNode:source toNode:key withData:nil];
                        
                    }];
                    
                }];
                
            } else {
                NSLog(@"Could not parse JSON file.");
            }
        } else {
            NSLog(@"Could not load NSData from file.");
        }
    } else {
        NSLog(@"Please include america.json in the project resources.");
    }
}


#pragma mark - Rendering

- (void) redraw
{
    // Sync with screen refresh
    [self.canvas setNeedsDisplay];
}


#pragma mark - Interface Actions

- (IBAction) launchSourceURL:(id)sender
{
    // launch a URL in Safari
    [[UIApplication sharedApplication] openURL:[NSURL 
        URLWithString:@"http://samizdat.cc/projects/echolalia/final/"]];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize 
    // simultaneously prevent other gesture recognizers from recognizing simultaneously
    
    // if the gesture recognizers's view isn't ours, don't allow simultaneous recognition
    if (gestureRecognizer.view != self.canvas)
        return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || 
        [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    
    // if either of the gesture recognizers is the pan, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || 
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        return NO;
    
    return YES;
}


#pragma mark - Touch Handleing

- (void) addGestureRecognizersToCanvas:(UIView *)canvas
{
    // adds a set of gesture recognizers to the canvas
    
    //    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self 
    //                                                                                                action:@selector(rotateHandler:)];
    //    [canvas addGestureRecognizer:rotationGesture];
    //    [rotationGesture release];
    //    
    //    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self 
    //                                                                                       action:@selector(pinchHandler:)];
    //    [pinchGesture setDelegate:self];
    //    [canvas addGestureRecognizer:pinchGesture];
    //    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                                                 action:@selector(panHandler:)]; // LOL !
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [canvas addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                   action:@selector(showLongTouchMenu:)];
    [canvas addGestureRecognizer:longPressGesture];
}

- (void) showLongTouchMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    // display a menu with a single item to allow the simulation to be reset
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        //        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Reset" action:@selector(resetHandler:)];
        UIMenuItem *debugMenuItem = [[UIMenuItem alloc] initWithTitle:@"Debug" action:@selector(debugHandler:)];
        
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:@[debugMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        //        [resetMenuItem release];
    }
}

//- (void) resetHandler:(UIMenuController *)controller
//{
//    // Reset the simulation
//}

- (void) debugHandler:(UIMenuController *)controller
{
    self.canvas.debugDrawing = !self.canvas.debugDrawing;
}

- (BOOL) canBecomeFirstResponder
{
    // UIMenuController requires that we can become first responder or it won't display
    return YES;
}

- (void) panHandler:(UIPanGestureRecognizer *)gestureRecognizer
{
    // move the closest node from the touch position
    static ATNode *node = nil;
    UIView *piece = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer locationInView:piece];
    
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            node = [system_ nearestNodeToPoint:translation withinRadius:30.0];
            node.fixed = YES;
            break;
        case UIGestureRecognizerStateChanged:
            node.position = [system_ fromViewPoint:translation];
            break;
        default:
            node.fixed = NO;
            
            //[node mas setTempMass:100.0];
            
            break;
    }
    
    // start the simulation
    [system_ start:YES];
}


//- (void) rotateHandler:(UIRotationGestureRecognizer *)gestureRecognizer
//{
//    // rotate handler
//    
//    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || 
//        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//            [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], 
//                                                                         [gestureRecognizer rotation]);
//            [gestureRecognizer setRotation:0];
//    }
//}
//
//
//- (void) pinchHandler:(UIPinchGestureRecognizer *)gestureRecognizer
//{
//    // pinch / scale handler
//    
//    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || 
//        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], 
//                                                                        [gestureRecognizer scale], 
//                                                                        [gestureRecognizer scale]);
//            [gestureRecognizer setScale:1];
//    }
//}


@end
