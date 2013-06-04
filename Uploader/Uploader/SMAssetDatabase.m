//
//  SMAssetDatabase.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//  http://www.icodeblog.com/2011/11/04/simple-sqlite-database-interaction-using-fmdb/

#import "SMAssetDatabase.h"
#import "FMDatabase.h"

// Table Assets
__attribute ((unused)) static NSString *kTBAssets = @"assets";
__attribute ((unused)) static NSString *kTBAssetsID = @"id";
__attribute ((unused)) static NSString *kTBAssetsURL = @"url";
__attribute ((unused)) static NSString *kTBAssetsDate = @"date";
__attribute ((unused)) static NSString *kTBAssetsUploaded = @"uploaded";
__attribute ((unused)) static NSString *kTBAssetsFailureCount = @"failure_count";
__attribute ((unused)) static NSString *kTBAssetsNextRetry = @"next_retry";

// Table Albums
__attribute ((unused)) static NSString *kTBAlbums = @"albums";
__attribute ((unused)) static NSString *kTBAlbumsID = @"id";
__attribute ((unused)) static NSString *kTBAlbumsURL = @"url";
__attribute ((unused)) static NSString *kTBAlbumsName = @"name";
__attribute ((unused)) static NSString *kTBAlbumsEnableUploading = @"enable_uploading";
__attribute ((unused)) static NSString *kTBAlbumsPriority = @"priority";
__attribute ((unused)) static NSString *kTBAlbumsPrivate = @"private";

// Table AlbumAssets
__attribute ((unused)) static NSString *kTBAlbumAssets = @"album_assets";
__attribute ((unused)) static NSString *kTBAlbumAssetsAlbumID = @"album_id";
__attribute ((unused)) static NSString *kTBAlbumAssetsAssetID = @"asset_id";


@interface SMAssetDatabase ()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation SMAssetDatabase


+(SMAssetDatabase*)sharedInstance{
    static SMAssetDatabase *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SMAssetDatabase alloc]init];
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
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    _databasePath = [documentsDirectory stringByAppendingPathComponent:@"SMAssetDatabase.sqlite"];
    
    [self deleteDatabase];
    [self createAndOpenDatabase];
}


-(void)createAndOpenDatabase{
    BOOL databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:self.databasePath];
    
    if(databaseExists){
        NSLog(@"Opening existing database instance at %@", self.databasePath);
    }
    else{
        NSLog(@"Creating new database instance at %@", self.databasePath);
    }
    self.database = [FMDatabase databaseWithPath:self.databasePath];
    if([self.database open] == NO){
        NSLog(@"ERROR! Failed to open database at path %@", self.databasePath);
        return;
    }
    if(databaseExists == NO){
        NSLog(@"Creating database tables");
        [self createTables];
    }

    
}

-(void)createTables{
    NSString *createAlbumsTable = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"%@\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \"%@\" TEXT NOT NULL UNIQUE, \"%@\" TEXT NOT NULL, \"%@\" BOOL NOT NULL DEFAULT 0, \"%@\" INTEGER NOT NULL DEFAULT 0, \"%@\" INTEGER NOT NULL DEFAULT 1)",
                                   kTBAlbums, kTBAlbumsID, kTBAlbumsURL, kTBAlbumsName, kTBAlbumsEnableUploading, kTBAlbumsPriority, kTBAlbumsPrivate];
    NSString *createAssetsTable = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"%@\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \"%@\" TEXT NOT NULL UNIQUE, \"%@\" REAL NOT NULL, \"%@\" BOOL NOT NULL DEFAULT 0, \"%@\" INTEGER NOT NULL DEFAULT 0, \"%@\" REAL NOT NULL DEFAULT 0)",
                                   kTBAssets, kTBAssetsID, kTBAssetsURL, kTBAssetsDate, kTBAssetsUploaded, kTBAssetsFailureCount, kTBAssetsNextRetry];
    NSString *createAlbumAssetsTable = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ INTEGER NOT NULL REFERENCES albums(%@) ON DELETE CASCADE, %@ INTEGER NOT NULL REFERENCES assets(%@) ON DELETE CASCADE)",
                                        kTBAlbumAssets, kTBAlbumAssetsAlbumID, kTBAlbumsID, kTBAlbumAssetsAssetID, kTBAssetsID];
    
    if(([self createTableWithString:createAlbumsTable] &&
        [self createTableWithString:createAssetsTable] &&
       [self createTableWithString:createAlbumAssetsTable]) == NO){
        NSLog(@"Failed to create tables");
    }
    
}

-(BOOL)createTableWithString:(NSString*)queryString{
    if([self.database executeUpdate:queryString]){
        return YES;
    }
    else{
        NSLog(@"**** ERROR! Could not update database with string %@", queryString);
        return NO;
    }    
}

-(void)closeDatabase{
    if(self.database) [self.database close];
}

-(void)deleteDatabase{
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:self.databasePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.databasePath error:&error];
        if (!success) {
            NSLog(@"Error removing database at path: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Deleted database at path: %@", self.databasePath);
        }
    }
}



-(void)query:(NSString*)queryString{
}






#pragma mark Public methods
-(void)test_insert_garbage{
    if(self.database == nil) return;
    static int offset = 0;
    int x = 0;
    for(x = 0; x < 100; x++){
        NSString *url = [NSString stringWithFormat:@"URL-%d", offset+x];
        NSString *updateString = [NSString stringWithFormat:@"INSERT INTO albums (id, name, url) VALUES (%d, 'red', '%@')", offset + x, url];
        BOOL s = [self.database executeUpdate:updateString];
        if(s == NO){
            NSLog(@"**** ERROR: could not update with string %@", updateString);
            NSLog(@"Last error = %@", self.database.lastError);
        }
    }
    offset += x;
    
}




-(void)test_query_garbage{
    NSString *queryString = @"select * from albums where id > 2 AND id < 40";
    FMResultSet *resultSet = [self.database executeQuery:queryString];

    while([resultSet next]){
        NSString *name = [resultSet stringForColumn:kTBAlbumsName];
        NSString *url = [resultSet stringForColumn:kTBAlbumsURL];
        NSInteger ident = [resultSet intForColumn:kTBAlbumsID];
        
        NSLog(@"name=%@ url=%@ ident=%d", name, url, ident);
        
    }    
}


@end



















