//
//  AgoraManager.m
//  
//
//  Created by XueYulun on 15/6/24.
//
//

#import "AgoraManager.h"

static NSString * const AgoraKey = @"421CA23ADE36440B9AC4969B3B232279";

@implementation AgoraManager

static AgoraManager * manager = nil;

+ (AgoraManager *)shareAgora {
    
    @synchronized(self)
    {
        if (!manager) {
            // Safe Get single ton
            manager = [[[self class] alloc] init];
            [manager initialized];
        }
        return manager;
    }
}

- (void)initialized {
    
    __weak typeof(self)weakSelf = self;
    
    // Load Audio Kit
    self.audioKit = [[AgoraAudioKit alloc] initWithVideoEnabled:FALSE quality:^(NSUInteger uid, AgoraAudioMediaQuality quality, NSUInteger delay, NSUInteger jitter, NSUInteger lost, NSUInteger lost2) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:LoggerUid:Delay:allPack:lost:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf LoggerUid:uid Delay:delay allPack:lost lost:lost2];
        }
        
    } error:^(AgoraAudioErrorCode errorCode) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:APILoadError:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf APILoadError:errorCode];
        }
    }];
    
    NSURL * docURL = [[NSURL alloc] initFileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    NSString *logDir = [docURL path];
    
    NSString *logTextPath = [logDir stringByAppendingPathComponent:@"com.agora.CacheLogs/agorasdk.log"];
    NSDictionary *profileDic = @{@"mediaSdk": @{@"logFile": logTextPath}};
    NSData *profileData = [NSJSONSerialization dataWithJSONObject:profileDic options:0 error:NULL];
    NSString *profileString = [[NSString alloc] initWithData:profileData encoding:NSUTF8StringEncoding];
    
    [self.audioKit setProfile:profileString merge:true];
    
    // Set Leave Channel Block
    [self.audioKit leaveChannelBlock:^(AgoraAudioSessionStat *stat) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        // Remove Proximit Monitore
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        strongSelf.inChannel = NO;
        strongSelf.currentChannelIdentifier = nil;
    }];
    
    // Update Session Stat
    [self.audioKit updateSessionStatBlock:^(AgoraAudioSessionStat *stat) {
        
        // Logger
    }];
    
    // net Work Quality
    [self.audioKit networkQualityBlock:^(AgoraAudioMediaQuality quality) {
        
        // Logger
    }];
}

- (void)JoinChannel:(NSString *)channelName {
    
    __weak typeof(self)weakSelf = self;
    
    // Other User Joined
    [self.audioKit userJoinedBlock:^(NSUInteger uid, NSInteger elapsed) {
        
        NSLog(@"New User Join in");
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:EnterUser:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf EnterUser:uid];
        }
    }];
    
    // User Off Line
    [self.audioKit userOfflineBlock:^(NSUInteger uid) {
        
        NSLog(@"User Off line");
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:LeaveUser:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf LeaveUser:uid];
        }
    }];
    
    // User Mute Audio
    [self.audioKit userMuteAudioBlock:^(NSUInteger uid, bool muted) {
        
        NSLog(@"Mute Audio, %d", muted);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:MutedUser:Mute:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf MutedUser:uid Mute:muted];
        }
    }];
    
    // Join Channel
    [self.audioKit joinChannelByKey:AgoraKey channelName:channelName info:nil uid:0 success:^(NSString* channel, NSUInteger uid, NSInteger elapsed){
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        // Add Proximit Monitore enabled
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
        strongSelf.inChannel = YES;
        strongSelf.currentChannelIdentifier = channelName;
        
        if ([strongSelf.delegate respondsToSelector:@selector(agoreManager:JoinChannel:ChannelName:userID:)]) {
            
            [strongSelf.delegate agoreManager:strongSelf JoinChannel:YES ChannelName:channel userID:uid];
        }
    }];
}

- (void)LeaveChannel:(NSString *)channelName {
    
    // Leave Channel
    [self.audioKit leaveChannel];
}

- (void)Mute: (BOOL)isMute {
    
    // Set Mute statu
    [self.audioKit setMute:isMute];
}

- (void)Speaker: (BOOL)isSpeaker {
    
    // Enable or Disable speaker
    [self.audioKit setEnableSpeaker:isSpeaker];
    
    if (isSpeaker) {
        
        // Default Speaker Volume
        [self.audioKit setSpeakerVolume:130];
    }
}

- (NSString *)profile {
    
    // Initialized Logger file
    NSDictionary *profileDic = @{@"mediaSdk": @{@"logFilter" : @(0)}};
    NSData *profileData = [NSJSONSerialization dataWithJSONObject:profileDic options:0 error:NULL];
    NSString *profileString = [[NSString alloc] initWithData:profileData encoding:NSUTF8StringEncoding];
    return profileString;
}

@end
