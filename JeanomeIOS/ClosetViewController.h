//
//  ClosetViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosetViewController : UIViewController {
    
    id fbResult;
    
    IBOutlet UILabel *facebookIdLabel;
    IBOutlet UIImageView *facebookProfilePicView;
}

@property(copy, nonatomic) id fbResult;

-(id)initWithFbResult:(id)result;



@end
