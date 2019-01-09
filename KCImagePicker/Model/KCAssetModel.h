//
//  KCAssetModel.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, copy) NSString *duration;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic,assign, readonly) CGSize naturalSize;

- (void)fetchImageWithWidth:(CGFloat)width completion:(void(^)(UIImage *image))completion;

- (void)fetchVideoWithCompletion:(void(^)(AVAsset *asset))completion;




@end

NS_ASSUME_NONNULL_END
