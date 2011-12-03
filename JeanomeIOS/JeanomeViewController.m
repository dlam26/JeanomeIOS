//
//  JeanomeViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "JeanomeViewController.h"

@implementation JeanomeViewController

@synthesize facebookId, fbResult, fbRequest;

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
    // NSLog(@"JeanomeViewController.m:38   viewDidLoad()");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     
    
    logoutButton.hidden = YES;
    [self updateIsSessionValid];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//     NSLog(@"JeanomeViewController.m:72   viewWillAppear()");
}

- (void)viewDidAppear:(BOOL)animated
{
///     NSLog(@"JeanomeViewController.m:77   viewDidAppear()");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)startTakingPhoto:(id)sender
{   
//#if (TARGET_IPHONE_SIMULATOR)
    
//#else 
    tpvc = [[TakePhotoViewController alloc] initWithFacebookRequest:fbRequest andResponse:fbResult andFacebookId:facebookId];
    
    // tpvc.title = @"How's it look?";
    
    [self.navigationController pushViewController:tpvc animated:YES];
    [tpvc release];
//#endif
}

-(IBAction)openCloset:(id)sender
{
    if(!self.fbResult) {
        // Need to be logged in, so redirect to it...
        
        NSLog(@"JeanomeViewController.m:85   openCloset()  need to be logged in... so clicking the button");
        
        [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        // Original version, kinda stalls for a sec while it loads the JSON from myjeanome.com/api
        ClosetViewController *cvc = [[[ClosetViewController alloc] initWithFbResult:fbResult] autorelease];
        cvc.title = @"My Closet";
        [self.navigationController pushViewController:cvc animated:YES];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
        // Asynchrnous closet load,  but causes problems loading images initially 
        // in PictureTableViewCell in the table view image thingy
//        [self performSelectorInBackground:@selector(__initClosetView:) withObject:@"notused"];
        
        

    }
}

/*
    Used via performSelectorInBackground() in openCloset() above 
 
    IMPORTANT   Threads need to set up their own autorelease pool!  See "Thread Programming Guide"
 
 http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/Multithreading/CreatingThreads/CreatingThreads.html%23//apple_ref/doc/uid/10000057i-CH15-SW8
 */
-(void)__initClosetView:(NSString *)notused;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // turned off at ClosetViewController.m:98
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
    
    closetViewController = [[[ClosetViewController alloc] initWithFbResult:fbResult] autorelease];
    
    [self.navigationController pushViewController:closetViewController animated:YES];

    [pool release];
}


/*
    https://developers.facebook.com/docs/mobile/ios/build/#linktoapp
 */
-(IBAction)facebookLogin:(id)sender
{    
    // NSLog(@"JeanomeViewController.m:83   facebookLogin()");
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    

    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:nil];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObject:@"id" forKey:@"fields"];
    // Get the users facebook id
    [[delegate facebook] requestWithGraphPath:@"me" andParams:paramDict andDelegate:self]; 

//    loginButton.hidden  = YES;
    logoutButton.hidden = NO;
    
    [self updateIsSessionValid];
}

-(IBAction)facebookLogout:(id)sender
{
    // NSLog(@"JeanomeViewController.m:107   facebookLogout()");
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [[delegate facebook] logout:delegate];
    
    // loginButton.hidden = NO;
    logoutButton.hidden = YES;
    
    facebookId = nil;
    fbRequest = nil;
    fbResult = nil;
    
    [self updateIsSessionValid];
}

-(IBAction)printFacebookId:(id)sender
{
    NSLog(@"JeanomeViewController.m:135   printFacebookId: %@", self.facebookId);
    
    // [fb retain];   //why it's crashing when u click on it twice is beyond me
}




-(void)updateIsSessionValid
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    BOOL isSessionValid = [[delegate facebook] isSessionValid];
                           
   //  NSLog(@"JeanomeViewController.m:118   updateIsSessionValid()!  %@", isSessionValid ? @"YES" : @"NO");

    isSessionValidLabel.text = [NSString stringWithFormat:@"Is session valid: %@", isSessionValid ? @"YES" : @"NO"];
    
    logoutButton.hidden = !isSessionValid;
}

#pragma mark - <FBRequestDelegate> protocol

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request;
{
    
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"JeanomeViewController.m:151  didReceiveResponse()");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
//    NSLog(@"JeanomeViewController.m:160  didFailWithError()  %@", error);    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    // NSLog(@"JeanomeViewController.m:163  didLoad()");
    
    NSDictionary *dict = result;
    
    self.facebookId = [dict objectForKey:@"id"];
    self.fbRequest = request;
    self.fbResult = result;
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
//    NSLog(@"JeanomeViewController.m:173  didLoadRawResponse()");

}


@end
