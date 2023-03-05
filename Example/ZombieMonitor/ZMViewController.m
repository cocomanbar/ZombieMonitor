//
//  ZMViewController.m
//  ZombieMonitor
//
//  Created by cocomanbar on 03/05/2023.
//  Copyright (c) 2023 cocomanbar. All rights reserved.
//

#import "ZMViewController.h"
#import "ZMCrashView.h"

@interface ZMViewController ()

@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"TEST CODE";
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.backgroundColor = UIColor.orangeColor;
    button.frame = CGRectMake(20, 200, 220, 50);
    [button setTitle:@"Make a Zombie Crash." forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(makeCrash) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

- (void)makeCrash {
    
    //EXC_BAD_ACCESS(code=1,address=0x155555560)：表示0x155555560此内存并不合法，内部实现为已经被释放，为垃圾内存。
    //Thread 1: EXC_BAD_ACCESS (code=1, address=0x10)
    ZMCrashView *myview = [[ZMCrashView alloc] init]; //导致SIGSEGV的错误，一般会导致进程流产
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
