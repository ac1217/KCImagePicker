//
//  KCAssetModel.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAssetModel.h"
#import "KCAssetManager.h"

@implementation KCAssetModel

- (void)fetchImageWithWidth:(CGFloat)width completion:(void(^)(UIImage *image))completion
{
    [[KCAssetManager defaultManager] fetchImageWithAsset:self.asset width:width completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        
        completion(image);
    }];
    
}

- (void)fetchVideoWithCompletion:(void(^)(AVAsset *asset))completion
{
    [[KCAssetManager defaultManager] fetchVideoWithAsset:self.asset completion:^(AVAsset * _Nonnull avasset, AVAudioMix * _Nonnull audioMix, NSDictionary * _Nonnull info) {
        completion(avasset);
    }];
}

@end
