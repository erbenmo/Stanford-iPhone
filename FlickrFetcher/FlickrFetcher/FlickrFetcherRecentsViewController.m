//
//  FlickrFetcherRecentsViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 18/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrFetcherRecentsViewController.h"
#import "FlickrFetcher.h"
#import "FlickrFetcherPicInPlaceViewController.h"

@interface FlickrFetcherRecentsViewController ()
@property (nonatomic, strong)NSMutableArray* photos;
@property (nonatomic, strong)NSMutableSet* visited;
@end

@implementation FlickrFetcherRecentsViewController
@synthesize photos = _photos;
@synthesize visited = _visited;


-(void) setRecentPhoto:(NSDictionary*) photo {
    if(!self.photos)
        self.photos = [[NSMutableArray alloc] init];
    
    if(!self.visited)
        self.visited = [[NSMutableSet alloc] init];
    
    id photo_id = [photo objectForKey:@"id"];
    if([self.visited containsObject:photo_id])
        return;
    
    if([self.photos count] < 5) {
        [self.photos addObject:photo];
        [self.visited addObject:photo_id];
    } else {
        id remove_photo_id = [[self.photos objectAtIndex:0] objectForKey:@"id"];
        [self.photos removeObjectAtIndex:0];
        [self.visited removeObject:remove_photo_id];
        
        [self.photos addObject:photo];
        [self.visited addObject:photo_id];
    }
    
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
    [self.tableView reloadData];

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recentsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* curPhoto = [self.photos objectAtIndex:indexPath.row];
    NSString* title = [curPhoto objectForKey:@"title"];
    NSString* content = [curPhoto valueForKeyPath:@"description._content"];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
