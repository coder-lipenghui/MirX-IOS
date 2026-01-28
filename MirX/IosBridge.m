//
//  IosBridge.m
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//

// IosBridge.m
#import "IosBridge.h"
#import "NetworkStateMonitor.h"
#import "PowerStateMonitor.h"

@interface IosBridge ()
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NetworkStateMonitor *networkMonitor;
@property (nonatomic, strong) PowerStateMonitor *powerMonitor;
@property (nonatomic, assign) BOOL gameReady;
@property (nonatomic, assign) NSInteger lastPlatformId;
@end

@implementation IosBridge

- (instancetype)initWithWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
        _gameReady = NO;

        __weak typeof(self) weakSelf = self;

        // 网络监测器：状态变化回调 -> 通知 JS
        _networkMonitor = [[NetworkStateMonitor alloc] initWithChangeHandler:^(NSInteger state, NSInteger stage) {
            __strong typeof(weakSelf) selfStrong = weakSelf;
            if (!selfStrong) return;
            if (!selfStrong.gameReady) return; // 游戏没准备好先缓存，等 onGameReady 统一补发
            [selfStrong notifyNetworkState:state stage:stage];
        }];

        // 电池监测器：状态变化回调 -> 通知 JS
        _powerMonitor = [[PowerStateMonitor alloc] initWithChangeHandler:^(NSInteger state, NSInteger val) {
            __strong typeof(weakSelf) selfStrong = weakSelf;
            if (!selfStrong) return;
            if (!selfStrong.gameReady) return;
            [selfStrong notifyPowerState:state val:val];
        }];

        // 开始监测
        [_networkMonitor start];
        [_powerMonitor start];
    }
    return self;
}

- (void)dealloc {
    [_networkMonitor stop];
    [_powerMonitor stop];
}

- (void)onGameReady {
    self.gameReady = YES;

    // 把缓存的最新状态补发一次（类似你 Android 的 getLastState / getLastVal）
    NSInteger netState = self.networkMonitor.lastState;
    NSInteger netStage = self.networkMonitor.lastStage;
    if (netState > 0 && netStage > 0) {
        [self notifyNetworkState:netState stage:netStage];
    }

    NSInteger powerState = self.powerMonitor.lastState;
    NSInteger powerVal = self.powerMonitor.lastVal;
    if (powerState > 0 && powerVal > 0) {
        [self notifyPowerState:powerState val:powerVal];
    }
}

#pragma mark - Notify JS

- (void)trigger:(NSString *)eventName jsonString:(NSString *)jsonString {
    NSLog(@"[IosBridge] trigger eventName=%@ json=%@", eventName, jsonString);

    NSString *prettyJson = [self prettyJsonIfPossible:jsonString];
    NSString *msg = [NSString stringWithFormat:@"eventName:\n%@\n\njson:\n%@", eventName, prettyJson];
    NSLog(@"[IosBridge] trigger msg=%@", msg);

    if (jsonString.length == 0) {
        return;
    }

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return;
    }

    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || ![jsonObj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"[IosBridge] trigger parse error: %@", error);
        return;
    }

    NSDictionary *dict = (NSDictionary *)jsonObj;
    NSNumber *platformId = dict[@"platform_id"];
    if ([platformId respondsToSelector:@selector(integerValue)]) {
        self.lastPlatformId = platformId.integerValue;
    }
}

- (void)triggerArray:(NSString *)bodyJsonArrayString {
    NSLog(@"[IosBridge] triggerArray: %@", bodyJsonArrayString);

    NSString *eventName = @"";
    NSString *jsonString = @"";

    if (bodyJsonArrayString.length > 0) {
        NSData *data = [bodyJsonArrayString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error && [jsonObj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)jsonObj;
            if (arr.count >= 2) {
                if ([arr[0] isKindOfClass:[NSString class]]) {
                    eventName = arr[0];
                }
                if ([arr[1] isKindOfClass:[NSString class]]) {
                    jsonString = arr[1];
                }
            }
        } else if (error) {
            NSLog(@"[IosBridge] triggerArray parse error: %@", error);
        }
    }

    NSString *prettyJson = [self prettyJsonIfPossible:jsonString];
    NSString *msg = [NSString stringWithFormat:@"rawBody:\n%@\n\neventName:\n%@\n\njson:\n%@",
                     bodyJsonArrayString, eventName, prettyJson];
    NSLog(@"[IosBridge] triggerArray msg=%@", msg);

    if (eventName.length > 0 || jsonString.length > 0) {
        [self trigger:eventName jsonString:jsonString];
    }
}

- (void)notifyNetworkState:(NSInteger)state stage:(NSInteger)stage {
    // JS: setNetworkState(state:int, stage:int)
    NSString *js = [NSString stringWithFormat:@"try{ if(window.setNetworkState){ setNetworkState(%ld,%ld); } }catch(e){}",
                    (long)state, (long)stage];
    [self evalJS:js];
}

- (void)notifyPowerState:(NSInteger)state val:(NSInteger)val {
    // JS: setPowerState(state:int, val:int)
    NSString *js = [NSString stringWithFormat:@"try{ if(window.setPowerState){ setPowerState(%ld,%ld); } }catch(e){}",
                    (long)state, (long)val];
    [self evalJS:js];
}

- (void)evalJS:(NSString *)js {
    WKWebView *wv = self.webView;
    if (!wv) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        [wv evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            // 需要调试时打开
            // if (error) NSLog(@"[IosBridge] evalJS error: %@", error);
        }];
    });
}

- (NSString *)prettyJsonIfPossible:(NSString *)jsonString {
    if (jsonString.length == 0) {
        return @"";
    }

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return jsonString;
    }

    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || !jsonObj) {
        return jsonString;
    }

    NSData *prettyData = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
    if (error || !prettyData) {
        return jsonString;
    }

    NSString *pretty = [[NSString alloc] initWithData:prettyData encoding:NSUTF8StringEncoding];
    return pretty ?: jsonString;
}

@end
