//
//  FaceLogin.h
//  App
//
//  Created by zhangzuoren on 2017/11/20.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceLogin : UIViewController
@property (strong,nonatomic) NSData *imageData;
@property (nonatomic, copy) void(^block)();
@end
