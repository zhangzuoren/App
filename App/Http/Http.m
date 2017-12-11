//
//  Http.m
//  AppFramework
//
//  Created by zhangzuoren on 16/8/27.
//  Copyright © 2016年 zhangzuoren. All rights reserved.
//

#import "Http.h"
#import "AFNetworking.h"
#import "UrlSessionManager.h"
#import "NSString+Password.h"
#import "NSDictionary+Category.h"
#import "AFHTTPSessionManager+RetryPolicy.h"

NSString *const HttpCache = @"HttpCache";
NSString *const HttpCacheArrayKey = @"HttpCacheArrayKey";
NSString *const HttpPasswordKey = @"GUIDKey";
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define NSStringIsNullOrEmpty(string) ({NSString *str=(string);(str==nil || [str isEqual:[NSNull null]] ||  str.length == 0 || [str isKindOfClass:[NSNull class]] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])?YES:NO;})
#ifdef DEBUG
#define YBLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define YBLog(s, ... )
#endif

@interface Http()
@end

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypePut,
    RequestTypeDelete,
};


@implementation Http



+ (void)getUrl:(NSString *)url parametersDic:(NSDictionary *)parameters caches:(CacheBlock)caches success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [[self alloc] requestWithUrl:url withDic:parameters requestType:RequestTypeGet caches:^(id cacheObj) {
        caches(cacheObj);
    } success:^(id requestObj) {
        success(requestObj);
    } failure:^(NSError *errorInfo) {
        failure(errorInfo);
    }];
}


+ (void)postUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [[self alloc] requestWithUrl:url withDic:parameters requestType:RequestTypePost caches:nil success:^(id requestObj) {
        success(requestObj);
    } failure:^(NSError *errorInfo) {
        failure(errorInfo);
    }];
}


+ (void)putUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [[self alloc] requestWithUrl:url withDic:parameters requestType:RequestTypePut caches:nil success:^(id requestObj) {
        success(requestObj);
    } failure:^(NSError *errorInfo) {
        failure(errorInfo);
    }];
}


+ (void)deleteUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [[self alloc] requestWithUrl:url withDic:parameters requestType:RequestTypeDelete caches:nil success:^(id requestObj) {
        success(requestObj);
    } failure:^(NSError *errorInfo) {
        failure(errorInfo);
    }];
}


+ (void)downLoadUrl:(NSString *)url parametersDic:(NSDictionary *)parameters downLoadProgress:(loadProgress)progress success:(void (^)(NSURL *filePath, NSURLResponse *response))success failure:(FailureBlock)failure {
    
    __block typeof(self)weakself = self;
    
    NSString *urlWithoutQuery = [[self alloc] prepareUrlWithoutQueryRequestWithUrlStr:url];
    
    NSString *fullUrl = [[self alloc] generateUrlWithUrlStr:urlWithoutQuery withDic:parameters];
    
    NSURL *requestUrl = [NSURL URLWithString:fullUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    
    NSURLSessionDownloadTask *downloadTask = [[UrlSessionManager sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[weakself alloc] stopActivityIndicator];
        
        if (error) {
            if (failure) {
                YBLog(@"下载错误: %@", error.userInfo);
                failure(error);
            }
        } else {
            if (success) {
                success(filePath, response);
            }
        }
        
    }];
    
    [downloadTask resume];
}


+ (void)postImagesData:(NSMutableArray *)imagesData uploadUrl:(NSString *)url name:(NSString *)name parametersDic:(NSDictionary *)parameters uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [[self alloc] uploadMutipleWithUrl:url fileDatas:imagesData filePaths:nil name:name mimeType:@"image/jpeg" suffix:@"jpg" parametersDic:parameters uploadProgress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
        if (progress) {
            progress(bytesRead, totalBytesRead);
        }
        
    } success:^(NSDictionary *requestObj) {
        
        if (success) {
            success(requestObj);
        }
        
    } failure:^(NSError *errorInfo) {
        
        if (failure) {
            failure(errorInfo);
        }
        
    }];
}


+ (void)postFilesData:(NSMutableArray *)imagesData uploadUrl:(NSString *)url name:(NSString *)name suffix:(NSString *)suffix parametersDic:(NSDictionary *)parametersDic uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    if(suffix == nil) {
        suffix = @"";
    }
    
    [[self alloc] uploadMutipleWithUrl:url fileDatas:imagesData filePaths:nil name:name mimeType:@"application/octet-stream" suffix:suffix parametersDic:parametersDic uploadProgress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
        if (progress) {
            progress(bytesRead, totalBytesRead);
        }
        
    } success:^(NSDictionary *requestObj) {
        
        if (success) {
            success(requestObj);
        }
        
    } failure:^(NSError *errorInfo) {
        
        if (failure) {
            failure(errorInfo);
        }
        
    }];
}


+ (void)postVoiceData:(NSMutableArray *)VoicesData uploadUrl:(NSString *)url name:(NSString *)name mimeType:(NSString *)mimeType suffix:(NSString *)suffix parametersDic:(NSDictionary *)parametersDic uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    if (suffix == nil || [suffix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        suffix = @"spx";
    }
    
    if (mimeType == nil || [mimeType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        mimeType = @"audio/ogg";
    }
    
    [[self alloc] uploadMutipleWithUrl:url fileDatas:VoicesData filePaths:nil name:name mimeType:mimeType suffix:suffix parametersDic:parametersDic uploadProgress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
        if (progress) {
            progress(bytesRead, totalBytesRead);
        }
        
    } success:^(NSDictionary *requestObj) {
        
        if (success) {
            success(requestObj);
        }
        
    } failure:^(NSError *errorInfo) {
        
        if (failure) {
            failure(errorInfo);
        }
        
    }];
}


+ (void)postWithFilesPaths:(NSMutableArray *)filePaths uploadUrl:(NSString *)url name:(NSString *)name suffix:(NSString *)suffix parametersDic:(NSDictionary *)parameters uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    if (suffix == nil) {
        suffix = @"";
    }
    
    [[self alloc] uploadMutipleWithUrl:url fileDatas:nil filePaths:filePaths name:name mimeType:@"application/octet-stream" suffix:suffix parametersDic:parameters uploadProgress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
        if (progress) {
            progress(bytesRead, totalBytesRead);
        }
        
    } success:^(NSDictionary *requestObj) {
        
        if (success) {
            success(requestObj);
        }
        
    } failure:^(NSError *errorInfo) {
        
        if (failure) {
            failure(errorInfo);
        }
        
    }];
    
}


- (void)uploadMutipleWithUrl:(NSString *)url fileDatas:(NSMutableArray *)fileDatas filePaths:(NSMutableArray *)filePaths name:(NSString *)name mimeType:(NSString *)type suffix:(NSString *)suffix parametersDic:(NSDictionary *)parametersDic uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    __block typeof(self)weakself = self;
    
    if (filePaths != nil && fileDatas == nil) {
        
        fileDatas = [NSMutableArray array];
        for (int i = 0; i < filePaths.count; i ++) {
            NSData *data = [NSData dataWithContentsOfFile:filePaths[i]];
            [fileDatas addObject:data];
        }
        
    }
    
    if (fileDatas && fileDatas.count > 0) {
        
        NSString *urlWithoutQuery = [self prepareUrlWithoutQueryRequestWithUrlStr:url];
        
        NSURLSessionDataTask *tast = [[UrlSessionManager sharedManager] POST:urlWithoutQuery parameters:parametersDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSString *mimeType = type;
            if (mimeType == nil || [mimeType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
                mimeType = @"image/png";
            }
            
            NSString *suf = suffix;
            if (suf == nil) {
                suf = @"";
            }
            
            for (int i = 0; i < fileDatas.count; i ++) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d", str, i];
                //根据mimetype截取文件后缀
                NSString *fileWithSuffix = fileName;
                if (suffix.length > 0) {
                    fileWithSuffix = [fileName stringByAppendingPathExtension:suf];
                }
                
                // 上传图片，以文件流的格式
                [formData appendPartWithFileData:fileDatas[i] name:name fileName:fileWithSuffix mimeType:mimeType];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            if (progress) {
                progress (uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakself stopActivityIndicator];
            
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakself stopActivityIndicator];
            
            if (failure) {
                failure(error);
                YBLog(@"上传多个文件错误： %@", error);
            }
        }];
        
        [tast resume];
    }
}


- (void)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters requestType:(RequestType)requestType caches:(CacheBlock)caches success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    __block typeof(self)weakself = self;
    
    NSString *urlWithoutQuery = [self prepareUrlWithoutQueryRequestWithUrlStr:url];
    
    if (requestType == RequestTypeGet) {
        
        //设置Cache
        NSString *cacheKey = [self getHttpCacheKeyWithUrl:url param:parameters];
        YYCache *cache = [[YYCache alloc] initWithName:HttpCache];
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        id cacheData;
        cacheData = [cache objectForKey:cacheKey];
        if (cacheData != 0) {
            //判断是否为字典
            if ([cacheData isKindOfClass:[NSDictionary  class]]) {
                NSDictionary *requestDic = (NSDictionary *)cacheData;
                if (requestDic) {
                    caches(requestDic);
                }
            }else if([cacheData isKindOfClass:[NSArray  class]]){
                NSArray *requestArr = (NSArray *)cacheData;
                if (requestArr) {
                    caches(requestArr);
                }
            }
        }
        
        [[UrlSessionManager sharedManager] GET:urlWithoutQuery parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakself stopActivityIndicator];
            
            if (success) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    success(responseObject);
                    //保存缓存
                    [cache setObject:responseObject forKey:cacheKey];
                }else if([responseObject isKindOfClass:[NSArray class]]){
                    success(responseObject);
                    //保存缓存
                    [cache setObject:responseObject forKey:cacheKey];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakself stopActivityIndicator];
            
            if (failure) {
                YBLog(@"get请求错误: %@", error.userInfo);
                failure(error);
            }
        } retryCount:5 retryInterval:2.0 progressive:false fatalStatusCodes:@[@401, @403]];
        
    } else if (requestType == RequestTypePost) {
        
        [[UrlSessionManager sharedManager] POST:urlWithoutQuery parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakself stopActivityIndicator];
            
            if (success) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    success(responseObject);
                }else if([responseObject isKindOfClass:[NSArray class]]) {
                    success(responseObject);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self stopActivityIndicator];
            
            if (failure) {
                YBLog(@"post请求错误: %@", error.userInfo);
                failure(error);
            }
        }];
        
    } else if (requestType == RequestTypePut) {
        
        [[UrlSessionManager sharedManager] PUT:urlWithoutQuery parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakself stopActivityIndicator];
            
            if (success) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    success(responseObject);
                }else if([responseObject isKindOfClass:[NSArray class]]) {
                    success(responseObject);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakself stopActivityIndicator];
            
            if (failure) {
                YBLog(@"put请求错误: %@", error.userInfo);
                failure(error);
            }
        }];
    } else if (requestType == RequestTypeDelete) {
        
        [[UrlSessionManager sharedManager] DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakself stopActivityIndicator];
            
            if (success) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    success(responseObject);
                }else if([responseObject isKindOfClass:[NSArray class]]) {
                    success(responseObject);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakself stopActivityIndicator];
            
            if (failure) {
                YBLog(@"delete请求错误: %@", error.userInfo);
                failure(error);
            }
            
        }];
    }
}

#pragma mark 获取缓存key
- (NSString *)getHttpCacheKeyWithUrl:(NSString *)url param:(NSDictionary *)param{
    NSString *paramStr = [param dictionaryToJson];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@",url,paramStr,@"cacheKey"];
    NSString *trimText = [cacheKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *md5CacheKey = [trimText MD5Digest];
    return md5CacheKey;
}

- (NSString *)prepareUrlWithoutQueryRequestWithUrlStr:(NSString *)urlStr {
    //如果不是完整链接就拼接上baseurl
    NSString *urlWithoutQuery = [self urlWithoutQuery:urlStr];
    return [urlWithoutQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlWithoutQuery:(NSString *)url {
    //完整链接
    if ([url containsString:@"://"]) {
        return url;
    }
    //部分url 拼接上baseurl
    else {
        return [BaseUrl stringByAppendingString:url];
    }
}
- (void)stopActivityIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

//拼接参数为url
- (NSString *)generateUrlWithUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parametersDic {
    if (!parametersDic || parametersDic.count <= 0) {
        return urlStr;
    }
    NSMutableArray *parameters = [NSMutableArray array];
    //拼接参数
    [parametersDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //value
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *parameter =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        
        [parameters addObject:parameter];
    }];
    
    NSString *queryString = [parameters componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",urlStr,queryString];
    //处理url包含中文的问题
    return [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)getNetworkType:(void (^)(NSInteger type))networkType{
    //创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"status = %ld", (long)status);
        //监测到网络改变
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                YBLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                YBLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                YBLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                YBLog(@"WiFi网络");
                break;
                
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (networkType) {
                networkType(status);
            }
        });
    }];
    
    //激活网络状态监测
    [manager startMonitoring];
}
@end

