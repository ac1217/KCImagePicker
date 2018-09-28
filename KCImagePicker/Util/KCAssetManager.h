//
//  KCAssetManager.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KCAlbumModel.h"
#import "KCAssetModel.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCAssetManager : NSObject

+ (instancetype)defaultManager;

- (void)fetchAllAlbumsWithCompletion:(void (^)(NSArray<KCAlbumModel *> *))completion;
- (void)fetchCameraRollAlbumsWithCompletion:(void (^)(KCAlbumModel  *))completion;

- (void)fetchImageWithAsset:(PHAsset *)asset width:(CGFloat)width completion:(void (^)(UIImage *image,NSDictionary *info))completion;

- (void)fetchAssetWithResult:(PHFetchResult *)result completion:(void (^)(NSArray <KCAssetModel *>*))completion;

- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info))completion;
@end

NS_ASSUME_NONNULL_END
