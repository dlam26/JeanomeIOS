//
//  JeanomeViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "TakePhotoViewController.h"
#import "SettingsViewController.h"

// wtf http://stackoverflow.com/questions/4091676/strange-behavior-with-compile-error-expected-specifier-qualifier-list-before-c
@class FacebookBrain;

@interface JeanomeViewController : UIViewController <FBRequestDelegate>
{    
    NSString *facebookId;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *logoutButton;
    IBOutlet UILabel *isSessionValidLabel;
    
}

@property(retain,nonatomic) NSString *facebookId;


-(IBAction)startTakingPhoto:(id)sender;
-(void)updateIsSessionValid;

@end
