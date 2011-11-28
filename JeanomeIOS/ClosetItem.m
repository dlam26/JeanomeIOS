//
//  ClosetItem.m
//  JeanomeIOS
//
//  Created by david lam on 11/27/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ClosetItem.h"

@implementation ClosetItem

@synthesize itemId, note, category, imageURL, brand, time;
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
    self.time = [imageDict objectForKey:@"time"];   // TODO convert to NSDate
    return self;
}



@end
