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
@synthesize theNavigationBar;
@synthesize jeanome;

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
    // NSLog(@"JeanomeViewController.m:38   viewDidLoad()   facebookId: %@", facebookId);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    theNavigationBar.tintColor = [Jeanome getJeanomeColor]; 
    theNavigationBar.topItem.titleView = [Jeanome getJeanomeLogoImageView];
    
    
    /*
    theNavigationBar = [[UINavigationBar alloc] initWithFrame:[Jeanome getNavigationBarFrame]];

    UINavigationItem *item = [[UINavigationItem alloc] init];
    [theNavigationBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:self.theNavigationBar];
    [item release];
    */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
     //NSLog(@"JeanomeViewController.m:59   viewWillAppear()");
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    BOOL isSessionValid = [[delegate facebook] isSessionValid];
    NSLog(@"JeanomeViewController.m:64   viewDidAppear()  isSessionValid: %d", isSessionValid);
    */
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
    tpvc = [[TakePhotoViewController alloc] initWithJeanome:jeanome];
    
    // tpvc.title = @"How's it look?";
    
    [self.navigationController pushViewController:tpvc animated:YES];
    [tpvc release];
//#endif
}

-(IBAction)openCloset:(id)sender
{
    if(!self.fbResult) {
        // Need to be logged in, so redirect to it...
        
        //NSLog(@"JeanomeViewController.m:85   openCloset()  need to be logged in... so clicking the button");
        
        [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        // Original version, kinda stalls for a sec while it loads the JSON from myjeanome.com/api
        ClosetViewController *cvc = [[[ClosetViewController alloc] initWithFbResult:fbResult] autorelease];
        cvc.title = @"My Closet";
        [self.navigationController pushViewController:cvc animated:YES];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
        // Asynchronous closet load,  but causes problems loading images initially 
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

        // NOTE- this will perform a request which when done, will call 
        // the facebook delegate method request:didLoad() below which 
        // pushes root view controller
        
        [[delegate facebook] authorize:nil];
        
        /*        
        //  Show activity indicator while loading... may need to do in block
        // 
        UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        av.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 100, 100);
        av.tag  = 1;
        [self.view addSubview:av];
        [av startAnimating];
        */
        
    }
    else {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObject:@"id,name" forKey:@"fields"];
        // Get the users facebook id
        [[delegate facebook] requestWithGraphPath:@"me" andParams:paramDict andDelegate:self]; 
        
        NSLog(@"JeanomeViewController.m:192  facebookLogin() already logged in to facebook... so gogogogo!");
//        [delegate fbDidLogin];
    }
    
}

-(IBAction)facebookLogout:(id)sender
{
    // NSLog(@"JeanomeViewController.m:107   facebookLogout()");
    
//    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
//    [[delegate facebook] logout:delegate];
    
    // loginButton.hidden = NO;
    
    facebookId = nil;
    fbRequest = nil;
    fbResult = nil;
}



#pragma mark - <FBRequestDelegate> protocol

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request;
{
    // NSLog(@"JeanomeViewController.m:219   requestLoading()");
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    // NSLog(@"JeanomeViewController.m:227  didReceiveResponse()");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    // NSLog(@"JeanomeViewController.m:235  didFailWithError()  %@", error);    
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
    NSLog(@"JeanomeViewController.m:247  FBRequest  didLoad()");
    
    NSDictionary *dict = result;
    
    self.facebookId = [dict objectForKey:@"id"];
    self.fbRequest = request;
    self.fbResult = result;
    
    //  12/4/2011  Changing screens to follow the mockup, 
    //             so store the login info so i can retrieve it later    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.facebookId = [dict objectForKey:@"id"];
    delegate.facebookLoginDict = result;
 
    UINavigationController *newNav = [[UINavigationController alloc] init];
    newNav.navigationBar.tintColor = [Jeanome getJeanomeColor];
    
    //  12/7/2011  Create a Jeanome object to hold facebook session info
    jeanome = [[Jeanome alloc] initWithFacebook:self.facebookId andDict:self.fbResult];
    
    RootViewController *rvc = [[RootViewController alloc] initWithJeanome:jeanome];
    [newNav pushViewController:rvc animated:NO];
    
    delegate.window.rootViewController = newNav;
    
    [rvc release]; [newNav release];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    //NSLog(@"JeanomeViewController.m:282  didLoadRawResponse()");

}

@end