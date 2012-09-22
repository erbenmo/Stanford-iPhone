//
//  CalculatorViewController.m
//  Calculator
//
//  Created by MoErben on 2/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL onDotRightHandSide;
@property (nonatomic, strong) CalculatorBrain* brain;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize scratch;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain*)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
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

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self appendToScratch:self.display.text];
}

- (IBAction)operationPressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    NSString* operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self appendToScratch:operation];
}

- (void)appendToScratch:(NSString *)item {
    NSString* newText = [NSString stringWithString:self.scratch.text];
    newText = [newText stringByAppendingString:item];
    newText = [newText stringByAppendingString:@" "];
    
    if([newText length] > 27)
        newText = [newText substringFromIndex:([newText length]-27)];
    
    self.scratch.text = newText;
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
    [super viewDidUnload];
}
@end
