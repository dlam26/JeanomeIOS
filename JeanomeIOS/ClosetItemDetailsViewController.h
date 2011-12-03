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


@interface ClosetItemDetailsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *categoryTextField;
    IBOutlet UITextField *brandTextField;
    IBOutlet UITextField *costTextField;
    IBOutlet UITextView *noteTextView;
    IBOutlet UIScrollView *scrollView;
    
    id <PhotoDetailsDelegate> delegate;
    
    ClosetItem *ci;
}

@property(nonatomic,retain) IBOutlet UITextField *categoryTextField;
@property(nonatomic,retain) IBOutlet UITextField *brandTextField;
@property(nonatomic,retain) IBOutlet UITextField *costTextField;
@property(nonatomic,retain) IBOutlet UITextView *noteTextView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) id <PhotoDetailsDelegate> delegate;
@property(nonatomic,retain) ClosetItem *ci;

-(id)initWithClosetItem:(ClosetItem *)closetItem;

-(IBAction)saveDetails:(id)sender;


@end
