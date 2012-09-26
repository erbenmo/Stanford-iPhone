//
//  Tag+Create.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag*) createTagWithFlickr:(NSString*)tagName inManagedObjectContext:(NSManagedObjectContext *)context;
@end
