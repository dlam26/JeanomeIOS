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
#import "Closet.h"
#import "ClosetItem.h"
#import "PictureDownloader.h"

@interface PictureTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, PictureDownloaderDelegate, UIScrollViewDelegate> {
    
    Closet *closet;
        
    NSMutableDictionary *imageDownloadsInProgress;
    UITableView *tableViewInsideCell;
}

@property(nonatomic,retain) Closet *closet;

@property(nonatomic,retain) IBOutlet UITableView *tableViewInsideCell;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void) _loadClosetImage:intoCell:(UITableViewCell *)cell;

- (void)startClosetPictureDownload:(NSDictionary *)info;

- (void) _logImageSize:(UIImage *)image atLine:(int)line;

//- (void) _logImageSize:(UIImage *)image atLine:(int)line;

-(void)pictureTap:(id)target;

@end
