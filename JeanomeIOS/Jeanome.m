//
//  Jeanome.m
//  JeanomeIOS
//
//  Created by david lam on 12/5/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Jeanome.h"
#import "Reachability.h"

@implementation Jeanome 

@synthesize facebookId, facebookLoginDict;


/*
    12/7/2011   Seems like facebookLoginDict contains one key "id" with the facebook id
 */
-(id)initWithFacebook:(NSString *)fbId andDict:(NSDictionary *)fbDict {
    self = [super init];
    if (self) {
        self.facebookId = fbId;
        self.facebookLoginDict = fbDict;
    }
    return self;
}

+(BOOL)isConnectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+ (UIColor *)getJeanomeColor
{
    return [UIColor colorWithRed:0.43 green:0.54 blue:0.78 alpha:1.0];
}

/*
 see RootViewController.m:28
 */
+(UIImageView *)getJeanomeLogoImageView
{
    UIImage *logo = [UIImage imageNamed:@"iphone_logo_toolbar"];    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)] autorelease];    
    imageView.image = logo;
    
    return imageView;
}

+(CGRect)getNavigationBarFrame
{
    return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66);
}


/*
    Toolbar with 3 buttons:
 
        Prev - Calls accessoryPrev()
        Next - Calls accessoryNext()
        Done - Calls accessoryDone()
 
    12/6/2011  The width of 320.0 here is for the hacked inputAccessory
    view for 'category'  (uses the UIActionSheet).  
    It dosen't seem to affect the other fields.
 */
+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate
{
    return [Jeanome accessoryViewCreatePrevNextDoneInput:delegate withFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
}

+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate withFrame:(CGRect)frame;
{
    UIToolbar *prevNextDoneToolbar = [[[UIToolbar alloc] initWithFrame:frame] autorelease];
    
    UIBarButtonItem *b;
    NSMutableArray *buttons = [NSMutableArray array];
    
    b = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:delegate action:@selector(accessoryPrev)];
    [buttons addObject:b];
    [b release];
    
    // create a spacer
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:b];
    [b release];
    
    b = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:delegate action:@selector(accessoryNext)];
    [buttons addObject:b];
    [b release];
    
    // flexible space to position button on right
    b = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:b];
    [b release];
    
    // done button
    b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:delegate action:@selector(accessoryDone)];
    [buttons addObject:b];
    [b release];
    
    [prevNextDoneToolbar setItems:buttons];
        
    return prevNextDoneToolbar;
}

+(UIView *)accessoryViewCreateDoneInput:(id)delegate
{
    UIToolbar *doneToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 30.0)] autorelease];
    
    UIBarButtonItem *b;
    NSMutableArray *buttons = [NSMutableArray array];
    
    // flexible space to position button on right
    b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:b];
    [b release];
    
    // done button
    b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:delegate action:@selector(accessoryDone)];
    [buttons addObject:b];
    [b release];
    
    [doneToolbar setItems:buttons];
    
    return doneToolbar;   
}


/*
 Uploads an image to Jeanome, creating a closet (if neccssary), and creating a closet item
 which is subsequently posted to facebook!
 
 Returns the response string 
 
 
        closetItem.userId SET IN
 */
+(NSString *)uploadToJeanome:(ClosetItem *)closetItem withImage:(UIImage *)img withUploadProgressDelegate:(id)progressDelegate andDelegate:(id)delegate
{
    // important!  needs to have trailing slash or Django complains about 
    // the APPEND_SLASH setting not being set...
    NSURL *postURL = [NSURL URLWithString:[JEANOME_URL stringByAppendingFormat:@"/closet/add/"]];
    
    NSHTTPCookie *facebookIdCookie = [self __createUploadCookie:@"userID" withValue:closetItem.userId];    
    NSHTTPCookie *accessTokenCookie = [self __createUploadCookie:@"accessToken" withValue:[Jeanome getAccessToken]];

    DebugLog(@" postURL: %@ ", postURL);   
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:postURL];
    [ASIFormDataRequest setShouldUpdateNetworkActivityIndicator:YES];
        
    // views.py:203   request.POST: {u'category': [u''], u'note': [u'22'], u'brand': [u'222'], u'do_add_item': [u'Submit'], u'value': [u'222']}
        
    // If the 'value' is empty or negative, just set it to 0.  Otherwise the python
    // code will check closet_item_form.is_valid() and return false
    if(closetItem.value == nil || closetItem.value < 0) {
        DebugLog(@"  setting closet item to 0 since it was nil or negative!");
        closetItem.value = [NSNumber numberWithInt:0];
    }
    
    // Can only have 2 decimal digits!
    NSNumberFormatter *twoDecimalDigitsFormatter = [[NSNumberFormatter alloc] init];
    [twoDecimalDigitsFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [twoDecimalDigitsFormatter setMaximumFractionDigits:2];
    NSNumber *truncatedValue = [twoDecimalDigitsFormatter numberFromString:[twoDecimalDigitsFormatter stringFromNumber:closetItem.value]];
    [twoDecimalDigitsFormatter release];    
    
    [request setPostValue:closetItem.brand forKey:@"brand"];
    [request setPostValue:truncatedValue forKey:@"value"];
    [request setPostValue:[closetItem getCategoryIdentifier] forKey:@"category"];    
    [request setPostValue:closetItem.note forKey:@"note"];
    
    // 12/3/2011  I think this is for the ghetto hidden form thing thats used 
    // when creating a closet item
    [request setPostValue:@"Submit" forKey:@"do_add_item"];   
    
    // IMPORTANT:  The edited photo after Aviary is set to imageView.image
    [request addData:UIImageJPEGRepresentation(img, 1.0) forKey:@"picture"];
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithObjects:facebookIdCookie, accessTokenCookie, nil]];    

    //  12/9/2011  uploads timing out, but still work! :O
    //  wait, its because 3g upload speed is 0.01 at home right now X___X
    //
    //     30 - uploads but still get timeout when Django POSTs to facebook
    //          ...but it still can get 3G timeout =(
    [request setTimeOutSeconds:30];

    // http://allseeing-i.com/ASIHTTPRequest/How-to-use#progress
    [request setUploadProgressDelegate:progressDelegate];
    [request setShowAccurateProgress:YES];
    
    [request setDelegate:delegate];
    
//    [request startSynchronous];   // UIKit can't update screen with this!
    [request startAsynchronous];
    

    NSError *error = [request error];
    
    if(!error) {    
        return [request responseString];
    }
    else {
        DebugLog(@"  Error occurred while uploading pic!  %@", [error localizedDescription]);
        return nil;
    }
}


/*
 Create a cookie because the python code in closet/views.py fetches info from it
 
 http://allseeing-i.com/ASIHTTPRequest/How-to-use#persistent_cookies
 
 also see ASIHTTPRequestsTests.m in its source folder
 */
+(NSHTTPCookie *)__createUploadCookie:(NSString *)name 
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
    
    // DebugLog(@"__createUploadCookie():  %@", cookie);
    
    return cookie;
}

/* 
    Set into NSUserDefaults in AppDelegate:115 
 */
+(NSString *)getAccessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    return [defaults objectForKey:@"FBAccessTokenKey"];
}


/*
    Pop's up an animate notiification box from the bottom!
 
 */ 
+(void)notificationBox:(UIView *)view withMsg:(NSString *)msg
{    
    // Test animating a UILabel onto the screen
    
    CGFloat labelWidth = 200.0;
    CGFloat labelHeight = 60.0;
    CGFloat padding = 20.0;
    
    CGFloat x      = view.bounds.size.width - labelWidth - padding;
    CGFloat startY = view.bounds.size.height + 30.0;
    CGFloat endY   = view.bounds.size.height - 100.0;
    
    CGRect bottomRightCornerOffScreen = CGRectMake(x, startY, labelWidth, labelHeight);    
    CGRect bottomRightCorner          = CGRectMake(x, endY, labelWidth, labelHeight);

    UILabel *lbl = [[UILabel alloc] initWithFrame:bottomRightCornerOffScreen];
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:239.0f/255.0f blue:213.0f/255.0f alpha:1.0f];   // cream color
    lbl.font = [UIFont systemFontOfSize:14.0];
    lbl.text = msg;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
    lbl.shadowOffset = CGSizeMake(0, -1);
    lbl.numberOfLines = 0;   // Word wrap and use as many lines as needed
    lbl.layer.cornerRadius = 15;    
    
    [UIView animateWithDuration:2.0 
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         lbl.frame = bottomRightCorner;
                     } completion:^(BOOL finished) {
        
                         [NSThread sleepForTimeInterval:1.5];
        
                         [UIView animateWithDuration:2.0 
                                               delay:0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              lbl.frame = bottomRightCornerOffScreen;
                                          } completion:^(BOOL finished) {
                                              [lbl removeFromSuperview]; 
                                          }
                          ];
                     }
     ];
    
    [view addSubview:lbl];
}

+(UIView *)newLoadingBox
{
    return [Jeanome newLoadingBox:@"Loading"];
}


/*
    Returns a UIView showing a translucent gray box containing a spinning 
    UIActivityIndcatorView in the middle of it
 
 http://stackoverflow.com/questions/3490991/big-activity-indicator-on-iphone
 */
+(UIView *)newLoadingBox:(NSString *)loadingBoxText
{
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];     
    loading.layer.cornerRadius = 15;
    loading.opaque = NO;
    loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 110, 22)];    
    loadLabel.text = loadingBoxText;
    loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    loadLabel.textAlignment = UITextAlignmentCenter;
    loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    loadLabel.backgroundColor = [UIColor clearColor];
    [loading addSubview:loadLabel];
    [loadLabel release];
    
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = CGRectMake(42, 54, 37, 37);
    [spinning startAnimating];
    [loading addSubview:spinning];
    [spinning release];
    
    return loading;
}

+(UIAlertView *)newNoInternetConnectionAlertView
{    
    return [Jeanome newNoInternetConnectionAlertView:@"Error loading, check if you have an internet connection."];
}

+(UIAlertView *)newNoInternetConnectionAlertView:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh snap!" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];        
    
    return alertView;
}


@end
