//
//  LoginManager.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

static LoginManager * manager = nil;

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[LoginManager alloc] init];
    });
    
    return manager;
}

- (void)Record: (NSString *)phoneNumber pass: (NSString *)passWord {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNumber forKey:DLChatRoomPhoneNumber];
    [defaults setObject:passWord forKey:DLChatRoomPassWord];
    [defaults synchronize];
    
    AVInstallation *installation = [AVInstallation currentInstallation];
    [installation setObject:[AVUser currentUser].username forKey:@"number"];
    [installation saveInBackground];
}

- (void)Login: (NSString *)phoneNumber pass: (NSString *)passWord {
    
    [AVOSOperate LoginWithNumber:phoneNumber passWord:passWord];
}

- (void)AutoLogin {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([AVUser currentUser] == nil && [defaults boolForKey:@"ApplicationFirstLaunch"] == YES) {
        
        [self Login:[defaults objectForKey:DLChatRoomPhoneNumber] pass:[defaults objectForKey:DLChatRoomPassWord]];
    }
}

- (void)Logout {
    
    [AVUser logOut];
    [LoginManager shareManager].isLogin = NO;
    [LoginManager shareManager].isSendVerifyCode = NO;
    [LoginManager shareManager].VerifySucceed = NO;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"ApplicationFirstLaunch"];
    [defaults synchronize];
}

@end
