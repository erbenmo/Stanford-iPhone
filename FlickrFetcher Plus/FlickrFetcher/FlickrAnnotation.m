//
//  FlickrAnnotation.m
//  FlickrFetcher
//
//  Created by Erben Mo on 23/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrAnnotation.h"

@implementation FlickrAnnotation
@synthesize photo = _photo;

-(NSString*) title {
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

-(NSString*) subtitle {
    return [self.photo valueForKeyPath:@"description._content"];
}

-(CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

+ (FlickrAnnotation*)annotationForPhoto:(NSDictionary*) photo {
    FlickrAnnotation* curAnnotation = [[FlickrAnnotation alloc] init];
    curAnnotation.photo = photo;
    
    return curAnnotation;
}

@end
