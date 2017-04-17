//
//  ViewController.m
//  ZZJAudioTool
//
//  Created by mac on 2017/4/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "AudioTool.h"

#define screenWidth   [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

- (IBAction)play:(id)sender;
- (IBAction)next:(UIButton *)sender;
- (IBAction)previous:(UIButton *)sender;
- (IBAction)pause:(UIButton *)sender;

@property (nonatomic,strong)AudioTool *audioTool;

@end

@implementation ViewController

- (IBAction)play:(id)sender {
    //默认播放第一个音频文件（需提前对音频数组进行由小到大的排序）
    [_audioTool playMatchVoice];
}

- (IBAction)next:(UIButton *)sender {
    
}

- (IBAction)previous:(UIButton *)sender {
    
}

- (IBAction)pause:(UIButton *)sender {
    [_audioTool pauseMatchVoice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"AudioTool";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setPage];
    
    [self InitAudioTool];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioToolDidFinishedPlaying:) name:@"AudioToolDidFinishedPlaying" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPage {
    
    
}

//初始化AudioTool
- (void)InitAudioTool {
    
    _audioTool = [[AudioTool alloc] init];
    _audioTool.voiceArray = [[NSMutableArray alloc] init];
    
    NSArray *indexArray = @[@"0",@"1",@"2",@"3"];
    NSArray *voiceArray = @[@"G.E.M.邓紫棋 - 喜欢你.mp3",@"Maroon 5 - One More Night - LVLF Remix.mp3",@"Rameez - La La La.mp3",@"李健,孙俪 - 风吹麦浪.mp3"];
    
    for (int i=0;i<indexArray.count;i++) {
        
        NSDictionary *dic = @{@"index":[NSString stringWithFormat:@"%@",indexArray[i]],@"voice_url":[NSString stringWithFormat:@"%@",voiceArray[i]]};
        
        [_audioTool.voiceArray addObject:dic];
    }
    
    [_audioTool printVoiceArray];
}

- (void)AudioToolDidFinishedPlaying:(NSNotification *)notification {
    
    NSLog(@"AudioToolDidFinishedPlaying");
    
    NSDictionary *dic = notification.userInfo;
    
    NSInteger index = [dic[@"index"] integerValue];
    NSLog(@"刚刚播放结束的音频对应的index为： %ld",index);
}

@end
