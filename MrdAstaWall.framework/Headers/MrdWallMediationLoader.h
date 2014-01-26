//
//  MrdWallMediationLoader.h
//  MrdAstaWall
//
//  Created by Marge on 2013/11/26.
//  Copyright (c) 2013年 Marge. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface MrdWallMediationLoader : NSObject

-(instancetype)initWithMediaCode:(NSString *)mediaCode;

// Start getting mediation setting
-(void)startLoading;

// Show wall view
-(BOOL)showWall:(UIViewController *)vc;

@end
