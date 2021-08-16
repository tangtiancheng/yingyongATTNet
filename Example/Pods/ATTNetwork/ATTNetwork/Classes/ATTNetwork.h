//
//  ATTNetwork.h
//  MCEnglish
//
//  Created by lwb on 2017/2/13.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "AFURLSessionManager.h"

typedef NS_ENUM(NSInteger, HTTPMethod) {
    ATTRequestGET,
    ATTRequestPOST,
    ATTHTTPRequestGET,
    ATTHTTPRequestPOST,
    ATTJSONRequestHTTPRespondPOST,
    ATTDATARequestPOST,
    ATTRequestPUT,
    ATTRequeatDELETE
};

typedef NS_ENUM(NSInteger, NetWorkType) {
    NETWORK_NOTREACHABLE,
    NETWORK_WLAN,
    NETWORK_WIFI,
    NETWORK_UNKNOWN
};

@class NSURLSessionTask;
typedef NSURLSessionDataTask ATTURLSessionDataTask;
typedef NSURLSessionUploadTask ATTURLSessionUploadTask;
typedef NSURLSessionDownloadTask ATTURLSessionDownloadTask;

typedef void (^ATTResponseSuccessBlock)(id response);
typedef void (^ATTResponseFailureBlock)(NSError *error);
typedef void (^ATTDataProgress)(NSProgress *dataProgress);
typedef void (^ATTUploadProgress)(NSProgress *uploadProgress);
typedef void (^ATTDownloadProgress)(NSProgress *downloadProgress);


//重写Debug模式下打印日志
#ifdef DEBUG
#define ATTLog(format, ...) printf("\n[%s] %s [ATTNetWork第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define ATTLog(...)
#endif


@interface ATTNetwork : NSObject

//@property (nonatomic, strong) AFHTTPSessionManager *htmlResponDataSessionManager;

@property (nonatomic, strong) AFHTTPSessionManager *dataJSONSessionManager;//request为json respond为json

@property (nonatomic, strong) AFHTTPSessionManager *httpResquestDataSessionManager;//request为http respond为http

@property (nonatomic, strong) AFHTTPSessionManager *jsonResquesthtmlRespondSessionManager;//request为json respond为http

@property (nonatomic, strong) AFURLSessionManager *dataResquesthtmlRespondSessionManager;//request为data respond为http(由于部分接口的body传的是一个加密后的串)


@property (nonatomic, strong) AFHTTPSessionManager *uploadSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *downloadSessionManager;
//@property (nonatomic, assign) NetWorkType netWorkType;

/**
 获取单实例

 @return 单例对象
 */
+ (instancetype)shareInstance;



/**
 GET请求  request和respond都是HTTP

 @param url url
 @param params 请求参数
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)getHTTPWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue;

/**
 POST请求   request和respond都是HTTP

 @param url url
 @param params 请求参数
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)postHTTPWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue;




/**
 POST请求   request是JSON, respond是HTTP

 @param url url
 @param params 请求参数
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)postJSONRequestHTTPRespondWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue;

/**
 POST请求   request是JSON, respond是HTTP

 @param url url
 @param body 请求body
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)postDATARequestWithURL:(NSString *)url
                                  body:(NSData *)bodyData
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue;



/**
 GET请求    request和respond都是JSON

 @param url url
 @param params 请求参数
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)getWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue;


/**
 POST请求    request和respond都是JSON

 @param url url
 @param params 请求参数
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)postWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue;





/**
 POST请求

 @param url url
 @param params 请求参数
 @param isLoading 是否显示loading提示框
 @param progress 请求的加载进度
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)postWithURL:(NSString *)url
                                params:(NSDictionary *)params
                              progress:(ATTDataProgress)progress
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue;

/**
 PUT请求

 @param url url
 @param params 请求参数
 @param isLoading 是否显示loading提示框
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)putWithURL:(NSString *)url
                               params:(NSDictionary *)params
                            isLoading:(BOOL)isLoading
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue;

/**
 PUT请求

 @param url url
 @param params 请求参数
 @param progress 请求的加载进度
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)putWithURL:(NSString *)url
                               params:(NSDictionary *)params
                             progress:(ATTDataProgress)progress
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue;



/**
 DELETE请求

 @param url url
 @param params 请求参数
 @param progress 请求的加载进度
 @param success 请求成功的回调
 @param failue 请求失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDataTask *)deleteWithURL:(NSString *)url
                                  params:(NSDictionary *)params
                                progress:(ATTDataProgress)progress
                                 success:(ATTResponseSuccessBlock)success
                                 failure:(ATTResponseFailureBlock)failue;


/**
 文件的上传请求--通过文件路径

 @param url url
 @param params 请求的参数
 @param filePath 上传的文件路径
 @param isLoading 是否显示loading提示框
 @param progress 上传进度
 @param success 上传成功的回调
 @param failure 上传失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionUploadTask *)uploadWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                  filePath:(NSString *)filePath
                                    name:(NSString *)name
                                fileName:fileName
                                  progress:(ATTUploadProgress)progress
                                   success:(ATTResponseSuccessBlock)success
                                   failure:(ATTResponseFailureBlock)failure;


/**
 文件上传的请求--直接通过NSData文件

 @param url url
 @param params 请求的参数
 @param fileData 上传的文件
 @param name 文件参数
 @param fileName 上传的文件名字
 @param isLoading 是否显示loading提示框
 @param progress 上传进度
 @param success 上传成功的回调
 @param failure 上传失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionUploadTask *)uploadWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                  fileData:(NSData *)fileData
                                      name:(NSString *)name
                                  fileName:fileName
                                  progress:(ATTUploadProgress)progress
                                   success:(ATTResponseSuccessBlock)success
                                   failure:(ATTResponseFailureBlock)failure;



/**
 文件下载的请求

 @param url url
 @param saveToPath 下载文件保存的路径
 @param isLoading 是否显示loading提示框
 @param progress 下载的进度
 @param success 下载成功的回调
 @param failure 下载失败的回调
 @return 该次请求的task
 */
- (ATTURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                    saveToPath:(NSString *)saveToPath
                                      progress:(ATTDownloadProgress)progress
                                       success:(ATTResponseSuccessBlock)success
                                       failure:(ATTResponseFailureBlock)failure;




@end
