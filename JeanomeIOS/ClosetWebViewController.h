//
//  ClosetWebViewController.h
//  JeanomeIOS
//
//  Created by david lam on 12/14/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Jeanome.h"

@interface ClosetWebViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIWebView *webView;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *forwardButton;
    IBOutlet UITextField *addressBar;
    
    NSURL *url;
}

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) NSURL *url;

- (id)initWithURL:(NSString *)urlString;
-(IBAction)back:(id)sender;
-(IBAction)forward:(id)sender;

@end
