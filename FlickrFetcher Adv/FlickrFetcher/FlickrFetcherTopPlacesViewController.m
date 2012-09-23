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
@end

@implementation FlickrFetcherTopPlacesViewController
@synthesize cities = _cities;
@synthesize picsInPlace = _picsInPlace;

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
    NSArray* places = [[FlickrFetcher topPlaces] copy];
    
    for (NSDictionary* place in places) {
        [self.cities addObject:place];
    }
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - FlickrFetcherTopPlacesViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.picsInPlace = [[FlickrFetcher photosInPlace:[self.cities objectAtIndex:indexPath.row] maxResults:50] copy];
    
    [self performSegueWithIdentifier:@"getPicInPlace" sender:self];
}

@end
