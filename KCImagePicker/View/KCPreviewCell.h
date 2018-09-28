//
//  KCPreviewCell.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/19.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCPreviewCell : UICollectionViewCell

@property (nonatomic,strong) KCAssetModel *assetModel;


- (void)zooming;

- (void)addPlayerView:(UIView *)view;


@property (nonatomic,assign) BOOL playing;

@end

NS_ASSUME_NONNULL_END
