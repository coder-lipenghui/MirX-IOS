//
//  ViewController.m
//  MirX
//
//  Created by 李鹏辉 on 2026/1/28.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "IosBridge.h"

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) IosBridge *iosBridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.accountName.length > 0) {
        self.navigationItem.title = self.accountName;
        NSLog(@"Login account: %@", self.accountName);
    }

    self.view.backgroundColor = [UIColor blackColor]; // 防止露底显白边
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView = webView;
    
    self.iosBridge = [[IosBridge alloc] initWithWebView:self.webView];
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // iOS 14+ 推荐用 WKWebpagePreferences 控制 JS
    if (@available(iOS 14.0, *)) {
        WKWebpagePreferences *pagePrefs = [[WKWebpagePreferences alloc] init];
        pagePrefs.allowsContentJavaScript = YES;
        config.defaultWebpagePreferences = pagePrefs;
    } else {
        // iOS 13 及以下
        config.preferences.javaScriptEnabled = YES;
    }
    
    // 关键：别让系统给 scrollView 自动加安全区 inset
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [self.view addSubview:webView];

    // 关键：贴满“父 view”，不要贴 safeAreaLayoutGuide
    [NSLayoutConstraint activateConstraints:@[
    [webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.30.40"]]];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.iosBridge updateSafeAreaWithViewController:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.iosBridge updateSafeAreaWithViewController:self];
    }];
}

#pragma mark - WKNavigationDelegate (可选：打印加载失败原因)
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation: %@", error);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation: %@", error);
}

#pragma mark - WKUIDelegate (可选：让 alert 能弹)
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
 initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
