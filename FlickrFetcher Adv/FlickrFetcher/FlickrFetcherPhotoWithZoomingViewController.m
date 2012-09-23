//
//  FlickrFetcherPhotoWithZoomingViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 16/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrFetcherPhotoWithZoomingViewController.h"
#import "FlickrFetcher.h"

@interface FlickrFetcherPhotoWithZoomingViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary* pic;
@end

@implementation FlickrFetcherPhotoWithZoomingViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize pic = _pic;

- (void) setPic:(NSDictionary *)pic {
    _pic = pic;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
    
    self.scrollView.delegate = self;
    
    NSURL* urlForPhotot = [FlickrFetcher urlForPhoto:self.pic format:FlickrPhotoFormatLarge];
    NSData* data = [[NSData alloc] initWithContentsOfURL:urlForPhotot];
    UIImage* picture = [UIImage imageWithData:data];
    
    [self.imageView setImage:picture];
    
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.contentSize = self.imageView.bounds.size;
    
    
    [self.imageView setNeedsDisplay];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
