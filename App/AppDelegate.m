//
//  AppDelegate.m
//  App
//
//  Created by zhangzuoren on 2017/11/19.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <objc/message.h>
#import "Login.h"
#import "FaceLogin.h"
#import "FaceBanding.h"
#import "UIAlertView+Block.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    /* 检查更新 */
    [self checkUpdate];
    
    /* 显示登录页 */
    [self showLogin];
    
    return YES;
}
-(void)showLogin{
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:[[Login alloc] init]];
}
-(void)showHome{
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController=nav;
}
-(void)checkUpdate{
    NSURL *url = [NSURL URLWithString:@"https://www.zjsos.net:3443/tzga/ios-tzga-Updates.txt"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data){
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(![dict[@"versionName"] isEqualToString:@"1.0"]){
                NSString *url=dict[@"updateUrl"];
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    if(buttonIndex==1){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                } title:@"提示" message:@"检测到新版本，是否更新？" cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
            }
        }
    }];
}

+ (void)progressWKContentViewCrash {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            NSLog(@"WKContentView-Crash->修复失败");
        }
    }
}

BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
