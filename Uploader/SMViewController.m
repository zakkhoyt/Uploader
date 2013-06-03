//
//  SMViewController.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMViewController.h"
#import "SMLibraryScanner.h"
#import "SMAssetDatabase.h"


@interface SMViewController ()
@property (nonatomic, strong) SMLibraryScanner *libraryScanner;
@property (nonatomic, strong) SMAssetDatabase *assetDatabase;
@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _libraryScanner = [[SMLibraryScanner alloc]init];
    
    
    _assetDatabase = [SMAssetDatabase sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBActions

- (IBAction)scanLibraryButtonTouchUpInside:(UIButton*)sender {
    sender.enabled = NO;
    [self.libraryScanner scanLibraryGroupsBlock:^(NSArray *groups) {
        NSLog(@"%@", groups);
        sender.enabled = YES;
    }];
}
- (IBAction)insertButtonTouchUpInside:(id)sender {
    [self.assetDatabase test_insert_garbage];
}

- (IBAction)queryButtonTouchUpInside:(id)sender {
    [self.assetDatabase test_query_garbage];
}

@end
