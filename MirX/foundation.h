#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface foundation : NSObject

@property (nonatomic, assign, getter=isInited) BOOL inited;
@property (nonatomic, assign) BOOL gameInited;

/**
 * 初始化
 */
- (void)init:(UIViewController *)viewController;

- (void)gameInit;

/**
 * 登录
 */
- (void)login:(UIViewController *)viewController;

/**
 * 支付
 */
- (void)pay:(UIViewController *)viewController
    orderId:(NSString *)orderId
       name:(NSString *)name
      price:(NSInteger)price;

/**
 * 切换账号
 */
- (void)switchAccount:(UIViewController *)viewController;

/**
 * 登出
 */
- (void)logout:(UIViewController *)viewController;

/**
 * 退出
 */
- (void)exit:(UIViewController *)viewController;

/**
 * 数据上报接口
 */
- (void)report:(UIViewController *)viewController type:(NSInteger)type;

/**
 * SDK侧数据上报
 */
- (void)trigger:(UIViewController *)viewController type:(NSInteger)type;

/**
 * 显示SDK悬浮窗
 */
- (void)showFloatView:(UIViewController *)viewController;

/**
 * 关闭SDK悬浮窗
 */
- (void)dismissFloatView:(UIViewController *)viewController;

/**
 * 拓展接口
 */
- (void)extendFunction:(UIViewController *)viewController
          functionType:(NSInteger)functionType
                object:(nullable id)object;

- (void)onLoginFailed;
- (void)onLoginSuccess:(UIViewController *)viewController;

/**
 * 发起支付
 */
- (void)doPay:(UIViewController *)viewController
           id:(NSInteger)productId
         name:(NSString *)name
        price:(NSInteger)price;

/**
 * 获取渠道ID
 */
- (nullable NSString *)getChannelID;

/**
 * 获取部分游戏属性值
 */
- (NSString *)getConfig:(UIViewController *)viewController key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
