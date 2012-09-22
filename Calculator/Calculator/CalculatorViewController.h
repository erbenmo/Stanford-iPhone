//
//  CalculatorViewController.h
//  Calculator
//
//  Created by MoErben on 2/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *scratch;
@property (weak, nonatomic) IBOutlet UILabel *printVar;

@end
