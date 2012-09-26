//
//  TagViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 25/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "TagViewController.h"
#import "TagPhotoViewController.h"
#import "VacationHelper.h"
#import "Tag.h"

@interface TagViewController ()
@property (nonatomic, strong) NSString* selectedTag;
@end

@implementation TagViewController
@synthesize  photoDatabase = _photoDatabase;
@synthesize  vacationName = _vacationName;
@synthesize selectedTag = _selectedTag;

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tagCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Tag* tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tag* tag = (Tag*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedTag = tag.name;
    [self performSegueWithIdentifier:@"toPhoto" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toPhoto"]) {
        TagPhotoViewController* dest = (TagPhotoViewController*)segue.destinationViewController;
        dest.vacationName = self.vacationName;
        dest.forTag = self.selectedTag;
    }
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
	// Do any additional setup after loading the view.
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
