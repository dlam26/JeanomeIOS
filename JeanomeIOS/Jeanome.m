//
//  Jeanome.m
//  JeanomeIOS
//
//  Created by david lam on 12/5/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Jeanome.h"

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
//    UIImage *logo = [UIImage imageNamed:@"iphone_logo_toolbar-smaller"];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)] autorelease];    
    imageView.image = logo;
    
    //    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_logo_toolbar"]] autorelease];
    
    
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
+(NSString *)uploadToJeanome:(ClosetItem *)closetItem withImage:(UIImage *)img
{
    // important!  needs to have trailing slash or Django complains about 
    // the APPEND_SLASH setting not being set...
    NSURL *postURL = [NSURL URLWithString:[JEANOME_URL stringByAppendingFormat:@"/closet/add/"]];
    
    NSHTTPCookie *facebookIdCookie = [self __createUploadCookie:@"userID" withValue:closetItem.userId];    
    NSHTTPCookie *accessTokenCookie = [self __createUploadCookie:@"accessToken" withValue:[Jeanome getAccessToken]];
#ifndef DEBUG    
    NSLog(@"Jeanome.m:132  uploadToJeanome()  postURL: %@ ", postURL);
    NSLog(@"Jeanome.m:151  facebookIdCookie()  %@", facebookIdCookie);
    NSLog(@"Jeanome.m:152  accessTokenCookie()  %@", accessTokenCookie);
    
#endif    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:postURL];
    
    // views.py:203   request.POST: {u'category': [u''], u'note': [u'22'], u'brand': [u'222'], u'do_add_item': [u'Submit'], u'value': [u'222']}
    
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
    [request setTimeOutSeconds:20];  //  12/9/2011  uploads timing out, but still work! :O
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if(!error) {    
        return [request responseString];
    }
    else {
        NSLog(@"Jeanome.m:186   Error occurred while uploading pic!  %@", [error localizedDescription]);
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
    
    // NSLog(@"__createUploadCookie():  %@", cookie);
    
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

//    NSLog(@"bottomRightCornerOffScreen: %@", NSStringFromCGRect(bottomRightCornerOffScreen));
//    NSLog(@"bottomRightCorner: %@", NSStringFromCGRect(bottomRightCorner));
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:bottomRightCornerOffScreen];
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:239.0f/255.0f blue:213.0f/255.0f alpha:1.0f];   // cream color
    lbl.font = [UIFont systemFontOfSize:14.0];
    lbl.text = msg;
    lbl.textAlignment = UITextAlignmentLeft;
    lbl.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
    lbl.shadowOffset = CGSizeMake(0, -1);
    lbl.numberOfLines = 0;   // Word wrap and use as many lines as needed
        
    [UIView animateWithDuration:2.0 animations:^{ 
        lbl.frame = bottomRightCorner;
    } completion:^(BOOL finished) {     
        
        [NSThread sleepForTimeInterval:3.0];
        
        [UIView animateWithDuration:2.0 animations:^{
            lbl.frame = bottomRightCornerOffScreen;
        } completion:^(BOOL finished) {
            [lbl removeFromSuperview]; 
        }];
    }];
    
    [view addSubview:lbl];
}



@end
