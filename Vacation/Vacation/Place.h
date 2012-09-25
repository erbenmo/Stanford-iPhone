//
//  Place.h
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vacation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSSet *vacations;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addVacationsObject:(Vacation *)value;
- (void)removeVacationsObject:(Vacation *)value;
- (void)addVacations:(NSSet *)values;
- (void)removeVacations:(NSSet *)values;

@end
