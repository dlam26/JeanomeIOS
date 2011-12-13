//
//  Constants.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

// from http://blog.mbcharbonneau.com/2008/10/27/better-logging-in-objective-c/
//
//  maybe also see http://stackoverflow.com/questions/2207741/is-it-ok-to-submit-the-iphone-app-binary-with-nslog-statements  
//
#ifdef DEBUG
//#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DebugLog(__FORMAT__, ...) NSLog((@"%@:%d  %s " __FORMAT__), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(...) do {} while (0)
#endif



//#define JEANOME_TITLE @"Jeanome™"
#define JEANOME_TITLE @"Jeanome"

// NOTE: dont put trailing slash for these
#define JEANOME_URL_LOCAL @"http://localhost:8000"
#define JEANOME_URL_LOCAL2 @"http://10.0.1.23:8000"
#define JEANOME_URL_MERCEDES @"http//192.168.1.119:8000"
#define JEANOME_URL_STAGING @"http://staging.myjeanome.com"
#define JEANOME_URL_PRODUCTION @"http://myjeanome.com"


#ifdef DEBUG
#define JEANOME_URL JEANOME_URL_LOCAL2
#else
#define JEANOME_URL JEANOME_URL_PRODUCTION
#endif



//#define JEANOME_URL @"http://staging.myjeanome.com"

//  Important!  The id here needs to be concatenated with an fb 
//  and put in the "URL types" -> "URL Schemes" in the info.plist file
// 
//    example: fb281090161905701
// 
#define FACEBOOK_APP_ID_PRODUCTION @"264707123545649"
#define FACEBOOK_APP_ID_STAGING @"198027163600527"
#define FACEBOOK_APP_ID_DEV @"281090161905701"
#define FACEBOOK_APP_ID_DAVID_DEV @"126387207470405"


#define SETTING_JEANOME_URL @"jeanomeurl"

#define NOTIFICATION_CLOSET_ITEM_ADDED @"NotificationClosetItemAdded"
#define NOTIFICATION_CATEGORY_SELECTED @"NotificationCategorySelected"
