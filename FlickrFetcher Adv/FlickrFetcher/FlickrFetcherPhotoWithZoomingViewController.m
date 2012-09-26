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
#import "VacationToVisitViewController.h"
#import "Photo+Create.h"
#import "Photo+Delete.h"
#import "VacationHelper.h"

@interface FlickrFetcherPhotoWithZoomingViewController ()<UIScrollViewDelegate, VacationToVisitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary* pic;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, strong) ImageCache* cache;
@property (nonatomic, strong) NSString* vacationName;
@end

@implementation FlickrFetcherPhotoWithZoomingViewController
@synthesize visitButton = _visitButton;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize pic = _pic;
@synthesize spinner = _spinner;
@synthesize cache = _cache;
@synthesize vacationName = _vacationName;

- (void) setPic:(NSDictionary *)pic {
    _pic = pic;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (IBAction)toggleVisitButton:(UIButton*)sender {
    if([self.visitButton.titleLabel.text isEqualToString:@"visit"]) {
        [self performSegueWithIdentifier:@"modalVacationOption" sender:self];
    } else {
        [self.visitButton setTitle:@"visit" forState:UIControlStateNormal];
        [VacationHelper openVacation:self.vacationName usingBlock:^(UIManagedDocument* doc) {
            [self deletePhotoFromDoc:doc];
        }];
    }
}

- (void) addPhotoToDoc:(UIManagedDocument*) doc {
    if (doc.documentState == UIDocumentStateNormal){
        
        //dispatch_queue_t fetchQ = dispatch_queue_create("save photo", NULL);
        //dispatch_async(fetchQ, ^{
            //Save photo to database
            [doc.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
                
                [Photo createPhotoWithFlickrInfo:self.pic inManagedObjectContext:doc.managedObjectContext];
                
                [doc saveToURL:doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                }];
            }];
            //dispatch_release(fetchQ);
        //});
    }

}

- (void) deletePhotoFromDoc:(UIManagedDocument*) doc {
    if (doc.documentState == UIDocumentStateNormal){
        
        //dispatch_queue_t fetchQ = dispatch_queue_create("save photo", NULL);
        //dispatch_async(fetchQ, ^{
        //Save photo to database
        [doc.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
            
            [Photo deletePhotoWithFlickrInfo:self.pic inManagedObjectContext:doc.managedObjectContext];
            
            [doc saveToURL:doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            }];
        }];
        //dispatch_release(fetchQ);
        //});
    }

}
/*
- (void)setInitialVisitStatus: (UIManagedDocument*) doc {
    if (doc.documentState == UIDocumentStateNormal){
        
        //dispatch_queue_t fetchQ = dispatch_queue_create("save photo", NULL);
        //dispatch_async(fetchQ, ^{
        //Save photo to database
        [doc.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [self.pic objectForKey:FLICKR_PHOTO_ID]];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            NSArray *matches = [doc.managedObjectContext executeFetchRequest:request error:nil];
            if([matches count] == 1) {
                Photo* photo = [matches lastObject];
                if([photo.visited intValue] == 1)
                    [self.visitButton setTitle:@"unvisit" forState: UIControlStateNormal];
                else
                    [self.visitButton setTitle:@"visit" forState:UIControlStateNormal];
            }
        }];
        //dispatch_release(fetchQ);
        //});
    }

}*/

- (void)chooseVacationToVisit:(VacationToVisitViewController *)sender choseOption:(NSString *)option {
    self.vacationName = option;
    [VacationHelper openVacation:self.vacationName usingBlock:^(UIManagedDocument* doc) {
        [self addPhotoToDoc:doc];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
    self.visitButton.titleLabel.text = @"unvisit";
    [self.visitButton setTitle:@"unvisit" forState:UIControlStateNormal];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"modalVacationOption"]) {
        //VacationToVisitViewController* dest = (VacationToVisitViewController*)(segue.destinationViewController);
        if([segue.destinationViewController isKindOfClass:[VacationToVisitViewController class]])
            [segue.destinationViewController setDelegate:self];
    }
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
    [self setVisitButton:nil];
    [self setVisitButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
