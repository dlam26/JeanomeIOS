//
//  TakePhotoViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 11/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeanome.h"
#import "Constants.h"
#import "AFFeatherController.h"
#import "ASIFormDataRequest.h"
#import "FBRequest.h"

#import "AppDelegate.h"
#import "ClosetItemDetailsViewController.h"
#import "ClosetItem.h"


@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, AFFeatherDelegate, PhotoDetailsDelegate> 
{
    UIImageView *imageView;
    UIScrollView *scrollView;

    UIToolbar *myToolbar;
    UIImagePickerController *imgPicker;    
    
    // Used to pass a UIImage to Aviary
    UIImage *pickedImage;
    
    Jeanome *jeanome;
    
    // stores info about the new closet item that'll be created from the picked image
    ClosetItem *closetItem;
}


@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) UIImagePickerController *imgPicker;
@property(nonatomic, retain) UIImage *pickedImage;

@property(nonatomic, retain) Jeanome *jeanome;


@property(nonatomic, retain) ClosetItem *closetItem;

- (id)initWithJeanome:(Jeanome *)j;

- (void)displayFeatherWithImage:(UIImage *)image;


-(IBAction)showAviary:(id)sender;
-(IBAction)uploadPic:(id)sender;
-(IBAction)editDetails:(id)sender;



@end
