//
//  SMAssetUploader.m
//  Uploader
//
//  Created by Zakk Hoyt on 6/3/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMAssetUploader.h"


@interface SMAssetUploader ()
@end

@implementation SMAssetUploader

+(SMAssetUploader*)sharedInstance{
    static SMAssetUploader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SMAssetUploader alloc]init];
    });
    return instance;
}


-(id)init{
    self = [super init];
    if(self){
//        [self initializeClass];
    }
    return self;
}

#pragma mark Public methods
@end
