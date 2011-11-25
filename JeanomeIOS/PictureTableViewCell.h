//
//  PictureTableViewCell.h
//  JeanomeIOS
//
//  Created by david lam on 11/22/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    
    NSDictionary *items;
    NSDecimalNumber *itemcount;
}

@property(nonatomic,retain) IBOutlet UITableView *tableViewInsideCell;
@property(nonatomic,retain) NSDictionary *items;  // set from...  ClosetViewController.m:157
@property(nonatomic,retain) NSDecimalNumber *itemcount;

- (void) _loadClosetImage:intoCell:(UITableViewCell *)cell;
@end
