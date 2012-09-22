//
//  GraphView.h
//  Calculator
//
//  Created by MoErben on 6/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (CGFloat) getValue:(CGFloat) x;
@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

- (void)pinchHandler:(UIPinchGestureRecognizer *)gesture;
- (void)panHandler:(UIPanGestureRecognizer *)gesture;
- (void)tripleTapHandler:(UITapGestureRecognizer*) gesture;
@end

