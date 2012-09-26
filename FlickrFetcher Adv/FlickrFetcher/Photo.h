//
//  Photo.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * visited;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
