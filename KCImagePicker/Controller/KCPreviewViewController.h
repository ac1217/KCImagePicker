//
//  KCPreviewViewController.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCPreviewViewController : UIViewController

@property (nonatomic,strong) NSArray *assetModels;

@property (nonatomic,strong) NSMutableArray *selectedAssetModels;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign, getter=isOriginalImage) BOOL originalImage;

@property (nonatomic,copy) void(^selectedUpdateBlock)(void);
@property (nonatomic,copy) void(^orginalImageUpdateBlock)(BOOL);


@property (nonatomic,copy) UIImageView *(^sourceImageViewBlock)(int idx);


@end

NS_ASSUME_NONNULL_END
