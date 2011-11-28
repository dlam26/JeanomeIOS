//
//  PictureDownloader.h
//  JeanomeIOS
//
//  Created by david lam on 11/28/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

/*
 Copied from this file in the LazyTableImages sample
 
 File: IconDownloader.h 
 Abstract: Helper object for managing the downloading of a particular app's icon.
 As a delegate "NSURLConnectionDelegate" is downloads the app icon in the background if it does not
 yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 
 A simple BOOL tracks whether or not a download is already in progress to avoid redundant requests.
 
 Version: 1.2 
 */

@class ClosetItem;
@class RootViewController;

@protocol PictureDownloaderDelegate;

@interface PictureDownloader : NSObject
{
    ClosetItem *closetItem;
    NSIndexPath *indexPathInTableView;
    id <PictureDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) ClosetItem *closetItem;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <PictureDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol PictureDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end