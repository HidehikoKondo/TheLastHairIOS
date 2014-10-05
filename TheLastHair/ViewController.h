//
//  ViewController.h
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdstirView.h"
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GAITrackedViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import <GameFeatKit/GFView.h>
#import <GameFeatKit/GFController.h>

//@interface ViewController : UIViewController<AdstirViewDelegate,GKLeaderboardViewControllerDelegate>
@interface ViewController : GAITrackedViewController<AdstirViewDelegate,GKLeaderboardViewControllerDelegate,GADInterstitialDelegate,GFViewDelegate>{
    // インスタンス変数として 1 つ宣言する
    GADInterstitial *interstitial_;
}


- (IBAction)displayGameFeat:(id)sender;
@property (nonatomic, retain) AdstirView* adview; //プロパティーで宣言すると、管理が簡単になります。
- (IBAction)tweetButton:(id)sender;
- (IBAction)likeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *appsButton;
- (IBAction)lineButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gamefeatButton;
//@property (weak, nonatomic) IBOutlet UIImageView *gamefeatImage;

@end
