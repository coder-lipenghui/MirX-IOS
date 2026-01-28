#import "foundation.h"
#import "Config.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kFoundationTag = @"LIPENGHIU_DEBUG";

static NSString *FoundationURLEncode(NSString *value) {
    NSCharacterSet *allowed = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [value stringByAddingPercentEncodingWithAllowedCharacters:allowed] ?: @"";
}

static NSString *FoundationDeviceId(void) {
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    return uuid.UUIDString ?: @"";
}

static NSString *FoundationMD5(NSString *input) {
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@implementation foundation

- (void)init:(UIViewController *)viewController {
}

- (void)gameInit {
    self.gameInited = YES;
}

- (void)login:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }
}

- (void)pay:(UIViewController *)viewController orderId:(NSString *)orderId name:(NSString *)name price:(NSInteger)price {
    if (!self.inited) {
        return;
    }
}

- (void)switchAccount:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }
}

- (void)logout:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }
}

- (void)exit:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确认退出游戏？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(viewController) weakVC = viewController;
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        __strong typeof(weakVC) strongVC = weakVC;
        [strongVC dismissViewControllerAnimated:YES completion:nil];
        exit(0);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)adminTrigger:(UIViewController *)viewController type:(NSInteger)type {
}

- (void)getGameCopyright:(UIViewController *)viewController {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?sku=%@",
                           Config.url,
                           Config.channel,
                           Config.copyrightApi,
                           Config.sku];
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSLog(@"%@ invalid url: %@", kFoundationTag, urlString);
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@ error: %@", kFoundationTag, error);
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSString *respStr = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"";
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSLog(@"%@ 版号信息获取失败 http=%ld, body=%@", kFoundationTag, (long)httpResponse.statusCode, respStr);
            return;
        }

        NSError *jsonError = nil;
        NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] : nil;
        if (!json || jsonError) {
            NSLog(@"%@ 版号信息获取失败:JSON错误 body=%@", kFoundationTag, respStr);
            return;
        }

        Config.crISBN = json[@"copyright_isbn"] ?: @"";
        Config.crNumber = json[@"copyright_number"] ?: @"";
        Config.crAuthor = json[@"copyright_author"] ?: @"";
        Config.crPress = json[@"copyright_press"] ?: @"";
        NSLog(@"%@ success", kFoundationTag);
    }];
    [task resume];
}

- (void)report:(UIViewController *)viewController type:(NSInteger)type {
    [self adminTrigger:viewController type:type];
    [self trigger:viewController type:type];
}

- (void)trigger:(UIViewController *)viewController type:(NSInteger)type {
}

- (void)showFloatView:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }
}

- (void)dismissFloatView:(UIViewController *)viewController {
    if (!self.inited) {
        return;
    }
}

- (void)extendFunction:(UIViewController *)viewController functionType:(NSInteger)functionType object:(id)object {
    if (!self.inited) {
        return;
    }
}

- (void)onLoginFailed {
}

- (void)onLoginSuccess:(UIViewController *)viewController {
    if (Config.isDebug && Config.url.length == 0) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"platformId"] = @(Config.distributionId);
        params[@"deviceVender"] = @"Apple";
        params[@"deviceOs"] = [UIDevice currentDevice].systemVersion ?: @"";
        params[@"deviceId"] = FoundationDeviceId();
        params[@"deviceType"] = [UIDevice currentDevice].model ?: @"";
        params[@"token"] = Config.sdk_token ?: @"";
        params[@"uid"] = Config.sdk_uid ?: @"";
        params[@"userName"] = Config.sdk_uname ?: @"";
        params[@"sku"] = Config.sku ?: @"";

        NSString *urlString = [NSString stringWithFormat:@"%@%@", Config.url, Config.loginApi];
        NSLog(@"LOGIN %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        if (!url) {
            [self showLoginErrorAndExit:viewController];
            return;
        }

        NSError *jsonError = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError || !body) {
            [self showLoginErrorAndExit:viewController];
            return;
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        request.HTTPBody = body;

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"onFailure network error: %@", error);
                [self showLoginErrorAndExit:viewController];
                return;
            }

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *respStr = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"";
            if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                NSLog(@"onFailure http=%ld, body=%@", (long)httpResponse.statusCode, respStr);
                [self showLoginErrorAndExit:viewController];
                return;
            }

            NSError *parseError = nil;
            NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError] : nil;
            if (!json || parseError) {
                NSLog(@"LOGIN parse/handle error body=%@", respStr);
                [self showLoginErrorAndExit:viewController];
                return;
            }

            NSInteger code = [json[@"errorCode"] integerValue];
            if (code == 0) {
                NSInteger distributionId = [json[@"platformId"] integerValue];
                NSString *distAccount = json[@"channelAccount"] ?: @"";
                NSString *distUid = json[@"channelUid"] ?: @"";
                NSString *account = json[@"account"] ?: @"";
                NSString *gameUid = json[@"gameUid"] ?: @"";
                NSInteger clientVer = [json[@"clientVer"] integerValue];
                NSString *signCode = json[@"signCode"] ?: @"";
                long long signTime = [json[@"signTime"] longLongValue];
                BOOL selectServer = [json[@"selectServer"] boolValue];
                NSString *resourceServerUrl = json[@"resourceServerUrl"] ?: @"";

                Config.distributionId = distributionId;
                Config.gameEntrance = [resourceServerUrl stringByAppendingString:@"/index.html"];
                Config.account = account;
                Config.uid = gameUid;
                Config.clientVer = clientVer;
                Config.signCode = signCode;
                Config.signTime = signTime;
                Config.sdk_uname = distAccount;
                Config.sdk_uid = distUid;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleLoginSuccess:viewController selectServer:selectServer signCode:signCode signTime:signTime];
                });
            } else {
                NSInteger failCode = [json[@"code"] integerValue];
                NSString *msg = json[@"errorMessage"] ?: @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"登录失败:%ld,%@", (long)failCode, msg];
                    [self showMessage:message inViewController:viewController];
                });
            }
        }];
        [task resume];
    });
}

- (void)handleLoginSuccess:(UIViewController *)viewController
              selectServer:(BOOL)selectServer
                  signCode:(NSString *)signCode
                  signTime:(long long)signTime {
}

- (void)showLoginErrorAndExit:(UIViewController *)viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"登录验证出现异常，请联系管理员。"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            exit(0);
        }]];
        [viewController presentViewController:alert animated:YES completion:nil];
    });
}

- (void)doPay:(UIViewController *)viewController id:(NSInteger)productId name:(NSString *)name price:(NSInteger)price {
    NSLog(@"%@ %ld %@ %ld", kFoundationTag, (long)productId, name, (long)price);

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *secretKey = @"d41d8cd98f00b204e9800998ecf8427e";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sku"] = Config.sku ?: @"";
        params[@"platformId"] = @(Config.distributionId);
        params[@"account"] = Config.account ?: @"";
        params[@"platformUserId"] = Config.sdk_uid ?: @"";
        params[@"playerId"] = Config.roleId ?: @"";
        params[@"nickName"] = FoundationURLEncode(Config.roleName ?: @"");
        params[@"roleLevel"] = @(Config.roleLevel);
        params[@"serverId"] = @(Config.serverId);
        params[@"serverName"] = FoundationURLEncode(Config.serverName ?: @"");
        params[@"money"] = @(price);
        params[@"productId"] = @(productId);
        params[@"productName"] = FoundationURLEncode(name ?: @"");
        params[@"deviceId"] = FoundationDeviceId();
        params[@"createTime"] = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970])];

        NSArray<NSString *> *keyList = @[
            @"sku",
            @"platformId",
            @"account",
            @"platformUserId",
            @"playerId",
            @"nickName",
            @"roleLevel",
            @"serverId",
            @"serverName",
            @"money",
            @"productId",
            @"productName",
            @"deviceId",
            @"createTime"
        ];

        NSArray<NSString *> *sortedKeys = [keyList sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray<NSString *> *segments = [NSMutableArray array];
        for (NSString *key in sortedKeys) {
            id value = params[key] ?: @"";
            [segments addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        NSString *keyString = [segments componentsJoinedByString:@"&"];
        params[@"ticket"] = FoundationMD5([secretKey stringByAppendingString:keyString]);

        NSString *urlString = [NSString stringWithFormat:@"%@%@", Config.url, Config.orderApi];
        NSURL *url = [NSURL URLWithString:urlString];
        if (!url) {
            [self showMessage:@"创建订单失败，请尝试重新发起充值。多次未成功 请联系管理员。" inViewController:viewController];
            return;
        }

        NSError *jsonError = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError || !body) {
            [self showMessage:@"创建订单异常,请联系管理员。" inViewController:viewController];
            return;
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        request.HTTPBody = body;

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"%@ 创建订单请求失败 %@", kFoundationTag, error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"创建订单失败，请尝试重新发起充值。多次未成功 请联系管理员。" inViewController:viewController];
                });
                return;
            }

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *respStr = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"";
            if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                NSLog(@"%@ 创建订单失败 http=%ld, body=%@", kFoundationTag, (long)httpResponse.statusCode, respStr);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"创建订单失败，请尝试重新发起充值。多次未成功 请联系管理员。" inViewController:viewController];
                });
                return;
            }

            NSError *parseError = nil;
            NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError] : nil;
            if (!json || parseError) {
                NSLog(@"%@ 创建订单解析/处理异常 body=%@", kFoundationTag, respStr);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:@"创建订单异常,请联系管理员。" inViewController:viewController];
                });
                return;
            }

            NSInteger code = [json[@"code"] integerValue];
            if (code == 0) {
                NSString *orderId = json[@"orderId"] ?: @"";
                NSString *productName = json[@"productName"] ?: @"";
                NSInteger productPrice = [json[@"productPrice"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pay:viewController orderId:orderId name:productName price:productPrice];
                });
            } else {
                NSString *message = json[@"msg"] ?: (json[@"message"] ?: @"");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *display = [NSString stringWithFormat:@"创建订单失败:%@", message];
                    [self showMessage:display inViewController:viewController];
                });
            }
        }];
        [task resume];
    });
}

- (nullable NSString *)getChannelID {
    return nil;
}

- (NSString *)getConfig:(UIViewController *)viewController key:(NSString *)key {
    return @"";
}

- (void)showMessage:(NSString *)message inViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
