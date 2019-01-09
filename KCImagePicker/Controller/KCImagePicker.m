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
#import "KCAssetTransition.h"

@interface KCImagePicker ()

@property (nonatomic,strong) UILabel *emptyLabel;
@property (nonatomic,strong) UIButton *emptyBtn;

@property (nonatomic,strong) KCAssetTransition *transition;

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
    return [self init];
}

- (void)setup
{
    self.maxSelectedCount = 9;
    
    self.delegate = self.transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[KCAssetManager defaultManager] requestAuthorizationWithCompletion:^(NSError * _Nonnull error) {
        
        if (error) {
            
            [self.view addSubview:self.emptyLabel];
            [self.view addSubview:self.emptyBtn];
            
            [self.emptyLabel sizeToFit];
            
            
            self.emptyLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, 130);
            
            
            [self.emptyBtn sizeToFit];
            self.emptyBtn.center = CGPointMake(self.view.bounds.size.width * 0.5, CGRectGetMaxY(self.emptyLabel.frame) + 20);
            
        }else {
            
            [self pushToAsset];
        }
        
    }];
    
}

- (void)pushToAsset
{
    
    [[KCAssetManager defaultManager] fetchCameraRollAlbumsWithCompletion:^(KCAlbumModel * _Nonnull model) {
        
        KCAssetViewController *assetVC = [[KCAssetViewController alloc] init];
        assetVC.albumModel = model;
        
        [self pushViewController:assetVC animated:NO];
      
    }];
}

- (void)settingBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.numberOfLines = 0;
        _emptyLabel.font = [UIFont systemFontOfSize:14];
        _emptyLabel.text = @"请在iPhone的“设置-隐私-照片”选项中，\n允许App访问你的手机相册。";
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

- (UIButton *)emptyBtn
{
    if (!_emptyBtn) {
        
        _emptyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_emptyBtn setTitle:@"立即设置" forState:UIControlStateNormal];
        
        _emptyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_emptyBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _emptyBtn;
}

- (UIImage *)normalButtonImage
{
    if (_normalButtonImage) {
        return _normalButtonImage;
    }
    
    return [UIImage imageNamed:@"deselect_img"];
}

- (UIImage *)selectedButtonImage
{
    if (_selectedButtonImage) {
        return _selectedButtonImage;
    }
    
    return [UIImage imageNamed:@"select_img"];
    
}

- (UIColor *)themeColor
{
    if (_themeColor) {
        return _themeColor;
    }
    return [UIColor colorWithRed:106/256.0 green:184/256.0 blue:77/256.0 alpha:1];
}

- (KCAssetTransition *)transition
{
    if (!_transition) {
        _transition = [[KCAssetTransition alloc] init];
    }
    return _transition;
}


@end
