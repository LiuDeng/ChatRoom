//
//  AVOSOperate.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "AVOSOperate.h"

@interface AVOSOperate ()

+ (void)GetAgoraKey;

@end

@implementation AVOSOperate

+ (void)LoadAVOS {
    
    [AVOSCloud setApplicationId:@"0ypwnkwb9bl5vq3y9uplcy7luxow37sbjfwg31ni2swplksn"
                      clientKey:@"gswb6dos30r6wojks6ifmxxs1r59d2pwnp5wryrwem0dztmr"];
    [AVOSCloud useAVCloudCN];
    [AVOSCloud registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
    [self GetAgoraKey];
}

+ (void)LoginWithNumber: (NSString *)number passWord: (NSString *)passWord {

    [AVUser logInWithMobilePhoneNumberInBackground:number password:passWord block:^(AVUser *user, NSError *error) {
       
        if (!error) {
            
            [LoginManager shareManager].isLogin = YES;
            [[LoginManager shareManager] Record:number pass:passWord];
        } else {
            
            [LoginManager shareManager].isLogin = NO;
        }
    }];
}

+ (void)RegisterWithNumber: (NSString *)number passWord: (NSString *)passWord nickName: (NSString *)nickName {
    
    AVUser * user = [AVUser user];
    user.username = number;
    user.password = passWord;
    user.mobilePhoneNumber = number;
    [user setObject:nickName forKey:@"nickName"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    
        if (succeeded) {
            
            [LoginManager shareManager].isLogin = YES;
            [[LoginManager shareManager] Record:number pass:passWord];
            
            [LoginManager shareManager].isSendVerifyCode = YES;
        } else {
            
            [LoginManager shareManager].isSendVerifyCode = NO;
        }
    }];
}

+ (void)VerifyNumber: (NSString *)number {
    
    [AVUser verifyMobilePhone:number withBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [LoginManager shareManager].VerifySucceed = YES;
        } else {
            
            [LoginManager shareManager].VerifySucceed = NO;
        }
    }];
}

+ (void)GetAgoraKey {
    
    AVQuery *query = [AVQuery queryWithClassName:AVCLASS_AGORA];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            
            AVObject * object = [objects firstObject];
            
            [AgoraManager shareAgora].isGetAgoraKey = YES;
            [AgoraManager shareAgora].AgoraKey = [object objectForKey:@"key"];
        } else {
            
            [AgoraManager shareAgora].isGetAgoraKey = NO;
        }
    }];
}

@end
