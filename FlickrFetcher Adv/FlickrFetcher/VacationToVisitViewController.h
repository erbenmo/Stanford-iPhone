//
//  VacationToVisitViewController.h
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VacationToVisitViewController;

@protocol VacationToVisitViewControllerDelegate <NSObject>
- (void)chooseVacationToVisit:(VacationToVisitViewController *)sender
                        choseOption:(NSString *)option;
@end


@interface VacationToVisitViewController : UITableViewController
@property (nonatomic, strong) NSArray* virtualVacations;
@property (nonatomic, weak) id<VacationToVisitViewControllerDelegate> delegate;
@end
