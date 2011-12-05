//
//  ClosetItemDetailsViewController.h
//  JeanomeIOS
//
//  Created by David Lam on 12/2/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ClosetItem.h"

@protocol PhotoDetailsDelegate <NSObject>

@required
-(void)saveDetails:(NSDictionary *)details;

@end


@interface ClosetItemDetailsViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextField *categoryTextField;
    IBOutlet UITextField *brandTextField;
    IBOutlet UITextField *costTextField;
    IBOutlet UITextField *noteTextField;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITableView *editDetailsTable;
    IBOutlet UIImageView *closetItemImageView;
    
    id <PhotoDetailsDelegate> delegate;
    
    ClosetItem *ci;
}

@property(nonatomic,retain) IBOutlet UITextField *categoryTextField;
@property(nonatomic,retain) IBOutlet UITextField *brandTextField;
@property(nonatomic,retain) IBOutlet UITextField *costTextField;
@property(nonatomic,retain) IBOutlet UITextField *noteTextField;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UITableView *editDetailsTable;
@property(nonatomic,retain) IBOutlet UIImageView *closetItemImageView;
@property(nonatomic,retain) id <PhotoDetailsDelegate> delegate;
@property(nonatomic,retain) ClosetItem *closetItem;

-(id)initWithClosetItem:(ClosetItem *)item;

-(IBAction)saveDetails:(id)sender;


@end
