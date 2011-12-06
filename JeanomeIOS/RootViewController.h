//
//  RootViewController.h
//  JeanomeIOS
//
//  Created by david lam on 12/4/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Jeanome.h"
#import "AppDelegate.h"
#import "TakePhotoViewController.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    
    UINavigationController *nav;    
    UITableView *rootTableView;
}

@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UITableView *rootTableView;

@end
