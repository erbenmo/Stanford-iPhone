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


-(NSString*) path {
    if(!_path) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imageCache"];
    }
    return _path;
}

-(NSFileManager*) manager {
    if(!_manager) {
        _manager = [[NSFileManager alloc] init];
        
        if(![_manager fileExistsAtPath:self.path])
            [_manager createDirectoryAtPath:self.path
                withIntermediateDirectories:NO
                                 attributes:nil
                                      error:nil];
    }
    
    return _manager;
}

- (unsigned long long int)folderSize {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        NSDictionary *attribute = [self.manager attributesOfItemAtPath:filePath error:nil];
        fileSize += [attribute fileSize];
    }
    
    return fileSize;
}

- (NSString*)earliestModifiedFile {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    
    NSString* earlyFileName;
    NSDate* earlyFileDate;
    
    NSString *fileName;
    while (fileName = [filesEnumerator nextObject]) {
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        NSDictionary *attribute = [self.manager attributesOfItemAtPath:filePath error:nil];
        NSDate* curDate = [attribute fileCreationDate];
        if(earlyFileDate == nil) {
            earlyFileName = fileName;
            earlyFileDate = curDate;
        } else if([curDate compare:earlyFileDate] == NSOrderedAscending) {
            earlyFileName = fileName;
            earlyFileDate = curDate;
        }
    }
    
    return earlyFileName;
}

-(BOOL) hitCache:(NSDictionary *)image {
    NSString* fileName = [image objectForKey:FLICKR_PHOTO_ID];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    return [self.manager fileExistsAtPath:filePath];
}

-(void) addImageToCache:(NSDictionary *)image withData:(NSData *)data {
    NSString* fileName = [image objectForKey:FLICKR_PHOTO_ID];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    unsigned long long int fs = [self folderSize];
    //NSLog(@"before: %lld", fs);
    if(fs > 1*1048576) {
        NSString* victimFile = [self earliestModifiedFile];
        NSString* victimPath = [self.path stringByAppendingPathComponent:victimFile];
        [self.manager removeItemAtPath:victimPath error:nil];
    }
    
    [self.manager createFileAtPath:filePath contents:data attributes:nil];
    
    fs = [self folderSize];
    //NSLog(@"after: %lld", fs);
}

-(NSData*) getPixelsFromCache:(NSDictionary *)image {
    NSString* fileName = [image objectForKey:FLICKR_PHOTO_ID];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        
    return [self.manager contentsAtPath:filePath];
}





@end


