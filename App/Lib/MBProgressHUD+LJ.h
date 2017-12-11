//
//  MBProgressHUD+LJ.h
//  lntuApp
//
//  Created by 王森 http://www.51zan.cc on 14-9-18.
//  Copyright (c) 2015-11-25年 PUPBOSS. All rights reserved.
//


#import "MBProgressHUD.h"

@interface MBProgressHUD (LJ)


#pragma mark 当 MBProgressHUD 更新的时候，只需要将本程序中另外的的两个文件替换即可。

/**
 *  返回一个成功的 HUD
 *
 *  @param success 要显示的文字
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  返回一个失败的 HUD
 *
 *  @param error 要显示的文字
 */
+ (void)showError:(NSString *)error;

/**
 *  返回一个文字加载中
 *
 *  @param message 要显示的文字
 */
+ (void)showMessage:(NSString *)message;

/**
 *  隐藏 HUD
 */
+ (void)hideHUD;


@end
