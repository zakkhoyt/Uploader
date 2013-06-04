//
//  SMAssetCameraScanner.m
//  Uploader
//
//  Created by Zakk Hoyt on 6/3/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMAssetCameraScanner.h"

@interface SMAssetCameraScanner ()
@end


@implementation SMAssetCameraScanner

+(SMAssetCameraScanner*)sharedInstance{
    static SMAssetCameraScanner *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SMAssetCameraScanner alloc]init];
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

@end
