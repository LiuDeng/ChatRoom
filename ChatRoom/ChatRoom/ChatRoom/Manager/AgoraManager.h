//
//  AgoraManager.h
//  
//
//  Created by XueYulun on 15/6/24.
//
//

#import <Foundation/Foundation.h>

@class AgoraManager;

@protocol AgoraManageDelegate <NSObject>

///------------------------------
/// @name 声网SDK代理方法
///------------------------------

/*!
 *  When initialized SDK Success, Logger With this Delegate Method.
 *
 *  @param manager  [AgoraManager shareAgore].
 *  @param uid      user ID
 *  @param dalay    Session Delay
 *  @param allPack  All Package
 *  @param lostPack Lost Package
 */
- (void)agoreManager:(AgoraManager *)manager LoggerUid: (NSUInteger)uid Delay: (NSUInteger)dalay allPack: (NSUInteger)allPack lost: (NSUInteger)lostPack;

/*!
 *  API initialized Error Delegate
 *
 *  @param manager   [AgoraManager shareAgore].
 *  @param errorCode ErrorCode in Agora SDK
 */
- (void)agoreManager:(AgoraManager *)manager APILoadError: (AgoraAudioErrorCode)errorCode;

/*!
 *  Join Channel result delegate method, The Join Success And Failure Block always call this delegate method.
 *
 *  @param manager     manager, [AgoraManager shareAgore].
 *  @param result      Join Channel Result.
 *  @param channelName Joinde Channel Name.
 *  @param uid         user ID.
 */
- (void)agoreManager: (AgoraManager *)manager JoinChannel: (BOOL)result ChannelName: (NSString *)channelName userID: (NSInteger)uid;

/*!
 *  Channel With Other User Join.
 *
 *  @param manager [AgoraManager shareAgore].
 *  @param uid     New user ID.
 */
- (void)agoreManager:(AgoraManager *)manager EnterUser: (NSInteger)uid;

/*!
 *  Channel With Other User Leave.
 *
 *  @param manager [AgoraManager shareAgore].
 *  @param uid     Left user ID.
 */
- (void)agoreManager:(AgoraManager *)manager LeaveUser:(NSInteger)uid;

/*!
 *  Other User muted channel.
 *
 *  @param manager [AgoraManager shareAgore].
 *  @param uid     muted user id.
 *  @param muted   muted.
 */
- (void)agoreManager:(AgoraManager *)manager MutedUser:(NSInteger)uid Mute: (BOOL)muted;

@end

@interface AgoraManager : NSObject

///------------------------------
///  @name 声网SDK 操作
///------------------------------

/*!
 *  Share Agore instance.
 */
+ (AgoraManager *)shareAgora;

//! @abstract audio Kit, Global Agora object.
@property (nonatomic, strong) AgoraAudioKit * audioKit;

/*!
 *  Join Channel With Channel Name, can't be nil.
 *
 *  @param channelName Destination Channel Name, if not, you will create it.
 */
- (void)JoinChannel: (NSString *)channelName;

/*!
 *  Leave Channel.
 *
 *  @param channelName Channel name is needless.
 */
- (void)LeaveChannel: (NSString *)channelName;

/*!
 *  Mute MicroPhone.
 *
 *  @param isMute set micro phone is mute.
 */
- (void)Mute: (BOOL)isMute;

/*!
 *  LoudSpeaker, ear phone, When Join channel, Will open proximit monitor.
 *
 *  @param isSpeaker set speaker.
 */
- (void)Speaker: (BOOL)isSpeaker;

//! @abstract current Room Identifier.
@property (nonatomic, strong) NSString * currentChannelIdentifier;

//! @abstract is in channel.
@property (nonatomic, assign) BOOL inChannel;

//! @abstract audio kit Delegate, some status method will accede to this protocal.
@property (nonatomic, assign) id<AgoraManageDelegate> delegate;

@property (nonatomic, assign) BOOL isGetAgoraKey;
@property (nonatomic, strong) NSString * AgoraKey;

@end
