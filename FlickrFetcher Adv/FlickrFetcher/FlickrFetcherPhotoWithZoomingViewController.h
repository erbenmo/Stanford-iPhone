//
//  FlickrFetcherPhotoWithZoomingViewController.h
//  FlickrFetcher
//
//  Created by Erben Mo on 16/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrFetcherPhotoWithZoomingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *visitButton;

- (void) setPic:(NSDictionary*) pic;
@end
