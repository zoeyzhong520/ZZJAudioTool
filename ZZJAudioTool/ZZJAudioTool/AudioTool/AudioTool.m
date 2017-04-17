//
//  AudioTool.m
//  ReadBook
//
//  Created by 仲召俊 on 2017/3/10.
//  Copyright © 2017年 ReadBook. All rights reserved.
//

#import "AudioTool.h"

@interface AudioTool ()<AVAudioPlayerDelegate>

@property (nonatomic,copy) NSString *url;//音频文件的URL

@property (nonatomic)NSInteger index;//播放音频的索引

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

#pragma mark -- 对播放、暂停、停止方法的二次封装
//遍历voiceArray数组，找出符合条件的音频URL并播放
- (void)playMatchVoice:(NSInteger)index {
    
    if (_voiceArray.count > 0) {
        
        for (NSDictionary *dic in _voiceArray) {
            
            NSInteger IndexAtTool = [dic[@"index"] integerValue];
            NSString *url = dic[@"voice_url"];
            
            if (IndexAtTool == index) {
                NSLog(@"传入的index和AudioTool里的index相匹配");
                [self playMusic:url];
                _url = url;
                break;
            }else{
                NSLog(@"没有符合条件的音频！");
                break;
            }
        }
    }
    
}

- (void)playMatchVoice {
    
    if (_voiceArray.count > 0) {
        
        for (int i=0;i<_voiceArray.count;i++) {
            //默认播放第一个音频（需提前对音频数组按照index的值，进行由小到大的排序）
            NSString *url = _voiceArray[0][@"voice_url"];
            _url = url;
            
            //播放音频
            [self playMusic:url];
            
            //初始化index的数值为0
            _index = 0;
        }
    }
}

//暂停播放
- (void)pauseMatchVoice {
    [self pauseMusic:_url];
}

//停止
- (void)stopMatchVoice {
    [self stopMusic:_url];
}

//播放下一个音频
- (void)playNextMatchVoice {
    
    //先停止播放
    [self stopMatchVoice];
    
    //播放索引+1
    _index++;
    if (_index >= _voiceArray.count) {
        _index = 0;
        NSLog(@"音频文件已经全部播放完！");
    }
    
    //开始播放
    [self playMusic:_voiceArray[_index][@"voice_url"]];
}

#pragma mark -- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"音乐播放完成！");
    
    //音频播放完成之后，自动播放下一个
    [self playNextMatchVoice];
    
    NSDictionary *dic = @{@"index":[NSString stringWithFormat:@"%@",_voiceArray[_index][@"index"]]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioToolDidFinishedPlaying" object:nil userInfo:dic];
}

@end
