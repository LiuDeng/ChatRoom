//
//  LoginManager.h
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const DLChatRoomPhoneNumber = @"DLChatRoomPhoneNumberLocalSaveKey";
static NSString * const DLChatRoomPassWord = @"DLChatRoomPassWordLocalSaveKey";

@class AVUser;

@interface LoginManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) BOOL isLogin;

- (void)Record: (NSString *)phoneNumber pass: (NSString *)passWord;

- (void)Login: (NSString *)phoneNumber pass: (NSString *)passWord;
- (void)AutoLogin;

- (void)Logout;

@property (nonatomic, assign) BOOL isSendVerifyCode;
@property (nonatomic, assign) BOOL VerifySucceed;

@end
