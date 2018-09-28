//
//  KCAssetFooterView.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/19.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAssetFooterView.h"

@interface KCAssetFooterView ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation KCAssetFooterView

- (void)setAssetModels:(NSArray *)assetModels
{
    _assetModels = assetModels;
    
    NSInteger imageCount = 0;
    NSInteger videoCount = 0;
    
    
    for (KCAssetModel *am in assetModels) {
        if (am.asset.mediaType == PHAssetMediaTypeImage) {
            imageCount += 1;
        }else if (am.asset.mediaType == PHAssetMediaTypeVideo) {
            videoCount += 1;
        }
    }
    
    NSMutableString *str = [NSMutableString string];
    
    if (imageCount) {
        [str appendFormat:@"%zd张照片", imageCount];
    }
    
    if (videoCount) {
        
        if (imageCount) {
            [str appendString:@"、"];
        }
        
        [str appendFormat:@"%zd个视频", videoCount];
    }
    
    self.label.text = str;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.textColor = [UIColor darkTextColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    
    return _label;
}

@end
