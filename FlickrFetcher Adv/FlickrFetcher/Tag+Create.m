//
//  Tag+Create.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Tag+Create.h"
#import "FlickrFetcher.h"

@implementation Tag (Create)

+ (Tag*) createTagWithFlickr:(NSString*)tagName inManagedObjectContext:(NSManagedObjectContext *)context {
    Tag* tag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches || [matches count] > 1) {
        NSLog(@"error in fetching photo");
    } else if([matches count] == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.name = tagName;
    } else {
        tag = [matches lastObject];
    }
    
    return tag;
}

@end
