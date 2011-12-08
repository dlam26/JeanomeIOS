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
    NSString *userId;
    NSString *itemId;
    NSString *brand;
    NSNumber *value;
    NSString *note;
    NSString *category;
    NSString *imageURL;
    NSDate *time;

    UIImage *image;
    UIImageView *imageView;
}

@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *itemId;
@property(nonatomic,retain) NSString *brand;
@property(nonatomic,retain) NSNumber *value;
@property(nonatomic,retain) NSString *note;
@property(nonatomic,retain) NSString *category;
@property(nonatomic,retain) NSString *imageURL;

@property(nonatomic,retain) NSDate *time;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) UIImageView *imageView;

-(id)initWithImageDict:(NSDictionary *)imageDict andId:(NSString *)theId;

+(NSDictionary *)makeImageDict:(NSString *)itemId withNote:(NSString *)note 
                  withCategory:(NSString *)category withImageURL:(NSString *)imageURL
                     withBrand:(NSString *)brand withValue:(NSNumber *)value 
                      withTime:(NSString *)time withImage:(UIImage *)image
                     forUserId:(NSString *)userId;

+(NSString *)categoryNameToIdentifier:(NSString *)categoryName;

-(NSString *)getCategoryIdentifier;



@end
