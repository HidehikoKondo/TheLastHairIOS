//
//  AppsListViewController.m
//  TheLastHair
//
//  Created by HIDEHIKO KONDO on 2013/04/07.
//  Copyright (c) 2013年 UDONKONET. All rights reserved.
//

#import "AppsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"

#define APPLISTURL @"http://www.udonko.net/applist"  // アプリ一覧のURL
@interface AppsListViewController ()

@end

@implementation AppsListViewController
@synthesize appWebView;
@synthesize loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //google analytics
    self.screenName = @"AppList";
    
    
    
	// Do any additional setup after loading the view.
    
    //インジケーターのビューの角丸設定
    loadingView.layer.cornerRadius = 10;
    
    
    //アプリ一覧のURL設定
    NSURL *url = [NSURL URLWithString:APPLISTURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [appWebView loadRequest:request];
    [appWebView reload];
}
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
    
    self.adview = [[AdstirView alloc]initWithOrigin:CGPointMake(0, rect.size.height-50)];
	self.adview.media = @"MEDIA-f5977393";
	self.adview.spot = 1;
	self.adview.rootViewController = self;
	[self.adview start];
	[self.view addSubview:self.adview];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
	[self.adview stop];
	[self.adview removeFromSuperview];
	self.adview.rootViewController = nil;
	self.adview = nil;
	[super viewWillDisappear:animated];
    
    
}
//WebVIewが表示完了時の動作
- (void)webViewDidFinishLoad:(UIWebView *)view {
    
    //インジケータービューをフェードアウト
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    loadingView.alpha = 0;
    [UIView commitAnimations];
    
}
//戻るボタン
- (IBAction)backButton:(id)sender {
    //戻るメソッド
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
