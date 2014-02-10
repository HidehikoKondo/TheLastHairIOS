//
//  IKonectCallback.h
//  mobile-platform
//
//  Created by rudo on 2013/02/13.
//
//

#import <Foundation/Foundation.h>

@protocol IKonectNotificationsCallback<NSObject>

@optional
- (void)onLaunchFromNotification:(NSString*)notificationsId message:(NSString*)message extra:(NSDictionary*)extra;

@optional
- (void)onCompleteAdRequest:(BOOL)success;

@end
