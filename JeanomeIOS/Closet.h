//
//  Closet.h
//  JeanomeIOS
//
//  Created by David Lam on 11/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface Closet : NSObject <UITableViewDataSource, UITableViewDelegate> {
    
    NSDictionary *closetInfo;
}

@property(retain,nonatomic) NSDictionary *closetInfo;

-(id)initWithJSON:(NSString *)json;
-(NSString *)getName;
-(NSString *)getSquarePhoto;
-(NSString *)getFollowers;
-(NSString *)getFollowing;
-(NSString *)getStatus;
-(NSDecimalNumber *)getPoints;

-(NSString *)__defaultWith:(NSString *)aDefault ifThisIsNull:(id)val;

@end
