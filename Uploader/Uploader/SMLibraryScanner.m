//
//  SMLibraryScanner.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMLibraryScanner.h"

#import <AssetsLibrary/AssetsLibrary.h>

static NSString * kSMLibraryScannerCameraRoll = @"Camera Roll";
static NSString * kSMLibraryScannerSmile = @"Smile";

@interface SMLibraryScanner ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableArray *groups;
@end


@implementation SMLibraryScanner

-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}

-(void)initializeClass{
    _filterType = SMLibraryScannerFilterTypeCameraRoll | SMLibraryScannerFilterTypeSmile;
//    _filterType = SMLibraryScannerFilterTypeAll;
    _queue = [[NSOperationQueue alloc]init];
    _library = [[ALAssetsLibrary alloc] init];
    _groups = [@[]mutableCopy];
}

-(void)scanLibraryGroupsBlock:(SMLibraryScannerGroupsBlock)groupsBlock{
    [self.queue addOperationWithBlock:^{
        [self.groups removeAllObjects];
        [self scanAssetGroupsWithCompletionBlock:^{
            groupsBlock(self.groups);
        }];
    }];
}



-(void)scanAssetGroupsWithCompletionBlock:(SMLibraryScannerEmptyBlock)completion{
    // Note ALAssetsGroupSavedPhotos is for all photos in the camera aroll
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if (group) {
                                        if((self.filterType & SMLibraryScannerFilterTypeAll) == SMLibraryScannerFilterTypeAll){
                                            [self.groups addObject:group];
                                        }
                                        else{
                                            if((self.filterType & SMLibraryScannerFilterTypeCameraRoll) == SMLibraryScannerFilterTypeCameraRoll){
                                                NSString* groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                                if([groupName isEqualToString:kSMLibraryScannerCameraRoll]){
                                                    [self.groups addObject:group];
                                                }
                                            }
                                            if((self.filterType & SMLibraryScannerFilterTypeSmile) == SMLibraryScannerFilterTypeSmile){
                                                NSString* groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                                if([groupName isEqualToString:kSMLibraryScannerSmile]){
                                                    [self.groups addObject:group];
                                                }
                                            }
                                        }
                                }
                                    else{
                                        completion();
                                    }
                                    
                                    //                                    dispatch_resume(self.updateQueue);
                                    //                                    [self.db deleteAlbumsNotIn:groupsSeen];
                                    //
                                    //                                    [self.db runWhenAllCurrentDBOperationsComplete:^{
                                    //                                        DDLogInfo(@"Done updating asset DB, resuming upload");
                                    //                                        [SMUploader resumeUploading];
                                    //                                    }];
                                }
                              failureBlock:^(NSError *error) {
                                  //                                  dispatch_resume(self.updateQueue);
                                  //                                  DDLogInfo(@"ALAssetsLibrary enumerateGroupsWithTypes: fail %@", error);
                                  //                                  [self promptUserForLocationAuth];
                              }];

}
@end
