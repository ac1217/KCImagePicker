//
//  KCImagePicker.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCImagePicker.h"
#import "KCAlbumViewController.h"
#import "KCAssetViewController.h"
#import "KCAssetManager.h"

@interface KCImagePicker ()

@end

@implementation KCImagePicker

@dynamic delegate;

- (instancetype)init
{
    KCAlbumViewController *albumVC = [[KCAlbumViewController alloc] init];
    self = [super initWithRootViewController:albumVC];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    KCAlbumViewController *albumVC = [[KCAlbumViewController alloc] init];
    
    if (self = [super initWithRootViewController:albumVC]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.maxSelectedCount = 9;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pushToAsset];
}

- (void)setupUI
{
    
}

- (void)pushToAsset
{
    
    [[KCAssetManager defaultManager] fetchCameraRollAlbumsWithCompletion:^(KCAlbumModel * _Nonnull model) {
            KCAssetViewController *assetVC = [[KCAssetViewController alloc] init];
            assetVC.albumModel = model;
            
            [self pushViewController:assetVC animated:NO];
      
        
        
        
    }];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

@end
