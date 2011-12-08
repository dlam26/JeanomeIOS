//
//  RootViewController.m
//  JeanomeIOS
//
//  Created by david lam on 12/4/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize nav, rootTableView, jeanome;

- (id)initWithJeanome:(Jeanome *)j
{
    self = [super init];
    if (self) {
        self.jeanome = j;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        /*
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 320, 400) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
         */
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
    
    nav = [[UINavigationController alloc] init];
    nav.navigationBar.tintColor = [Jeanome getJeanomeColor];
    
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(startTakingPhoto:)];    
    
    UIBarButtonItem *myClosetBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_profile" ofType:@"png"]]  style:UIBarButtonItemStylePlain target:self action:@selector(openCloset:)];
 
    self.navigationItem.leftBarButtonItem = cameraBarButton;
    self.navigationItem.rightBarButtonItem = myClosetBarButton;
    
    rootTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    rootTableView.dataSource = self;
    rootTableView.delegate = self;
    rootTableView.separatorColor = [UIColor blackColor];
    
    self.navigationItem.titleView = [Jeanome getJeanomeLogoImageView];

    [self.view addSubview:rootTableView];
    
    [cameraBarButton release]; [myClosetBarButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [rootTableView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)startTakingPhoto:(id)sender
{   
    //NSLog(@"RootViewController.m:83   startTakingPhoto()");
    
    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	myIndicator.center = CGPointMake(160, 240);
	myIndicator.hidesWhenStopped = NO;
    
    [myIndicator startAnimating];
    
    TakePhotoViewController *tpvc = [[TakePhotoViewController alloc] initWithJeanome:jeanome];
    // tpvc.title = @"How's it look?";
    
    [self.navigationController pushViewController:tpvc animated:YES];

    [tpvc release]; [myIndicator release];
}



-(IBAction)openCloset:(id)sender
{   
    NSLog(@"RootViewController.m:99   openCloset()");
    
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
    NSLog(@"RootViewController.m:266  gestureRecognizer:shouldReceiveTouch()");
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"RootViewController.m:271  gestureRecognizerShouldBegin()");
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // clear out the psuedo-placeholder text in the description UITextView
    textView.text = @"";
    return YES;
}




@end
