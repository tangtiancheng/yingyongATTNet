//
//  ATTNetwork.m
//  MCEnglish
//
//  Created by lwb on 2017/2/13.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import "ATTNetwork.h"

#import "AFNetworkActivityIndicatorManager.h"

static NSTimeInterval att_timeout = 20.f;

@interface ATTNetwork()

@end

@implementation ATTNetwork
#pragma mark-----Public-Method
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id shareInsatance = nil;
    dispatch_once(&onceToken, ^{
        shareInsatance = [[self alloc] init];
    });
    return shareInsatance;
}

- (ATTURLSessionDataTask *)getHTTPWithURL:(NSString *)url
                                   params:(NSDictionary *)params
                                  success:(ATTResponseSuccessBlock)success
                                  failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTHTTPRequestGET
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionDataTask *)postWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequestPOST
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionDataTask *)getWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequestGET
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionDataTask *)postHTTPWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTHTTPRequestPOST
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionDataTask *)postJSONRequestHTTPRespondWithURL:(NSString *)url
                                params:(NSDictionary *)params
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTJSONRequestHTTPRespondPOST
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}



- (ATTURLSessionDataTask *)postWithURL:(NSString *)url
                                params:(NSDictionary *)params
                              progress:(ATTDataProgress)progress
                               success:(ATTResponseSuccessBlock)success
                               failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequestPOST
                             urlString:url
                                params:params
                              progress:progress
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionDataTask *)putWithURL:(NSString *)url
                               params:(NSDictionary *)params
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequestPUT
                             urlString:url
                                params:params
                              progress:nil
                          successBlock:success
                          failureBlock:failue];
}


- (ATTURLSessionDataTask *)putWithURL:(NSString *)url
                               params:(NSDictionary *)params
                             progress:(ATTDataProgress)progress
                              success:(ATTResponseSuccessBlock)success
                              failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequestPUT
                             urlString:url
                                params:params
                              progress:progress
                          successBlock:success
                          failureBlock:failue];

}


- (ATTURLSessionDataTask *)deleteWithURL:(NSString *)url
                                  params:(NSDictionary *)params
                                progress:(ATTDataProgress)progress
                                 success:(ATTResponseSuccessBlock)success
                                 failure:(ATTResponseFailureBlock)failue {
    return [self requestWithHttpMethod:ATTRequeatDELETE
                             urlString:url
                                params:params
                              progress:progress
                          successBlock:success
                          failureBlock:failue];
}

- (ATTURLSessionUploadTask *)uploadWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                  filePath:(NSString *)filePath
                                      name:(NSString *)name
                                  fileName:fileName
                                  progress:(ATTUploadProgress)progress
                                   success:(ATTResponseSuccessBlock)success
                                   failure:(ATTResponseFailureBlock)failure {
    return [self requestUploadWithURL:url
                               params:params
                             filePath:filePath
                             fileData:nil
                                 name:name
                             fileName:fileName
                       isloadFilePath:YES
                             progress:progress
                              success:success
                              failure:failure];
}

- (ATTURLSessionUploadTask *)uploadWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                  fileData:(NSData *)fileData
                                      name:(NSString *)name
                                  fileName:fileName
                                  progress:(ATTUploadProgress)progress
                                   success:(ATTResponseSuccessBlock)success
                                   failure:(ATTResponseFailureBlock)failure {
    return [self requestUploadWithURL:url
                               params:params
                             filePath:nil
                             fileData:fileData
                                 name:name
                             fileName:fileName
                       isloadFilePath:NO
                             progress:progress
                              success:success
                              failure:failure];
}

- (ATTURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                    saveToPath:(NSString *)saveToPath
                                      progress:(ATTDownloadProgress)progress
                                       success:(ATTResponseSuccessBlock)success
                                       failure:(ATTResponseFailureBlock)failure {
    if (url) {
        url = [self att_URLEncoding:url];
    }
    NSString *integrityURL = url;//[NSString stringWithFormat:@"%@%@", dev_baseURL, url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:integrityURL]];
    ATTURLSessionDownloadTask *downloadSessionTask = nil;
    downloadSessionTask = [_downloadSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress (downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success ? success (filePath.absoluteString) : nil;
        failure && error ? failure (error) : nil;
        if (error) {
        }
    }];
    [downloadSessionTask resume];
    if (downloadSessionTask) {
//        [_downloadRequestArray addObject:downloadSessionTask];
    }
    return downloadSessionTask;
}


#pragma mark----Priviate-Method
- (instancetype) init {
    self = [super init];
    if (self) {
        [self sessionManagerInit];
    }
    return self;
}

- (void)sessionManagerInit {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _dataResquesthtmlRespondSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html" , nil];
    _dataResquesthtmlRespondSessionManager.responseSerializer = responseSerializer;
    _dataResquesthtmlRespondSessionManager.operationQueue.maxConcurrentOperationCount = 5;


    //一般数据请求sessionManager设置
    _dataJSONSessionManager = [AFHTTPSessionManager manager];
    [self setJSONRequestManager:_dataJSONSessionManager];
    [self setJSONRespondManager:_dataJSONSessionManager];
    [_dataJSONSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_dataJSONSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _dataJSONSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html" , nil];
    _dataJSONSessionManager.operationQueue.maxConcurrentOperationCount = 5;

    _httpResquestDataSessionManager = [AFHTTPSessionManager manager];
    [self setHTTPRequestManager:_httpResquestDataSessionManager];
    [self setHTTPRespondManager:_httpResquestDataSessionManager];
    [_httpResquestDataSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_httpResquestDataSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _httpResquestDataSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html" , nil];
    _httpResquestDataSessionManager.operationQueue.maxConcurrentOperationCount = 5;

    _jsonResquesthtmlRespondSessionManager = [AFHTTPSessionManager manager];
    [self setJSONRequestManager:_jsonResquesthtmlRespondSessionManager];
    [self setHTTPRespondManager:_jsonResquesthtmlRespondSessionManager];
    [_jsonResquesthtmlRespondSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_jsonResquesthtmlRespondSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _jsonResquesthtmlRespondSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html" , nil];
    _jsonResquesthtmlRespondSessionManager.operationQueue.maxConcurrentOperationCount = 5;

    //数据上传的sessionManager设置
    _uploadSessionManager = [AFHTTPSessionManager manager];
    [self setJSONRequestManager:_uploadSessionManager];
    [self setJSONRespondManager:_uploadSessionManager];
    [_uploadSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_uploadSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _uploadSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html" , nil];
    _uploadSessionManager.operationQueue.maxConcurrentOperationCount = 5;

    //数据下载的sessionManager设置
    _downloadSessionManager = [AFHTTPSessionManager manager];
    [self setJSONRequestManager:_downloadSessionManager];
    [self setJSONRespondManager:_downloadSessionManager];
}

- (void)setJSONRequestManager:(AFHTTPSessionManager *)sessionManager {
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = att_timeout; //请求超时设定
    sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
}
- (void)setJSONRespondManager:(AFHTTPSessionManager *)sessionManager {
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
}


- (void)setHTTPRequestManager:(AFHTTPSessionManager *)sessionManager {
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = att_timeout; //请求超时设定
    sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
}
- (void)setHTTPRespondManager:(AFHTTPSessionManager *)sessionManager {
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (AFSecurityPolicy *)customSecurityPolicy {
    //获取证书路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cerFilesPath" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    if (!cerData) {
        return nil;
    }
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    //是否允许无效证书 默认为NO
    securityPolicy.allowInvalidCertificates = YES;

    //是否允许验证域名 默认为YES
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
    return securityPolicy;
}

- (ATTURLSessionDataTask *)postDATARequestWithURL:(NSString *)url
                                             body:(NSData *)bodyData
                                          success:(ATTResponseSuccessBlock)success
                                          failure:(ATTResponseFailureBlock)failue {
    ATTURLSessionDataTask *dataSessionTask = nil;
    NSString *integrityURL = url;
    if (integrityURL) {

        integrityURL = [integrityURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//[self att_URLEncoding:integrityURL];
    }
    NSData *postData = bodyData;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= att_timeout;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];


    dataSessionTask = [self.dataResquesthtmlRespondSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failue (error);
        } else {
            success(responseObject);
        }
    } ];
    [dataSessionTask resume];
    return dataSessionTask;
}

- (ATTURLSessionDataTask *)requestWithHttpMethod:(HTTPMethod)httpMethod
                                       urlString:(NSString *)urlString
                                          params:(NSDictionary *)params
                                        progress:(ATTDataProgress)dataProgress
                                    successBlock:(ATTResponseSuccessBlock)success
                                    failureBlock:(ATTResponseFailureBlock)failure {

    ATTURLSessionDataTask *dataSessionTask = nil;
    NSString *integrityURL = urlString;
//    NSString *s = [@"放房间里" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [@"放房间里" e]
    if (integrityURL) {
        integrityURL = [integrityURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//[self att_URLEncoding:integrityURL];
    }
    if (httpMethod == ATTRequestGET) {

        dataSessionTask = [_dataJSONSessionManager GET:integrityURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success (responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure (error);
        }];
    } else if(httpMethod == ATTHTTPRequestGET) {

        dataSessionTask = [_httpResquestDataSessionManager GET:integrityURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success (responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure (error);
        }];
    } else if (httpMethod == ATTRequestPOST) {
        dataSessionTask = [_dataJSONSessionManager POST:integrityURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (dataProgress) {
                dataProgress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure(error);
        }];
    }  else if (httpMethod == ATTHTTPRequestPOST) {

        dataSessionTask = [_httpResquestDataSessionManager POST:integrityURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (dataProgress) {
                dataProgress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure(error);
        }];
    } else if(httpMethod == ATTJSONRequestHTTPRespondPOST) {
        dataSessionTask = [_jsonResquesthtmlRespondSessionManager POST:integrityURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (dataProgress) {
                dataProgress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure(error);
        }];
    }
    else if (httpMethod == ATTRequestPUT) {

        dataSessionTask = [_dataJSONSessionManager PUT:integrityURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure(error);
            ATTLog(@"ATTError:%@", [error localizedDescription])
        }];

    } else if (httpMethod == ATTRequeatDELETE) {

        dataSessionTask = [_dataJSONSessionManager DELETE:integrityURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [_dataRequestArray removeObject:task];
            failure(error);
            ATTLog(@"ATTError:%@", [error localizedDescription])
        }];
    }

    if (dataSessionTask) {
//        [_dataRequestArray addObject:dataSessionTask];
    }
    return dataSessionTask;
}



- (ATTURLSessionUploadTask *)requestUploadWithURL:(NSString *)urlString
                                           params:(NSDictionary *)params
                                         filePath:(NSString *)filePath
                                         fileData:(NSData *)fileData
                                             name:(NSString *)name
                                         fileName:(NSString *)fileName
                                   isloadFilePath:(BOOL)isloadFilePath
                                         progress:(ATTUploadProgress)progress
                                          success:(ATTResponseSuccessBlock)success
                                          failure:(ATTResponseFailureBlock)failure{

    if (isloadFilePath) {//从路径加载
        BOOL isFilePathExist = [self isFileExist:filePath];
        if (!isFilePathExist) {
            return nil;
        }
    } else {
        if (!fileData) {
            return nil;
        }
    }
    ATTURLSessionUploadTask *uploadSessionTask = nil;

    NSString *integrityURL = urlString;
    if (integrityURL) {
        integrityURL = [self att_URLEncoding:integrityURL];
    }
    if (isloadFilePath) {
//        [_uploadSessionManager uploadTaskWithRequest:<#(nonnull NSURLRequest *)#> fromFile:<#(nonnull NSURL *)#> progress:^(NSProgress * _Nonnull uploadProgress) {
//            <#code#>
//        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            <#code#>
//        }];

        uploadSessionTask = [_uploadSessionManager POST:integrityURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            [formData appendPartWithFormData:fileData name:name];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:NULL];
//            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:@"application/octet-stream" error:NULL];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            progress ? progress (uploadProgress) : nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success ? success (responseObject) :nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure ? failure(error) : nil;
            if (error) {
            }
        }];
    } else {
        uploadSessionTask = [_uploadSessionManager POST:integrityURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:fileData name:name];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
             progress ? progress (uploadProgress) : nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success ? success (responseObject) :nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure ? failure(error) : nil;
            if (error) {
            }

        }];

    }
    [uploadSessionTask resume];
    if (uploadSessionTask) {
//        [_uploadRequestArray addObject:uploadSessionTask];
    }
    return uploadSessionTask;
}

//对URL含有中文的进行中文编码
- (NSString *)att_URLEncoding:(NSString *)url {
    if ([self isContainChineseStr:url]) {
        return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return url;
}

// 字符串中含有中文字符的判断
- (BOOL)isContainChineseStr:(NSString *)string {
    for(int i = 0;i < [string length];i++) {
        int a =[string characterAtIndex:i];
        if( a >0x4e00 && a <0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFileExist:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}


@end
