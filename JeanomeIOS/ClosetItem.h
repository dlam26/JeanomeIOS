//
//  ClosetItem.h
//  JeanomeIOS
//
//  Holds a cached UIImage and info about a closet item. Basically same as the ClosetItem in Django
// 
//  Copying design from the AppRecord.m class in LazyTableImages!
//  
//
//  Created by david lam on 11/27/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClosetItem : NSObject
{
    NSString *itemId;
    NSString *note;
    NSString *category;
    NSString *imageURL;
    NSString *brand;
    NSDate *time;
    
    UIImage *image;
    UIImageView *imageView;
    
}

@property (nonatomic,retain) NSString *itemId;
@property (nonatomic,retain) NSString *note;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic,retain) NSString *brand;
@property (nonatomic,retain) NSDate *time;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UIImageView *imageView;

-(id)initWithImageDict:(NSDictionary *)imageDict andId:(NSString *)theId;

@end
