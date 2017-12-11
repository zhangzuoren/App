//
//  UserInfo.m
//  One
//
//  Created by 张作 on 16/2/25.
//  Copyright © 2016年 menghuanwu. All rights reserved.
//

#import "UserInfo.h"
#import <HealthKit/HealthKit.h>

@implementation UserInfo
singleton_implementation(UserInfo)

#pragma mark 保存
-(void)save{
    [[NSUserDefaults standardUserDefaults] setInteger:self.usertype forKey:@"app_usertype"];
    [[NSUserDefaults standardUserDefaults] setObject:self.login_username forKey:@"app_username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.login_password forKey:@"app_password"];
    [[NSUserDefaults standardUserDefaults] setBool:self.islogin forKey:@"app_islogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark 读取
-(void)read{
    self.usertype=[[NSUserDefaults standardUserDefaults] integerForKey:@"app_usertype"];
    self.login_username=[[NSUserDefaults standardUserDefaults] objectForKey:@"app_username"];
    self.login_password=[[NSUserDefaults standardUserDefaults] objectForKey:@"app_password"];
    self.islogin=[[NSUserDefaults standardUserDefaults] boolForKey:@"app_islogin"];
}
#pragma mark 删除
-(void)output{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_usertype"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_password"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"app_islogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 填充个人信息
-(void)setUserInfo:(NSDictionary *)info{
    self.userid=info[@"userid"];
    self.username=info[@"username"];
    self.idnum=info[@"idnum"];
    self.mobile=info[@"mobile"];
    self.address=info[@"address"];
}
-(void)setFRUserInfo:(NSDictionary *)info{
    self.userid=info[@"userBasicInfo"][@"userid"];
    self.username=info[@"appBasicInfo"][@"appConEntName"];
    self.idnum=info[@"appBasicInfo"][@"appConRegNo"];
    self.address=info[@"appBasicInfo"][@"appConLoc"];
    self.mobile=nil;
    self.companycode=info[@"appBasicInfo"][@"appConEntUniCode"];
    self.legalman=info[@"appBasicInfo"][@"appConLegRep"];
}
-(void)setFaceUserInfo:(NSDictionary *)info{
    self.usertype=[info[@"usertype"] integerValue];
    self.userid=info[@"uuid"];
    self.username=info[@"username"];
    self.idnum=info[@"certnum"];
    self.mobile=info[@"mobile"];
    self.address=info[@"address"];
}
@end
