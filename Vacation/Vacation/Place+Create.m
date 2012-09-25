//
//  Place+Create.m
//  Vacation
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

+ (Place *)placeWithId:(NSString *)placeId
inManagedObjectContext:(NSManagedObjectContext *)context {
    Place* place;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"placeId = %@", placeId];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"placeId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray* matches = [context executeFetchRequest:request error:nil];
    
    if(!matches || [matches count] > 1) {
        NSLog(@"error");
    } else if([matches count] == 0) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.placeId = placeId;
    } else {
        place = [matches lastObject];
    }
    
    return place;
}

@end
