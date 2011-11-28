//
//  PictureTableViewCell.h
//  JeanomeIOS
// 
//  UITableViewCell which contains another UITableView inside to support side scrolling
//  of pictures inside a Jeanome closet!
//
//  Created by david lam on 11/22/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClosetItem.h"
#import "PictureDownloader.h"

@interface PictureTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, PictureDownloaderDelegate> {
    
    NSDecimalNumber *itemcount;    
    NSDictionary *items;            // set in ClosetViewController.m:157
    NSArray *closetItems; // contains ClosetItem's
    
    NSMutableDictionary *imageDownloadsInProgress;
}

@property(nonatomic,retain) NSDecimalNumber *itemcount;
@property(nonatomic,retain) NSDictionary *items;  // set from...  ClosetViewController.m:157
@property(nonatomic,retain) NSArray *closetItems;

@property(nonatomic,retain) IBOutlet UITableView *tableViewInsideCell;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void) _loadClosetImage:intoCell:(UITableViewCell *)cell;

- (void)startClosetPictureDownload:(ClosetItem *)closetItem forIndexPath:(NSIndexPath *)indexPath;
@end
