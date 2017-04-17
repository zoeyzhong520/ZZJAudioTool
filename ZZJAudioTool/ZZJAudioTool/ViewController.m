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

@property (nonatomic,strong)NSArray *voiceArray;

@property (nonatomic,strong)AudioTool *audioTool;

@end

@implementation ViewController

- (IBAction)play:(id)sender {
    [_audioTool playMusic:_audioTool.voiceArray[0]];
}

- (IBAction)next:(UIButton *)sender {
    
}

- (IBAction)previous:(UIButton *)sender {
    
}

- (IBAction)pause:(UIButton *)sender {
    [_audioTool pauseMusic:_audioTool.voiceArray[0]];
}

- (NSArray *)voiceArray {
    if (!_voiceArray) {
        _voiceArray = @[@"G.E.M.邓紫棋 - 喜欢你.mp3",@"Maroon 5 - One More Night - LVLF Remix.mp3",@"Rameez - La La La.mp3",@"李健,孙俪 - 风吹麦浪.mp3"];
    }
    return _voiceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"AudioTool";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setPage];
    
    [self AudioTool];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPage {
    
    
}


- (void)AudioTool {
    
    _audioTool = [[AudioTool alloc] init];
    _audioTool.voiceArray = @[@"G.E.M.邓紫棋 - 喜欢你.mp3",@"Maroon 5 - One More Night - LVLF Remix.mp3",@"Rameez - La La La.mp3",@"李健,孙俪 - 风吹麦浪.mp3"];
    [_audioTool printVoiceArray];
}

@end
