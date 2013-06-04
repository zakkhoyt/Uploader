//
//  SMViewController.m
//  Uploader
//
//  Created by Zakk Hoyt on 5/31/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "SMViewController.h"
#import "SMAssetLibraryScanner.h"
#import "SMAssetDatabase.h"


@interface SMViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) SMAssetLibraryScanner *assetLibraryScanner;
@property (nonatomic, strong) SMAssetDatabase *assetDatabase;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _assetLibraryScanner = [[SMAssetLibraryScanner alloc]init];
    
    
    _assetDatabase = [SMAssetDatabase sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Implements UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            if(image == nil){
                image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            }
            self.imageView.image = image;
        }];
        
    }];
	
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
}



#pragma mark IBActions

- (IBAction)scanLibraryButtonTouchUpInside:(UIButton*)sender {
    sender.enabled = NO;
    [self.assetLibraryScanner scanAssetLibraryForGroups:^(NSArray *groups) {
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


- (IBAction)choosePhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
	picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    }];
}


- (IBAction)takePhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
	picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    }];
}

- (IBAction)savedPhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
	picker.delegate = self;
    picker.editing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    }];
}



@end
