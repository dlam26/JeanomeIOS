//
//  RootViewController.m
//  JeanomeIOS
//
//  Created by david lam on 12/4/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize rootTableView, staticImageView, jeanome, facebookLoginButton;

// old
- (id)initWithJeanome:(Jeanome *)j
{
    self = [super init];
    if (self) {
        self.jeanome = j;
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

- (void)loadView 
{
    DebugLog();    
 
    CGRect wholeScreenRect  = [[UIScreen mainScreen] bounds];
//    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];    
//    CGRect hardcodedWholeScreenRect = CGRectMake(0, 0, 320, 480);
    
    CGRect frame = wholeScreenRect;
    
//    NSLog(@"RootViewController.m:37  viewDidLoad()  self.view.frame: %@   wholeScreenRect: %@   applicationFrameRect: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(wholeScreenRect), NSStringFromCGRect(applicationFrame));
    
    self.navigationItem.titleView = [Jeanome getJeanomeLogoImageView];
    
    //  12/8/2011  Show a static image mercedes made that fits the whole screen
    //
    staticImageView = [[UIImageView alloc] initWithFrame:frame];    
    staticImageView.userInteractionEnabled = YES;  // disabled by default
    
    if(!jeanome) {
        // not logged in, so show the login page!
        
        staticImageView.image = [UIImage imageNamed:@"Default.png"];
        
        self.navigationController.navigationBarHidden = YES;
        
        UIImage *facebookLoginButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoginWithFacebookNormal" ofType:@"png"]];
        
        facebookLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 323, facebookLoginButtonImage.size.width, facebookLoginButtonImage.size.height)];
        [facebookLoginButton setImage:facebookLoginButtonImage forState:UIControlStateNormal];
        [facebookLoginButton addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];        
        [facebookLoginButton sizeToFit];
        [facebookLoginButton setAlpha:0.0];                 // for fade in animation!  see viewDidLoad
        [staticImageView addSubview:facebookLoginButton];
        [facebookLoginButton release];
    }
    else {        
        // logged in, so show mercedes splash image to take a photo!
        
        staticImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_wallpaper_instruction" ofType:@"png"]];        
        
        UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(startTakingPhoto:)];    
        
        // UIBarButtonItem *myClosetBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_profile" ofType:@"png"]]  style:UIBarButtonItemStylePlain target:self action:@selector(openCloset:)];
        
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        
        self.navigationItem.leftBarButtonItem = cameraBarButton;
        self.navigationItem.rightBarButtonItem = logoutButton;
        self.navigationController.navigationBarHidden = NO;
        
        // NSLog(@"SCREEN applicationFraome.size: %@    self.view.frame.size: %@    self.view.bounds.size: %@", NSStringFromCGSize([UIScreen mainScreen].applicationFrame.size),  NSStringFromCGSize(self.view.frame.size), NSStringFromCGSize(self.view.bounds.size));
        /*
         float bottomLX=CGRectGetMinX(self.view.frame);
         float bottomLY=CGRectGetMaxY(self.view.frame);
         NSLog(@"(%f,%f)",bottomLX,bottomLY);
         */
        
        
        //  Show who's logged in on the bottom left   (80.0 seems like a lot to subtract...)
        CGFloat labelHeight = 20.0;
        CGFloat bottomPadding = 90.0;
        UILabel *whosLoggedInLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, frame.size.height - bottomPadding, frame.size.width, labelHeight)];    
        NSString *loggedInName = [jeanome.facebookLoginDict objectForKey:@"name"];    
        loggedInName = !loggedInName ? @"..." : loggedInName;
        whosLoggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@", loggedInName];    
        whosLoggedInLabel.font = [UIFont systemFontOfSize:12.0];
        whosLoggedInLabel.textColor = [UIColor whiteColor];
        whosLoggedInLabel.backgroundColor = [UIColor clearColor];
        whosLoggedInLabel.opaque = NO;
        
        [staticImageView addSubview:whosLoggedInLabel];
                
        [whosLoggedInLabel release];
        [cameraBarButton release]; 
        [logoutButton release]; 
    }
    
    self.view = staticImageView;
    [staticImageView release];
}

- (void)viewDidLoad
{
    DebugLog();

//  http://www.iphonedevsdk.com/forum/iphone-sdk-development/10077-sending-messages-back-root-view-controller.html
        
    // Change the background image if an item was added
    // ...see ClosetItemDetailsViewController.m:754 in _saveClosetItemDetails()
    // 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closetItemWasAdded) name:NOTIFICATION_CLOSET_ITEM_ADDED object:jeanome];
    
//    [Jeanome notificationBox:self.view withMsg:@"testing notification box...  RootViewController.m:143"];
        
    // Should only run on app launch!
    //    XXX  12/12/2011   Removing this if(!jeanome) block could cause a 'deallocated instance' 
    //                      crash on facebookLoginButton if hitting cancel from Aviary
    //  
    if(!jeanome) {
        [UIView animateWithDuration:1.0 animations:^{
            facebookLoginButton.alpha = 1.0;
        }];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [rootTableView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    DebugLog();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)startTakingPhoto:(id)sender
{   
    DebugLog();

    //dosen't work, needs to be async
//    UIView *loadingBox = [Jeanome newLoadingBox];    
//    [self.view addSubview:loadingBox];
    
    TakePhotoViewController *tpvc = [[TakePhotoViewController alloc] initWithJeanome:jeanome];
    [self.navigationController pushViewController:tpvc animated:YES];
    [tpvc release]; 
    
//    [loadingBox release];
}



-(IBAction)openCloset:(id)sender
{   
    DebugLog();
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Original version, kinda stalls for a sec while it loads the JSON from myjeanome.com/api
    ClosetViewController *cvc = [[[ClosetViewController alloc] initWithFbResult:appDelegate.facebookLoginDict] autorelease];

    [self.navigationController pushViewController:cvc animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Asynchrnous closet load,  but causes problems loading images initially 
    // in PictureTableViewCell in the table view image thingy
    //        [self performSelectorInBackground:@selector(__initClosetView:) withObject:@"notused"];

}




#pragma mark - <UITableViewDataSource>

//  This is the number of categories...  e.g. Shoes, Bags, Makeup
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {        
        return [NSString stringWithFormat:@"Shoes"];
    }
    else if(section == 1) {
        return @"Bags";
    }
    else if(section == 2) {
        return @"Makeup";
    }
    else 
        return [NSString stringWithFormat:@"Category %d", section];
}


/*
 Builds rows of each category, and the photos of each category in a closet.
 
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // NSLog(@"RootViewController.m:176  (%d,%d)  SUBVIEW COUNT: %u", indexPath.section, indexPath.row, [[cell subviews] count]);

    // 12/5/2011 reused table cells are stacking on top of each other and messing up screen
    if ([[cell subviews] count] > 1) {
        return cell;
    }
    
    // #0  Make a wrapper UIView which spans the original cell height/width
    // and give it a grey background
    UIView *wrapper = [[UIView alloc] initWithFrame:cell.frame];
        
    // #1  Add the big camera icon that shows up on the left...
    //            
    UIImageView *bigCameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_camera_95" ofType:@"png"]]];
    [bigCameraIcon setFrame:bigCameraIcon.frame];
    [bigCameraIcon setUserInteractionEnabled:YES];
    [bigCameraIcon.layer setBorderColor:[[UIColor blackColor] CGColor]];

    CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];    
    bigCameraIcon.frame = CGRectMake(cell.frame.origin.x + 10.0, cell.frame.origin.y + 10.0, 100.0, cellHeight - 20.0);
    bigCameraIcon.backgroundColor = [UIColor grayColor];
    
    UITapGestureRecognizer *cameraTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTakingPhoto:)];
    cameraTapRecognizer.delegate = self;
    [bigCameraIcon addGestureRecognizer:cameraTapRecognizer];
    [cameraTapRecognizer release];
    
    
    // #2  add the "Showcase that lovely purse" label to the right
    //
    UILabel *blurb = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x + bigCameraIcon.frame.size.width + 20.0, cell.frame.origin.y, 190.0, cellHeight)];
    
    blurb.numberOfLines = 2;
    blurb.lineBreakMode = UILineBreakModeWordWrap;
    blurb.textAlignment = UITextAlignmentCenter;
    blurb.font = [UIFont systemFontOfSize:21.0];
    blurb.backgroundColor = [UIColor grayColor];

    
    if(indexPath.section == 0) {
        blurb.text = @"Get your favorite pair of shoes!";
    }
    else if(indexPath.section == 1) {
        blurb.text = @"Showcase that lovely purse!";
    }
    else {
        blurb.text = @"Coming Soon...";
    }
    
    if(indexPath.section == 0 || indexPath.section == 1) {
        [wrapper addSubview:bigCameraIcon];
    }
    
    [wrapper addSubview:blurb];    
    [cell addSubview:wrapper];
    
    cell.contentView.backgroundColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [bigCameraIcon release]; [blurb release]; [wrapper release];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [tableView sectionHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"  %@", [self tableView:tableView titleForHeaderInSection:section]];

    // UIView *defaultTableHeaderView = tableView.tableHeaderView;
    // CGRect f = defaultTableHeaderView.frame;
    
    UIView *customHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, [self tableView:tableView heightForHeaderInSection:section])] autorelease];
    
    // Label spans about 40% across the screen
    UILabel *styledHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 4.0, 320.0 * 0.45, [self tableView:tableView heightForHeaderInSection:section])] autorelease];
                                                                           
    styledHeaderLabel.backgroundColor = [UIColor grayColor];
    styledHeaderLabel.text = [title uppercaseString];
    [styledHeaderLabel.layer setCornerRadius:5.0];
    
    [customHeaderView addSubview:styledHeaderLabel];
    
    return customHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DebugLog();
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    DebugLog();
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // clear out the psuedo-placeholder text in the description UITextView
    textView.text = @"";
    return YES;
}

#pragma mark - <FBSessionDelegate>


/**
 * Called when the user has succesfully logged in.
 */   
- (void)fbDidLogin {    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self facebookLogin];
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {

}

/**
 * Called when the user logged out.
 */
- (void) fbDidLogout {
    DebugLog();
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    // logged out now, so get rid of this since it stores the login info
    jeanome = nil;
    
    [self loadView];
    [self viewDidLoad];
    
//    [Jeanome notificationBox:self.view withMsg:@"Thanks for using Jeanome!"];
}


#pragma mark - <FBRequestDelegate>

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    NSDictionary *dict = result;
    
    NSString *facebookId = [dict objectForKey:@"id"];
    //FBRequest *fbRequest = request;
    id fbResult = result;
    
//    DebugLog(@"  facebookId: %@", facebookId);
    
    //  12/7/2011  Create a Jeanome object to hold facebook session info
    jeanome = [[Jeanome alloc] initWithFacebook:facebookId andDict:fbResult];
    
    //  We've set the Jeanome model object finally, so viewDidLoad() will now load the front page.
    [self loadView];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    DebugLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    DebugLog(@"Err code: %d", [error code]);
}

#pragma mark - @selector's

//  See viewDidLoad() on line 81ish

- (void)logout
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout:self];    
}

- (void)facebookLogin
{
    DebugLog();
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
        
    if (![[delegate facebook] isSessionValid]) {
        
        DebugLog(@"not logged in yet!");
        
        // NOTE- this will perform a request which when done, will call 
        // the facebook delegate method request:didLoad() which 
        // pushes root view controller
        
        //  Permissions granted in Jeanome Django code  templates/base.html:299
        //       'email,offline_access,user_photos,friends_photos,publish_stream'
        //
        //     THIS IS IMPORTANT AS PHOTO ALBUM CREATION WILL NOT WORK WITHOUT THIS!!!1
        //
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"offline_access", @"user_photos", @"friends_photos", @"publish_stream", nil];
        
        [[delegate facebook] authorize:permissions];
    }
    else {
        // Logged into facebook, so get info 
        // and load the view in facebook request:didLoad
        
        DebugLog(@" already logged in!");
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObject:@"id,name" forKey:@"fields"];
        
        // Get the users facebook id
        [[delegate facebook] requestWithGraphPath:@"me" andParams:paramDict andDelegate:self];
        
    }
}

/*
    Used with NSNotificationCenter to change the background image to the dog
    after the user adds an item.
 
     http://www.iphonedevsdk.com/forum/iphone-sdk-development/10077-sending-messages-back-root-view-controller.html
 
    see ClosetItemDetailsViewController.m:754 in _saveClosetItemDetails()
 */
- (void)closetItemWasAdded
{
    DebugLog(@"Closet item was added, so changing wallpaper and showing notificationBox!");
    
    //  TODO change staticImageView here     
    staticImageView.image = [UIImage imageNamed:@"iphone_wallpaper_tookphoto.png"];
        
    [Jeanome notificationBox:self.view withMsg:@"Booyah! You've just added a new item!  +10 points!"];    
}

@end
