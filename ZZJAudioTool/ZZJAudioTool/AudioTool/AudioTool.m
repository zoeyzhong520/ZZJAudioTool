//
//  AudioTool.m
//  ReadBook
//
//  Created by 仲召俊 on 2017/3/10.
//  Copyright © 2017年 ReadBook. All rights reserved.
//

#import "AudioTool.h"

@interface AudioTool ()<AVAudioPlayerDelegate>

@property (nonatomic)NSInteger currentIndex;

@end

@implementation AudioTool

/*
 单例创建
 */
static id sharedInstance = nil;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t p;
    dispatch_once(&p, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/*
 存放所有的音乐播放器
 */
static NSMutableDictionary *musices;
- (NSMutableDictionary *)musices {
    
    if (musices == nil) {
        musices = [NSMutableDictionary dictionary];
    }
    return musices;
}

/*
 播放音乐
 */
- (BOOL)playMusic:(NSString *)fileName {
    
    if (!fileName) {
        //如果没有传入文件名，那么直接返回
        return NO;
    }
    //1.取出对应的播放器
    AVAudioPlayer *player = [self musices][fileName];
    
    //2.如果播放器没有创建，那么就进行初始化
    if (!player) {
        //2.1音频文件的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!url) {
            NSLog(@"file not found");
            return NO;
        }
        
        //2.2创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = (id<AVAudioPlayerDelegate>)self;
        
        //2.3缓冲
        if (![player prepareToPlay]) {
            return NO;
        }
        
        //2.4存入字典
        [self musices][fileName] = player;
    }
    
    //3.播放
    if (![player isPlaying]) {
        //如果当前没处于播放状态，那么就播放
        return [player play];
    }
    return YES;//正在播放，那么就返回YES
}

- (void)pauseMusic:(NSString *)fileName {
    
    if (!fileName) {
        return;
    }
    
    //1.取出对应的播放器
    AVAudioPlayer *player = [self musices][fileName];
    
    //2.暂停
    [player pause];
}

- (void)stopMusic:(NSString *)fileName {
    
    if (!fileName) {
        return;
    }
    
    //1.取出对应的播放器
    AVAudioPlayer *player = [self musices][fileName];
    
    //2.停止
    [player stop];
    
    //3.将播放器从字典中移除
    [[self musices] removeObjectForKey:fileName];
}

//打印音频数组
- (void)printVoiceArray {
    
    NSLog(@"传入的voiceArray： %@",_voiceArray);
}

#pragma mark -- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"音乐播放完成！");
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioToolDidFinishedPlaying" object:nil userInfo:dic];
    
    
}

@end
