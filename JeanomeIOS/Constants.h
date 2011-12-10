//
//  Constants.h
//  JeanomeIOS
//
//  Created by David Lam on 11/9/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define JEANOME_TITLE @"Jeanome™"
#define JEANOME_TITLE @"Jeanome"

#define JEANOME_URL_LOCAL @"http://localhost:8000"
#define JEANOME_URL_LOCAL2 @"http://10.0.1.23:8000"
#define JEANOME_URL_MERCEDES @"http//192.168.1.119:8000"
#define JEANOME_URL_STAGING @"http://staging.myjeanome.com"
#define JEANOME_URL_PRODUCTION @"http://myjeanome.com"

// NOTE: dont put trailing slash kk
#define JEANOME_URL @"http://localhost:8000"

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
