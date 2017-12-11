//
//  MBProgressHUD+LJ.m
//  lntuApp
//
//  Created by 王森 http://www.51zan.cc on 14-9-18.
//  Copyright (c) 2015-11-25年 PUPBOSS. All rights reserved.
//

#import "MBProgressHUD+LJ.h"
@implementation MBProgressHUD (LJ)

+ (void)showSuccess:(NSString *)success{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegateInstance window] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = success;
    [hud hideAnimated:YES afterDelay:2.f];
}
+ (void)showError:(NSString *)error{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegateInstance window] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = error;
    [hud hideAnimated:YES afterDelay:2.f];
}
+ (void)showMessage:(NSString *)message{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegateInstance window] animated:YES];
    hud.label.text = message;
}
+ (void)hideHUD{
    NSEnumerator *subviewsEnum = [[AppDelegateInstance window].subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud=(MBProgressHUD *)subview;
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES];
        }
    }
}


@end
