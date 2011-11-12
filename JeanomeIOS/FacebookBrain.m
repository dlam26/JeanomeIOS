//
//  FacebookBrain.m
//  JeanomeIOS
//
//  Created by David Lam on 11/11/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "FacebookBrain.h"

@implementation FacebookBrain

@synthesize facebook;

- (id)init {
    self = [super init];
    if (self) {
        // https://developers.facebook.com/docs/mobile/ios/build/#linktoapp
        self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID_DEV andDelegate:self];
        
    }
    return self;
}


@end
