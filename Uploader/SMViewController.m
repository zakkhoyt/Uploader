//
//  SMViewController.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMViewController.h"
#import "SMLibraryScanner.h"



@interface SMViewController ()
@property (nonatomic, strong) SMLibraryScanner *libraryScanner;
@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _libraryScanner = [[SMLibraryScanner alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBActions

- (IBAction)scanLibraryButtonTouchUpInside:(UIButton*)sender {
    sender.enabled = NO;
    [_libraryScanner scanLibraryGroupsBlock:^(NSArray *groups) {
        NSLog(@"%@", groups);
        sender.enabled = YES;
    }];
}


@end
