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

@interface ClosetViewController : UIViewController {
    
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
    
    IBOutlet UIScrollView *imageScrollView;
}

@property(copy, nonatomic) id fbResult;
@property(retain, nonatomic) NSDictionary *fbResultDict;
@property(retain, nonatomic) Closet *closet;


-(id)initWithFbResult:(id)result;

-(void)showSettingsPage;

@end
