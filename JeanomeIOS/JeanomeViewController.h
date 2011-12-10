//
//  JeanomeViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Jeanome.h"
#import "AppDelegate.h"

#import "Constants.h"
#import "TakePhotoViewController.h"
#import "SettingsViewController.h"
#import "ClosetViewController.h"

// http://stackoverflow.com/questions/146986/what-defines-are-set-up-by-xcode-when-compiling-for-iphone
#include "TargetConditionals.h"


// wtf http://stackoverflow.com/questions/4091676/strange-behavior-with-compile-error-expected-specifier-qualifier-list-before-c
@class TakePhotoViewController;

@interface JeanomeViewController : UIViewController <FBRequestDelegate>
{    
    NSString *facebookId;
    FBRequest *fbRequest;
    id fbResult;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UINavigationBar *theNavigationBar;
    
    ClosetViewController *closetViewController;
    TakePhotoViewController *tpvc;    

    Jeanome *jeanome;  // set in request:(FBRequest *) didLoad
}

@property(retain,nonatomic) NSString *facebookId;
@property(retain,nonatomic) FBRequest *fbRequest;
@property(copy, nonatomic) id fbResult;
@property(retain,nonatomic) IBOutlet UINavigationBar *theNavigationBar;

@property(retain,nonatomic) Jeanome *jeanome;

-(IBAction)startTakingPhoto:(id)sender;
-(IBAction)openCloset:(id)sender;
//-(void)__initClosetView;
-(void)__initClosetView:(NSString *)notused;

-(IBAction)facebookLogout:(id)sender;

@end
