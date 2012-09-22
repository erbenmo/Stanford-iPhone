//
//  GraphViewController.m
//  Calculator
//
//  Created by MoErben on 6/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "FavoriteGraphController.h"

@interface GraphViewController () <GraphViewDataSource, GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView* graphView;


@property (strong, nonatomic) NSString* stack;
@end

@implementation GraphViewController

 
@synthesize graphView = _graphView;
@synthesize stack = _stack;

- (void)prepareView {
    [self.graphView setNeedsDisplay];
}

- (void) setProgram:(id)program {
    self.stack = program;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinchHandler:)]];

    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(panHandler:)]];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTapHandler:)];
    tapGesture.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer: tapGesture];
     
    self.graphView.dataSource = self;
}

- (CGFloat)getValue:(CGFloat)x {
    NSMutableDictionary* xValue = [[NSMutableDictionary alloc] init];
    [xValue setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    
    double result = [CalculatorBrain runProgram:self.stack usingVariableValues:xValue];
    return result;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#define FAVORITE_KEY @"GraphViewController.FAVORITE_KEY"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"popMyFavoriteList"]) {
        NSArray* programs = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY];
        [segue.destinationViewController setPrograms:programs];
        [segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)AddtoFavorite:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* favorites = [[defaults objectForKey:FAVORITE_KEY] mutableCopy];
    if(!favorites) favorites = [NSMutableArray array];
    
    [favorites addObject:self.stack];
    [defaults setObject:favorites forKey:FAVORITE_KEY];
    [defaults synchronize];
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}
@end
