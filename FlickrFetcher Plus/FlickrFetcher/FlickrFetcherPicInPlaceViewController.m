//
//  FlickrFetcherPicInPlaceViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 15/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrFetcherPicInPlaceViewController.h"
#import "FlickrFetcherRecentsViewController.h"
#import "FlickrFetcherPhotoWithZoomingViewController.h"
#import "MapViewController.h"
#import "FlickrAnnotation.h"

@interface FlickrFetcherPicInPlaceViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSArray* pics;
@property (nonatomic, strong) NSDictionary* picSelected;
@end

@implementation FlickrFetcherPicInPlaceViewController
@synthesize pics = _pics;
@synthesize picSelected;

- (UIImage*)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation {
    FlickrAnnotation* ann = (FlickrAnnotation*) annotation;
    
    NSURL *url = [FlickrFetcher urlForPhoto:ann.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

- (void) setPics:(NSArray *)pics {
    _pics = [pics copy];
    [self.tableView reloadData];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSMutableArray*) getAnnotations {
    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:[self.pics count]];
    
    for (NSDictionary* pic in self.pics) {
        [annotations addObject:[FlickrAnnotation annotationForPhoto:pic]];
    }
    
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showPic"]) {
        [segue.destinationViewController setPic:self.picSelected];
    } else if([segue.identifier isEqualToString:@"toMap"]) {
        [segue.destinationViewController setAnnotations:[self getAnnotations]];
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - Pic In Place data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"picInPlace";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* title = [[self.pics objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString* content = [[self.pics objectAtIndex:indexPath.row] valueForKeyPath:@"description._content"];
    
    if(!title) {
        title = content;
        content = nil;
    }
    
    if(!title || [title isEqualToString:@""]) {
        title = @"Unknown";
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = content;
    
    return cell;
}

- (FlickrFetcherRecentsViewController*) getRecentsTabVC {
    UINavigationController* nav = [self.tabBarController.viewControllers objectAtIndex:1];
    
    id ans = [nav.viewControllers objectAtIndex:0];
    
    if (![ans isKindOfClass:[FlickrFetcherRecentsViewController class]]) {
        ans = nil;
    }
    
    return ans;
}

#pragma mark - Pic In Place view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.picSelected = [self.pics objectAtIndex:indexPath.row];
    
    FlickrFetcherRecentsViewController* recentsTab = [self getRecentsTabVC];
    [recentsTab setRecentPhoto:self.picSelected];
    
    [self performSegueWithIdentifier:@"showPic" sender:self];
}

@end
