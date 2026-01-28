#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Config : NSObject

/**
 * 是否是测试版本
 */
@property (class, nonatomic, assign) BOOL isDebug;

//=================后台分配的参数=======================//
/**
 * 游戏SKU
 */
@property (class, nonatomic, copy) NSString *sku;

/**
 * 分销渠道ID
 */
@property (class, nonatomic, assign) NSInteger distributionId;

@property (class, nonatomic, copy) NSString *url;

/**
 * 渠道名称
 */
@property (class, nonatomic, copy) NSString *channel;

/**
 * 游戏入口地址
 */
@property (class, nonatomic, copy) NSString *gameEntrance;

@property (class, nonatomic, assign) NSInteger clientVer;

//================渠道分配的参数=======================//
/**
 * 分销商分配的appId
 */
@property (class, nonatomic, copy) NSString *appId;

/**
 * 分销商分配的appKey
 */
@property (class, nonatomic, copy) NSString *appKey;

/**
 * bugly分配的id，需要与客户端的id相同
 */
@property (class, nonatomic, copy) NSString *BuglyAppId;

/**
 * safe area信息
 */
@property (class, nonatomic, copy) NSArray<NSNumber *> *safeArea;

/**
 * 游戏版号相关资料，可默认填写 后台有填写则会被覆盖
 */
@property (class, nonatomic, copy) NSString *crISBN;
@property (class, nonatomic, copy) NSString *crNumber;
@property (class, nonatomic, copy) NSString *crPress;
@property (class, nonatomic, copy) NSString *crAuthor;

//////[以下部分基本无需修改]/////////////

/**以下部分为游戏需要的接口名称，不要随意更改，除非后台对应的接口名称发生变化**/

/**
 * 游戏登录API接口
 */
@property (class, nonatomic, copy) NSString *loginApi;

/**
 * 游戏获取订单接口
 */
@property (class, nonatomic, copy) NSString *orderApi;

/**
 * 进入游戏接口
 */
@property (class, nonatomic, copy) NSString *notifyApi;

/**
 * CDKKEY接口
 */
@property (class, nonatomic, copy) NSString *cdkeyApi;

/**
 * CDKKEY接口
 */
@property (class, nonatomic, copy) NSString *contactApi;

/**
 * 游戏更新接口
 */
@property (class, nonatomic, copy) NSString *updateApi;

/**
 * 游戏分包资源获取接口
 */
@property (class, nonatomic, copy) NSString *assetsApi;

/**
 * 游戏版号信息获取接口
 */
@property (class, nonatomic, copy) NSString *copyrightApi;

/**
 * 游戏问题反馈提交接口
 */
@property (class, nonatomic, copy) NSString *feedbackApi;

/**
 * 数据上报接口
 */
@property (class, nonatomic, copy) NSString *reportApi;

/**
 * 以下部分为数据上报需要,无需手动填写
 */
//角色数据
@property (class, nonatomic, copy) NSString *roleId;
@property (class, nonatomic, copy) NSString *roleName;
@property (class, nonatomic, assign) NSInteger roleLevel;
@property (class, nonatomic, assign) NSInteger roleVipLevel;
@property (class, nonatomic, assign) long long roleCreateTime;
@property (class, nonatomic, assign) long long roleUpdateTime;

//账号数据
@property (class, nonatomic, copy, nullable) NSString *sdk_uid;
@property (class, nonatomic, copy, nullable) NSString *sdk_uname;
@property (class, nonatomic, copy, nullable) NSString *sdk_token;
@property (class, nonatomic, copy, nullable) NSString *account;
@property (class, nonatomic, copy, nullable) NSString *uid;
@property (class, nonatomic, copy, nullable) NSString *token;
@property (class, nonatomic, copy, nullable) NSString *signCode;
@property (class, nonatomic, assign) long long signTime;

//区服数据
@property (class, nonatomic, assign) NSInteger serverId;
@property (class, nonatomic, assign) NSInteger serverIndex;
@property (class, nonatomic, copy) NSString *serverName;

@end

NS_ASSUME_NONNULL_END
