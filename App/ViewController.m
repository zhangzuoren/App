//
//  ViewController.m
//  XSJ
//
//  Created by zhangzuoren on 2017/6/1.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "FaceBanding.h"

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong,nonatomic) WKWebView *wkWebView;
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) UIBarButtonItem *customBackBarItem;
@property (strong,nonatomic) UIBarButtonItem *closeButtonItem;
//保存请求链接
@property (strong,nonatomic) NSMutableArray *snapShotsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setup];
    [self deleteWebCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        Configuration.allowsAirPlayForMediaPlayback = YES;
        Configuration.allowsInlineMediaPlayback = YES;
        Configuration.selectionGranularity = YES;
        Configuration.processPool = [[WKProcessPool alloc] init];
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        [UserContentController addScriptMessageHandler:self name:@"setUsertoken"];      //保存用户token
        [UserContentController addScriptMessageHandler:self name:@"getUsertoken"];      //获取用户token
        
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = NO;
        Configuration.userContentController = UserContentController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) configuration:Configuration];
        _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        [_wkWebView sizeToFit];
        
        if (@available(iOS 11.0, *)){
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _wkWebView;
}
-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [UIImage imageNamed:@"back"];
        UIImage* backItemHlImage = [UIImage imageNamed:@"back_light"] ;
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3);
        [_progressView setTrackTintColor:[UIColor whiteColor]];
        _progressView.progressTintColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:18.0/255.0 alpha:1];
    }
    return _progressView;
}
-(void)customBackItemClicked{
    if (self.wkWebView.goBack) {
        [self.wkWebView goBack];
    }else{
        [self updateNavigationItems];
    }
}


-(void)setup{
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    
    NSString *url;
    UserInfo *info=[UserInfo sharedUserInfo];
    if(info.usertype==1){
        url=[NSString stringWithFormat:@"%@/tzgaApp/index.html?usertype=%@&uuid=%@&username=%@&idnum=%@&mobile=%@&address=%@",BaseUrl,@"gr",info.userid?info.userid:@"",info.username?info.username:@"",info.idnum?info.idnum:@"",info.mobile?info.mobile:@"",info.address?info.address:@""];
    }else{
        url=[NSString stringWithFormat:@"%@/tzgaApp/index.html?usertype=%@&uuid=%@&username=%@&idnum=%@&mobile=%@&address=%@&companycode=%@&legalman=%@",BaseUrl,@"fr",info.userid?info.userid:@"",info.username?info.username:@"",info.idnum?info.idnum:@"",info.mobile?info.mobile:@"",info.address?info.address:@"",info.companycode?info.companycode:@"",info.legalman?info.legalman:@""];
    }
    
    NSURLRequest *Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.wkWebView loadRequest:Request_zsj];
}

#pragma mark ================ 自定义返回/关闭按钮 ================
-(void)updateNavigationItems{
    if (self.wkWebView.canGoBack) {
        self.navigationItem.leftBarButtonItem=self.customBackBarItem;
    }else{
        self.navigationItem.leftBarButtonItem=nil;
    }
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    // 获取加载网页的标题
    self.title = self.wkWebView.title;
    [self updateNavigationItems];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([navigationAction.request.URL.absoluteString containsString:@"login_renlian.jsp"]) {
        FaceBanding *root=[[FaceBanding alloc] init];
        [root setBlock:^{
            [MBProgressHUD showSuccess:@"绑定成功"];
        }];
        [self presentViewController:root animated:YES completion:nil];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if([navigationAction.request.URL.absoluteString containsString:@"login.jsp"]){
        [[UserInfo sharedUserInfo] output];
        [AppDelegateInstance showLogin];
    }
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{@"request":request,@"snapShotView":currentSnapShotView}];
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}
//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}
//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark ================ WKUIDelegate ================
// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}
//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /* 保存用户token */
    if([message.name isEqualToString:@"setUsertoken"]){
        NSString *token=message.body;
        NSLog(@"%@",token);
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"app_token"];
    }
    
    /* 读取用户token */
    if([message.name isEqualToString:@"getUsertoken"]){
        NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"app_token"];
        NSLog(@"%@",token);
        if(token){
            [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"getUsertokenCallback('%@')",token] completionHandler:nil];
        }else{
            [self.wkWebView evaluateJavaScript:@"getUsertokenCallback('fail')" completionHandler:nil];
        }
    }
}

#pragma mark - 清理缓存
- (void)deleteWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache,]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}
@end
