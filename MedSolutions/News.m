//
//  News.m
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import "News.h"

@implementation News

- (instancetype)initDetailedWithJson:(NSDictionary *)json{
    
    self = [super init];
    if (self) {
        self.title = json[@"lead"];
        self.text = json[@"text"];
        self.newsId= [json[@"id"] integerValue];
        self.imageUrlString = json[@"image"];
    }
    return self;
}

-(instancetype)initPreviewWithJson:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.title = json[@"title"];
        self.newsDescription = json[@"description"];
        self.newsId = [json[@"id"] integerValue];
        self.createdAt = json[@"created_at"];
        self.imageUrlString = json[@"thumbnail"];
    }
    return self;
}

@end
