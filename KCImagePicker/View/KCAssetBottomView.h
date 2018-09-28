//
//  KCAssetBottomView.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/19.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCAssetBottomView : UIView

@property (nonatomic,strong) UIButton *funcBtn;
@property (nonatomic,strong) UIButton *originBtn;
@property (nonatomic,strong) UIButton *sendBtn;


@property (nonatomic,copy) void(^funcBtnClickBlock)(void);
@property (nonatomic,copy) void(^originBtnClickBlock)(void);
@property (nonatomic,copy) void(^sendBtnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
