//
//  TakePhotoViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFFeatherController.h"
#import "OverlayViewController.h"

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AFFeatherDelegate> 
{
    UIImageView *imageView;
    UIToolbar *myToolbar;
    UIImagePickerController *imgPicker;
    
    UIImage *pickedImage;
    
    OverlayViewController *overlayViewController;
}


@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, retain) UIImagePickerController *imgPicker;

@property (nonatomic, retain) OverlayViewController *overlayViewController;

@property (nonatomic, retain) UIImage *pickedImage;


- (void)displayFeatherWithImage:(UIImage *)image;

@end
