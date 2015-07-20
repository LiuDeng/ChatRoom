//
//  AppDelegate.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AVOSOperate LoadAVOS];
    
    [self LoadMainStyle];
    
    [[LoginManager shareManager] AutoLogin];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

// @ 整体样式设计

- (void)LoadMainStyle {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor primaryBackgroundColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor defaultTextColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:16.],NSFontAttributeName,nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor defaultTextColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
