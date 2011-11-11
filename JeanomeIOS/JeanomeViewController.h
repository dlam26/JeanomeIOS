//
//  JeanomeViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Constants.h"
#import "TakePhotoViewController.h"

@interface JeanomeViewController : UIViewController
{
    IBOutlet UIButton *logoutButton;
    IBOutlet UILabel *isSessionValidLabel;
}



-(IBAction)startTakingPhoto:(id)sender;
-(void)updateIsSessionValid;

@end
