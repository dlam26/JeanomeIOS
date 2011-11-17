//
//  Closet.m
//  JeanomeIOS
//
//  Created by David Lam on 11/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//
//
//  See jeanome/api/views.py:17 closet()
//

#import "Closet.h"

@implementation Closet
    
@synthesize closetInfo;

-(id)initWithJSON:(NSString *)json
{    
    NSLog(@"Closet.m:20   json: %@", json);
    
    self.closetInfo = [json JSONValue];
    return self;
}


-(NSString *)getName
{
    return [self.closetInfo objectForKey:@"name"];
}

-(NSDecimalNumber *)getPoints
{
    //NSLog(@"Closet.m:34  getPoints(): %@", [self.closetInfo objectForKey:@"points"]);
    
    return [self.closetInfo objectForKey:@"points"];
}

-(NSString *)getSquarePhoto
{
    return [self.closetInfo objectForKey:@"square_photo"];
}

-(NSString *)getFollowers
{
    NSLog(@"Closet.m:46  getFollowers(): %@", [self.closetInfo objectForKey:@"followers"]);
    
    return [self.closetInfo objectForKey:@"followers"];
}

-(NSString *)getFollowing
{
    return [self.closetInfo objectForKey:@"following"];
}

-(NSString *)getStatus
{
    return [self.closetInfo objectForKey:@"status"];
}

@end
