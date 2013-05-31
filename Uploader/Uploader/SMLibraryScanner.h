//
//  SMLibraryScanner.h
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SMLibraryScannerEmptyBlock)(void);
typedef void (^SMLibraryScannerGroupsBlock)(NSArray *groups);



typedef enum {
    SMLibraryScannerFilterTypeAll =             0x01 << 1,
    SMLibraryScannerFilterTypeCameraRoll =      0x01 << 2,
    SMLibraryScannerFilterTypeSmile =           0x01 << 3,
} SMLibraryScannerFilterType;


@interface SMLibraryScanner : NSObject
@property (nonatomic) SMLibraryScannerFilterType filterType;


-(void)scanLibraryGroupsBlock:(SMLibraryScannerGroupsBlock)groupsBlock;


@end
