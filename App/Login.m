//
//  Login.m
//  App
//
//  Created by zhangzuoren on 2017/11/20.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "Login.h"
#import "LoginTextField.h"
#import "FaceBanding.h"
#import "FaceLogin.h"
#import "ViewController.h"
#import "Regin.h"
#import "Forget.h"

@interface Login ()<UITextFieldDelegate>
{
    int _type;//1.个人 2.法人
    BOOL _isRemember;//是否记住密码
}
@property (strong,nonatomic) UIImageView *head_back;
@property (strong,nonatomic) UIImageView *iconOne;
@property (strong,nonatomic) UIImageView *iconTwo;
@property (strong,nonatomic) UIImageView *iconThree;
@property (strong,nonatomic) UIImageView *iconFour;
@property (strong,nonatomic) UIImageView *iconFive;

@property (strong,nonatomic) UIButton *geren;
@property (strong,nonatomic) UIButton *faren;
@property (strong,nonatomic) UIImageView *gerenChoose;
@property (strong,nonatomic) UIImageView *farenChoose;

@property (strong,nonatomic) LoginTextField *username;
@property (strong,nonatomic) LoginTextField *password;
@property (strong,nonatomic) UIButton *remember;
@property (strong,nonatomic) UILabel *rememberLab;
@property (strong,nonatomic) UIButton *forget;
@property (strong,nonatomic) UIButton *regin;

@property (strong,nonatomic) UIButton *facelog;
@property (strong,nonatomic) UIButton *log;
@property (strong,nonatomic) UILabel *des;
@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    self.title=@"登录";
    _type=1;
    
    [self setup];
    [self checkLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    _head_back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*(540.0/750.0))];
    _head_back.image=[UIImage imageNamed:@"login_titlebg"];
    [self.view addSubview:_head_back];
    
    _iconOne=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, _head_back.frame.size.height/2-40, 80, 80)];
    _iconOne.image=[UIImage imageNamed:@"login_logo"];
    [_head_back addSubview:_iconOne];
    
    _iconTwo=[[UIImageView alloc] initWithFrame:CGRectMake(40, 64, 20*(150.0/34.0), 20)];
    _iconTwo.image=[UIImage imageNamed:@"login_tzgaj"];
    [_head_back addSubview:_iconTwo];
    
    _iconThree=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 44, 60, 60*(114.0/100.0))];
    _iconThree.image=[UIImage imageNamed:@"login_titlert"];
    [_head_back addSubview:_iconThree];
    
    _iconFour=[[UIImageView alloc] initWithFrame:CGRectMake(_iconOne.frame.origin.x+80-5, _iconOne.frame.origin.y+80-30, 30*(66.0/58.0), 30)];
    _iconFour.image=[UIImage imageNamed:@"login_gongan"];
    [_head_back addSubview:_iconFour];
    
    _iconFive=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-30*(322.0/61.0)/2, _iconOne.frame.origin.y+80+10, 30*(322.0/61.0), 30)];
    _iconFive.image=[UIImage imageNamed:@"login_titile"];
    [_head_back addSubview:_iconFive];
    
    _geren=[UIButton buttonWithType:UIButtonTypeCustom];
    _geren.frame=CGRectMake(0, _head_back.frame.size.height, [UIScreen mainScreen].bounds.size.width/2.0, 44);
    [_geren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_geren setTitle:@"个人登录" forState:UIControlStateNormal];
    [_geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateNormal];
    [_geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateHighlighted];
    [_geren addTarget:self action:@selector(gerenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_geren];
    
    _faren=[UIButton buttonWithType:UIButtonTypeCustom];
    _faren.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2.0, _head_back.frame.size.height, [UIScreen mainScreen].bounds.size.width/2.0, 44);
    [_faren setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_faren setTitle:@"法人登录" forState:UIControlStateNormal];
    [_faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateNormal];
    [_faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateHighlighted];
    [_faren addTarget:self action:@selector(farenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_faren];
    
    _gerenChoose=[[UIImageView alloc] initWithFrame:CGRectMake(_faren.frame.size.width/2-5, 44-5, 10, 5)];
    _gerenChoose.image=[UIImage imageNamed:@"login_choose"];
    _gerenChoose.hidden=NO;
    [_geren addSubview:_gerenChoose];
    
    _farenChoose=[[UIImageView alloc] initWithFrame:CGRectMake(_faren.frame.size.width/2-5, 44-5, 10, 5)];
    _farenChoose.image=[UIImage imageNamed:@"login_choose"];
    _farenChoose.hidden=YES;
    [_faren addSubview:_farenChoose];
    
    UIImageView *username_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20*(60.0/40.0), 20)];
    username_image.image=[UIImage imageNamed:@"login_username"];
    _username=[[LoginTextField alloc] initWithFrame:CGRectMake(40, _geren.frame.origin.y+44+40, [UIScreen mainScreen].bounds.size.width-80, 40)];
    _username.leftView=username_image;
    _username.leftViewMode=UITextFieldViewModeAlways;
    _username.font=[UIFont systemFontOfSize:16];
    _username.textColor=[UIColor blackColor];
    _username.placeholder=@"请输入用户名";
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    _username.autocorrectionType=UITextAutocorrectionTypeNo;
    _username.returnKeyType=UIReturnKeyDone;
    _username.keyboardType=UIKeyboardTypeDefault;
    _username.delegate=self;
    [self.view addSubview:_username];
    
    UIImageView *password_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20*(60.0/40.0), 20)];
    password_image.image=[UIImage imageNamed:@"login_pwd"];
    _password=[[LoginTextField alloc] initWithFrame:CGRectMake(40, _username.frame.origin.y+40+10, [UIScreen mainScreen].bounds.size.width-80, 40)];
    _password.leftView=password_image;
    _password.leftViewMode=UITextFieldViewModeAlways;
    _password.font=[UIFont systemFontOfSize:16];
    _password.textColor=[UIColor blackColor];
    _password.placeholder=@"请输入密码";
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.autocorrectionType=UITextAutocorrectionTypeNo;
    _password.returnKeyType=UIReturnKeyDone;
    _password.keyboardType=UIKeyboardTypeDefault;
    _password.secureTextEntry=YES;
    _password.delegate=self;
    [self.view addSubview:_password];
    
    _remember=[UIButton buttonWithType:UIButtonTypeCustom];
    _remember.frame=CGRectMake(40, _password.frame.origin.y+40+10, 20, 20);
    [_remember setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [_remember setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateHighlighted];
    [_remember addTarget:self action:@selector(rememberClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_remember];
    
    _rememberLab=[[UILabel alloc] initWithFrame:CGRectMake(60, _password.frame.origin.y+40+10, 60, 20)];
    _rememberLab.font=[UIFont systemFontOfSize:14];
    _rememberLab.textColor=[UIColor lightGrayColor];
    _rememberLab.textAlignment=NSTextAlignmentCenter;
    _rememberLab.text=@"记住密码";
    [self.view addSubview:_rememberLab];
    
    _forget=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _forget.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-40-80, _password.frame.origin.y+40+10, 80, 20);
    [_forget.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_forget setTitleColor:[UIColor colorWithHexString:@"#1492ff"] forState:UIControlStateNormal];
    [_forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forget addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forget];
    
    _facelog=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _facelog.frame=CGRectMake(40, _rememberLab.frame.origin.y+_rememberLab.frame.size.height+20, [UIScreen mainScreen].bounds.size.width-80, 24);
    [_facelog setTitleColor:[UIColor colorWithHexString:@"#1492ff"] forState:UIControlStateNormal];
    [_facelog setTitle:@"使用人脸登录" forState:UIControlStateNormal];
    [_facelog addTarget:self action:@selector(facelogClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_facelog];
    
    _log=[UIButton buttonWithType:UIButtonTypeCustom];
    _log.frame=CGRectMake(40, _facelog.frame.origin.y+_facelog.frame.size.height+10, [UIScreen mainScreen].bounds.size.width-80, 44);
    _log.layer.cornerRadius=22;
    _log.clipsToBounds=YES;
    [_log setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateNormal];
    [_log setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3da3fb"]] forState:UIControlStateHighlighted];
    [_log setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_log setTitle:@"登录" forState:UIControlStateNormal];
    [_log addTarget:self action:@selector(logClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_log];
    
    _des=[[UILabel alloc] initWithFrame:CGRectMake(40, _log.frame.origin.y+44+5, [UIScreen mainScreen].bounds.size.width-80, 20)];
    _des.font=[UIFont systemFontOfSize:14];
    _des.textColor=[UIColor lightGrayColor];
    _des.textAlignment=NSTextAlignmentCenter;
    _des.text=@"请使用浙江政务服务网账号登录";
    [self.view addSubview:_des];
    
    _regin=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _regin.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-30);
    _regin.bounds=CGRectMake(0, 0, 60, 20);
    [_regin.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_regin setTitleColor:[UIColor colorWithHexString:@"#1492ff"] forState:UIControlStateNormal];
    [_regin setTitle:@"注册" forState:UIControlStateNormal];
    [_regin addTarget:self action:@selector(reginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regin];
}
-(void)checkLogin{
    UserInfo *info=[UserInfo sharedUserInfo];
    [info read];
    if(info.islogin){
        if(info.usertype==1){
            [self gerenClick];
        }else{
            [self farenClick];
        }
        self.username.text=info.login_username;
        self.password.text=info.login_password;
        _isRemember=YES;
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateNormal];
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateHighlighted];
    }
}
-(void)gerenClick{
    _type=1;
    
    [self.geren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.geren setTitle:@"个人登录" forState:UIControlStateNormal];
    [self.geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateNormal];
    [self.geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateHighlighted];
    self.gerenChoose.hidden=NO;
    
    [self.faren setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.faren setTitle:@"法人登录" forState:UIControlStateNormal];
    [self.faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateNormal];
    [self.faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateHighlighted];
    self.farenChoose.hidden=YES;
}
-(void)farenClick{
    _type=2;
    
    [self.geren setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.geren setTitle:@"个人登录" forState:UIControlStateNormal];
    [self.geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateNormal];
    [self.geren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#d0e9ff"]] forState:UIControlStateHighlighted];
    self.gerenChoose.hidden=YES;
    
    [self.faren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.faren setTitle:@"法人登录" forState:UIControlStateNormal];
    [self.faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateNormal];
    [self.faren setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1492ff"]] forState:UIControlStateHighlighted];
    self.farenChoose.hidden=NO;
}
-(void)rememberClick{
    if(_isRemember){
        _isRemember=NO;
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateHighlighted];
    }else{
        _isRemember=YES;
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateNormal];
        [self.remember setBackgroundImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateHighlighted];
    }
}
-(void)facelogClick{
    FaceLogin *root=[[FaceLogin alloc] init];
    [root setBlock:^{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showHome];
        [MBProgressHUD showSuccess:@"登录成功"];
    }];
    [self presentViewController:root animated:NO completion:nil];
}
-(void)logClick{
    if(self.username.text.length>0 && self.password.text.length>0){
        [MBProgressHUD showMessage:@"登录中"];
        [Http getUrl:[NSString stringWithFormat:@"%@/userinfo",BaseUrl] parametersDic:@{@"status":_type==1?@"gr":@"fr",@"loginname":self.username.text,@"password":self.password.text} caches:^(id cacheObj) {
        } success:^(id requestObj) {
            if([requestObj[@"reuslt"] isEqualToString:@"1"]){
                UserInfo *info=[UserInfo sharedUserInfo];
                info.usertype=_type;
                info.login_username=self.username.text;
                info.login_password=self.password.text;
                info.islogin=YES;
                
                if(_isRemember){
                    [info save];
                }
                
                if(_type==1){
                    [[UserInfo sharedUserInfo] setUserInfo:requestObj[@"data"]];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showHome];
                    [MBProgressHUD showSuccess:@"登录成功"];
                }else{
                    [[UserInfo sharedUserInfo] setFRUserInfo:requestObj[@"data"]];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showHome];
                    [MBProgressHUD showSuccess:@"登录成功"];
                }
            }
        } failure:^(NSError *errorInfo) {
            [MBProgressHUD hideHUD];
            [UIAlertView alertWithCallBackBlock:nil title:@"提示" message:@"服务器连接失败" cancelButtonName:@"确定" otherButtonTitles:nil];
        }];
    }else{
        [UIAlertView alertWithCallBackBlock:nil title:@"提示" message:@"请输入用户名与密码" cancelButtonName:@"确定" otherButtonTitles:nil];
    }
}
-(void)reginClick{
    Regin *root=[[Regin alloc] init];
    [self.navigationController pushViewController:root animated:YES];
}
-(void)forgetClick{
    Forget *root=[[Forget alloc] init];
    [self.navigationController pushViewController:root animated:YES];
}

#pragma mark - textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
