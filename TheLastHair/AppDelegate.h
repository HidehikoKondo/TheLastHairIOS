//
//  AppDelegate.h
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import <FelloPush/KonectNotificationsAPI.h>
#import <FelloPush/IKonectNotificationsCallback.h>

static NSString* appId = @"10361";      //felloのID プッシュ通知用

@interface AppDelegate : UIResponder <UIApplicationDelegate, IKonectNotificationsCallback>

@property (strong, nonatomic) UIWindow *window;

@end
