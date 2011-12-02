//
//  Closet.h
//  JeanomeIOS
//
//  Created by David Lam on 11/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ClosetItem.h"

@interface Closet : NSObject <UITableViewDataSource, UITableViewDelegate> {
    
    NSDictionary *closetInfo;
    
    NSMutableDictionary *closetItems;
}

@property(retain,nonatomic) NSDictionary *closetInfo;
@property(retain,nonatomic) NSMutableDictionary *closetItems;

-(id)initWithJSON:(NSString *)json;
-(NSString *)getName;
-(NSString *)getSquarePhoto;
-(NSString *)getFollowers;
-(NSString *)getFollowing;
-(NSString *)getStatus;
-(NSDecimalNumber *)getPoints;

-(NSArray *)getClosetItemsArray;

-(void)setClosetItem:(ClosetItem *)closetItem forItemId:(NSString *)itemId;

-(NSString *)__defaultWith:(NSString *)aDefault ifThisIsNull:(id)val;

@end
