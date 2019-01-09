//
//  KCAssetTransition.h
//  KCImagePicker
//
//  Created by Erica on 2018/12/10.
//  Copyright © 2018 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCAssetTransition : NSObject<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@property (nonatomic,assign) CGRect fromRect;
@property (nonatomic,assign) CGRect toRect;
@property (nonatomic,strong) UIImage *image;


//@property (nonatomic,weak) UIImageView *fromImageView;
//@property (nonatomic,weak) UIImageView *toImageView;

@end

NS_ASSUME_NONNULL_END
