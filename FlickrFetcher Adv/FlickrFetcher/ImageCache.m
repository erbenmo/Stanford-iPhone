//
//  ImageCache.m
//  FlickrFetcher
//
//  Created by Erben Mo on 23/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "ImageCache.h"
#import "FlickrFetcher.h"

@interface ImageCache()
@property (nonatomic, strong) NSFileManager* manager;
@property (nonatomic, copy) NSString* path;
@end

@implementation ImageCache
@synthesize manager = _manager;
@synthesize path = _path;


-(NSFileManager*) manager {
    if(!_manager) {
        _manager = [[NSFileManager alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imageCache"];
        if(![_manager fileExistsAtPath:self.path])
            [_manager createDirectoryAtPath:self.path
                withIntermediateDirectories:NO
                                 attributes:nil
                                      error:nil];
    }
    
    return _manager;
}

-(BOOL) hitCache:(NSDictionary *)image {
    NSNumber* unique = [image objectForKey:FLICKR_PHOTO_ID];
    NSString *fileName = [unique stringValue];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    return [self.manager fileExistsAtPath:filePath];
}

-(void) addImageToCache:(NSDictionary *)image withData:(NSData *)data {
    NSNumber* unique = [image objectForKey:FLICKR_PHOTO_ID];
    NSString *fileName = [unique stringValue];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    [self.manager createFileAtPath:filePath contents:data attributes:nil];
}

-(NSData*) getPixelsFromCache:(NSDictionary *)image {
    NSNumber* unique = [image objectForKey:FLICKR_PHOTO_ID];
    NSString *fileName = [unique stringValue];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    return [self.manager contentsAtPath:filePath];
}






@end


