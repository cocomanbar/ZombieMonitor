//
//  ZombieForwardCache.m
//  ZombieMonitor
//
//  Created by tanxl on 2023/3/5.
//

#import "ZombieForwardCache.h"
#import <objc/runtime.h>

@interface ZombieForwardCache ()
<NSCacheDelegate>

@property (nonatomic, strong) NSCache *zombieCache;

@end

@implementation ZombieForwardCache

+ (instancetype)shared {
    static ZombieForwardCache *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZombieForwardCache alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _zombieCache = [[NSCache alloc] init];
        _zombieCache.delegate = self;
        _zombieCache.name = @"k_zombie_cache";
        _zombieCache.totalCostLimit = 1024 * 1024 * 2; // 2M
//        _zombieCache.totalCostLimit = 50; // 测试
    }
    return self;
}

/** 延迟释放对象 */
- (void)addObject:(NSObject *)object {
    if (!object) {
        return;
    }
    
    [self.zombieCache setObject:object forKey:[NSString stringWithFormat:@"%p", object] cost:class_getInstanceSize([object class])];
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
#ifdef DEBUG
    NSLog(@"ZombieForwardCache 释放了一个受保护对象：obj = %@", obj);
#endif
}

@end
