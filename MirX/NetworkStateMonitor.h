//
//  NetworkStateMonitor.h
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//

#ifndef NetworkStateMonitor_h
#define NetworkStateMonitor_h

// NetworkStateMonitor.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NetworkStateChangeHandler)(NSInteger state, NSInteger stage);

@interface NetworkStateMonitor : NSObject

// 缓存的最后状态：state 1=流量 2=wifi；stage 1-4
@property (nonatomic, assign, readonly) NSInteger lastState;
@property (nonatomic, assign, readonly) NSInteger lastStage;

// 变化回调
- (instancetype)initWithChangeHandler:(NetworkStateChangeHandler)handler;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
#endif /* NetworkStateMonitor_h */
