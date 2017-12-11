//
//  UserInfo.h
//  One
//
//  Created by 张作 on 16/2/25.
//  Copyright © 2016年 menghuanwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject

singleton_interface(UserInfo);

@property (assign,nonatomic) BOOL logined;                  //是否登录成功
@property (strong,nonatomic) NSString *token;               //token

/**
 *  用户名 密码
 */
@property (assign,nonatomic) NSInteger usertype;            //用户类型（1.个人用户 2.法人用户）
@property (strong,nonatomic) NSString *login_username;      //用户名
@property (strong,nonatomic) NSString *login_password;      //密码
@property (assign,nonatomic) BOOL islogin;                  //自动登录

/**
 *  用户信息
 */
@property (strong,nonatomic) NSString *userid;
@property (strong,nonatomic) NSString *authlevel;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *idnum;
@property (strong,nonatomic) NSString *sex;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *mobile;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *companycode;
@property (strong,nonatomic) NSString *legalman;

-(void)save;
-(void)read;
-(void)output;

-(void)setUserInfo:(NSDictionary *)info;
-(void)setFRUserInfo:(NSDictionary *)info;
-(void)setFaceUserInfo:(NSDictionary *)info;
-(NSDictionary *)getUserInfo;

@end
