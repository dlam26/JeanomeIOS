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
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UINavigationController *nav;
}
    
    
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;

@end
