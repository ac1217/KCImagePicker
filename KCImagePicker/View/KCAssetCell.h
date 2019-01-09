//
//  KCAssetCell.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCAssetCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) KCAssetModel *assetModel;

@property (nonatomic,copy) void(^selectBtnClickBlock)(KCAssetCell *cell);

- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)index;

@property (nonatomic,strong) UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
