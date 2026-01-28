//
//  IosBridge.h
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//

#ifndef IosBridge_h
#define IosBridge_h

// IosBridge.h
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class NetworkStateMonitor;
@class PowerStateMonitor;

NS_ASSUME_NONNULL_BEGIN

@interface IosBridge : NSObject

@property (nonatomic, weak, readonly) WKWebView *webView;

- (instancetype)initWithWebView:(WKWebView *)webView;

// 游戏准备好后调用：把缓存的最新网络/电量状态补发给 JS
- (void)onGameReady;

// 主动通知（一般由 monitor 触发）
- (void)notifyNetworkState:(NSInteger)state stage:(NSInteger)stage;
- (void)notifyPowerState:(NSInteger)state val:(NSInteger)val;

// 获取/绑定监测器
@property (nonatomic, strong, readonly) NetworkStateMonitor *networkMonitor;
@property (nonatomic, strong, readonly) PowerStateMonitor *powerMonitor;

@end

NS_ASSUME_NONNULL_END
#endif /* IosBridge_h */
