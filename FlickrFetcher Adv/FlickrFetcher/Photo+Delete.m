//
//  Photo+Delete.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photo+Delete.h"
#import "Place.h"
#import "Tag.h"
#import "FlickrFetcher.h"

@implementation Photo (Delete)
+(void)deletePhotoWithFlickrInfo:(NSDictionary *)flickr inManagedObjectContext:(NSManagedObjectContext *)context {    
    // photo
    {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickr objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"%s: Didn't delete anything. More than one photo was returned.", __FUNCTION__);
    } else if ([matches count] == 1) {
        Photo* photo = [matches lastObject];
        [context deleteObject:photo];
    } else {
        NSLog(@"%s: Didn't delete anything. No photo was returned.", __FUNCTION__);
    }
    }
    
    // place
    {
    //Check to see if number of photos taken at place is now zero and then delete place
    NSFetchRequest *placeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    placeRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", [flickr objectForKey:FLICKR_PHOTO_PLACE_NAME]];
    NSSortDescriptor *placeSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    placeRequest.sortDescriptors = [NSArray arrayWithObject:placeSortDescriptor];
        
    NSError *error = nil;
    NSArray *placeMatches = [context executeFetchRequest:placeRequest error:&error];
    
    if (!placeMatches || ([placeMatches count] > 1)) {
        // handle error
        NSLog(@"%s: Didn't delete anything. More than one photo was returned.", __FUNCTION__);
    } else if ([placeMatches count] == 1) {
        Place* place = [placeMatches lastObject];
        NSLog(@"%@, %d", place.name, [place.photos count]);
        if ([place.photos count] ==0) {
            [context deleteObject:place];
        }
    } else {
        NSLog(@"%s: Didn't delete anything. No place was returned.", __FUNCTION__);
    }
    }
    
    
    // tag
    {
    NSFetchRequest *tagRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSSortDescriptor *tagSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

    tagRequest.sortDescriptors = [NSArray arrayWithObject:tagSortDescriptor];
    NSError *error = nil;

    NSArray *tagMatches = [context executeFetchRequest:tagRequest error:&error];
    
    if (!tagMatches || ([tagMatches count] > 1)) {
        // handle error
        NSLog(@"%s: Didn't delete anything. More than one photo was returned.", __FUNCTION__);
    } else{
        for (Tag* tag in tagMatches) {
            NSLog(@"tag: %@", tag.name);
            if ([tag.photos count] == 0) {
                [context deleteObject:tag];
            }
        }
    }
    }
}
@end
