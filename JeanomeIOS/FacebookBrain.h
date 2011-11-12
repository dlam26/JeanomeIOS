//
//  FacebookBrain.h
//  JeanomeIOS
//
//  Created by David Lam on 11/11/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "Constants.h"

@interface FacebookBrain : NSObject <FBRequestDelegate, FBSessionDelegate>
{
    Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;


@end
