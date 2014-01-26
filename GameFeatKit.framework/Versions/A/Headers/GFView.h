//
//  GameFeat.h
//  GameFeat
//
//  Created by n-watanabe on 13/02/13.
//  Copyright (c) 2013年 Basicinc.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <StoreKit/StoreKit.h>

@protocol GFViewDelegate <NSObject>
- (void)didShowGameFeat;
- (void)didCloseGameFeat;
@end

@interface GFView : UIViewController <UIWebViewDelegate,SKStoreProductViewControllerDelegate> {
    //UIWebView *_webView;
    UIViewController *gfDelegate;
    NSURLConnection *httpConnection;
    NSMutableData *httpData;
    NSString *uuid;
    int requestType;
}

@property (nonatomic, retain) UIViewController *gfDelegate;
@property (nonatomic, retain) NSString *gfSiteId;
@property (nonatomic, retain) NSMutableArray *gfInstalledAdList;
@property (assign) id<GFViewDelegate> delegate;

- (void)start:(UIViewController *)parent site_id:(NSString *)site_id;
- (void)start:(UIViewController *)parent site_id:(NSString *)site_id delegate:(id<GFViewDelegate>)del;
- (BOOL)conversionCheck;

@end