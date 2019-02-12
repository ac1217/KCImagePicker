//
//  KCImagePickerAppearance.h
//  KCImagePicker
//
//  Created by Erica on 2019/1/23.
//  Copyright © 2019 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCImagePickerAppearance : NSObject

@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,strong) UIImage *selectedCheckButtonImage;
@property (nonatomic,strong) UIImage *normalCheckButtonImage;

@property (nonatomic,strong) UIImage *normalSendButtonImage;
@property (nonatomic,strong) UIImage *disabledSendButtonImage;

@end

NS_ASSUME_NONNULL_END
