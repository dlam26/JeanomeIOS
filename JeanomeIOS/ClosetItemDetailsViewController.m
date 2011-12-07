//
//  ClosetItemDetailsViewController.m
//  JeanomeIOS
//
//  Created by David Lam on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetItemDetailsViewController.h"

@implementation ClosetItemDetailsViewController

@synthesize delegate;
@synthesize editDetailsTable;
@synthesize closetItem;
@synthesize categoryTextField, priceTextField, brandTextField;
@synthesize categoryPicker;
@synthesize noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.titleView = [Jeanome getJeanomeLogoImageView];

    }
    return self;
}

// see TakePhotoViewController.m:438 in editDetails()
-(id)initWithClosetItem:(ClosetItem *)item
{
    self = [super init];
    if (self) {
        self.closetItem = item;        
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

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_saveClosetItemDetails:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self registerForKeyboardNotifications];
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
    12/6/2011   hmm don't think need to pass withImageURL anything because its set 
                from the Python code after you upload
 */
-(void)_saveClosetItemDetails:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    if ([self.categoryTextField.text length] == 0 || [self.brandTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Doh!" 
                                                        message:@"Category and brand are required." 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];        
    }
    else {
        
        NSDictionary *imageDict = [ClosetItem makeImageDict:nil withNote:self.noteTextView.text
                                               withCategory:self.categoryTextField.text withImageURL:nil withBrand:self.brandTextField.text withValue:[nf numberFromString:self.priceTextField.text] withTime:[df stringFromDate:[NSDate date]] withImage:itemImageView.image];
        [self.delegate saveDetails:imageDict];
        
        [df release]; [nf release];
            
        // Now, with everthing saved, go back to the TakePhotoViewController    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == categoryTextField) {
        
        return NO;
    }
    else
        return YES;        
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //NSLog(@"ClosetItemDetailsViewController.m:133   textFieldShouldEndEditing()!");
    
    // TODO    check/valid the input for the field here   e.g. price can't be negative
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    selectedField = nil;
}

/*
    http://stackoverflow.com/questions/433337/iphone-sdk-set-max-character-length-textfield
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    //  cost/value field can have at most 7 digits:  `value` decimal(7,2) NOT NULL
    // 
    if([textField isEqual:priceTextField]) {
        
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
            else if([nf numberFromString:newCost] < 0) {
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"ClosetItemDetailsViewController.m:142   textFieldShouldReturn()!");
    
    //  When hitting 'Next' on the keyboard, it should go to the next field
    // 
    if (textField == categoryTextField) {
        [priceTextField becomeFirstResponder];
    }
    else if(textField == priceTextField) {
        [brandTextField becomeFirstResponder];
    }
    else if(textField == brandTextField) {
        [noteTextView becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    return NO;
}


#pragma mark - <UITextViewDelegate>    ...for note field

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NSLog(@"ClosetItemDetailsViewController.m:202   textViewShouldBeginEditing()");    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    NSLog(@"ClosetItemDetailsViewController.m:209   textViewDidBeginEditing()");
    
    textView.textColor = [UIColor blackColor];
    
    // clear out the psuedo-placeholder text in the description UITextView
    if([textView.text isEqualToString:DEFAULT_NOTE_PLACEHOLDER]) {
        textView.text = @"";
    }
    
    selectedField = textView;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    NSLog(@"ClosetItemDetailsViewController.m:214   textViewShouldEndEditing()");
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    NSLog(@"ClosetItemDetailsViewController.m:223   textViewDidEndEditing()");
}

/*
    12/5/2011  Put in a ghetto thing to limit the size of what's typed 
    into MAX_LENGTH because UITextView is a UIScrollView and I 
    don't like the scroll view inside a scroll view thing.  
    (see line 410 where i set tv.scrollEnabled = NO;
 
    Besides, I dont think you'd want to type that much anyways.            
 */ 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger currLength = [textView.text length];
    NSUInteger replacementLength = [text length];
    NSUInteger MAX_LENGTH = 350;
    
    if(replacementLength + currLength <= currLength) {
        return YES;                         // always allow delete
    }
    else if(currLength < MAX_LENGTH) {
        return YES;                         // no more than MAX_LENGTH characters
    }
    else {
        return NO;
    }

}


#pragma mark - <UIPickerViewDelegate> 

// for the category select

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0) {
        return @"";
    }
    else if(row == 1) {
        return @"Shoes";
    }
    else {
        return @"Bags";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    categoryTextField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [categoryTextField resignFirstResponder];
}

#pragma mark - <UIPickerViewDataSource> 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/*  Should return the number of categories unlocked for the current user.
 */ 
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}


/*
    Can't put a inputAccessoryView in a UIPicker, so do some workaround with
    a UIActionSheet
 
    http://stackoverflow.com/questions/5591815/how-to-add-a-done-button-over-the-pickerview

    called from ClosetItemDetailsViewController.m:377  UITapGestureRecognizer
 */

-(void)_showCategoryPicker
{
    NSLog(@"ClosetItemDetailsViewController.m:293   _showCategoryPicker()");
    
    [selectedField resignFirstResponder];
    
    categoryPicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 270)] autorelease];
    categoryPicker.delegate = self;
    categoryPicker.dataSource = self;
    categoryPicker.showsSelectionIndicator = YES;
    
    UIView *toolbar = [Jeanome accessoryViewCreatePrevNextDoneInput:self];

    
    categoryActionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil] autorelease];
    [categoryActionSheet addSubview:toolbar];
    [categoryActionSheet addSubview:categoryPicker];
    [categoryActionSheet showInView:self.view.superview];
    [categoryActionSheet setBounds:CGRectMake(0,0,320, 400)];
    

    selectedField = categoryTextField;
    
    if([[categoryTextField text] isEqualToString:@"Shoes"]) {
        [categoryPicker selectRow:1 inComponent:0 animated:NO];
    }
    else if([[categoryTextField text] isEqualToString:@"Bags"]) {
        [categoryPicker selectRow:2 inComponent:0 animated:NO];
    }
}

#pragma mark - <UITableViewDataSource>

// first section is for the photo, second section is for editing the details, third is for the description
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    }
    else if(section == 1) {
        return 3;
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return nil;
    }
    if(section == 1) {        
        return @"Item Details";
    }
    else {
        return nil;
    }

}

/*
    Shows rows of editable fields in cells where,
 
        The first cell contains an image of the current closet item
        The rest contain a one line editable field
        The last is the 'note' for the closet item
 
 http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell
 
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }    
    
    // 12/5/2011 reused table cells are stacking on top of each other and messing up screen
    if ([[cell subviews] count] > 1) {
        return cell;
    }

    if([indexPath section] == 0) {    // Just holds the ClosetItem image
        
        itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 0.0, 140.0, 140.0)];                
        itemImageView.image = closetItem.image;                          
        [cell addSubview:itemImageView];
        
        // get rid of the cell borders
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }    
    else if([indexPath section] == 1) {
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 195, 30)];
        tf.adjustsFontSizeToFitWidth = YES;
        tf.textColor = [UIColor blackColor];
        
        if([indexPath row] == 0) {
            tf.placeholder   = @"(Required)";
            /*
            tf.keyboardType  = UIKeyboardTypeDefault;
            tf.returnKeyType = UIReturnKeyNext;
             */
            tf.text = closetItem.category;
            
            categoryTextField = tf;
            
            //  use a category select picker instead of a text field
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_showCategoryPicker)];            
            [tf addGestureRecognizer:tap];
        }
        else if([indexPath row] == 1) {
            tf.placeholder   = @"$";
            tf.keyboardType  = UIKeyboardTypeDecimalPad;
            //tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            tf.returnKeyType  = UIReturnKeyNext;
            tf.text = closetItem.value ? [NSString stringWithFormat:@"%@", closetItem.value] : @"";
            priceTextField    = tf;
        }
        else if([indexPath row] == 2) {
            tf.placeholder   = @"(Required)";
            tf.keyboardType  = UIKeyboardTypeDefault;
            tf.returnKeyType = UIReturnKeyNext;
            tf.text          = closetItem.brand;
            brandTextField   = tf;
        }
        
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tf.textAlignment = UITextAlignmentLeft;
        tf.tag = 0;
        tf.clearButtonMode = UITextFieldViewModeNever;
        tf.inputAccessoryView = [Jeanome accessoryViewCreatePrevNextDoneInput:self];
        tf.delegate = self;

        [tf setEnabled:YES];
        [cell addSubview:tf];
        [tf release];
    }
    else {
        // the 'note'
        
        //   12/5/2011  This dosen't seem to work, it goes outside of 
        //   the cell border and stuff
        // 
        // CGRect textViewFrame = CGRectMake(10.0, 10.0, cell.frame.size.width-10.0, cell.frame.size.height-10.0);
        
        CGRect textViewFrame = CGRectMake(15.0, 5.0, 295.0, 165.0);
        
        UITextView *tv = [[UITextView alloc] initWithFrame:textViewFrame];
        
        if(!closetItem.note) {
            tv.text = DEFAULT_NOTE_PLACEHOLDER;
            tv.textColor = [UIColor lightGrayColor];
        }
        else {
            tv.text = closetItem.note;
        }            

        tv.inputAccessoryView = [Jeanome accessoryViewCreatePrevNextDoneInput:self];
        // tv.scrollEnabled = NO;
        tv.delegate = self;
        
        [tv setFont:[UIFont systemFontOfSize:18.0]];
        [tv setEditable:YES];
                
        [cell addSubview:tv];
        
        noteTextView = tv;        
    }
    
    // Put in the text labels
    
    if ([indexPath section] == 1) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Category";
        }
        else if ([indexPath row] == 1) {
            cell.textLabel.text = @"Price";
        }
        else if([indexPath row] == 2) {
            cell.textLabel.text = @"Brand";
        }
    }
    else {
        // no text label for the description
    }
    
    //  Properties that should be applied to all cells:

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return cell;
}


#pragma mark - <UITableViewDelegate>


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return tableView.rowHeight * 3.0;   // holds the picture
    }    
    else if(indexPath.section == 2) {
        return tableView.rowHeight * 4.0;   // e.g. the description box
    }
    else {
        return tableView.rowHeight;
    }
}

#pragma mark - <UIScrollViewDelegate>

/*
    Used to normalize how much we need to scroll/animate screen when clicking on a text field
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    verticalOffset = scrollView.contentOffset.y;

    // NSLog(@"ClosetItemDetailsViewController.m:559  scrollViewDidScroll  %f", verticalOffset);
}

#pragma mark - <InputAccessoryDoneDelegate>!!!  (in Jeanome.h)

-(void)accessoryNext
{
    if(selectedField) { 
        if(selectedField == categoryTextField) {
            [self accessoryDone];
            [self _accessoryActivate:priceTextField];
        }
        else if(selectedField == priceTextField) {
            [self _accessoryActivate:brandTextField];
        }
        else if(selectedField == brandTextField) {
            [self _accessoryActivate:noteTextView];
        }   
        else if(selectedField == noteTextView) {
            [self _accessoryActivate:categoryTextField];
        }
    }
}

-(void)accessoryPrev
{
    if(selectedField) {        
        if(selectedField == categoryTextField) {
            [self accessoryDone];
            [self _accessoryActivate:noteTextView];
        }
        else if(selectedField == priceTextField) {
            [self _accessoryActivate:categoryTextField];
        }
        else if(selectedField == brandTextField) {
            [self _accessoryActivate:priceTextField];
        }
        else if(selectedField == noteTextView) {
            [self _accessoryActivate:brandTextField];
        }
    }    
}

-(void)accessoryDone
{
    if(selectedField == categoryTextField) {
        // also need to get rid of the UIPicker if it's there

        if(categoryActionSheet)
            [categoryActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    [selectedField resignFirstResponder];
}

-(void)_accessoryActivate:(id)field 
{
    if(field == categoryTextField) {
        
        [selectedField resignFirstResponder];
        [self _showCategoryPicker];
    }
    else {
        [field becomeFirstResponder];
    }
    
    selectedField = field;
}


#pragma mark - OTHER

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

/*
    from "Moving Content That Is Located Under the Keyboard"
    http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
 */
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
//    NSLog(@"ClosetItemDetailsViewController.m:693   keyboardWasShown()");
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    editDetailsTable.contentInset = contentInsets;
    editDetailsTable.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (CGRectContainsPoint(aRect, selectedField.frame.origin) ) {
        
        CGFloat adjustedY;
        
        adjustedY = selectedField.frame.origin.y + kbSize.height;
        
        if(selectedField == priceTextField)
            adjustedY -= 30;
        else if(selectedField == noteTextView)
            adjustedY += 70;
                
                
        CGPoint scrollPoint = CGPointMake(0.0, adjustedY);
        [editDetailsTable setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    NSLog(@"ClosetItemDetailsViewController.m:715   keyboardWillBeHidden()");
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    editDetailsTable.contentInset = contentInsets;
    editDetailsTable.scrollIndicatorInsets = contentInsets;
}

@end
