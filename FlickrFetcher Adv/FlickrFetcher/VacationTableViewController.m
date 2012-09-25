//
//  VacationTableViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "VacationTableViewController.h"
#import "OptionViewController.h"

@interface VacationTableViewController ()
@property (nonatomic, strong) NSMutableArray* virtualVacations;
@property (nonatomic, strong) NSString* selectedVacation;
@end

@implementation VacationTableViewController
@synthesize virtualVacations = _virtualVacations;
@synthesize selectedVacation = _selectedVacation;

- (NSArray*)virtualVacations {
    if(!_virtualVacations) _virtualVacations = [[NSMutableArray alloc] init];
    return _virtualVacations;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


// invariant
// if "#" is in plist
// then there also exists directory "#"
- (IBAction)addNewVacation:(id)sender {
    NSUInteger numVacation = [self.virtualVacations count] + 1;
    NSString* newVacationName = [NSString stringWithFormat:@"%d", numVacation];
    
    [self.virtualVacations addObject:newVacationName];
    NSString* plistPath = [NSHomeDirectory() stringByAppendingPathComponent:VACATION_PLIST];
    [self.virtualVacations writeToFile:plistPath atomically:YES];

    [self.tableView reloadData];
}

- (void)readVirtualVacationList {
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:VACATION_PLIST];
    self.virtualVacations = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:VACATION_PLIST];
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if([manager fileExistsAtPath:fullPath])
        self.virtualVacations = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    else
        [self.virtualVacations writeToFile:fullPath atomically:YES];
    
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.virtualVacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.virtualVacations objectAtIndex:indexPath.row
                           ];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedVacation = [self.virtualVacations objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toOption" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toOption"]) {
        [segue.destinationViewController setVacationName:self.selectedVacation];
    }
}

@end
