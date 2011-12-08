//
//  ClosetItemDetailsViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Jeanome.h"
#import "ClosetItem.h"
//#import "AppDelegate.h"

#define DEFAULT_NOTE_PLACEHOLDER @"Say something"


@protocol PhotoDetailsDelegate <NSObject>

@required
-(void)saveDetails:(NSDictionary *)details;

@end


@interface ClosetItemDetailsViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate>
{
    id <PhotoDetailsDelegate> delegate;
    ClosetItem *closetItem;
    
    IBOutlet UITableView *editDetailsTable;
    CGFloat verticalOffset;
    
    UIImageView *itemImageView;
    UITextField *categoryTextField;
    UITextField *costTextField;
    UITextField *brandTextField;
    UITextView *noteTextView;    

    UIView *selectedField;   // set to one of the four things above when selected
    
    UIPickerView *categoryPicker;
    UIActionSheet *categoryActionSheet;
}

@property(nonatomic,retain) id <PhotoDetailsDelegate> delegate;
@property(nonatomic,retain) ClosetItem *closetItem;

@property(nonatomic,retain) IBOutlet UITableView *editDetailsTable;


@property(nonatomic,retain) UITextField *categoryTextField;
@property(nonatomic,retain) UITextField *costTextField;
@property(nonatomic,retain) UITextField *brandTextField;
@property(nonatomic,retain) UITextView *noteTextView;

@property(nonatomic,retain) UIPickerView *categoryPicker;
@property(nonatomic,retain) UIActionSheet *categoryActionSheet;

-(id)initWithClosetItem:(ClosetItem *)item;

-(void)_saveClosetItemDetails:(id)sender;
-(void)_showCategoryPicker;
-(void)_accessoryActivate:(id)field;
-(void)accessoryDone;

- (void)registerForKeyboardNotifications;

// selectors
-(void)hideInputs;

@end
