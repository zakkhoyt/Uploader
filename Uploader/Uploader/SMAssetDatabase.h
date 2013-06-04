//
//  SMAssetDatabase.h
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAssetDatabase : NSObject
+(SMAssetDatabase*)sharedInstance;
-(void)test_insert_garbage;
-(void)test_query_garbage;
@end
