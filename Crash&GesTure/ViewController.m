//
//  ViewController.m
//  Crash&GesTure
//
//  Created by chedao on 17/3/14.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import "ViewController.h"
#import "GestureUnLockView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GestureUnLockView * gestureView = [[GestureUnLockView alloc] init];
    gestureView.frame = self.view.bounds;
    [self.view addSubview:gestureView];
    
    gestureView.gestureType = 2;
    gestureView.setGestureBlock = ^(BOOL finish){
    
        if (finish) {
            NSLog(@"设置成功");
        }
    };
    gestureView.finishBlock = ^{
        NSLog(@"手势密码正确");
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
