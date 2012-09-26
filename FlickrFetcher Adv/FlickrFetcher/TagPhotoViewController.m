//
//  TagPhotoViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "TagPhotoViewController.h"
#import "Photo.h"
#import "Tag.h"
#import "VacationHelper.h"

@interface TagPhotoViewController ()

@end

@implementation TagPhotoViewController
@synthesize  photoDatabase = _photoDatabase;
@synthesize  vacationName = _vacationName;
@synthesize  forTag = _forTag;

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ANY tags.name = %@", self.forTag];
    
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
    static NSString *CellIdentifier = @"photoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Photo* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    
    return cell;
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
