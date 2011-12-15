//
//  ClosetWebViewController.m
//  JeanomeIOS
//
//  Created by david lam on 12/14/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetWebViewController.h"

@implementation ClosetWebViewController

@synthesize webView;
@synthesize url;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithURL:(NSString *)urlString {
    self = [super init];
    if (self) {
        url = [NSURL URLWithString:urlString];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView
{
    // test test
    webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
 
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.0.1.23:8000/closet/100003115255847/197#my_closet_header"]];
    
    [webView loadRequest:urlRequest];
    
    UIView *addressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    
    UITextField *urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 200, 50)];                          
    urlTextField.text = webView.request.URL.absoluteString;
    [addressBar addSubview:urlTextField];

    [webView addSubview:addressBar];
        
    self.view = webView;
}
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Jeanome getJeanomeLogoImageView];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:urlRequest];
    webView.scalesPageToFit = YES;       // enable pinch zoom
    webView.delegate = self;
    addressBar.text = url.absoluteString;
    addressBar.clearButtonMode = UITextFieldViewModeWhileEditing;
//    addressBar.userInteractionEnabled = NO;   // e.g. read only text field
    
//    backButton.enabled    = webView.canGoBack ? YES : NO;
//    forwardButton.enabled = webView.canGoForward ? YES : NO;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
  
    // XXX   12/14/2011   This release is causing a crash when going back/and forth
    //                    from the web view via the navigation controller
    //                    e.g. [ClosetWebViewController respondsToSelector:]: 
    //                         message sent to deallocated instance 
//    [webView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBAction's

-(IBAction)back:(id)sender;
{
//    DebugLog();
    [webView goBack];
    [addressBar setText:webView.request.URL.absoluteString];
}

-(IBAction)forward:(id)sender;
{
//    DebugLog();
    [webView goForward];
    [addressBar setText:webView.request.URL.absoluteString];
}

#pragma mark - <UIWebViewDelegate>

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DebugLog("error.code: %d    error description: %@", [error code], [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//      UIWebViewNavigationType
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    DebugLog();
    
    // started in RootViewController.m:657  imageTapped()
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    DebugLog();
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // if no http://  ...add it in    
    if([textField.text rangeOfString:@"http://"].location == NSNotFound
            && [textField.text rangeOfString:@"https://"].location == NSNotFound) {
    
        addressBar.text = [NSString stringWithFormat:@"http://%@", addressBar.text];
    }   
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:addressBar.text]];    
    [webView loadRequest:urlRequest];    
    [addressBar resignFirstResponder];    

    return YES;
}



@end
