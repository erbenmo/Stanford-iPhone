//
//  CalculatorBrain.m
//  Calculator
//
//  Created by MoErben on 2/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import "CalculatorBrain.h"
@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
 
- (NSMutableArray *)programStack {
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

- (void) clear {
    [self.programStack removeAllObjects];
}

- (id)program {
    return [self.programStack copy];
}

- (void)pop {
    id topOfStack = [self.programStack lastObject];
    if(topOfStack) [self.programStack removeLastObject];
}

- (NSString*) getDescription {
    return [[self class] descriptionOfProgram:self.programStack];
}

+ (BOOL)isOperation:(NSString*)op {
    NSSet* opSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", nil];
    return [opSet containsObject:op];
}

+ (int)leftScore:(id)cur {
    if([cur isKindOfClass:[NSNumber class]])
        return 3;
    assert([cur isKindOfClass:[NSString class]]);
    
    if([cur isEqualToString:@"+"] || [cur isEqualToString:@"-"])
        return 0;
    else if([cur isEqualToString:@"*"] || [cur isEqualToString:@"/"])
        return 2;
    else if([cur isEqualToString:@"π"])
        return 3;
    else if([cur isEqualToString:@"sin"] || [cur isEqualToString:@"cos"] || [cur isEqualToString:@"sqrt"])
        return 4;
    else
        return 3; // vars
    return -1;
}

+ (int)rightScore:(id)cur {
    if([cur isKindOfClass:[NSString class]] &&
       [cur isEqualToString:@"*"])
        return 1;
    else
        return [[self class] leftScore:cur];
}

+ (BOOL)singleOperator:(NSString*)op {
    assert([[self class] isOperation:op]);
    
    return [[self class] leftScore:op] == 4;
}

+ (NSString *)descriptionOfProgram:(id)program {
    assert([program isKindOfClass:[NSArray class]]);
    
    NSMutableArray* types = [program mutableCopy];
    NSMutableArray* strs = [[NSMutableArray alloc] init];
    for (id cur in types) {
        if([[self class] leftScore:cur] == 3)
            if([cur isKindOfClass:[NSString class]])
                [strs addObject:cur];
            else
                [strs addObject:[cur stringValue]];
        else
            [strs addObject:cur];
    }
    
    while(YES) {
        NSUInteger i;
        for (i=0; i<[types count]; i++) {
            if ([[self class] isOperation:[types objectAtIndex:i]] &&
                ![[types objectAtIndex:i] isEqualToString:@"π"] &&
                [[types objectAtIndex:i] isEqualToString:[strs objectAtIndex:i]]) {
                break;
            }
        }
        
        if(i == [types count])
            break;
        
        NSString* curOp = [types objectAtIndex:i];
        NSString* curStr = [strs objectAtIndex:i];
        
        if([[self class]singleOperator:curOp]) {
            assert(i>=1);
            NSString* prevStr = [strs objectAtIndex:i-1];
            [strs replaceObjectAtIndex:i withObject:[curStr stringByAppendingFormat:@"(%@)", prevStr]];
            [types removeObjectAtIndex:i-1];
            [strs removeObjectAtIndex:i-1];
        }
        else {
            assert(i>=2);
            NSString* leftStr = [strs objectAtIndex:i-2];
            NSString* rightStr = [strs objectAtIndex:i-1];
            id leftType = [types objectAtIndex:i-2];
            id rightType = [types objectAtIndex:i-1];
            
            if([[self class] leftScore:leftType] < [[self class] rightScore:curOp])
                leftStr = [NSString stringWithFormat:@"(%@)", leftStr];
            if([[self class] rightScore:rightType] < [[self class] rightScore:curOp])
                rightStr = [NSString stringWithFormat:@"(%@)", rightStr];
         
            [strs replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ %@ %@", leftStr, curStr, rightStr]];
            
            NSMutableIndexSet* toDeleteIndexSet = [[NSMutableIndexSet alloc] init];
            [toDeleteIndexSet addIndex:i-2];
            [toDeleteIndexSet addIndex:i-1];
            
            [types removeObjectsAtIndexes:toDeleteIndexSet];
            [strs removeObjectsAtIndexes:toDeleteIndexSet];
        }
    }
    
    NSString* result = [[NSString alloc] init];
    for (NSString* cur in strs) {
        result = [result stringByAppendingFormat:@"%@,  ", cur];
    }
    
    return result;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVarOperand:(NSString *)operand {
    [self.programStack addObject:operand];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (double)performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *) stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] *
                     [self popOperandOffProgramStack:stack];
        } else if([operation isEqualToString:@"-"]) {
            double right = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - right;
        } else if([operation isEqualToString:@"/"]) {
            double right = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] / right;
        } else if([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableDictionary* varDict;
    NSSet* varSet = [[self class] variablesUsedInProgram:program];
    
    for (NSString* cur in varSet) {
        [varDict setObject:0 forKey:cur];
    }
    
    return [[self class] runProgram:program usingVariableValues:varDict];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray* stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        for (NSUInteger i=0; i<[stack count]; i++) {
            id cur = [stack objectAtIndex:i];
            if(![cur isKindOfClass:[NSString class]]) continue;
            
            if([variableValues objectForKey:cur] != nil)
                [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:cur]];
        }
    }
    
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
   
    NSMutableSet* varSet;
    
    for (id cur in program) {
        if(![cur isKindOfClass:[NSString class]]) continue;
        if([[self class] isOperation:cur]) continue;
        
        [varSet addObject:cur];
    }
    
    return varSet;
}

@end
