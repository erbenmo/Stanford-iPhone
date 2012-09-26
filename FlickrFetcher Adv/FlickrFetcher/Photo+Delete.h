//
//  Photo+Delete.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photo.h"

@interface Photo (Delete)
+(void)deletePhotoWithFlickrInfo: (NSDictionary*)flickr inManagedObjectContext:(NSManagedObjectContext *)context;

@end
