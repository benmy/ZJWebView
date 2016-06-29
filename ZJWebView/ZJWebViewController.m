//
//  WebViewController.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/4/1.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ZJWebViewController.h"

@interface ZJWebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZJWebViewController

- (UIProgressView*)progressView{
    if (!_progressView) {
        // 进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3)];
        progressView.tintColor = [UIColor blueColor];
        progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}

- (WKWebView*)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64)];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib;
    
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKNavigationDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

//开始加载Web页面的时候
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];//设置进度条开始
    [self.progressView setProgress:_webView.estimatedProgress animated:YES];
    [self.progressView setHidden:NO];
    NSLog(@"didCommitNavigation");
}

//结束记载的时候
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//设置进度条开始
    [self.progressView setProgress:1 animated:YES];
    [self reloadProgress];

    NSLog(@"didFinishNavigation");
}

//加载失败的时候，如：网络异常
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//设置进度条开始
    [self reloadProgress];
    NSLog(@"Loading webView method with error:%@", error);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"webview load progress:%2f", newprogress);
        [self.progressView setProgress:newprogress animated:YES];
    }
}

- (void)reloadProgress{
    [self.progressView setHidden:YES];
    [self.progressView setProgress:0 animated:YES];
}
@end
