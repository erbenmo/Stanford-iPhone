//
//  CalculatorViewController.m
//  Calculator
//
//  Created by MoErben on 2/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL onDotRightHandSide;
@property (nonatomic, strong) CalculatorBrain* brain;
@property (nonatomic, strong) NSMutableDictionary* testVarVal;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize scratch;
@synthesize printVar;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVarVal = _testVarVal;

- (void) awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return false;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (CalculatorBrain*)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSMutableDictionary*) testVarVal {
    if(!_testVarVal) {
        _testVarVal = [[NSMutableDictionary alloc] init];
        //[_testVarVal setObject:0 forKey:@"x"];
    }
    return _testVarVal;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setProgram:[self.brain program]];
}

- (GraphViewController*) splitViewGraphViewController {
    id hvc = [self.splitViewController.viewControllers lastObject];
    if(![hvc isKindOfClass:[GraphViewController class]])
        hvc = nil;
    
    return hvc;
}

- (IBAction)graph:(UIButton *)sender {
    if([self splitViewGraphViewController]) {
        [[self splitViewGraphViewController] prepareView];
        [[self splitViewGraphViewController] setProgram:[self.brain program]];
    }
    else
        [self performSegueWithIdentifier:@"empty" sender:self];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString* digit = [sender currentTitle];

    if(self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.onDotRightHandSide = NO;
    }
}
 
// don't mess with userIsInTheMiddleOfEnteringANumber & onDotRightHandSide
//  since we don't want x.a
- (IBAction)varPressed:(UIButton *)sender {
    self.display.text = [sender currentTitle];
}

- (IBAction)dotPressed {
    NSString* dot = @".";
    if(self.userIsInTheMiddleOfEnteringANumber) {
        if(self.onDotRightHandSide == YES)
            return;
        self.display.text = [self.display.text stringByAppendingString:dot];
    }
    else {
        self.display.text = dot;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    self.onDotRightHandSide = YES;
}

- (void)updateScratch {
    NSString* newText;
    newText = [self.brain getDescription];
    
    if([newText length] > 35)
        newText = [newText substringFromIndex:([newText length]-35)];
    
    self.scratch.text = newText;
}

- (IBAction)enterPressed {
    if([self.display.text isEqualToString:@"x"]) // var x
        [self.brain pushVarOperand:self.display.text];
    else
        [self.brain pushOperand:[self.display.text doubleValue]]; // a value
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateScratch];
}

- (IBAction)operationPressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    NSString* operation = [sender currentTitle];
    double result = [self.brain performOperation:operation usingVariableValues:self.testVarVal];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self updateScratch];
}


/*
- (void)updatePrintVar {
    self.printVar.text = @"";
    
    for (NSString* key in self.testVarVal) {
        NSNumber* value = [self.testVarVal objectForKey:key];
        
        self.printVar.text = [self.printVar.text stringByAppendingString:key];
        self.printVar.text = [self.printVar.text stringByAppendingString:@" = "];
        self.printVar.text = [self.printVar.text stringByAppendingString:[value stringValue]];
        self.printVar.text = [self.printVar.text stringByAppendingString:@"  "];
    }
}
*/

/*
- (IBAction)test1Pressed:(UIButton *)sender {
    self.testVarVal = nil;
    [self updatePrintVar];
}

- (IBAction)test2Pressed:(UIButton *)sender {
    [self.testVarVal setValue:[NSNumber numberWithInt:3] forKey:@"x"];
    [self.testVarVal setValue:[NSNumber numberWithInt:4] forKey:@"a"];
    [self.testVarVal setValue:[NSNumber numberWithInt:5] forKey:@"c"];
    
    [self updatePrintVar];
}

- (IBAction)test3Pressed:(UIButton *)sender {
    [self.testVarVal setValue:[NSNumber numberWithInt:0] forKey:@"x"];
    [self.testVarVal setValue:[NSNumber numberWithInt:-10] forKey:@"a"];
    [self.testVarVal setValue:[NSNumber numberWithInt:2] forKey:@"c"];
    [self updatePrintVar];
}
*/

- (IBAction)undoPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber && [self.display.text length]>0) {
        NSString* last = [self.display.text substringFromIndex:[self.display.text length]-1];
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        if([last isEqualToString:@"."])
            self.onDotRightHandSide = NO;
    }
    else
        [self.brain pop];
    
    [self updateScratch];
}

- (IBAction)clearAll:(id)sender {
    [self.brain clear];
    self.scratch.text = @"";
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.onDotRightHandSide = NO;
}

- (void)viewDidUnload {
    [self setScratch:nil];
    [self setPrintVar:nil];
    [super viewDidUnload];
}
@end
