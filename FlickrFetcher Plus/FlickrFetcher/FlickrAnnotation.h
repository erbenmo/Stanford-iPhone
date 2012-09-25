//
//  FlickrAnnotation.h
//  FlickrFetcher
//
//  Created by Erben Mo on 23/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"

@interface FlickrAnnotation : NSObject<MKAnnotation>
@property (nonatomic, strong) NSDictionary* photo;
+ (FlickrAnnotation*)annotationForPhoto:(NSDictionary*) photo;
@end
