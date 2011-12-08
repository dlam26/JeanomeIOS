//
//  PictureDownloader.m
//  JeanomeIOS
//
//  Created by david lam on 11/28/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

/*
 Copied from this file in LazyTableImages
 
 File: IconDownloader.h 
 Abstract: Helper object for managing the downloading of a particular app's icon.
 As a delegate "NSURLConnectionDelegate" is downloads the app icon in the background if it does not
 yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 
 A simple BOOL tracks whether or not a download is already in progress to avoid redundant requests.

 */

#import "PictureDownloader.h"
#import "ClosetItem.h"

#define degreesToRadians(x) (M_PI * x / 180.0)


@implementation PictureDownloader

@synthesize closetItem;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
    [closetItem release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:closetItem.imageURL]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // NSLog(@"PictureDownloader.m:74  didRecieveResponse()");

   // NSMutableData *responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"PictureDownloader.m:80   didRecieveData()");
    
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"PictureDownloader.m:87   didFailWithError()"); 
    
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"PictureDownloader.m:92   connectionDidFinishLoading()");
    
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    // rotate since 90 degrees since it's being shown in a sideways UITableView
    UIImageView *closetItemImageView  = [[UIImageView alloc] initWithImage:image];
    closetItemImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
    closetItemImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.closetItem.image = image;
    self.closetItem.imageView = closetItemImageView;
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
    
    [image release]; [closetItemImageView release];
}

@end

