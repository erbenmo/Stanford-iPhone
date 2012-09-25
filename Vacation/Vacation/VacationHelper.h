//
//  VacationHelper.h
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VacationHelper

typedef void (^completion_block_t)(UIManagedDocument *vacation);

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock;

@end
