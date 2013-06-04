//
//  SMAssetLibraryScanner.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMAssetLibraryScanner.h"

#import <AssetsLibrary/AssetsLibrary.h>

static NSString * kSMAssetLibraryScannerCameraRoll = @"Camera Roll";
static NSString * kSMAssetLibraryScannerSmile = @"Smile";

@interface SMAssetLibraryScanner ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic) dispatch_queue_t queue;
@end


@implementation SMAssetLibraryScanner


+(SMAssetLibraryScanner*)sharedInstance{
    static SMAssetLibraryScanner *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SMAssetLibraryScanner alloc]init];
    });
    return instance;
}


-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}

-(void)initializeClass{
    _queue = dispatch_queue_create("com.webshots.smile.smassetlibraryscanner", NULL);
    _library = [[ALAssetsLibrary alloc] init];
    
    [self addAssetLibraryObeserver];
}

-(void)addAssetLibraryObeserver{
//    [[SmileAppData sharedInstance] addObserver:self forKeyPath:@"enableUpload" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(assetsLibraryChanged:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:self.library];
    
}








#pragma mark Public methods
-(void)scanAssetLibraryForGroups:(SMAssetLibraryScannerGroupsBlock)completion{
    
    
    NSMutableArray *groups = [@[]mutableCopy];
    
    // Note ALAssetsGroupSavedPhotos is for all photos in the camera aroll
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if (group) {
                                        [groups addObject:group];
                                    }
                                    else{
                                        completion(groups);
                                    }
                                    
                                }
                              failureBlock:^(NSError *error) {
                                  [groups removeAllObjects];
                                  completion(groups);
                              }];

}




-(void)scanSelectedAssetGroups:(NSArray*)groups forPhotos:(SMAssetLibraryScannerPhotosBlock)photosBlock{
//    NSMutableArray *
    
    
//    if (self.stop) return;
//    
//    @autoreleasepool {
//        BOOL isSmile = [[group valueForProperty:ALAssetsGroupPropertyURL] isEqual:[SmileAppData sharedInstance].smileAlbumURL];
//        id<AlbumUpdater> updater = [self.db newAlbum:group withPriority:isSmile enableUploading:YES isPrivate:NO];
//        
//        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
//                [updater addAsset:[[[result defaultRepresentation] url] absoluteString]
//                      takenAtTime:[[result valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]];
//            }
//        }];
//        
//        [updater done];
//    }
    
}





@end













