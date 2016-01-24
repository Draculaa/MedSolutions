//
//  HTTPManager.m
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import "HTTPManager.h"
#import <AFNetworking/AFNetworking.h>

@interface HTTPManager ()

@property (strong, nonatomic) AFHTTPSessionManager * httpSessionManager;
@property (strong, nonatomic) NSURLSessionTask * datatask;
@property  NSInteger currentPage;
@property  NSInteger newsLimit;

@end

@implementation HTTPManager

+ (instancetype)sharedManager{
    static HTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTPManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSURL* baseURL = [NSURL URLWithString:@"http://medsolutions.uxp.ru"];
        self.httpSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
        self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.httpSessionManager.requestSerializer setValue:@"secret_key" forHTTPHeaderField:@"API-KEY"];
        self.currentPage = 1;
        self.newsLimit = 5;
    }
    return self;
}

- (void)getFeedOnSuccess:(void (^)(NSArray *))succes
               onFailure:(void (^)(NSError *, NSInteger *))failure{
    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", self.currentPage], @"page",
                                 [NSString stringWithFormat:@"%d", self.newsLimit], @"limit",
                                 nil];
    self.datatask = [self.httpSessionManager GET:@"/api/v1/news"
                                      parameters:parameters
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                             NSLog(@"%@", responseObject);
                                             NSDictionary * data = responseObject[@"data"];
                                             NSMutableArray * news = [NSMutableArray new];
                                             for (NSDictionary * newsDesc in data) {
                                                 News * new = [[News alloc] initPreviewWithJson:newsDesc];
                                                 [news addObject:new];
                                             }
                                             succes(news);
                                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             failure(error, error.code);
                                         }];
    self.currentPage++;
    [self.datatask resume];
}

- (void)getDetailNewsWithMediaID:(NSInteger *)newsId
                       OnSuccess:(void (^)(NSDictionary *))succes
                       onFailure:(void (^)(NSError *, NSInteger *))failure{
    self.datatask = [self.httpSessionManager GET:[NSString stringWithFormat:@"/api/v1/news/%d", newsId]
                                      parameters:nil
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                             NSLog(@"%@", responseObject);
                                             NSArray * data = responseObject[@"data"];
                                             News * detailedNews = [[News alloc] initDetailedWithJson: data[0]];
                                             NSDictionary * spotlight = responseObject[@"spotlight"];
                                             NSMutableArray * spotlightNews = [NSMutableArray new];
                                             for (NSDictionary * newsDesc in spotlight) {
                                                 News * new = [[News alloc] initPreviewWithJson:newsDesc];
                                                 [spotlightNews addObject:new];
                                             }
                                             NSDictionary * result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      detailedNews, @"data",
                                                                      spotlightNews, @"spotlight",
                                                                      nil];
                                             succes(result);
                                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             NSLog(@"%@", error);
                                         }];
    [self.datatask resume];
}

- (void)cancel{
    [self.datatask cancel];
}

- (BOOL)isLoading{
    return self.datatask && self.datatask.state == NSURLSessionTaskStateRunning;
}


@end
