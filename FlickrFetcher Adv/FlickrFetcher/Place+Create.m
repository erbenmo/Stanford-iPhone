//
//  Place+Create.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Place+Create.h"
#import "FlickrFetcher.h"

@implementation Place (Create)
+ (Place*)createPlaceWithFlickr:(NSDictionary *)flickr inManagedObjectContext:(NSManagedObjectContext *)context {
    Place* place = nil;
    
    NSString *name = [flickr objectForKey:FLICKR_PHOTO_PLACE_NAME];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if (!places || ([places count] > 1)) {
        // handle error
    } else if (![places count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                              inManagedObjectContext:context];
        place.name = name;
        NSLog(@"%@", place.name);
        place.date = [NSDate date];
    } else {
        place = [places lastObject];
    }
    
    return place;
}
@end
