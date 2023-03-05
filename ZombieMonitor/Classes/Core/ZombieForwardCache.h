//
//  ZombieForwardCache.h
//  ZombieMonitor
//
//  Created by tanxl on 2023/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZombieForwardCache : NSObject

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype)shared;

- (void)addObject:(nullable NSObject *)object;

@end

NS_ASSUME_NONNULL_END
