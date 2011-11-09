//
//  TakePhotoViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//


/* 
 To use an image picker controller containing its default controls, perform these steps:
 
 Verify that the device is capable of picking content from the desired source. Do this calling the isSourceTypeAvailable: class method, providing a constant from the “UIImagePickerControllerSourceType” enum.
 Check which media types are available, for the source type you’re using, by calling the availableMediaTypesForSourceType: class method. This lets you distinguish between a camera that can be used for video recording and one that can be used only for still images.
 Tell the image picker controller to adjust the UI according to the media types you want to make available—still images, movies, or both—by setting the mediaTypes property.
 Present the user interface by calling the presentViewController:animated:completion: method of the currently active view controller, passing your configured image picker controller as the new view controller.
 On iPad, present the user interface using a popover. Doing so is valid only if the sourceType property of the image picker controller is set to UIImagePickerControllerSourceTypeCamera. To use a popover controller, use the methods described in “Presenting and Dismissing the Popover” in UIPopoverController Class Reference.
 
 When the user taps a button to pick a newly-captured or saved image or movie, or cancels the operation, dismiss the image picker using your delegate object. For newly-captured media, your delegate can then save it to the Camera Roll on the device. For previously-saved media, your delegate can then use the image data according to the purpose of your app.
 */


#import "TakePhotoViewController.h"

@implementation TakePhotoViewController

@synthesize imageView, myToolbar, imgPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSLog(@"TakePhotoViewController.m:54  viewDidLoad()");
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.allowsEditing = NO;
        self.imgPicker.delegate = self;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:self.imgPicker animated:NO];

        // [self presentViewController:imagePickerController animated:NO completion:NULL];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"TakePhotoViewController.m:93  didFinishPickingMediaWithInfo()");

    [self dismissModalViewControllerAnimated:YES];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    [self.imageView setImage:image];
    
    
    
 //   AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
    
//    [featherController setDelegate:self];
    
//    [self presentModalViewController:featherController animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"TakePhotoViewController.m:99  imagePickerControllerDidCancel()");

    
    [self dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:NO];
}


#pragma mark - Aviary Mobile Feather SDK

// TODO
- (void)displayEditorForImage:(UIImage *)image
{
    
    AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
    [featherController setDelegate:self];
    [self presentModalViewController:featherController animated:YES];
}

- (void)feather:(AFFeatherController *)featherController finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    
    NSLog(@"TakePhotoViewController.m:129   finishedWithImage()");
}

- (void)featherCanceled:(AFFeatherController *)featherController
{
    // Handle cancelation here
    
    NSLog(@"TakePhotoViewController.m:136   featherCancelled()");
}


@end
