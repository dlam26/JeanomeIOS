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

@synthesize imageView, scrollView, imgPicker, pickedImage;

@synthesize closetItem;
@synthesize jeanome;


- (void)dealloc {
    [self.closetItem release];
    [imageView release];
    [super dealloc];
}

- (id)initWithJeanome:(Jeanome *)j {
    self = [super init];
    if (self) {
        DebugLog();	
        self.jeanome = j;
        self.closetItem = [[ClosetItem alloc] init];
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

    // NSLog(@"TakePhotoViewController.m:54  viewDidLoad()");
    
    /*
    NSLog(@"Is there a camera? %d", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
    NSLog(@"Is there a photo library? %d", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]);
    NSLog(@"Is there a saved photos album? %d", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
    */
    
    // #1  setup scrollView so you can pan/pinch around the image
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 3.0;        
    scrollView.delegate = self;                
    [scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];

    // #2  setup the image picker!
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = NO;
    //imgPicker.showsCameraControls = NO;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;        

        [self presentViewController:imgPicker animated:NO completion:NULL];        
    }
    else {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        //[self presentViewController:imgPicker animated:NO completion:NULL];
        
        [self presentModalViewController:imgPicker animated:YES];
    }
    
    // #3 Setup navigation bar with multiple buttons    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 185, 44.01)];
    toolbar.tintColor = [Jeanome getJeanomeColor];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *b;
    
    // create a spacer
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:b];
    [b release];

    // create a "edit" button that'll bring up Aviary again
    b = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showAviary:)];
    b.style = UIBarButtonItemStyleBordered;
    [buttons addObject:b];
    [b release];
    
    // create another spacer
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:b];
    [b release];
    
    b = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:UIBarButtonItemStyleBordered target:self action:@selector(editDetails:)];
    [buttons addObject:b];
    [b release];
    
    // create a upload button with the system save icon!
    b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(uploadPic:)];    
    b.style = UIBarButtonItemStyleBordered;
    [buttons addObject:b];
    [b release];

    [toolbar setItems:buttons animated:NO];
    
    [buttons release];
    
    UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.navigationItem.rightBarButtonItem = rb;
    
    [toolbar release]; [rb release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self pickedImage]) {
        [self displayFeatherWithImage:[self pickedImage]];
        [self setPickedImage:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UIImagePickerControllerDelegate

/*
    Called after selecting a picture in the photo select page
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // NSLog(@"TakePhotoViewController.m:192  didFinishPickingMediaWithInfo()");
    
    // NSParameterAssert(image);
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // NSLog(@"didFinishPickingMediaWithInfo() PICKED image size in bytes:%i",[UIImagePNGRepresentation(image) length]);
    
    [self setPickedImage:image]; // used for aviary 
    [self dismissModalViewControllerAnimated:NO];
    closetItem.image = image;
    closetItem.userId = jeanome.facebookId;
    imageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DebugLog();

    [self dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:NO];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}



- (void)displayFeatherWithImage:(UIImage *)image
{
    //NSLog(@"TakePhotoViewController.m:238   displayFeatherWithImage()  closetItem retain count: %u", [closetItem retainCount]);
    
    if (image) {
        //
        // Use the following two lines to include the meme tool if desired.
        //
        // NSArray *tools = [AFDefaultTools() arrayByAddingObject:kAFMeme];
        // AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image andTools:tools] autorelease];
        //
        AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
        [featherController setDelegate:self];
        
        //  11/29/2011   Set animated to null, since you see TakePhotoViewController.xlb for like 
        //               a half a second while its animating to Aviary
        [self presentModalViewController:featherController animated:NO];
    } else {
        NSAssert(NO, @"AFFeatherController was passed a nil image");
    }
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// <UIScrollViewDelegate> 
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    DebugLog(@" sv.contentOffset: %@", NSStringFromCGPoint(sv.contentOffset));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


#pragma mark - Aviary Mobile Feather SDK

// TODO
/*
- (void)displayEditorForImage:(UIImage *)image
{
    NSLog(@"TakePhotoViewController.m:127   displayEditorForImage()!");
    
    AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
    [featherController setDelegate:self];
    [self presentModalViewController:featherController animated:YES];
}
 */

/*
    Called after you hit save from the Aviary photo editor
 */
- (void)feather:(AFFeatherController *)featherController finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    DebugLog(@"image size in bytes:%i ",[UIImagePNGRepresentation(image) length]);

    closetItem.image = image;
    closetItem.userId = jeanome.facebookId;
    
    imageView.image = image;
    
    [self editDetails:nil];
}

- (void)featherCanceled:(AFFeatherController *)featherController
{
    DebugLog();
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - IBAction's

-(IBAction)showAviary:(id)sender
{
    [self displayFeatherWithImage:[imageView image]];
}


// Called from UIToolbar on line 123
-(IBAction)uploadPic:(id)sender
{    
    closetItem.userId = jeanome.facebookId;
    [Jeanome uploadToJeanome:closetItem withImage:imageView.image];
}



/*
    Selector assigned to UIToolbar button in viewDidLoad() on line 136 above ^^
 */
-(IBAction)editDetails:(id)sender
{
    if(!closetItem) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Doh!" 
                                           message:@"Can't edit details because self.closetItem was nil." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];        
        [alert show];
        [alert release];
    }
    else {

        closetItem.userId = jeanome.facebookId;
        
        ClosetItemDetailsViewController *c = [[ClosetItemDetailsViewController alloc] initWithClosetItem:closetItem andJeanome:jeanome];
        c.title = @"Item Details";
        c.delegate = self;    
        [[self navigationController] pushViewController:c animated:YES];    
        [c release];
    }           
}

#pragma mark - <PhotoDetailsDelegate>

/*
    see ClosetItemDetailsViewController.m:93
 */ 
-(void)saveDetails:(NSDictionary *)details
{
    DebugLog(@"In saveDetails() <PhotoDetailsDelegate> method!" );
    
    ClosetItem *c = [[ClosetItem alloc] initWithImageDict:details andId:nil];
    closetItem = c;
    
    // XXX    DONT RELEASE OR AUTORELEASE c HERE,  closetItem IS NOW POINTING TO IT!!!
}

/*
    Used to show Aviary in case you hit back while editing item details!
 */
-(void)openAviary
{
    DebugLog();
    [self showAviary:nil];
}

@end
