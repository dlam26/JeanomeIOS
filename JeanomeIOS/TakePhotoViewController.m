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

@synthesize imageView, scrollView, myToolbar, imgPicker, pickedImage, overlayViewController;
@synthesize fbRequest, fbResult, facebookId;
@synthesize closetItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithFacebookRequest:(FBRequest *)req 
                  andResponse:(id)result
                andFacebookId:(NSString *)fbid {
    self = [super init];
    if (self) {
        self.fbRequest = req;
        self.fbResult = result;
        self.facebookId = fbid;
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
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;        
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
        
        NSLog(@"TakePhotoViewController.m:91   No camera available (probably on simulator, so picking from photo library");              

        //[self presentViewController:imgPicker animated:NO completion:NULL];
        
        [self presentModalViewController:imgPicker animated:YES];
    }
    
    // #3 Setup navigation bar with multiple buttons
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 185, 44.01)];
    toolbar.tintColor = [AppDelegate getJeanomeColor];
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    [toolbar release];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.imageView = nil;
//    self.overlayViewController = nil;
}

- (void)dealloc {
    
    [super dealloc];
//    [overlayViewController release];
    [imageView release];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self pickedImage]) {
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
    Called after you take a picture with the camera and hit 'Use'
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"TakePhotoViewController.m:192  didFinishPickingMediaWithInfo()");
    
    // NSParameterAssert(image);
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"didFinishPickingMediaWithInfo() PICKED image size in bytes:%i",[UIImagePNGRepresentation(image) length]);
    

    [self setPickedImage:image];
    [self dismissModalViewControllerAnimated:NO];
    [self.imageView setImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"TakePhotoViewController.m:210  imagePickerControllerDidCancel()");

    
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
    NSLog(@"TakePhotoViewController.m:238   displayFeatherWithImage()");
    
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
    NSLog(@"TakePhotoViewController.m:214   scrollViewDidScroll: %@", NSStringFromCGPoint(sv.contentOffset));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
    
    NSLog(@"TakePhotoViewController.m:129   finishedWithImage()");
    
    imageView.image = image;
}

- (void)featherCanceled:(AFFeatherController *)featherController
{
    // Handle cancelation here
    
    NSLog(@"TakePhotoViewController.m:136   featherCancelled()");
}


#pragma mark - IBAction's

-(IBAction)showAviary:(id)sender
{
    [self displayFeatherWithImage:[imageView image]];
}


/*
    Do a POST to http://myjeanome.com/closet/<user facebook id>
 
    Ex. how to get facebook user id in JSON  
 https://graph.facebook.com/me?fields=id&access_token=AAAAAAITEghMBAN7gLcD9XHm2exWasKkBJd3A1qMhZCOCQLSucM3P3LGYPEOoepSpJsKkK9fP5yWZCzT8XGWcYOM79X3yB01UZCW1QAOaQZDZD
 
    FIXME,  need to be logged into facebook for this to work  (it uses self.facebookId)
 
 */ 
-(IBAction)uploadPic:(id)sender
{    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    // Get the access token
    NSString *accessToken = [[delegate facebook] accessToken];
    
    // important!  needs to have trailing slash or Django complains about 
    // the APPEND_SLASH setting not being set...
    NSURL *postURL = [NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] stringForKey:SETTING_JEANOME_URL] stringByAppendingFormat:@"/closet/add/"]];
  
    NSHTTPCookie *facebookIdCookie = [self __createUploadCookie:@"userID" withValue:self.facebookId];    
    NSHTTPCookie *accessTokenCookie = [self __createUploadCookie:@"accessToken" withValue:accessToken];
        
    NSLog(@"TakePhotoViewController.m:348   postURL: %@ ", postURL);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:postURL];
    
    // views.py:203   request.POST: {u'category': [u''], u'note': [u'22'], u'brand': [u'222'], u'do_add_item': [u'Submit'], u'value': [u'222']}

    [request setPostValue:closetItem.brand forKey:@"brand"];
    [request setPostValue:closetItem.category forKey:@"category"];
    [request setPostValue:closetItem.value forKey:@"value"];
    [request setPostValue:closetItem.note forKey:@"note"];
    [request setPostValue:@"Submit" forKey:@"do_add_item"];   // wtf is this lol
    
    
    // 11/15/2011   THIS ACTUALLY WORKS TO SEND STUFF!!!
    // NSData *someData = [NSData dataWithBytes:"asdf" length:strlen("asdf")];
    // [request addData:someData forKey:@"picture"];
    
    // IMPORTANT:  The edited photo after Aviary is set to imageView.image in 
    
    [request addData:UIImageJPEGRepresentation(imageView.image, 1.0) forKey:@"picture"];
    
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithObjects:facebookIdCookie, accessTokenCookie, nil]];    
    
    /*
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
     */
    
	[request startSynchronous];
    
    // TODO set network activity indicator
}



/*
    Create a cookie because the python code in closet/views.py fetches info from it
 
    http://allseeing-i.com/ASIHTTPRequest/How-to-use#persistent_cookies
 
    also see ASIHTTPRequestsTests.m in its source folder
 */
-(NSHTTPCookie *)__createUploadCookie:(NSString *)name 
                      withValue:(NSString *)value
{
    NSDictionary *cookieProperties = [[[NSMutableDictionary alloc] init] autorelease];
    
    // How to make a cookie from the test file
    [cookieProperties setValue:value forKey:NSHTTPCookieValue];
    [cookieProperties setValue:name forKey:NSHTTPCookieName];
    [cookieProperties setValue:@"myjeanome.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*4] forKey:NSHTTPCookieExpires];
    [cookieProperties setValue:@"/JeanomeIOS" forKey:NSHTTPCookiePath];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    // NSLog(@"__createUploadCookie():  %@", cookie);
    
    return cookie;
}


-(IBAction)savePicToCameraRoll:(id)sender
{
    NSLog(@"TakePhotoViewController.m:325   savePicToCameraRoll()");
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(self.pickedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                       message:@"Image saved to Photo Album." 
                                      delegate:self cancelButtonTitle:@"Ok" 
                             otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

/*
    Selector assigned to UIToolbar button in viewDidLoad() on line 136 above ^^
 */
-(IBAction)editDetails:(id)sender
{
    ClosetItemDetailsViewController *c = [[ClosetItemDetailsViewController alloc] initWithClosetItem:self.closetItem];
    
    c.title = @"Item Details";
    c.delegate = self;    
    [[self navigationController] pushViewController:c animated:YES];    
    [c release];
}

#pragma mark - <PhotoDetailsDelegate>

/*
    see ClosetItemDetailsViewController.m:93
 */ 
-(void)saveDetails:(NSDictionary *)details
{
    NSLog(@"TakePhotoViewController.m:452   saveDetails() <PhotoDetailsDelegate> method!" );
    
    self.closetItem = [[ClosetItem alloc] initWithImageDict:details andId:nil];
}

@end
