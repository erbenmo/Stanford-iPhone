//
//  Place+Create.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Place.h"

@interface Place (Create)
+ (Place*) createPlaceWithFlickr: (NSDictionary*)flickr inManagedObjectContext:(NSManagedObjectContext *)context;
@end
