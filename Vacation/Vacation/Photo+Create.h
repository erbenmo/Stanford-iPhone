//
//  Photo+Create.h
//  Vacation
//
//  Created by Erben Mo on 24/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
