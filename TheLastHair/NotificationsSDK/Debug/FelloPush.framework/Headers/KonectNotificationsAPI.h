//
//  KonectSdk.h
//  mobile-platform
//
//  Created by rudo on 2013/02/05.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IKonectNotificationsCallback.h"

@interface KonectNotificationsAPI : NSObject

+ (void)initialize:(NSObject<IKonectNotificationsCallback>*)callback
     launchOptions:(NSDictionary*)launchOptions
             appId:(NSString*)appId
            isTest:(BOOL)isTest;
+ (void)setRootView:(UIViewController*)root;
+ (void)setupNotifications:(NSData*)devToken;
+ (void)setupNotificationsWithString:(NSString*)devToken;
+ (void)processLocalNotifications:(UILocalNotification*)notification;
+ (BOOL)processNotifications:(NSDictionary*)userInfo;
+ (void)beginInterstitial;
+ (void)cancelInterstitial;
+ (UILocalNotification*)scheduleLocalNotification:(NSString*)text at:(NSDate*)dateTime label:(NSString*)label;
+ (void)ignoreLocalNotification:(UILocalNotification*)notification;
+ (void)cancelLocalNotification:(UILocalNotification*)notification;

@end
