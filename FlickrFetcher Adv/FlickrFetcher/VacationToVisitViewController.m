//
//  VacationToVisitViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "VacationToVisitViewController.h"
#import "VacationTableViewController.h"

@interface VacationToVisitViewController ()
@end

@implementation VacationToVisitViewController
@synthesize virtualVacations = _virtualVacations;
@synthesize delegate = _delegate;

- (void)setDelegate:(id<VacationToVisitViewControllerDelegate>)delegate {
    _delegate = delegate;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:VACATION_PLIST];
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if([manager fileExistsAtPath:fullPath])
        self.virtualVacations = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    else
        self.virtualVacations = [[NSArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.virtualVacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"vacationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.virtualVacations objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedVacation = [self.virtualVacations objectAtIndex:indexPath.row];
    [self.delegate chooseVacationToVisit:self choseOption:selectedVacation];
}

@end
