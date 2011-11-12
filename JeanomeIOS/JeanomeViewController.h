//
//  JeanomeViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookBrain.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "TakePhotoViewController.h"

@interface JeanomeViewController : UIViewController
{    
    FacebookBrain *fb;
    
    IBOutlet UIButton *logoutButton;
    IBOutlet UILabel *isSessionValidLabel;
}

@property(retain,nonatomic) FacebookBrain *fb;

-(IBAction)startTakingPhoto:(id)sender;
-(void)updateIsSessionValid;

@end
