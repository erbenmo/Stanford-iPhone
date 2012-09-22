//
//  FavoriteGraphController.h
//  Calculator
//
//  Created by Erben Mo on 13/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoriteGraphController;

@protocol FavoriteGraphControllerDelegate
- (void)setProgram: (id) program;
@end

@interface FavoriteGraphController : UITableViewController
@property (nonatomic, weak) id <FavoriteGraphControllerDelegate> delegate;
@property (nonatomic, strong) NSArray* programs;
@end
