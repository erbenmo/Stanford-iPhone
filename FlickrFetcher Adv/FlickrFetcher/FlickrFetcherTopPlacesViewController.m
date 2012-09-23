//
//  FlickrFetcherTopPlacesViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 15/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrFetcherTopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherPicInPlaceViewController.h"

@interface FlickrFetcherTopPlacesViewController ()
@property (nonatomic, strong) NSMutableArray* cities;
@property (nonatomic, strong) NSArray* picsInPlace;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@end

@implementation FlickrFetcherTopPlacesViewController
@synthesize cities = _cities;
@synthesize picsInPlace = _picsInPlace;
@synthesize spinner = _spinner;

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

    self.cities = [NSMutableArray array];
    
    self.spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.spinner];
    [self.spinner startAnimating];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray* places = [[FlickrFetcher topPlaces] copy]; // dispatch
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary* place in places)
                [self.cities addObject:place];
            [self.tableView reloadData];
            [self.spinner stopAnimating];
        });
    });
    
    dispatch_release(downloadQueue);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"getPicInPlace"]) {
        [segue.destinationViewController setPics:self.picsInPlace];
    }
}


#pragma mark - FlickrFetcherTopPlacesViewControllerDelegateDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topPlacesID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* place = [self.cities objectAtIndex:indexPath.row];
    
    NSString* allContents = [place objectForKey:@"_content"];
    NSString* stateCountry = [allContents substringFromIndex:[allContents rangeOfString:@","].location+2];
    NSString* cityName = [allContents substringToIndex:[allContents rangeOfString:@","].location];

    cell.textLabel.text = cityName;
    cell.detailTextLabel.text = stateCountry;
    
    return cell;
}

#pragma mark - FlickrFetcherTopPlacesViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dispatch
    dispatch_queue_t downloadQ = dispatch_queue_create("flickr photo in place", NULL);
    [self.spinner startAnimating];

    dispatch_async(downloadQ, ^{
        self.picsInPlace = [[FlickrFetcher photosInPlace:[self.cities objectAtIndex:indexPath.row] maxResults:50] copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"getPicInPlace" sender:self];
            [self.spinner stopAnimating];
        });
    });
}

@end
