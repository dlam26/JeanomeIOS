//
//  SettingsViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 11/12/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Settings";
        
        defaults = [NSUserDefaults standardUserDefaults];
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
    
    jeanomeURLTextField.text = [defaults stringForKey:SETTING_JEANOME_URL];
    jeanomeURLTextField.delegate = self;

    jeanomeURLTextField.autocorrectionType = UITextAutocorrectionTypeNo;
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

-(IBAction)saveSettings:(id)sender
{
    [defaults setValue:[jeanomeURLTextField text] forKey:SETTING_JEANOME_URL];
    
    [defaults synchronize];
}

#pragma mark -  <UITextFieldDelegate> 


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"SettingsViewController.m:76   textFieldShouldReturn()");

    /*
    if (textField.text.length) {
		[textField resignFirstResponder];
		return YES;
	} else {
		return NO;
	}
     */
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"SettingsViewController.m:76   textFieldDidEndEditing()");
    
    /*
	[self.delegate askerViewController:self didAskQuestion:self.questionLabel.text andGotAnswer:self.answerField.text];
     */
}

@end
