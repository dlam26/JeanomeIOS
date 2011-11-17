//
//  ClosetViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetViewController.h"

@implementation ClosetViewController

@synthesize fbResult, fbResultDict, closet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithFbResult:(id)result
{
    self.fbResult = result;
    self.fbResultDict = result;

    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"transparent_settings_gear_icon" ofType:@"png"]] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsPage)];    

    self.navigationItem.rightBarButtonItem = settingsBarButton;
    
    NSString *closetUrlString = [NSString stringWithFormat:@"http://10.0.1.60:8000/api/closet/%@/", [self.fbResultDict objectForKey:@"id"]];

    NSString *closetJSON = [NSString stringWithContentsOfURL:[NSURL URLWithString:closetUrlString] encoding:NSUTF8StringEncoding error:nil];

    self.closet = [[Closet alloc] initWithJSON:closetJSON];
    
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
    
    NSDictionary *fbDict = fbResult;
    NSString *facebookId = [fbDict objectForKey:@"id"];
    facebookIdLabel.text = facebookId;
    
    
    // get the facebook image 
    // from... http://graph.facebook.com/1365147631/picture?type=large
    
    NSURL *profilePicURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", facebookId]];
    
    UIImage *profilePicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:profilePicURL]];
    
    [facebookProfilePic setImage:profilePicImage];
    [nameLabel setText:[self.closet getName]];
    [followersLabel setText:[NSString stringWithFormat:@"%@ Followers", [self.closet getFollowers]]];
    [followingLabel setText:[NSString stringWithFormat:@"%@ Following", [self.closet getFollowing]]];
    [statusLabel setText:[self.closet getStatus]];
    [pointsLabel setText:[NSString stringWithFormat:@"%@ pts.", [self.closet getPoints]]];
    
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

/*
 Attached to nav bar item as its selector on front page in AppDelegate.m:32
 */
-(void)showSettingsPage
{    
    SettingsViewController *svc = [[[SettingsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:svc animated:YES];    
}

@end