#import "Config.h"

@implementation Config

static BOOL ConfigIsDebug = YES;
static NSString *ConfigSku = @"";
static NSInteger ConfigDistributionId = 0;
static NSString *ConfigUrl = @"";
static NSString *ConfigChannel = @"";
static NSString *ConfigGameEntrance = @"";
static NSInteger ConfigClientVer = 0;

static NSString *ConfigAppId = @"";
static NSString *ConfigAppKey = @"";
static NSString *ConfigBuglyAppId = @"cb437e2282";
static NSArray<NSNumber *> *ConfigSafeArea = nil;
static NSInteger ConfigDesignResolutionWidth = 1334;
static NSInteger ConfigDesignResolutionHeight = 750;

static NSString *ConfigCrISBN = @"";
static NSString *ConfigCrNumber = @"";
static NSString *ConfigCrPress = @"";
static NSString *ConfigCrAuthor = @"";

static NSString *ConfigLoginApi = @"/api/channel/login";
static NSString *ConfigOrderApi = @"/api/payment/createOrder";
static NSString *ConfigNotifyApi = @"notify-login";
static NSString *ConfigCdkeyApi = @"cdkey";
static NSString *ConfigContactApi = @"contact";
static NSString *ConfigUpdateApi = @"center/game-update";
static NSString *ConfigAssetsApi = @"center/game-assets";
static NSString *ConfigCopyrightApi = @"game-copyright";
static NSString *ConfigFeedbackApi = @"center/feedback";
static NSString *ConfigReportApi = @"record";

static NSString *ConfigRoleId = @"";
static NSString *ConfigRoleName = @"";
static NSInteger ConfigRoleLevel = 1;
static NSInteger ConfigRoleVipLevel = 1;
static long long ConfigRoleCreateTime = 0;
static long long ConfigRoleUpdateTime = 0;

static NSString *ConfigSdkUid = nil;
static NSString *ConfigSdkUname = nil;
static NSString *ConfigSdkToken = nil;
static NSString *ConfigAccount = nil;
static NSString *ConfigUid = nil;
static NSString *ConfigToken = nil;
static NSString *ConfigSignCode = nil;
static long long ConfigSignTime = 0;

static NSInteger ConfigServerId = 0;
static NSInteger ConfigServerIndex = 0;
static NSString *ConfigServerName = @"";

+ (BOOL)isDebug {
    return ConfigIsDebug;
}

+ (void)setIsDebug:(BOOL)isDebug {
    ConfigIsDebug = isDebug;
}

+ (NSString *)sku {
    return ConfigSku;
}

+ (void)setSku:(NSString *)sku {
    ConfigSku = [sku copy];
}

+ (NSInteger)distributionId {
    return ConfigDistributionId;
}

+ (void)setDistributionId:(NSInteger)distributionId {
    ConfigDistributionId = distributionId;
}

+ (NSString *)url {
    return ConfigUrl;
}

+ (void)setUrl:(NSString *)url {
    ConfigUrl = [url copy];
}

+ (NSString *)channel {
    return ConfigChannel;
}

+ (void)setChannel:(NSString *)channel {
    ConfigChannel = [channel copy];
}

+ (NSString *)gameEntrance {
    return ConfigGameEntrance;
}

+ (void)setGameEntrance:(NSString *)gameEntrance {
    ConfigGameEntrance = [gameEntrance copy];
}

+ (NSInteger)clientVer {
    return ConfigClientVer;
}

+ (void)setClientVer:(NSInteger)clientVer {
    ConfigClientVer = clientVer;
}

+ (NSString *)appId {
    return ConfigAppId;
}

+ (void)setAppId:(NSString *)appId {
    ConfigAppId = [appId copy];
}

+ (NSString *)appKey {
    return ConfigAppKey;
}

+ (void)setAppKey:(NSString *)appKey {
    ConfigAppKey = [appKey copy];
}

+ (NSString *)BuglyAppId {
    return ConfigBuglyAppId;
}

+ (void)setBuglyAppId:(NSString *)BuglyAppId {
    ConfigBuglyAppId = [BuglyAppId copy];
}

+ (NSArray<NSNumber *> *)safeArea {
    if (!ConfigSafeArea) {
        ConfigSafeArea = @[@0, @0, @0, @0, @0];
    }
    return ConfigSafeArea;
}

+ (void)setSafeArea:(NSArray<NSNumber *> *)safeArea {
    ConfigSafeArea = [safeArea copy];
}

+ (NSInteger)designResolutionWidth {
    return ConfigDesignResolutionWidth;
}

+ (void)setDesignResolutionWidth:(NSInteger)designResolutionWidth {
    ConfigDesignResolutionWidth = designResolutionWidth;
}

+ (NSInteger)designResolutionHeight {
    return ConfigDesignResolutionHeight;
}

+ (void)setDesignResolutionHeight:(NSInteger)designResolutionHeight {
    ConfigDesignResolutionHeight = designResolutionHeight;
}

+ (NSString *)crISBN {
    return ConfigCrISBN;
}

+ (void)setCrISBN:(NSString *)crISBN {
    ConfigCrISBN = [crISBN copy];
}

+ (NSString *)crNumber {
    return ConfigCrNumber;
}

+ (void)setCrNumber:(NSString *)crNumber {
    ConfigCrNumber = [crNumber copy];
}

+ (NSString *)crPress {
    return ConfigCrPress;
}

+ (void)setCrPress:(NSString *)crPress {
    ConfigCrPress = [crPress copy];
}

+ (NSString *)crAuthor {
    return ConfigCrAuthor;
}

+ (void)setCrAuthor:(NSString *)crAuthor {
    ConfigCrAuthor = [crAuthor copy];
}

+ (NSString *)loginApi {
    return ConfigLoginApi;
}

+ (void)setLoginApi:(NSString *)loginApi {
    ConfigLoginApi = [loginApi copy];
}

+ (NSString *)orderApi {
    return ConfigOrderApi;
}

+ (void)setOrderApi:(NSString *)orderApi {
    ConfigOrderApi = [orderApi copy];
}

+ (NSString *)notifyApi {
    return ConfigNotifyApi;
}

+ (void)setNotifyApi:(NSString *)notifyApi {
    ConfigNotifyApi = [notifyApi copy];
}

+ (NSString *)cdkeyApi {
    return ConfigCdkeyApi;
}

+ (void)setCdkeyApi:(NSString *)cdkeyApi {
    ConfigCdkeyApi = [cdkeyApi copy];
}

+ (NSString *)contactApi {
    return ConfigContactApi;
}

+ (void)setContactApi:(NSString *)contactApi {
    ConfigContactApi = [contactApi copy];
}

+ (NSString *)updateApi {
    return ConfigUpdateApi;
}

+ (void)setUpdateApi:(NSString *)updateApi {
    ConfigUpdateApi = [updateApi copy];
}

+ (NSString *)assetsApi {
    return ConfigAssetsApi;
}

+ (void)setAssetsApi:(NSString *)assetsApi {
    ConfigAssetsApi = [assetsApi copy];
}

+ (NSString *)copyrightApi {
    return ConfigCopyrightApi;
}

+ (void)setCopyrightApi:(NSString *)copyrightApi {
    ConfigCopyrightApi = [copyrightApi copy];
}

+ (NSString *)feedbackApi {
    return ConfigFeedbackApi;
}

+ (void)setFeedbackApi:(NSString *)feedbackApi {
    ConfigFeedbackApi = [feedbackApi copy];
}

+ (NSString *)reportApi {
    return ConfigReportApi;
}

+ (void)setReportApi:(NSString *)reportApi {
    ConfigReportApi = [reportApi copy];
}

+ (NSString *)roleId {
    return ConfigRoleId;
}

+ (void)setRoleId:(NSString *)roleId {
    ConfigRoleId = [roleId copy];
}

+ (NSString *)roleName {
    return ConfigRoleName;
}

+ (void)setRoleName:(NSString *)roleName {
    ConfigRoleName = [roleName copy];
}

+ (NSInteger)roleLevel {
    return ConfigRoleLevel;
}

+ (void)setRoleLevel:(NSInteger)roleLevel {
    ConfigRoleLevel = roleLevel;
}

+ (NSInteger)roleVipLevel {
    return ConfigRoleVipLevel;
}

+ (void)setRoleVipLevel:(NSInteger)roleVipLevel {
    ConfigRoleVipLevel = roleVipLevel;
}

+ (long long)roleCreateTime {
    return ConfigRoleCreateTime;
}

+ (void)setRoleCreateTime:(long long)roleCreateTime {
    ConfigRoleCreateTime = roleCreateTime;
}

+ (long long)roleUpdateTime {
    return ConfigRoleUpdateTime;
}

+ (void)setRoleUpdateTime:(long long)roleUpdateTime {
    ConfigRoleUpdateTime = roleUpdateTime;
}

+ (NSString *)sdk_uid {
    return ConfigSdkUid;
}

+ (void)setSdk_uid:(NSString * _Nullable)sdk_uid {
    ConfigSdkUid = [sdk_uid copy];
}

+ (NSString *)sdk_uname {
    return ConfigSdkUname;
}

+ (void)setSdk_uname:(NSString * _Nullable)sdk_uname {
    ConfigSdkUname = [sdk_uname copy];
}

+ (NSString *)sdk_token {
    return ConfigSdkToken;
}

+ (void)setSdk_token:(NSString * _Nullable)sdk_token {
    ConfigSdkToken = [sdk_token copy];
}

+ (NSString *)account {
    return ConfigAccount;
}

+ (void)setAccount:(NSString * _Nullable)account {
    ConfigAccount = [account copy];
}

+ (NSString *)uid {
    return ConfigUid;
}

+ (void)setUid:(NSString * _Nullable)uid {
    ConfigUid = [uid copy];
}

+ (NSString *)token {
    return ConfigToken;
}

+ (void)setToken:(NSString * _Nullable)token {
    ConfigToken = [token copy];
}

+ (NSString *)signCode {
    return ConfigSignCode;
}

+ (void)setSignCode:(NSString * _Nullable)signCode {
    ConfigSignCode = [signCode copy];
}

+ (long long)signTime {
    return ConfigSignTime;
}

+ (void)setSignTime:(long long)signTime {
    ConfigSignTime = signTime;
}

+ (NSInteger)serverId {
    return ConfigServerId;
}

+ (void)setServerId:(NSInteger)serverId {
    ConfigServerId = serverId;
}

+ (NSInteger)serverIndex {
    return ConfigServerIndex;
}

+ (void)setServerIndex:(NSInteger)serverIndex {
    ConfigServerIndex = serverIndex;
}

+ (NSString *)serverName {
    return ConfigServerName;
}

+ (void)setServerName:(NSString *)serverName {
    ConfigServerName = [serverName copy];
}

@end
