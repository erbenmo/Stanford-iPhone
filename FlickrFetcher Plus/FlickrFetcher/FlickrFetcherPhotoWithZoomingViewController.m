//
//  FlickrFetcherPhotoWithZoomingViewController.m
//  FlickrFetcher
//
//  Created by Erben Mo on 16/9/12.
//  Copyright (c) 2012 Mo Erben. All rights reserved.
//

#import "FlickrFetcherPhotoWithZoomingViewController.h"
#import "FlickrFetcher.h"
#import "ImageCache.h"

@interface FlickrFetcherPhotoWithZoomingViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary* pic;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, strong) ImageCache* cache;
@end

@implementation FlickrFetcherPhotoWithZoomingViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize pic = _pic;
@synthesize spinner = _spinner;
@synthesize cache = _cache;

- (void) setPic:(NSDictionary *)pic {
    _pic = pic;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (ImageCache*) cache {
    if(!_cache) {
        _cache = [[ImageCache alloc] init];
    }
    return _cache;
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
    
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [self.spinner startAnimating];
    
    dispatch_queue_t downloadQ = dispatch_queue_create("download pic", NULL);
    dispatch_async(downloadQ, ^{
        
        // check cache first
        NSData* data;
        BOOL hit = [self.cache hitCache:self.pic];
        if(!hit) {
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            NSURL* urlForPhotot = [FlickrFetcher urlForPhoto:self.pic format:FlickrPhotoFormatLarge];
            data = [[NSData alloc] initWithContentsOfURL:urlForPhotot];
            [self.cache addImageToCache:self.pic withData:data];
        } else {
            data = [self.cache getPixelsFromCache:self.pic];
        }
        
        UIImage* picture = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:picture];
            
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            self.scrollView.contentSize = self.imageView.bounds.size;
            
            [self.imageView setNeedsDisplay];
            [self.spinner stopAnimating];
        });
    });
    
    dispatch_release(downloadQ);
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
