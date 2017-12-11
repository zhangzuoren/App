//
//  UrlSessionManager.h
//  NetWorking
//
//  Created by yiban on 16/4/6.
//  Copyright © 2016年 yiban. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface UrlSessionManager : AFHTTPSessionManager
+ (instancetype)sharedManager;
@end
