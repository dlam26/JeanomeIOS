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
    // NSLog(@"JeanomeViewController.m:72   viewWillAppear()");
}

- (void)viewDidAppear:(BOOL)animated
{
    // NSLog(@"JeanomeViewController.m:77   viewDidAppear()");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)startTakingPhoto:(id)sender
{    
    tpvc = [[TakePhotoViewController alloc] initWithFacebookRequest:fbRequest andResponse:fbResult andFacebookId:facebookId];
    
    tpvc.title = @"How's it look?";
    
    [self.navigationController pushViewController:tpvc animated:YES];
    
    [tpvc release];
}

-(IBAction)openCloset:(id)sender
{
    if(!self.fbResult) {
        // Need to be logged in, so redirect to it...
        
        NSLog(@"JeanomeViewController.m:85   openCloset()  need to be logged in... so clicking the button");
        
        [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {    
        // turned off at ClosetViewController.m:98
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSLog(@"JeanomeViewController.m:93  openCloset()   pushing ClosetViewController....");

        ClosetViewController *cvc = [[[ClosetViewController alloc] initWithFbResult:fbResult] autorelease];
        cvc.title = @"My Closet";
        [self.navigationController pushViewController:cvc animated:YES];
         
        //  11/22/2011  doing this via performSelectorInBackground()  
        //  Causing errors like these...  and makes it not show/display any of the JSON
        
        // 1148 Nov 22 17:01:33 dlam-macbook JeanomeIOS[3557]: *** __NSAutoreleaseNoPool(): Object 0x6025810 of class UIView autoreleased with no pool in place - just leaking
        // 1149 Nov 22 17:01:33 dlam-macbook JeanomeIOS[3557]: *** __NSAutoreleaseNoPool(): Object 0x60213e0 of class UILayoutContainerView autoreleased with no pool in place - just leaking
        //1150 Nov 22 17:01:33 dlam-macbook JeanomeIOS[3557]: *** __NSAutoreleaseNoPool(): Object 0x604e310 of class __NSArrayM autoreleased with no pool in place - just leaking
        // 1151 Nov 22 17:01:33 dlam-macbook JeanomeIOS[3557]: *** __NSAutoreleaseNoPool(): Object 0x4d4eee0 of class CABasicAnimation autoreleased with no pool in place - just leakin

        /*
        [self performSelectorInBackground:@selector(__initClosetView:) withObject:@"notused"];
         */
    }
}

-(void)__initClosetView:(NSString *)notused;
{
    closetViewController = [[[ClosetViewController alloc] initWithFbResult:fbResult] autorelease];
    
    closetViewController.title = @"Maaa Closet!";
    [self.navigationController pushViewController:closetViewController animated:YES];
    
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
