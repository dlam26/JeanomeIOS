//
//  ClosetViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetViewController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation ClosetViewController

@synthesize fbResult, fbResultDict, closet;
@synthesize tableViewCellWithTableView;

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
    
    // 1.  Set up the navigation bar

    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"transparent_settings_gear_icon" ofType:@"png"]] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsPage)];       

    self.navigationItem.rightBarButtonItem = settingsBarButton;
    
    // 2.  Fetch JSON from the server about the details.
    
    NSString *closetUrlString = [NSString stringWithFormat:@"%@/api/closet/%@/", [[NSUserDefaults standardUserDefaults] stringForKey:SETTING_JEANOME_URL], [self.fbResultDict objectForKey:@"id"]];
        
//    NSLog(@"ClosetViewController.m:36  initWithFBResult() Fetching from URL... %@", closetUrlString);
    
    //  TODO  replace with NSURLRequest, or some asynchronous call so i can show network activity indicator
    //
    NSString *closetJSON = [NSString stringWithContentsOfURL:[NSURL URLWithString:closetUrlString] encoding:NSUTF8StringEncoding error:nil];

    self.closet = [[Closet alloc] initWithJSON:closetJSON];
    
    self.title = [NSString stringWithFormat:@"%@'s Closet", [self.closet getName]];
    
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
 
//    NSLog(@"ClosetViewController.m:65   viewDidLoad()");
    
    NSDictionary *fbDict = fbResult;
    NSString *facebookId = [fbDict objectForKey:@"id"];
    facebookIdLabel.text = facebookId;
    
    
    // get the facebook image 
    // from... http://graph.facebook.com/1365147631/picture?type=large
    
    NSURL *profilePicURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", facebookId]];
    
    UIImage *profilePicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:profilePicURL]];
    
    [facebookProfilePic setImage:profilePicImage];
    [nameLabel setText:[self.closet getName]];
    [followersLabel setText:[NSString stringWithFormat:@"%@ followers", [self.closet getFollowers]]];
    [followingLabel setText:[NSString stringWithFormat:@"%@ following", [self.closet getFollowing]]];
    [statusLabel setText:[self.closet getStatus]];
    [pointsLabel setText:[NSString stringWithFormat:@"%@ pts.", [self.closet getPoints]]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  //  NSLog(@"ClosetViewController.m:91   viewWillAppear()");
    
    // turned on from JeanomeViewController.m:93
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // TODO change this to the number of actual categories once that gets implemented
    
    return 1;
    
    //return 3;
}

/*
    This is the number of categories...  e.g. Shoes, Bags, Makeup
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    else 
        return [NSString stringWithFormat:@"Category %d", section];
}



/*
    Builds rows of each category, and the photos of each category in a closet.
 
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellWithTableView";

    PictureTableViewCell *cell = (PictureTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PictureTableViewCell" owner:self options:nil];
        
        tableViewCellWithTableView.tableViewInsideCell.allowsSelection = NO;
        
        // rotate the table view on its side 90 degrees!
        tableViewCellWithTableView.transform = CGAffineTransformMakeRotation(-(0.5)*M_PI);
        // tableViewCellWithTableView.transform = CGAffineTransformMakeRotation(degreesToRadians(90));

        //  TODO  only get items of the current category shown in this rows tableview
    
        tableViewCellWithTableView.closet = closet;
        
        cell = tableViewCellWithTableView;
        
        cell.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
        [cell setNeedsDisplay];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"ClosetViewController.m:155   didSelectRowAtIndexPath()! %u", indexPath.row);
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.0;
    }
    else
        return [tableView sectionHeaderHeight];
}

/*
    This is the height of each closet item picture.  To show 3 on one screen, we should just divide
    the total screen width by 3!
 
    See PictureTableViewCell.m:64
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return 110;

    //return 106.666;
    
    return [[UIScreen mainScreen] bounds].size.width / 3.0;
}


@end
