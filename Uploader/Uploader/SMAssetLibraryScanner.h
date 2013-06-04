//
//  SMAssetLibraryScanner.h
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SMAssetLibraryScannerEmptyBlock)(void);
typedef void (^SMAssetLibraryScannerGroupsBlock)(NSArray *groups);
typedef void (^SMAssetLibraryScannerPhotosBlock)(NSArray *groups);

typedef enum {
    SMAssetLibraryScannerFilterTypeAll =             0x01 << 1,
    SMAssetLibraryScannerFilterTypeCameraRoll =      0x01 << 2,
    SMAssetLibraryScannerFilterTypeSmile =           0x01 << 3,
} SMAssetLibraryScannerFilterType;


@interface SMAssetLibraryScanner : NSObject
+(SMAssetLibraryScanner*)sharedInstance;

// Get a list of all photo groups via code block. Use this to display a list of groups to the user
-(void)scanAssetLibraryForGroups:(SMAssetLibraryScannerGroupsBlock)completion;

// Pass in a list of asset groups, get a list of photos via block callback.
-(void)scanSelectedAssetGroups:(NSArray*)groups forPhotos:(SMAssetLibraryScannerPhotosBlock)photosBlock;




@end
