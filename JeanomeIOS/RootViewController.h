//
//  RootViewController.h
//  JeanomeIOS
//
//  Created by david lam on 12/4/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FBConnect.h"

#import "Jeanome.h"
#import "AppDelegate.h"
#import "TakePhotoViewController.h"
#import "ClosetWebViewController.h"
#import "Constants.h"



@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FBSessionDelegate, FBRequestDelegate> {
    
    UITableView *rootTableView;    
    UIImageView *staticImageView;
    
    UIButton *facebookLoginButton;
    
    NSDictionary *theNewClosetItemDict;
    
    Jeanome *jeanome;
}


@property (strong,nonatomic) UITableView *rootTableView;
@property (nonatomic,retain) UIImageView *staticImageView;
@property (nonatomic,retain) UIButton *facebookLoginButton;
@property (nonatomic,retain) NSDictionary *theNewClosetItemDict;
@property (nonatomic,retain) Jeanome *jeanome;


- (id)initWithJeanome:(Jeanome *)j;
- (void)facebookLogin;
- (void)logout;

@end
