//
//  Jeanome.h
//  JeanomeIOS
//
//  Created by david lam on 12/5/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InputAccessoryDoneDelegate <NSObject>

@required
-(void)accessoryDone:(id)target;

@optional
-(void)accessoryNext:(id)target;
-(void)accessoryPrev:(id)target;

@end


@interface Jeanome : NSObject {
    
    
}

+(UIColor *)getJeanomeColor;
+(UIImageView *)getJeanomeLogoImageView;

+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate;
+(UIView *)accessoryViewCreateDoneInput:(id)target withDelegate:(id)delegate;

@end
