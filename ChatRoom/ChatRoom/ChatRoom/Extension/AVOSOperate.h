//
//  AVOSOperate.h
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVOSOperate : NSObject

+ (void)LoadAVOS;

+ (void)LoginWithNumber: (NSString *)number passWord: (NSString *)passWord;
+ (void)RegisterWithNumber: (NSString *)number passWord: (NSString *)passWord nickName: (NSString *)nickName;

+ (void)VerifyNumber: (NSString *)number;

@end
