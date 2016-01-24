//
//  News.h
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property NSInteger newsId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * newsDescription;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * imageUrlString;
@property (nonatomic, strong) NSMutableArray * spotlight;

- (instancetype)initDetailedWithJson:(NSDictionary *)json;
- (instancetype)initPreviewWithJson:(NSDictionary *)json;

@end
