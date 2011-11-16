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

@synthesize imageView, myToolbar, imgPicker, pickedImage, overlayViewController;

@synthesize fbRequest, fbResult, facebookId;

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
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.allowsEditing = NO;
        self.imgPicker.delegate = self;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;        
        //self.imgPicker.showsCameraControls = NO;
        
        self.overlayViewController = [[[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil] autorelease];
        
        
        //[self presentModalViewController:self.imgPicker animated:NO];

        [self presentViewController:imgPicker animated:NO completion:NULL];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.imageView = nil;
    self.overlayViewController = nil;
}

- (void)dealloc {
    
    [super dealloc];
    [overlayViewController release];
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
    NSLog(@"TakePhotoViewController.m:93  didFinishPickingMediaWithInfo()");
    
    // NSParameterAssert(image);
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"didFinishPickingMediaWithInfo() PICKED image size in bytes:%i",[UIImagePNGRepresentation(image) length]);
    

    [self setPickedImage:image];
    
    [self dismissModalViewControllerAnimated:NO];



    [self.imageView setImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"TakePhotoViewController.m:99  imagePickerControllerDidCancel()");

    
    [self dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:NO];
}


- (void)displayFeatherWithImage:(UIImage *)image
{
    NSLog(@"TakePhotoViewController.m:135   displayFeatherWithImage()");
    
    if (image) {
        //
        // Use the following two lines to include the meme tool if desired.
        //
        // NSArray *tools = [AFDefaultTools() arrayByAddingObject:kAFMeme];
        // AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image andTools:tools] autorelease];
        //
        AFFeatherController *featherController = [[[AFFeatherController alloc] initWithImage:image] autorelease];
        [featherController setDelegate:self];
        [self presentModalViewController:featherController animated:YES];
    } else {
        NSAssert(NO, @"AFFeatherController was passed a nil image");
    }
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
    NSLog(@"TakePhotoViewController.m:205  showAviary()");
    
    [self displayFeatherWithImage:[imageView image]];
}


/*
    Do a POST to http://myjeanome.com/closet/<user facebook id>
 
    Ex. how to get facebook user id in JSON  
 https://graph.facebook.com/me?fields=id&access_token=AAAAAAITEghMBAN7gLcD9XHm2exWasKkBJd3A1qMhZCOCQLSucM3P3LGYPEOoepSpJsKkK9fP5yWZCzT8XGWcYOM79X3yB01UZCW1QAOaQZDZD
 
 */ 
-(IBAction)uploadPic:(id)sender
{    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    // Get the access token
    NSString *accessToken = [[delegate facebook] accessToken];
    
    // important!  needs to have trailing slash or Django complains about 
    // the APPEND_SLASH setting not being set...
    NSURL *postURL = [NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] stringForKey:SETTING_JEANOME_URL] stringByAppendingFormat:@"/closet/%@/", self.facebookId]];
  
    //NSURL *postURL = [NSURL URLWithString:@"http://10.0.1.60:8000/testing/"];

    NSHTTPCookie *facebookIdCookie = [self __createUploadCookie:@"userID" withValue:self.facebookId];    
    NSHTTPCookie *accessTokenCookie = [self __createUploadCookie:@"accessToken" withValue:accessToken];
    
    
    NSLog(@"TakePhotoViewController.m:229   postURL: %@   facebookIdCookie: %@    accessTokenCookie: %@", postURL, facebookIdCookie, accessTokenCookie);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:postURL];
    
    // views.py:203   request.POST: {u'category': [u''], u'note': [u'22'], u'brand': [u'222'], u'do_add_item': [u'Submit'], u'value': [u'222']}
    
    [request setPostValue:@"" forKey:@"category"];
    [request setPostValue:@"Here is a note on TakePhotoViewController.m:234" forKey:@"note"];
    [request setPostValue:@"some brand" forKey:@"brand"];
    [request setPostValue:@"Submit" forKey:@"do_add_item"];
    [request setPostValue:@"66.66" forKey:@"value"];
    
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

@end
