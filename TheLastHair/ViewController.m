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
#import <GameFeatKit/GFView.h>
#import <GameFeatKit/GFController.h>
#import "GAI.h"
#import <MrdAstaWall/MrdAstaWall.h>
#import "AppDelegate.h"

#define TWEETTITLE   @"Twitterにサインインしてね"
#define TWEETMESSAGE @"iPhoneの「設定」→「Twitter」→ユーザー名とパスワードを入力して「サインイン」をタップ"
#define TWEETCANCEL  @"キャンセル"
#define TWEETDEFAULT @"テスト #udonkonet"
#define SOCIALTEXT   @"ばかも〜ん！！　最後の１本を抜くヤツがあるか〜！！"
#define APPURL       @"https://itunes.apple.com/jp/app/hage-qin-fu-duan-fa-shi/id570377317?mt=8&uo=4"



@interface ViewController (){
   NSUserDefaults *score;  //スコア保存用
   NSUserDefaults *newapp; //新アプリダイアログの表示判断用。xmlのnoを保存。
    
}
@property (nonatomic, retain) MrdIconLoader* iconLoader;

@end

@interface ViewController(MrdIconLoaderDelegate)<MrdIconLoaderDelegate>
@end

@implementation ViewController
NSString *nowTagStr;
NSString *txtBuffer;
NSString *strNo;
NSString *strDate;
NSString *strMessage;
NSString *strTitle;
NSString *strUrl;
bool error = NO;
AppDelegate  *delegate;

@synthesize iconLoader = _iconLoader;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // AdMobのインタースティシャル広告読み込み
//    [self loadAdMobIntersBanner];

    
    // アイコン、バッジ表示
    //　非表示
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //google analytics
    self.screenName = @"TopPage";
    
    
    //ゲームセンター
    NSLog(@"ゲームセンター対応チェック%d",isGameCenterAPIAvailable());
    //ゲームセンター対応の有効なバージョンならログイン画面を出す
    if(isGameCenterAPIAvailable() == 1){
        [self authenticateLocalPlayer];
    }
    
    //スコアを読み出し
    score = [NSUserDefaults standardUserDefaults];
    //ダウンロードダイアログ用のuserdefaults読み出し
   newapp = [NSUserDefaults standardUserDefaults];

    //gamefeatとアプリリンクボタンを非表示
    [_gamefeatButton setHidden:YES];
    [_appsButton setHidden:YES];
    
    
    //アスタ表示
    [self displayIconAdd];
   
   //xml読み込み
   [self loadDownloadXML];
    
   
}

// AdMobのインタースティシャル広告読み込み
- (void)loadAdMobIntersBanner
{
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.delegate = self;
    interstitial_.adUnitID = @"ca-app-pub-3324877759270339/8563045425";
    [interstitial_ loadRequest:[GADRequest request]];
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
    NSLog(@"admob interstitialDidReceiveAd");
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"admob interstitial didFailToReceiveAdWithError");
}


-(void)displayIconAdd{
    //表示するY座標をUDONKOAPPSボタンと同じにする
    NSInteger iconY = _gamefeatButton.frame.origin.y;
    
    // The array of points used as origin of icon frame
	CGPoint origins[] = {
		{85, iconY},
        {160, iconY},
        {240, iconY}
    };
    
    MrdIconLoader* iconLoader = [[MrdIconLoader alloc]init]; // (1)
    self.iconLoader = iconLoader;
	iconLoader.delegate = self;
//	IF_NO_ARC([iconLoader release];)

    
    
    for (int i=0; i < 3; i++)
	{
        CGRect frame;                                                       //frame
        frame.origin = origins[i];                                          //位置
        frame.size = kMrdIconCell_DefaultViewSize;                          //サイズ75x75
        MrdIconCell* iconCell = [[MrdIconCell alloc]initWithFrame:frame];   //セル生成
        iconCell.titleFrame = CGRectNull;                                   //タイトル非表示
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
    
    
//    if(delegate.interstitalFlg){
//        [self interstitalAdd:nil];
//    }
//    
//    delegate = [[AppDelegate alloc]init];
//    delegate.interstitalFlg = YES;
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
        
        // 処理終了後に呼び出されるコールバックを指定する
        [facebookPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultDone:
                    NSLog(@"Done!!");
                    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(interstitalAdd:) userInfo:nil repeats:NO];
                    break;
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Cancel!!");
                    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(interstitalAdd:) userInfo:nil repeats:NO];
                    break;
            }
        }];
        
        
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
        
        // 処理終了後に呼び出されるコールバックを指定する
        [twitterPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultDone:
                    NSLog(@"Done!!");
                    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(interstitalAdd:) userInfo:nil repeats:NO];
                    break;
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Cancel!!");
                    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(interstitalAdd:) userInfo:nil repeats:NO];
                    break;
            }
        }];
        
        
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

-(void)interstitalAdd:(NSTimer*)timer
{
    
    [self loadAdMobIntersBanner];


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
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismiss completed");
        [self interstitalAdd:nil];
    }];

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
    [self setGamefeatButton:nil];
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

//gamefeatを表示
- (IBAction)displayGameFeat:(id)sender {
    [GFController showGF:self site_id:@"1034"];
}


//=======================================================
// GFViewDelegate
//=======================================================
- (void)didShowGameFeat{
    // GameFeatが表示されたタイミングで呼び出されるdelegateメソッド
    NSLog(@"didShowGameFeat");
}
- (void)didCloseGameFeat{
    // GameFeatが閉じられたタイミングで呼び出されるdelegateメソッド
    NSLog(@"didCloseGameFeat");
}


#pragma mark - 新アプリダイアログ




-(void)loadDownloadXML{
   //ダウンロードしてねダイアログのメッセージを取得
   NSURL *URL = [NSURL URLWithString:@"http://coco8.sakura.ne.jp/udonko/apps/dlpopup/popup.xml"];
   NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
   xmlParser.delegate = self;
   [xmlParser parse];
   
   //非同期通信
   /*
    NSString *urlstring = @"http://saryou.jp";
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    */
   //日付とナンバーを取れるようにしておいたので、これで何かしらの判定をしてから
   //showDownloadDialogを呼び出すようにしましょう。
   //このままだと、毎回呼び出されちゃうのでうっとーしー。
   //ここは要検討
   NSLog(@"NO:%d userdefaultsのDLNO:%d",strNo.intValue,[newapp integerForKey:@"DLNO"]);
   NSLog(@"date:%@",strDate);
   
   //xmlパースでエラーがなければダイアログ表示
   if(!error){
      
      //noを比較して、保存してあるnoと異なればxmlが更新されたものと見なしてダイアログを表示する。
      //１度表示したら更新されるまで表示しないようにする。
      if(strNo.intValue == [newapp integerForKey:@"DLNO"]){
         //なにもしない
      }else{
         //ダイアログを表示
         [newapp setInteger:strNo.intValue forKey:@"DLNO"];
         NSLog(@"DLNO保存:%d",strNo.intValue);
         [newapp synchronize];
         [self showDownloadDialog];
      }
   }
}

//パーススタート
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
   if([elementName isEqualToString:@"no"]){
      nowTagStr = [NSString stringWithString:elementName];
      txtBuffer = [NSString stringWithFormat:@"%@",@""];
   }else if([elementName isEqualToString:@"title"]){
      nowTagStr = [NSString stringWithString:elementName];
      txtBuffer = [NSString stringWithFormat:@"%@",@""];
   }else if([elementName isEqualToString:@"message"]){
      nowTagStr = [NSString stringWithString:elementName];
      txtBuffer = [NSString stringWithFormat:@"%@",@""];
   }else if([elementName isEqualToString:@"url"]){
      nowTagStr = [NSString stringWithString:elementName];
      txtBuffer = [NSString stringWithFormat:@"%@",@""];
   }else if([elementName isEqualToString:@"date"]){
      nowTagStr = [NSString stringWithString:elementName];
      txtBuffer = [NSString stringWithFormat:@"%@",@""];
   }
}

//エレメント内に文字列を発見！
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   if([nowTagStr isEqualToString:@"no"]){
      txtBuffer = [txtBuffer stringByAppendingFormat:@"%@",string];
   }else if([nowTagStr isEqualToString:@"title"]){
      txtBuffer = [txtBuffer stringByAppendingFormat:@"%@",string];
   }else if([nowTagStr isEqualToString:@"message"]){
      txtBuffer = [txtBuffer stringByAppendingFormat:@"%@",string];
   }else if([nowTagStr isEqualToString:@"url"]){
      txtBuffer = [txtBuffer stringByAppendingFormat:@"%@",string];
   }else if([nowTagStr isEqualToString:@"date"]){
      txtBuffer = [txtBuffer stringByAppendingFormat:@"%@",string];
   }
}

//エレメントの読み込み終了時のイベント
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
   if([elementName isEqualToString:@"no"]){
      strNo = [NSString stringWithFormat:@"%@",txtBuffer];
   }else if([elementName isEqualToString:@"title"]){
      strTitle = [NSString stringWithFormat:@"%@",txtBuffer];
   }else if([elementName isEqualToString:@"message"]){
      strMessage = [NSString stringWithFormat:@"%@",txtBuffer];
   }else if([elementName isEqualToString:@"url"]){
      strUrl = [NSString stringWithFormat:@"%@",txtBuffer];
   }else if([elementName isEqualToString:@"date"]){
      strDate = [NSString stringWithFormat:@"%@",txtBuffer];
   }
}

//パース完了
-(void)parserDidEndDocument:(NSXMLParser *)parser{
   nowTagStr = [NSString stringWithFormat:@"%@",@""];
}

//パースエラー
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"エラーが発生しました");
   //error発生した場合はerrorをYESにしてダウンロードダイアログを表示しないようにする
   //主に通信切断時に呼び出されると思う。
   error = YES;
}




- (void)showDownloadDialog
{
   // 生成例
   UIAlertView *alert = [[UIAlertView alloc] init];
   
   // 生成と同時に各種設定も完了させる例
   alert =[[UIAlertView alloc]
           initWithTitle:strTitle
           message:strMessage
           delegate:self
           cancelButtonTitle:@"あとで"
           otherButtonTitles:@"ダウンロード", nil];
   [alert show];
}

// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
   
   switch (buttonIndex) {
      case 0:
         //１番目のボタンが押されたときの処理を記述する
         NSLog(@"いいえ");
         break;
      case 1:
         //２番目のボタンが押されたときの処理を記述する
         NSLog(@"ダウンロード");
         NSURL *url= [NSURL URLWithString:strUrl];
         [[UIApplication sharedApplication] openURL:url];
         break;
   }
}


-(IBAction)displayAsterWall:(id)sender{
    [self playSound:@"ok"];

    // 基本的なウォールの表示方法は以下のようになります。
    // ウォールを表示したいタイミング(ボタンをタップした際の処理など)で記述して下さい。
    NSBundle *mrdAstaWallBundle = [NSBundle bundleWithPath:[MrdAstaWall frameworkBundlePath]]; // (1)
    MrdAstaWallViewController *vc = [[MrdAstaWallViewController alloc]initWithNibName:@"MrdAstaWallViewController" bundle:mrdAstaWallBundle]; // (2)
    [vc setMediaCode:@"ast00400jm0th80qz0ma"]; // (3)
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:vc animated:YES completion:nil]; // (4)
    } else { //iOS5未満
        [self presentModalViewController:vc animated:YES]; // (5)
    }
 //   [vc release]; // (6)
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
    
    //アスタが表示されたらgamefeatも表示する。
    [_gamefeatButton setHidden:NO];
    [_appsButton setHidden:NO];
}

- (void)loader:(MrdIconLoader*)loader didFailToLoadContentForCells:(NSArray*)cells
{
	for (id cell in cells) {
		NSLog(@"---- The content is missing for iconCell:%p, loader:%p", cell,  loader);
	}
    //アスタが表示されたらgamefeatも表示する。
    [_gamefeatButton setHidden:YES];
    [_appsButton setHidden:YES];
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
