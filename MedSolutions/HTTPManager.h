//
//  HTTPManager.h
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface HTTPManager : NSObject

+ (instancetype)sharedManager;
- (void)getFeedOnSuccess: (void(^)(NSArray * news)) succes
               onFailure: (void(^)(NSError * error, NSInteger * statusCode)) failure;
- (void)getDetailNewsWithMediaID:(NSInteger *) newsId
                        OnSuccess: (void(^)(NSDictionary * data)) succes
                        onFailure: (void(^)(NSError * error, NSInteger * statusCode)) failure;
-(void)cancel;
-(BOOL)isLoading;


@end
