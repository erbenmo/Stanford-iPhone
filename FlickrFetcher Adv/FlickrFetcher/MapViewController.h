//
//  MapViewController.h
//  FlickrFetcher
//
//  Created by Erben Mo on 23/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSMutableArray* annotations;
@property (nonatomic, weak)id<MapViewControllerDelegate> delegate;
@end
