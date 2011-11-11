//
//  JeanomeViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "JeanomeViewController.h"

@implementation JeanomeViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        NSLog(@"JeanomeViewController.m:21   initWithNibName()");

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
    NSLog(@"JeanomeViewController.m:38   viewDidLoad()");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // self.title = JEANOME_TITLE;
    
    /*
    #warning UIBarMetrics only in iOS 5.0
     
     // set a picture for the navbar title
     
     UIImage *logo = [UIImage imageNamed:@"logo.png"];
     
    [self.navigationController.navigationBar setBackgroundImage:logo forBarMetrics:UIBarMetricsDefault];
    */
     
    // [self startTakingPhoto:nil];
    
    
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
    NSLog(@"JeanomeViewController.m:72   viewWillAppear()");
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"JeanomeViewController.m:77   viewDidAppear()");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)startTakingPhoto:(id)sender
{    
    TakePhotoViewController *tpvc = [[TakePhotoViewController alloc] init];
    
    tpvc.title = @"How's it look?";
    
    [self.navigationController pushViewController:tpvc animated:YES];
}


/*
    https://developers.facebook.com/docs/mobile/ios/build/#linktoapp
 */
-(IBAction)facebookLogin:(id)sender
{    
    NSLog(@"JeanomeViewController.m:83   facebookLogin()");
    
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
    
    logoutButton.hidden = NO;    
    [self updateIsSessionValid];
}

-(IBAction)facebookLogout:(id)sender
{
    NSLog(@"JeanomeViewController.m:107   facebookLogout()");
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [[delegate facebook] logout:delegate];
    [self updateIsSessionValid];
}


-(void)updateIsSessionValid
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    BOOL isSessionValid = [[delegate facebook] isSessionValid];
                           
   //  NSLog(@"JeanomeViewController.m:118   updateIsSessionValid()!  %@", isSessionValid ? @"YES" : @"NO");

    isSessionValidLabel.text = [NSString stringWithFormat:@"Is session valid: %@", isSessionValid ? @"YES" : @"NO"];
    
    logoutButton.hidden = !isSessionValid;
}

@end
