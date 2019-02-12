//
//  KCImagePicker.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>
#import "KCImagePickerAppearance.h"

//@class KCImagePicker;

//@protocol KCImagePickerDelegate <NSObject>
//
//@optional
//- (void)imagePicker:(KCImagePicker *)picker didFinishPickingImages:(NSArray <UIImage *>*)images assets:(NSArray <PHAsset *>*)assets;
//- (void)imagePickerDidCancel:(KCImagePicker *)picker;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface KCImagePicker : UINavigationController

@property (nonatomic,strong, readonly) KCImagePickerAppearance *appearance;

@property (nonatomic,assign) NSInteger maxSelectedCount;


@property (nonatomic,assign, getter=isEditing) BOOL editing;

@property (nonatomic,strong) UIColor *themeColor;

@property (nonatomic,strong) UIImage *selectedButtonImage;
@property (nonatomic,strong) UIImage *normalButtonImage;

@end

NS_ASSUME_NONNULL_END
