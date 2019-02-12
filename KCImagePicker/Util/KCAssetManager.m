//
//  KCAssetManager.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <Photos/Photos.h>
#import "KCAssetManager.h"

@implementation KCAssetManager

- (void)requestAuthorizationWithCompletion:(void(^)(NSError *error))cmp
{
   PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    switch (status) {
            case PHAuthorizationStatusAuthorized:
            !cmp ? : cmp(nil);
            break;
            case PHAuthorizationStatusDenied:
        {
            
            NSError *error = [NSError errorWithDomain:@"KCImagePicker" code:10001 userInfo:@{NSLocalizedFailureReasonErrorKey: @"用户拒绝相册访问权限"}];
            
            !cmp ? : cmp(error);
        }
            break;
            case PHAuthorizationStatusRestricted:
        {
            
            NSError *error = [NSError errorWithDomain:@"KCImagePicker" code:10002 userInfo:@{NSLocalizedFailureReasonErrorKey: @"相册访问权限不可用"}];
            
            !cmp ? : cmp(error);
        }
            break;
            case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (status) {
                            case PHAuthorizationStatusAuthorized:
                            !cmp ? : cmp(nil);
                            break;
                            case PHAuthorizationStatusDenied:
                        {
                            
                            NSError *error = [NSError errorWithDomain:@"KCImagePicker" code:10001 userInfo:@{NSLocalizedFailureReasonErrorKey: @"用户拒绝相册访问权限"}];
                            
                            !cmp ? : cmp(error);
                        }
                            break;
                            case PHAuthorizationStatusRestricted:
                        {
                            
                            NSError *error = [NSError errorWithDomain:@"KCImagePicker" code:10002 userInfo:@{NSLocalizedFailureReasonErrorKey: @"相册访问权限不可用"}];
                            
                            !cmp ? : cmp(error);
                        }
                            break;
                            
                        default:
                            break;
                    }
                });
                
            }];
            
        }
            break;
            
        default:
            break;
    }

}

+ (instancetype)defaultManager
{
    static id instane_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instane_ = [[self alloc] init];
    });
    return instane_;
}

- (void)fetchImageWithAsset:(PHAsset *)asset width:(CGFloat)width completion:(void (^)(UIImage *image,NSDictionary *info))completion
{
    
    
    // 修复获取图片时出现的瞬间内存过高问题
    // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
    
    PHAsset *phAsset = (PHAsset *)asset;
    
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    
    CGFloat pixelWidth = width * [UIScreen mainScreen].scale;
    
    if (pixelWidth > phAsset.pixelWidth) {
        pixelWidth = phAsset.pixelWidth;
    }
    
    // 超宽图片
    if (aspectRatio > 1.8) {
        pixelWidth = pixelWidth * aspectRatio;
    }
    // 超高图片
    if (aspectRatio < 0.2) {
        pixelWidth = pixelWidth * 0.5;
    }
    
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    CGSize imageSize = CGSizeMake(pixelWidth, pixelHeight);
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:completion];
}


- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info))completion
{
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            !completion ? : completion(asset, audioMix, info);
            
        });
    }];
}

- (void)fetchCameraRollAlbumsWithCompletion:(void (^)(KCAlbumModel  *))completion
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        // 有可能是PHCollectionList类的的对象，过滤掉
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        // 过滤空相册
        if (collection.estimatedAssetCount <= 0) continue;
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            KCAlbumModel *albumModel = [KCAlbumModel new];
            albumModel.name = collection.localizedTitle;
            albumModel.count = fetchResult.count;
            albumModel.result = fetchResult;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                !completion ? : completion(albumModel);
            });
            break;
        }
        
    }
}

- (void)fetchAllAlbumsWithCompletion:(void (^)(NSArray<KCAlbumModel *> *))completion{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *albumArr = [NSMutableArray array];
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        //    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld or mediaType == %ld",PHAssetMediaTypeVideo, PHAssetMediaTypeImage];
        //    if (!allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        //    if (!allowPickingImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
        //                                                PHAssetMediaTypeVideo];
        
        //    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        // 我的照片流 1.6.10重新加入..
        PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
        for (PHFetchResult *fetchResult in allAlbums) {
            for (PHAssetCollection *collection in fetchResult) {
                // 有可能是PHCollectionList类的的对象，过滤掉
                if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
                // 过滤空相册
                if (collection.estimatedAssetCount <= 0) continue;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (fetchResult.count < 1) continue;
                
                //            if ([self.pickerDelegate respondsToSelector:@selector(isAlbumCanSelect:result:)]) {
                //                if (![self.pickerDelegate isAlbumCanSelect:collection.localizedTitle result:fetchResult]) {
                //                    continue;
                //                }
                //            }
                
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
                //            if (collection.assetCollectionSubtype == 1000000201) continue; //『最近删除』相册
                
                KCAlbumModel *albumModel = [KCAlbumModel new];
                albumModel.name = collection.localizedTitle;
                albumModel.count = fetchResult.count;
                albumModel.result = fetchResult;
                
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [albumArr insertObject:albumModel atIndex:0];
                } else {
                    [albumArr addObject:albumModel];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !completion ? : completion(albumArr);
        });
    });
    
    
}

- (void)fetchAssetWithResult:(PHFetchResult *)result completion:(void (^)(NSArray <KCAssetModel *>*))completion
{
    NSMutableArray *photoArr = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        KCAssetModel *assetModel = [KCAssetModel new];
        assetModel.asset = asset;
        NSInteger duration = asset.duration;
        if (duration) {
            NSString *newTime;
            if (duration < 10) {
                newTime = [NSString stringWithFormat:@"0:0%zd",duration];
            } else if (duration < 60) {
                newTime = [NSString stringWithFormat:@"0:%zd",duration];
            } else {
                NSInteger min = duration / 60;
                NSInteger sec = duration - (min * 60);
                if (sec < 10) {
                    newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
                } else {
                    newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
                }
            }
            assetModel.duration = newTime;
        }
        
        
        [photoArr addObject:assetModel];
        
    }];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        !completion ? : completion(photoArr);
//    });
}


@end
