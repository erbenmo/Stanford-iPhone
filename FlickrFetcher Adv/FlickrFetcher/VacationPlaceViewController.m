//
//  VacationPlaceViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "VacationPlaceViewController.h"
#import "Place.h"
#import "PlacePhotoViewController.h"

@interface VacationPlaceViewController ()
@property (nonatomic, strong) NSString* selectedPlace;
@end

@implementation VacationPlaceViewController
@synthesize vacationName = _vacationName;
@synthesize photoDatabase = _photoDatabase;
@synthesize selectedPlace = _selectedPlace;

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Places
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.photoDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)setPhotoDatabase:(UIManagedDocument *)photoDatabase {
    if(_photoDatabase != photoDatabase) {
        _photoDatabase = photoDatabase;
        [self setupFetchedResultsController];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"placeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Place* place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toPhoto"]) {
        PlacePhotoViewController* dest = (PlacePhotoViewController*) segue.destinationViewController;
        dest.vacationName = self.vacationName;
        dest.forPlace = self.selectedPlace;
    }
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Place* place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedPlace = place.name;
    [self performSegueWithIdentifier:@"toPhoto" sender:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [VacationHelper openVacation:self.vacationName usingBlock:^(UIManagedDocument* db) {
        self.photoDatabase = db;
        NSLog(@"set database");
    }];
    
    self.debug = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
