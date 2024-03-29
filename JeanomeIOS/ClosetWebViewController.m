//
//  ClosetWebViewController.m
//  JeanomeIOS
//
//  Created by david lam on 12/14/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetWebViewController.h"

@implementation ClosetWebViewController

@synthesize theWebView;
@synthesize url;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)threadStartAnimating:(id)data
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


#pragma mark - View lifecycle

- (id)initWithURL:(NSString *)urlString {
    self = [super init];
    if (self) {
        url = [NSURL URLWithString:urlString];
        
        addressBar.text = url.absoluteString;
        
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
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
    theWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [theWebView setScalesPageToFit:YES];
    [theWebView setDelegate:self];
 
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.0.1.23:8000/closet/100003115255847/197#my_closet_header"]];
    
    [theWebView loadRequest:urlRequest];
    
    UIView *addressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    
    UITextField *urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 200, 50)];                          
    urlTextField.text = theWebView.request.URL.absoluteString;
    [addressBar addSubview:urlTextField];

    [theWebView addSubview:addressBar];
        
    self.view = theWebView;
}
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Jeanome getJeanomeLogoImageView];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [theWebView loadRequest:urlRequest];
    theWebView.scalesPageToFit = YES;       // enable pinch zoom
    theWebView.delegate = self;
    addressBar.text = url.absoluteString;
//    addressBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // e.g. read only text field   
    // Don't allow unrestricted web access in UIWebView as that means automatic 17+ rating
    addressBar.userInteractionEnabled = NO; 
    
//    backButton.enabled    = theWebView.canGoBack ? YES : NO;
//    forwardButton.enabled = theWebView.canGoForward ? YES : NO;
    
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
//    [theWebView release];
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
    [theWebView goBack];
//    [addressBar setText:theWebView.request.URL.absoluteString];
}

-(IBAction)forward:(id)sender;
{
//    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
//    DebugLog();
    [theWebView goForward];
//    [addressBar setText:theWebView.request.URL.absoluteString];
}

#pragma mark - <UIWebViewDelegate>

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DebugLog("error.code: %d    error description: %@", [error code], [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DebugLog();
    
//    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DebugLog();
    
    // started in RootViewController.m:657  imageTapped()
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DebugLog();
    

    
    //  Update address bar with new URL     
    addressBar.text = [webView request].URL.absoluteString;
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
    [theWebView loadRequest:urlRequest];    
    [addressBar resignFirstResponder];    

    return YES;
}

@end
