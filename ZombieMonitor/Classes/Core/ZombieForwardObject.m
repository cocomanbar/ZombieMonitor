//
//  ZombieForwardObject.m
//  ZombieMonitor
//
//  Created by tanxl on 2023/3/5.
//

#import "ZombieForwardObject.h"
#import <objc/runtime.h>

extern NSString *const kZombieMonitorOriginClassKey;

@interface ZombieForwardObjectProxy : NSObject

@end

@implementation ZombieForwardObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSAssert(false, @"Found a zombie instance className：%@，SEL：%@", (objc_getAssociatedObject(self, &kZombieMonitorOriginClassKey)), NSStringFromSelector(aSelector));
    return [[ZombieForwardObjectProxy alloc] init];
}

@end

@implementation ZombieForwardObjectProxy

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, (IMP)k_dynamicZombieMethodIMP, "v@:@");
    return YES;
}

id k_dynamicZombieMethodIMP(id self, SEL _cmd) {
    return 0;
}

@end
