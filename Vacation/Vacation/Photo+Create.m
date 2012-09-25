//
//  Photo+Create.m
//  Vacation
//
//  Created by Erben Mo on 24/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"
#import "Tag+Create.h"

@implementation Photo (Create)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context {
    Photo* photo;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique=%@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray* matches = [context executeFetchRequest:request error:nil];
    
    if(!matches || [matches count] > 1) {
        NSLog(@"error");
    } else if([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.url = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.whoTook = [Photographer photographerWithName:[flickrInfo objectForKey:FLICKR_PHOTO_OWNER] inManagedObjectContext:context];
        
        NSMutableSet* tags = [NSMutableSet set];
        for (NSString* tagString in [flickrInfo objectForKey:FLICKR_TAGS]) {
            Tag* tag = [Tag tagWithName:tagString inManagedObjectContext:context];
            [tags addObject:tag];
        }
        photo.tags = [tags copy];
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}
@end
