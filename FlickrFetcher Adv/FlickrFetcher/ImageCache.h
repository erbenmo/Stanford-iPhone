//
//  ImageCache.h
//  FlickrFetcher
//
//  Created by Erben Mo on 23/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

-(BOOL) hitCache: (NSDictionary*) image;
-(void) addImageToCache: (NSDictionary*) image withData: (NSData*) data;
-(NSData*) getPixelsFromCache: (NSDictionary*) image;

@end
