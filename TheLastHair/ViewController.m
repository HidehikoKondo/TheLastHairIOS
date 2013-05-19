//
//  ViewController.m
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MrdIconSDK/MrdIconSDK.h>


#define TWEETTITLE   @"Twitterにサインインしてね"
#define TWEETMESSAGE @"iPhoneの「設定」→「Twitter」→ユーザー名とパスワードを入力して「サインイン」をタップ"
#define TWEETCANCEL  @"キャンセル"
#define TWEETDEFAULT @"テスト #udonkonet"
#define SOCIALTEXT   @"ばかも〜ん！！　最後の１本を抜くヤツがあるか〜！！"
#define APPURL       @"https://itunes.apple.com/jp/app/hage-qin-fu-duan-fa-shi/id570377317?mt=8&uo=4"



@interface ViewController (){
    NSUserDefaults *score;  //スコア保存用
    
}
@property (nonatomic, retain) MrdIconLoader* iconLoader;

@end

@interface ViewController(MrdIconLoaderDelegate)<MrdIconLoaderDelegate>
@end

@implementation ViewController
@synthesize iconLoader = _iconLoader;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //ゲームセンター
    NSLog(@"ゲームセンター対応チェック%d",isGameCenterAPIAvailable());
    //ゲームセンター対応の有効なバージョンならログイン画面を出す
    if(isGameCenterAPIAvailable() == 1){
        [self authenticateLocalPlayer];
    }
    
    //スコアを読み出し
    score = [NSUserDefaults standardUserDefaults];
    
    
    //アスタ表示
    [self displayIconAdd];
    
    
    
}

-(void)displayIconAdd{
    //表示するY座標をUDONKOAPPSボタンと同じにする
    NSInteger iconY = _appsButton.frame.origin.y;
    
    // The array of points used as origin of icon frame
	CGPoint origins[] = {
		{23, iconY},
        {222, iconY}
    };
    
    MrdIconLoader* iconLoader = [[MrdIconLoader alloc]init]; // (1)
    self.iconLoader = iconLoader;
	iconLoader.delegate = self;
//	IF_NO_ARC([iconLoader release];)

    
    
    for (int i=0; i < 2; i++)
	{
        CGRect frame;                                                       //frame
        frame.origin = origins[i];                                          //位置
        frame.size = kMrdIconCell_DefaultViewSize;                          //サイズ75x75
        MrdIconCell* iconCell = [[MrdIconCell alloc]initWithFrame:frame];   //セル生成
        [iconLoader addIconCell:iconCell];                                  //セル追加
        [self.view addSubview:iconCell];                                    //セル配置
        [iconLoader startLoadWithMediaCode: @"id570377317"];                //ID設定
        _iconLoader = iconLoader; 
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//他のメソッドは省略します。
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //Adstir表示
	// MEDIA-ID,SPOT-NOには、管理画面で発行されたメディアID, 枠ナンバーを埋め込んでください。
	// 詳しくはhttp://wiki.ad-stir.com/%E3%83%A1%E3%83%87%E3%82%A3%E3%82%A2ID%E5%8F%96%E5%BE%97をご覧ください。
	//画面取得
    UIScreen *sc = [UIScreen mainScreen];
    
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    NSLog(@"%.1f, %.1f", rect.size.width, rect.size.height);
    
//    self.adview = [[AdstirView alloc]initWithOrigin:CGPointMake(0, rect.size.height-50)];
    self.adview = [[AdstirView alloc]initWithOrigin:CGPointZero];
    self.adview.media = @"MEDIA-f5977393";
	self.adview.spot = 1;
	self.adview.rootViewController = self;
	[self.adview start];
	[self.view addSubview:self.adview];
    
    //リーダーボードにハイスコアを送信
    [self sendLeaderboard];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.adview stop];
	[self.adview removeFromSuperview];
	self.adview.rootViewController = nil;
	self.adview = nil;
	[super viewWillDisappear:animated];
    
    
}


- (IBAction)likeButton:(id)sender {
    //音再生
    [self playSound:@"ok"];
    
    //バージョン確認
    NSString *version = [[UIDevice currentDevice]systemVersion];
    NSLog(@"Version %@", version);
    
    // iOS 6
    if([ version floatValue] >= 6.0) {
        SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookPostVC setInitialText:[NSString stringWithFormat:@"%@　【ハゲ親父断髪式：最高記録 %d本抜き】",SOCIALTEXT, [score integerForKey:@"SCORE"]]];
        [facebookPostVC addImage:[UIImage imageNamed:@"icon512.png"]];
        [facebookPostVC addURL:[NSURL URLWithString:APPURL]];
        
        [self presentViewController:facebookPostVC animated:YES completion:nil];
    }else{
        NSLog(@"FB未対応");
        UIAlertView *alert =
        [[UIAlertView alloc]initWithTitle:@"未対応じゃ！"
                                  message:@"facebookに投稿するには\n最新のiOSにアップデートしてね"
                                 delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK", nil
         ];
        
        [alert show];
    }
}
- (IBAction)tweetButton:(id)sender {
    //再生
    [self playSound:@"ok"];
    
    
    if(NSClassFromString(@"SLComposeViewController")) {
        // Social Frameworkが使える
        SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPostVC setInitialText:[NSString stringWithFormat:@"%@　【ハゲ親父断髪式：最高記録 %d本抜き】#udonkonet",SOCIALTEXT, [score integerForKey:@"SCORE"]]];
        [twitterPostVC addImage:[UIImage imageNamed:@"icon512.png"]];
        [twitterPostVC addURL:[NSURL URLWithString:APPURL]];
        [self presentViewController:twitterPostVC animated:YES completion:nil];
        
    }
    else {
        // いままで通りの方法 (iOS5)
        // ビューコントローラの初期化
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        // 送信文字列を設定
        [tweetViewController setInitialText:[NSString stringWithFormat:@"%@　【ハゲ親父断髪式：最高記録 %d本抜き】#udonkonet",SOCIALTEXT, [score integerForKey:@"SCORE"]]];
        
        // 送信画像を設定
        [tweetViewController addImage:[UIImage imageNamed:@"icon512.png"]];
        
        // イベントハンドラ定義
        tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (res == TWTweetComposeViewControllerResultCancelled) {
                NSLog(@"キャンセル");
            }
            else if (res == TWTweetComposeViewControllerResultDone) {
                NSLog(@"成功");
            }
            [self dismissModalViewControllerAnimated:YES];
        };
        
        // 送信View表示
        [self presentModalViewController:tweetViewController animated:YES];
        
    }
}

#pragma mark - 音声処理関係
-(void) playSound:(NSString *)filename{
    //OK音再生
    SystemSoundID soundID;
    NSURL* soundURL = [[NSBundle mainBundle] URLForResource:filename
                                              withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound (soundID);
}

//画面遷移時に呼び出すメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender tag] == 11){
        [self playSound:@"start"];
    }else{
        [self playSound:@"ok"];
    }
}

#pragma mark - ゲームセンター
//ゲームセンター関係の処理

//ゲームセンターに接続できるかどうかの確認処理
BOOL isGameCenterAPIAvailable()
{
    // GKLocalPlayerクラスが存在するかどうかをチェックする
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) !=
    nil;
    // デバイスはiOS 4.1以降で動作していなければならない
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (localPlayerClassAvailable && osVersionSupported);
}

//Gamecenterに接続する処理
- (void) authenticateLocalPlayer
{
    //バージョン確認
    NSString *version = [[UIDevice currentDevice]systemVersion];
    NSLog(@"Version %@", version);
    
    // iOS 6
    if([ version floatValue] >= 6.0) {
        GKLocalPlayer* player = [GKLocalPlayer localPlayer];
        player.authenticateHandler = ^(UIViewController* ui, NSError* error )
        {
            if( nil != ui )
            {
                [self presentViewController:ui animated:YES completion:nil];
            }
            else if( player.isAuthenticated )
            {
                // 認証に成功
                NSLog(@"ios6:認証OK");
            }
            else
            {
                // 認証に失敗
                NSLog(@"ios6:認証NG");
            }
        };
    }else{
        //ios5.1以前
        GKLocalPlayer* player = [GKLocalPlayer localPlayer];
        [player authenticateWithCompletionHandler:^(NSError* error)
         {
             if( player.isAuthenticated )
             {
                 // 認証に成功
                 NSLog(@"ios5:認証OK");
                 
             }
             else
             {
                 // 認証に失敗
                 NSLog(@"ios5:認証NG");
                 
             }
         }];
        
        
    }
}


//リーダーボードを立ち上げる
//UIButtonなどにアクションを関連づけて使用します。
//ランキングを表示する画面が表示されます。

-(IBAction)showBord
{
    //音再生
    [self playSound:@"ok"];
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [self presentViewController: leaderboardController animated: YES completion:nil];
    }
}

//リーダーボードで完了を押した時に呼ばれる（リーダーボードを閉じる処理）
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)sendLeaderboard{
    //リーダーボードに値を送信
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"ItazuraRanking"];
    NSInteger scoreR;
    //scoreRにゲームのスコアtapCountを格納
    scoreR = [score integerForKey:@"SCORE"];
    scoreReporter.value = scoreR;
    
    //scoreRepoterにハイスコアを格納
    //ハイスコアを送信
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
            NSLog(@"error %@",error);
        }else{
            // リーダーボードに値を送信
            NSLog(@"リーダーボードに値を送信");
        }
    }];
}




- (void)viewDidUnload {
    [self setAppsButton:nil];
    [super viewDidUnload];
}
- (IBAction)lineButton:(id)sender {
    //音再生
    [self playSound:@"ok"];
    
    // LINE に直接遷移。contentType で画像を指定する事もできる。アプリが入っていない場合は何も起きない。
    NSString *contentType = @"text";
    NSString *plainString = [NSString stringWithFormat:@"%@\n【ハゲ親父断髪式：最高記録 %d本抜き】\n%@",
                             SOCIALTEXT,
                             [score integerForKey:@"SCORE"],
                             APPURL ];
    
    // escape
    NSString *contentKey = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                        NULL,
                                                                                        (CFStringRef)plainString,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8 );
    NSString *urlString2 = [NSString
                            stringWithFormat:@"line://msg/%@/%@",
                            contentType, contentKey];
    NSURL *url = [NSURL URLWithString:urlString2];
    
    // LINEがインストールされているかどうか確認
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:[NSString stringWithFormat:@"LINEをインストールしてね〜♪"]
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil] ;
        [alert show];
    }
}
@end

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - aster広告delegate
@implementation ViewController(MrdIconLoaderDelegate)

- (void)loader:(MrdIconLoader*)loader didReceiveContentForCells:(NSArray *)cells
{
	for (id cell in cells) {
		NSLog(@"---- The content loaded for iconCell:%p, loader:%p", cell,  loader);
	}
}

- (void)loader:(MrdIconLoader*)loader didFailToLoadContentForCells:(NSArray*)cells
{
	for (id cell in cells) {
		NSLog(@"---- The content is missing for iconCell:%p, loader:%p", cell,  loader);
	}
}

- (BOOL)loader:(MrdIconLoader*)loader willHandleTapOnCell:(MrdIconCell*)aCell
{
	NSLog(@"---- loader:%p willHandleTapOnCell:%@", loader, aCell);
	return YES;
}

- (void)loader:(MrdIconLoader*)loader willOpenURL:(NSURL*)url cell:(MrdIconCell*)aCell
{
	NSLog(@"---- loader:%p willOpenURL:%@ cell:%@", loader, [url absoluteString], aCell);
}

@end
