//
//  ClosetViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Closet.h"
#import "SettingsViewController.h"
#import "PictureTableViewCell.h"

@class PictureTableViewCell;

@interface ClosetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    id fbResult;
    NSDictionary *fbResultDict;
    
    Closet *closet;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *followersLabel;
    IBOutlet UILabel *followingLabel;
    
    IBOutlet UILabel *facebookIdLabel;
    IBOutlet UIImageView *facebookProfilePic;
    
    IBOutlet UIImageView *statusIcon;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *pointsLabel;
    
    /* 
        1. Scroll up and down to see photos between categories 
        2. Scroll side to side to see photos within that category
     */
    IBOutlet UITableView *photoCategoryTableView;
}

@property(copy, nonatomic) id fbResult;
@property(retain, nonatomic) NSDictionary *fbResultDict;
@property(retain, nonatomic) Closet *closet;

//  http://iosstuff.wordpress.com/2011/06/29/adding-a-uitableview-inside-a-uitableviewcell/
@property(retain, nonatomic) IBOutlet PictureTableViewCell *tableViewCellWithTableView;


-(id)initWithFbResult:(id)result;

-(void)showSettingsPage;

@end
