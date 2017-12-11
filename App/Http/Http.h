//
//  Http.h
//  AppFramework
//
//  Created by zhangzuoren on 16/8/27.
//  Copyright © 2016年 zhangzuoren. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  成功的回调
 *
 *  @param requestObj 接口返回的数据字典，已经是解析过json，可直接赋值给model
 */
typedef void (^SuccessBlock)(id requestObj);

/*!
 *  失败的回调
 *
 *  @param errorInfo 失败的错误信息
 */
typedef void (^FailureBlock)(NSError *errorInfo);

/*!
 *  缓存的回调
 *
 *  @param cacheObj 接口返回的数据字典，已经是解析过json，可直接赋值给model
 */
typedef void (^CacheBlock)(id cacheObj);

/*!
 *  进度的回调
 *
 *  @param bytesRead      已经上传/下载的数据大小
 *  @param totalBytesRead 总共的数据大小
 */
typedef void (^loadProgress)(int64_t bytesRead, int64_t totalBytesRead);


@interface Http : NSObject


/*!
 *  get请求
 *
 *  @param url        请求的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param parameters 请求参数
 *  @param success    get请求成功的回调
 *  @param failure    get请求失败的回调
 */
+ (void)getUrl:(NSString *)url parametersDic:(NSDictionary *)parameters caches:(CacheBlock)caches success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  post请求
 *
 *  @param url        请求的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param parameters 请求参数
 *  @param success    post请求成功的回调
 *  @param failure    post请求失败的回调
 
 */
+ (void)postUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  put请求
 *
 *  @param url        请求的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param parameters 请求参数
 *  @param success    put请求成功的回调
 *  @param failure    put请求失败的回调
 */
+ (void)putUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  delete请求
 *
 *  @param url        请求的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param parameters 请求参数
 *  @param success    delete请求成功的回调
 *  @param failure    delete请求失败的回调
 */
+ (void)deleteUrl:(NSString *)url parametersDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  下载请求
 *
 *  @param url        下载的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param parameters 请求参数
 *  @param success    下载请求成功的回调, filePath是下载文件在本地的存储地址
 *  @param failure    下载请求失败的回调
 */
+ (void)downLoadUrl:(NSString *)url parametersDic:(NSDictionary *)parameters downLoadProgress:(loadProgress)progress success:(void (^)(NSURL *filePath, NSURLResponse *response))success failure:(FailureBlock)failure;

/*!
 *  上传图片
 *
 *  @param imagesData    上传的图片数组，元素为图片的data
 *  @param url           上传的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param name          上传参数名（与后端约定）
 *  @param parameters    上传参数
 *  @param progress      上传进度的回调
 *  @param success       上传请求成功的回调
 *  @param failure       上传请求失败的回调
 */
+ (void)postImagesData:(NSMutableArray *)imagesData uploadUrl:(NSString *)url name:(NSString *)name parametersDic:(NSDictionary *)parameters uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  上传文件
 *
 *  @param imagesData    上传的文件数组，元素为文件的data
 *  @param url           上传的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param name          上传参数名（与后端约定）
 *  @param suffix        上传文件扩展名，不赋值默认为空
 *  @param parametersDic    上传参数
 *  @param progress      上传进度的回调
 *  @param success       上传请求成功的回调
 *  @param failure       上传请求失败的回调
 */
+ (void)postFilesData:(NSMutableArray *)imagesData uploadUrl:(NSString *)url name:(NSString *)name suffix:(NSString *)suffix parametersDic:(NSDictionary *)parametersDic uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  上传音频文件
 *
 *  @param VoicesData    上传的音频文件数组，元素为文件的data
 *  @param url           上传的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param name          上传参数名（与后端约定）
 *  @param mimeType      mimeType, 不赋值默认为audio/ogg
 *  @param suffix        音频文件扩展名，不赋值默认为spx
 *  @param parametersDic    上传参数
 *  @param progress      上传进度的回调
 *  @param success       上传请求成功的回调
 *  @param failure       上传请求失败的回调
 */
+ (void)postVoiceData:(NSMutableArray *)VoicesData uploadUrl:(NSString *)url name:(NSString *)name mimeType:(NSString *)mimeType suffix:(NSString *)suffix parametersDic:(NSDictionary *)parametersDic uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  通过文件地址上传文件
 *
 *  @param filePaths     上传文件的地址数组，元素为上传文件的地址
 *  @param url           上传的url,可以是完整的url,也可以是url用来跟BaseUrl拼接的部分
 *  @param name          上传参数名（与后端约定）
 *  @param suffix        文件的扩展名,不赋值默认为空
 *  @param parameters    上传参数
 *  @param progress      上传进度的回调
 *  @param success       上传请求成功的回调
 *  @param failure       上传请求失败的回调
 */
+ (void)postWithFilesPaths:(NSMutableArray *)filePaths uploadUrl:(NSString *)url name:(NSString *)name suffix:(NSString *)suffix parametersDic:(NSDictionary *)parameters uploadProgress:(loadProgress)progress success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  获取当前网络连接类型
 *
 *  @param networkType 连接类型，-1：未知， 0：无网络，1：蜂窝网，2：wifi
 */
+ (void)getNetworkType:(void (^)(NSInteger type))networkType;

@end
