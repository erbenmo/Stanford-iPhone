//
//  CalculatorBrain.h
//  Calculator
//
//  Created by MoErben on 2/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVarOperand:(NSString*)operand;
- (void)pop;
- (double)performOperation:(NSString*) operation;
- (double)performOperation:(NSString*) operation usingVariableValues:(NSDictionary*) variableValues;
- (void) clear;
- (NSString *)getDescription;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double) runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
