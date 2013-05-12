//
//  AppsListViewController.h
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AdstirView.h"


@interface AppsListViewController : UIViewController<AdstirViewDelegate>
@property (nonatomic, retain) AdstirView* adview; //プロパティーで宣言すると、管理が簡単になります。
@property (weak, nonatomic) IBOutlet UIWebView *appWebView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;


@end
