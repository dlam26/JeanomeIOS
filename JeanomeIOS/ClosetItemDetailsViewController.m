//
//  ClosetItemDetailsViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetItemDetailsViewController.h"

@implementation ClosetItemDetailsViewController

@synthesize categoryTextField, brandTextField;
@synthesize costTextField, noteTextView, scrollView, delegate;
@synthesize ci;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        noteTextView.editable = YES;

//        noteTextView.layer.borderWidth = 2.0f;
//        noteTextView.layer.borderColor = [[UIColor blackColor] CGColor];
//        noteTextView.clipsToBounds = YES;                
    }
    return self;
}

// see TakePhotoViewController.m:438 in editDetails()
-(id)initWithClosetItem:(ClosetItem *)closetItem
{
    self = [super init];
    if (self) {
        self.ci = closetItem;
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
    
    self.categoryTextField.text = ci.category;
    self.brandTextField.text = ci.brand;
    self.costTextField.text = ci.value ? [NSString stringWithFormat:@"%@", ci.value] : @"";
    self.noteTextView.text = ci.note;
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


/*
    from http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-text-field
 */
- (void)animateTextField:(id)textField up:(BOOL)up
{
    if(textField == noteTextView || textField == costTextField) {
        
        int movementDistance;
        float movementDuration = movementDuration = 0.3f; // tweak as needed
        
        if(textField == noteTextView) {            
            movementDistance = 150; // tweak as needed
        }
        else {
            movementDistance = 85;
        }
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}


#pragma mark - IBActions

/*
    FIXME  figure out what to pass to withImageURL
 */
-(IBAction)saveDetails:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    NSDictionary *imageDict = [ClosetItem makeImageDict:nil withNote:self.noteTextView.text 
                                           withCategory:self.categoryTextField.text withImageURL:nil withBrand:self.brandTextField.text withValue:[nf numberFromString:self.costTextField.text] withTime:[df stringFromDate:[NSDate date]]];
    [self.delegate saveDetails:imageDict];                               
    [df release]; [nf release];
        
    // Now, with everthing saved, go back to the TakePhotoViewController
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"ClosetItemDetailsViewController.m:55   textFieldShouldEndEditing()!");
    
    // TODO    check/valid the input for the field here   e.g. price can't be negative

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"ClosetItemDetailsViewController.m:64   textFieldShouldReturn()!");
    
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

/*
    http://stackoverflow.com/questions/433337/iphone-sdk-set-max-character-length-textfield
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    //  cost/value field can have at most 7 digits:  `value` decimal(7,2) NOT NULL
    // 
    if([textField isEqual:costTextField]) {
        
        NSString *newCost = [textField.text stringByReplacingCharactersInRange:range withString:string];

        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        NSLocale *l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
        [nf setLocale:l_en];
                        
        if([string length] == 0) {
            return YES;   // backspace
        }
        else {            
            NSUInteger newCostLength = [textField.text length] + [string length] - range.length;
            
            if (newCostLength > 7 ) {
                return NO;  // allow max 7 digits
            }
            else if(![nf numberFromString:newCost]) {
                // Numbers don't have more than one decimal or negative sign
                return NO;
            }
            else {   
                return YES;
            }
        }
    }
    else {
        return YES;
    }
}


#pragma mark- <UITextViewDelegate>

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"ClosetItemDetailsViewController.m:74   textViewShouldEndEditing()!");
    
    // can validate stuff here
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextField:textView up:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextField:textView up:NO];
}



@end
