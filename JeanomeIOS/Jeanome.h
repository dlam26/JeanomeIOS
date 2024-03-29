//
//  Jeanome.h
//  JeanomeIOS
//
//  Created by david lam on 12/5/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "Constants.h"
#import "ClosetItem.h"
#import "ASIFormDataRequest.h"


@protocol InputAccessoryDoneDelegate <NSObject>

@required
-(void)accessoryDone:(id)target;

@optional
-(void)accessoryNext:(id)target;
-(void)accessoryPrev:(id)target;

@end


@interface Jeanome : NSObject {
        
    NSString *facebookId;             // The current logged in users facebook id
    NSDictionary *facebookLoginDict;  // Dict storing the logged in users info
}

@property(nonatomic,retain) NSString *facebookId;
@property(nonatomic,retain) NSDictionary *facebookLoginDict;

-(id)initWithFacebook:(NSString *)id andDict:(NSDictionary *)dict;

// from 'cannyboy' at http://stackoverflow.com/questions/1083701/how-to-check-for-an-active-internet-connection-on-iphone-sdk
+(BOOL)isConnectedToInternet;

+(UIColor *)getJeanomeColor;
+(UIImageView *)getJeanomeLogoImageView;
+(CGRect)getNavigationBarFrame;

+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate;
+(UIView *)accessoryViewCreatePrevNextDoneInput:(id)delegate withFrame:(CGRect)frame;
+(UIView *)accessoryViewCreateDoneInput:(id)delegate;

+(NSString *)uploadToJeanome:(ClosetItem *)closetItem withImage:(UIImage *)img withUploadProgressDelegate:(id)progressDelegate andDelegate:(id)delegate;

+(NSHTTPCookie *)__createUploadCookie:(NSString *)name withValue:(NSString *)value;

+(NSString *)getAccessToken;

+(void)notificationBox:(UIView *)view withMsg:(NSString *)msg;

+(UIView *)newLoadingBox;
+(UIView *)newLoadingBox:(NSString *)loadingBoxText;

+(UIAlertView *)newNoInternetConnectionAlertView;
+(UIAlertView *)newNoInternetConnectionAlertView:(NSString *)errorMessage;

@end
