//
//  PowerStateMonitor.h
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//
// PowerStateMonitor.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PowerStateChangeHandler)(NSInteger state, NSInteger val);

@interface PowerStateMonitor : NSObject

// 缓存：state 1=正常 2=充电中；val 1-100
@property (nonatomic, assign, readonly) NSInteger lastState;
@property (nonatomic, assign, readonly) NSInteger lastVal;

- (instancetype)initWithChangeHandler:(PowerStateChangeHandler)handler;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END

