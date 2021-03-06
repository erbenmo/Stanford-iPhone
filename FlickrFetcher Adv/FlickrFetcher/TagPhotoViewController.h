//
//  TagPhotoViewController.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface TagPhotoViewController : CoreDataTableViewController
@property (nonatomic, strong) UIManagedDocument *photoDatabase;  // Model is a Core Data database of photos
@property (nonatomic, strong) NSString* vacationName;
@property (nonatomic, strong) NSString* forTag;
@end
