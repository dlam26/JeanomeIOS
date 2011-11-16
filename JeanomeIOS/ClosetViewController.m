//
//  ClosetViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetViewController.h"

@implementation ClosetViewController

@synthesize fbResult;

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
    NSLog(@"ClosetViewController.m:28   initWithFbResult()");

    self.fbResult = result;


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
    
    NSData *profilePicData = [NSData dataWithContentsOfURL:profilePicURL];
    
    UIImage *profilePicImage = [UIImage imageWithData:profilePicData];
    
    [facebookProfilePicView setImage:profilePicImage];
    

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

@end
