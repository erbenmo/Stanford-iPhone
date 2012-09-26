//
//  Photo+Create.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photo+Create.h"
#import "Place+Create.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Create)

+(Photo*)createPhotoWithFlickrInfo:(NSDictionary *)flickr inManagedObjectContext:(NSManagedObjectContext *)context {
    Photo* photo;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickr objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches || [matches count] > 1) {
        NSLog(@"error in fetching photo");
    } else if([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickr objectForKey:FLICKR_PHOTO_ID];
        
        NSString *title = [flickr objectForKey:FLICKR_PHOTO_TITLE];
        if(title && ![title isEqualToString:@""])
            photo.title = title;
        else
            photo.title = @"Unknown";
        
        photo.url = [[FlickrFetcher urlForPhoto:flickr format:FlickrPhotoFormatLarge] absoluteString];
        photo.place = [Place createPlaceWithFlickr:flickr inManagedObjectContext:context];
        photo.visited = [NSNumber numberWithBool:YES];
        
        NSString* tagString = [[flickr objectForKey:FLICKR_TAGS] copy];
        NSArray *tags = [tagString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        for (NSString* aTagString in tags) {
            if([aTagString rangeOfString:@":"].length == 0) {
                Tag* tag = [Tag createTagWithFlickr:aTagString inManagedObjectContext:context];
                [photo addTagsObject:tag];
            }
        }
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}
@end
