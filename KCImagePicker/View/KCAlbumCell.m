//
//  KCAlbumCell.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAlbumCell.h"
#import "KCAssetManager.h"


@interface KCAlbumCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation KCAlbumCell

- (void)setAlbumModel:(KCAlbumModel *)albumModel
{
    _albumModel = albumModel;
    
    self.titleLabel.text = albumModel.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%zd", albumModel.count];
    
    
    [albumModel fetchImageWithWidth:self.imageView.frame.size.width completion:^(UIImage * _Nonnull image) {
        self.imageView.image = image;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    
    CGFloat imageWH = self.contentView.frame.size.width;
    self.imageView.frame = CGRectMake(0, 0, imageWH, imageWH);
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), imageWH, 25);
    self.detailLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), imageWH, 15);
    
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 5;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor lightGrayColor];
    }
    
    return _detailLabel;
}


@end
