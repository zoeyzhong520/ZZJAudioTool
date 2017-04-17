//
//  AudioTool.h
//  ReadBook
//
//  Created by 仲召俊 on 2017/3/10.
//  Copyright © 2017年 ReadBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AudioTool : NSObject

//存放音频的数组
@property (nonatomic,strong)NSMutableArray *voiceArray;

/*
 单例创建
 */
+ (instancetype)sharedInstance;

/*
 播放音乐文件
 */
- (BOOL)playMusic:(NSString *)fileName;

/*
 暂停播放
 */
- (void)pauseMusic:(NSString *)fileName;

/*
 停止
 */
- (void)stopMusic:(NSString *)fileName;

- (void)printVoiceArray;

#pragma mark -- 播放、暂停、停止方法的二次封装
//遍历voiceArray数组，找出符合条件的音频URL并播放
- (void)playMatchVoice:(NSInteger)index;

- (void)playMatchVoice;

//暂停播放
- (void)pauseMatchVoice;

//停止
- (void)stopMatchVoice;

@end
