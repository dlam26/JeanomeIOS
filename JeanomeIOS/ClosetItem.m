//
//  ClosetItem.m
//  JeanomeIOS
//
//  Created by david lam on 11/27/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetItem.h"

@implementation ClosetItem

@synthesize itemId, note, category, imageURL, brand, value, time;
@synthesize image, imageView;

- (void)dealloc {
    [itemId release];
    [note release];
    [category release];
    [imageURL release];
    [image release];
    [brand release];
    [time release];
    [super dealloc];
}

/* 
    Where imageDict is an image returned from the Jeanome JSON API
 */
-(id)initWithImageDict:(NSDictionary *)imageDict andId:(NSString *)theId
{
    self.itemId = theId;
    self.note = [imageDict objectForKey:@"note"];
    self.category = [imageDict objectForKey:@"category"];
    self.imageURL = [imageDict objectForKey:@"image"];
    // self.image = SET ELSEWHERE
    self.brand = [imageDict objectForKey:@"brand"];
    self.value = [imageDict objectForKey:@"value"];
    self.time = [imageDict objectForKey:@"time"];   // TODO convert to NSDate
    return self;
}

+(NSDictionary *)makeImageDict:(NSString *)itemId withNote:(NSString *)note 
                  withCategory:(NSString *)category withImageURL:(NSString *)imageURL
                     withBrand:(NSString *)brand withValue:(NSNumber *)value 
                      withTime:(NSString *)time
{
//    NSDictionary *toReturn = [NSDictionary dictionaryWithObjectsAndKeys:itemId, @"id", note, @"note", category, @"category", imageURL, @"image", brand, @"brand", time, @"time", nil];
    
    NSDictionary *toReturn = [NSMutableDictionary dictionary];
    [toReturn setValue:itemId forKey:@"id"];
    [toReturn setValue:note forKey:@"note"];
    [toReturn setValue:category forKey:@"category"];
    [toReturn setValue:imageURL forKey:@"image"];
    [toReturn setValue:brand forKey:@"brand"];
    [toReturn setValue:value forKey:@"value"];
    [toReturn setValue:time forKey:@"time"];
    
    return toReturn;
}

+(NSString *)categoryNameToIdentifier:(NSString *)categoryName
{
    NSString *categoryAbbreviation;
    
    if ([categoryName isEqual:@"Shoes"])
        categoryAbbreviation = @"S";    
    else if ([categoryName isEqual:@"Bags"])
        categoryAbbreviation = @"B";
    else if ([categoryName isEqual:@"Makeup"])
        categoryAbbreviation = @"M";
    else if ([categoryName isEqual:@"Jeans"])
        categoryAbbreviation = @"J";
    else if ([categoryName isEqual:@"Clothes"])
        categoryAbbreviation = @"C";
    else if ([categoryName isEqual:@"Electronics"])
        categoryAbbreviation = @"E";
    else 
        categoryAbbreviation = @"S";
    
    return categoryAbbreviation;
}

-(NSString *)getCategoryIdentifier
{
    return [ClosetItem categoryNameToIdentifier:self.category];
}

@end
