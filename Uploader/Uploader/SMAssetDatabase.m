//
//  SMAssetDatabase.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMAssetDatabase.h"
#import "FMDatabase.h"

@interface SMAssetDatabase ()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation SMAssetDatabase

-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}


-(void)initializeClass{
//    _fileManager  = [NSFileManager new];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    _databasePath = [documentsDirectory stringByAppendingPathComponent:@"SMAssetDatabase.sqlite"];
    
    [self createAndOpenDatabase];
    
}


-(void)createAndOpenDatabase{
    self.database = [FMDatabase databaseWithPath:self.databasePath];
    if([self.database open] == NO){
        NSLog(@"ERROR! Failed to open database at path %@", self.databasePath);
    }
}

-(void)closeAndDeleteDatabase{
    [self.database close];
}

@end
