//
//  Jeanome.m
//  JeanomeIOS
//
//  Created by david lam on 12/5/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Jeanome.h"

@implementation Jeanome 

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)];    
    imageView.image = logo;
    
    //    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_logo_toolbar"]] autorelease];
    
    
    return imageView;
}


/*
    Toolbar with 3 buttons:
 
        Prev - Calls accessoryPrev()
        Next - Calls accessoryNext()
        Done - Calls accessoryDone()
 
 */
+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate
{
    UIToolbar *prevNextDoneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 30.0)];
    
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

+(UIView *)accessoryViewCreateDoneInput:(id)target withDelegate:(id)delegate
{
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 30.0)];
    
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



@end
