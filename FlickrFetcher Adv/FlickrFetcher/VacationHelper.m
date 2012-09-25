//
//  VacationHelper.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "VacationHelper.h"

@implementation VacationHelper
static NSMutableDictionary *managedDocumentDictionary = nil;

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock {
    
    if (!managedDocumentDictionary){
        managedDocumentDictionary = [[NSMutableDictionary alloc]init ];
    }
    
    // Try to retrieve the relevant UIManagedDocument from managedDocumentDictionary
    UIManagedDocument *doc = [managedDocumentDictionary objectForKey:vacationName];
    
    // Get URL for this vacation -> "<Documents Directory>/<vacationName>"
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    
    // If UIManagedObject was not retrieved, create it
    if (!doc) {
        
        // Create UIManagedDocument with this URL
        doc = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Add to managedDocumentDictionary
        [managedDocumentDictionary setObject:doc forKey:vacationName];
    }
    
    // If document exists on disk...
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSLog(@"file exists");
        [doc openWithCompletionHandler:^(BOOL success)
         {
             completionBlock(doc);
         }];
        
    } else {
        NSLog(@"file doesn't exist, creating now");
        [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             completionBlock(doc);
         }];
        
    }
}

@end
