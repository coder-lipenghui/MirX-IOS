//
//  PowerStateMonitor.m
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//
// PowerStateMonitor.m
#import "PowerStateMonitor.h"
#import <UIKit/UIKit.h>

@interface PowerStateMonitor ()
@property (nonatomic, copy) PowerStateChangeHandler handler;
@property (nonatomic, assign) NSInteger lastState;
@property (nonatomic, assign) NSInteger lastVal;
@end

@implementation PowerStateMonitor

- (instancetype)initWithChangeHandler:(PowerStateChangeHandler)handler {
    self = [super init];
    if (self) {
        _handler = [handler copy];
        _lastState = 0;
        _lastVal = 0;
    }
    return self;
}

- (void)start {
    UIDevice *device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onBatteryChanged)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onBatteryChanged)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];

    // 启动时先读一次缓存
    [self onBatteryChanged];
}

- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIDevice.currentDevice.batteryMonitoringEnabled = NO;
}

- (void)onBatteryChanged {
    UIDevice *device = UIDevice.currentDevice;

    // val: 1-100
    float level = device.batteryLevel; // -1 表示不可用
    NSInteger val = (level < 0) ? 0 : (NSInteger)lroundf(level * 100.0f);
    if (val < 0) val = 0;
    if (val > 100) val = 100;

    // state: 1=正常 2=充电中（你定义的）
    NSInteger state = 1;
    switch (device.batteryState) {
        case UIDeviceBatteryStateCharging:
        case UIDeviceBatteryStateFull:
            state = 2;
            break;
        case UIDeviceBatteryStateUnplugged:
        case UIDeviceBatteryStateUnknown:
        default:
            state = 1;
            break;
    }

    [self updateIfChangedState:state val:val];
}

- (void)updateIfChangedState:(NSInteger)state val:(NSInteger)val {
    // 去重缓存
    if (self.lastState == state && self.lastVal == val) return;

    self.lastState = state;
    self.lastVal = val;

    if (self.handler && val > 0) {
        self.handler(state, val);
    }
}

@end
