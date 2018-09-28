//
//  KCAlbumModel.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAlbumModel.h"
#import "KCAssetManager.h"

@implementation KCAlbumModel

- (void)fetchImageWithWidth:(CGFloat)width completion:(void(^)(UIImage *image))completion
{
    
    [[KCAssetManager defaultManager] fetchImageWithAsset:self.result.lastObject width:width completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        completion(image);
    }];
}

@end
