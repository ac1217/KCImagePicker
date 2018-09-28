//
//  KCAlbumModel.h
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface KCAlbumModel : NSObject

@property (nonatomic, copy) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain

@property (nonatomic, strong) PHFetchResult *result;

- (void)fetchImageWithWidth:(CGFloat)width completion:(void(^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
