//
//  NSObject+ZombieMonitor.m
//  Pods-ZombieMonitor_Example
//
//  Created by tanxl on 2023/3/5.
//

#import "NSObject+ZombieMonitor.h"
#import <objc/runtime.h>
#import "ZombieForwardCache.h"
#import "ZombieForwardObject.h"

NSString *const kZombieMonitorMarkClassKey = @"kZombieMonitorMarkClassKey";

NSString *const kZombieMonitorOriginClassKey = @"kZombieMonitorOriginClassKey";

@implementation NSObject (ZombieMonitor)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        k_zombie_swizzleInstanceMethodWithTarget(NSObject.class,
                                                 @selector(dealloc),
                                                 @selector(k_k_zombie_dealloc));
        
        k_zombie_swizzleClassMethodWithTarget(NSObject.class,
                                                 @selector(allocWithZone:),
                                                 @selector(k_k_zombie_allocWithZone:));
    });
}

+ (instancetype)k_k_zombie_allocWithZone:(struct _NSZone *)zone {
    
    NSObject *objc = [self k_k_zombie_allocWithZone:zone];
    
    if (!objc) {
        return objc;
    }
    
    /// 过滤掉 NSBundle 不然会导致死循环
    if ([objc isKindOfClass:NSBundle.class]) {
        return objc;
    }
    
    objc_setAssociatedObject(objc, &kZombieMonitorMarkClassKey, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return objc;
}

- (void)k_k_zombie_dealloc{
    if ([objc_getAssociatedObject(self, &kZombieMonitorMarkClassKey) boolValue]) {
        objc_destructInstance(self);
        Class originCls = object_setClass(self, [ZombieForwardObject class]);
        objc_setAssociatedObject(self, &kZombieMonitorOriginClassKey, NSStringFromClass(originCls), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[ZombieForwardCache shared] addObject:self];
    }else{
        [self k_k_zombie_dealloc];
    }
}

BOOL k_zombie_swizzleInstanceMethodWithTarget(Class orignalClass, SEL oriSel, SEL swizzleSel) {
    if (!orignalClass) {
        return false;
    }
    Method origMethod = class_getInstanceMethod(orignalClass, oriSel);
    Method swizzleMethod = class_getInstanceMethod(orignalClass, swizzleSel);
    if (!origMethod) {
        class_addMethod(orignalClass, oriSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        method_setImplementation(swizzleMethod, imp_implementationWithBlock(^(id self, SEL _cmd) {
            NSAssert(false, @"Here comes an empty method implementation.");
        }));
    }
    BOOL didAddMethod = class_addMethod(orignalClass, oriSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(orignalClass, swizzleSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, swizzleMethod);
    }
    return true;
}

BOOL k_zombie_swizzleClassMethodWithTarget(Class orignalClass, SEL oriSel, SEL swizzleSel) {
    if (!orignalClass) {
        return false;
    }
    Method originalMethod = class_getClassMethod([orignalClass class], oriSel);
    Method swizzleMethod = class_getClassMethod([orignalClass class], swizzleSel);
    if (!originalMethod) {
        class_addMethod(object_getClass(orignalClass), oriSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        method_setImplementation(swizzleMethod, imp_implementationWithBlock(^(id self, SEL _cmd){
            NSAssert(false, @"Here comes an empty method implementation.");
        }));
    }
    BOOL didAddMethod = class_addMethod(object_getClass(orignalClass), oriSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(object_getClass(orignalClass), swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, (swizzleMethod));
    }
    return true;
}

@end
