//
//  Place.h
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Vacation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UNKNOWN_TYPE unique;
@property (nonatomic, retain) NSSet *vacations;
@property (nonatomic, retain) Photo *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addVacationsObject:(Vacation *)value;
- (void)removeVacationsObject:(Vacation *)value;
- (void)addVacations:(NSSet *)values;
- (void)removeVacations:(NSSet *)values;

@end
