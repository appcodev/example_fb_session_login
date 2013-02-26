//
//  AppDelegate.h
//  Space iHero
//
//  Created by Chalermchon Samana on 2/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

//facebook 11 step set to appdelegate file
//https://developers.facebook.com/docs/howtos/login-with-facebook-using-ios-sdk
//facebook #1
#import <FacebookSDK/FacebookSDK.h>

//facebook #2
extern NSString *const FBSessionStateChangedNotification;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

//facebook #5
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
//facebook #10 close session
- (void)closeSession;

@end
