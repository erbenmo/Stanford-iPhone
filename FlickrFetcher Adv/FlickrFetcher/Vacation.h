//
//  Vacation.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Vacation : NSManagedObject

@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Place *places;

@end
