//
//  AppDelegate.h
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import <FelloPush/IKonectNotificationsCallback.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,IKonectNotificationsCallback>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL interstitalFlg;

@end
