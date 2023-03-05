//
//  ZMCrashView.m
//  ZombieMonitor_Example
//
//  Created by tanxl on 2023/3/5.
//  Copyright © 2023 cocomanbar. All rights reserved.
//

#import "ZMCrashView.h"
#import "ZMSubView.h"

/**
 *  Note:
 *      Need it =>  -fno-objc-arc
 */
@implementation ZMCrashView

- (instancetype)init
{
    self = [super init];
    if (self) {
        ZMSubView *tempView = [[ZMSubView alloc]init];
        [tempView release];
        
        //AppDelegate里开启了init_safe_free()，表示释放的内存不会被覆盖，所以tempView调用setNeedsDisplay肯定会崩溃
        //如果不开启init_safe_free()，下面创建了10个UIView，那块被释放的内存可能会被覆盖，所以tempView调用setNeedsDisplay不一定会崩溃
        for (int i = 0; i < 10; i ++) {
            ZMSubView *temp = [[[ZMSubView alloc] init] autorelease];
            [self addSubview:temp];
        }
        
        [tempView setNeedsDisplay];
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
