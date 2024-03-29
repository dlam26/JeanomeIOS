//
//  AppDelegate.h
//  JeanomeIOS
//
//  Created by David Lam on 11/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotoViewController.h"
#import "JeanomeViewController.h"
#import "RootViewController.h"
#import "Constants.h"
#import "FBConnect.h"
#import "Jeanome.h"

@class JeanomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    Facebook *facebook;

    // Set in JeanomeViewController.m:257
    NSString *facebookId;             // The current logged in users facebook id
    NSDictionary *facebookLoginDict;  // Dict storing the logged in users info
    
    JeanomeViewController *jc;
}

@property(strong,nonatomic) UIWindow *window;
@property(strong,nonatomic) UINavigationController *navigationController;

@property(nonatomic,retain) Facebook *facebook;
@property(nonatomic,retain) NSString *facebookId;
@property(nonatomic,retain) NSDictionary *facebookLoginDict;

@property(nonatomic,retain) JeanomeViewController *jc;

@end
