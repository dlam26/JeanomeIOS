//
//  TakePhotoViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFFeatherController.h"
#import "ASIFormDataRequest.h"
#import "FBRequest.h"

#import "AppDelegate.h"
#import "OverlayViewController.h"

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AFFeatherDelegate> 
{
    UIImageView *imageView;
    UIToolbar *myToolbar;
    UIImagePickerController *imgPicker;
    
    UIImage *pickedImage;
    
    OverlayViewController *overlayViewController;
    
    NSString *facebookId;   // the facebook id of the current user

}


@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) OverlayViewController *overlayViewController;
@property (nonatomic, retain) UIImage *pickedImage;
@property (nonatomic, retain) NSString *facebookId;


- (void)displayFeatherWithImage:(UIImage *)image;

-(NSHTTPCookie *)__createUploadCookie:(NSString *)name 
                            withValue:(NSString *)value;



-(IBAction)uploadPic:(id)sender;

@end
