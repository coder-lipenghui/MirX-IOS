//
//  NetworkStateMonitor.m
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//
// NetworkStateMonitor.m
#import "NetworkStateMonitor.h"
#import <Network/Network.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface NetworkStateMonitor ()
@property (nonatomic, copy) NetworkStateChangeHandler handler;
@property (nonatomic, strong) nw_path_monitor_t pathMonitor;
@property (nonatomic, assign) NSInteger lastState;
@property (nonatomic, assign) NSInteger lastStage;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation NetworkStateMonitor

- (instancetype)initWithChangeHandler:(NetworkStateChangeHandler)handler {
    self = [super init];
    if (self) {
        _handler = [handler copy];
        _lastState = 0;
        _lastStage = 0;
        _queue = dispatch_queue_create("com.game.netmonitor", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)start {
    if (self.pathMonitor) return;

    self.pathMonitor = nw_path_monitor_create();

    __weak typeof(self) weakSelf = self;
    nw_path_monitor_set_update_handler(self.pathMonitor, ^(nw_path_t path) {
        __strong typeof(weakSelf) selfStrong = weakSelf;
        if (!selfStrong) return;

        NSInteger state = 0; // 1=流量 2=wifi
        if (nw_path_uses_interface_type(path, nw_interface_type_wifi)) {
            state = 2;
        } else if (nw_path_uses_interface_type(path, nw_interface_type_cellular)) {
            state = 1;
        } else {
            // 其他情况（无网/以太网等），你没定义，这里先不通知或按需扩展
            return;
        }

        // stage：iOS 没有官方直接给 1-4 的“信号强弱”统一值
        // 这里给一个保守实现：蜂窝网络固定给 3，wifi 固定给 4。
        // 如果你需要精确蜂窝信号（RSRP/ bars），需要额外做私有/灰色方案，不建议上架使用。
        NSInteger stage = (state == 2) ? 4 : 3;

        [selfStrong updateIfChangedState:state stage:stage];
    });

    nw_path_monitor_set_queue(self.pathMonitor, self.queue);
    nw_path_monitor_start(self.pathMonitor);
}

- (void)stop {
    if (!self.pathMonitor) return;
    nw_path_monitor_cancel(self.pathMonitor);
    self.pathMonitor = nil;
}

- (void)updateIfChangedState:(NSInteger)state stage:(NSInteger)stage {
    // 缓存并去重
    if (self.lastState == state && self.lastStage == stage) return;

    self.lastState = state;
    self.lastStage = stage;

    if (self.handler) {
        self.handler(state, stage);
    }
}

@end
