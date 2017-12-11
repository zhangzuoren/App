//
//  UrlSessionManager.m
//  NetWorking
//
//  Created by yiban on 16/4/6.
//  Copyright © 2016年 yiban. All rights reserved.
//

#import "UrlSessionManager.h"

@implementation UrlSessionManager
+ (instancetype)sharedManager {
    static UrlSessionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [UrlSessionManager manager];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    });
    
    return _manager;
}
@end
