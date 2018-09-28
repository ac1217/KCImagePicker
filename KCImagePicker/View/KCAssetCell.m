//
//  KCAssetCell.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAssetCell.h"

@interface KCAssetCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation KCAssetCell

- (void)setAssetModel:(KCAssetModel *)assetModel
{
    _assetModel = assetModel;
    
    [assetModel fetchImageWithWidth:self.imageView.frame.size.width completion:^(UIImage * _Nonnull image) {
        self.imageView.image = image;
    }];
    
    self.timeLabel.text = assetModel.duration;
    
    
    [self setupLayout];
    
}


- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)index
{
    
    if (selected) {
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd", index + 1] forState:UIControlStateNormal];
    }else {
        
        [self.selectBtn setTitle:nil forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.selectBtn];
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    
    self.imageView.frame = self.contentView.bounds;
    
    [self.timeLabel sizeToFit];
    
    CGRect timeFrame = self.timeLabel.frame;
    timeFrame.origin.x = self.contentView.bounds.size.width - timeFrame.size.width - 2;
    timeFrame.origin.y = self.contentView.bounds.size.height - timeFrame.size.height - 2;
    self.timeLabel.frame = timeFrame;
    
    CGFloat selectBtnWH = 30;
    CGFloat selectBtnX = self.contentView.frame.size.width - selectBtnWH;
    CGFloat selectBtnY = 0;
    self.selectBtn.frame = CGRectMake(selectBtnX, selectBtnY, selectBtnWH, selectBtnWH);
    
}


- (void)selectBtnClick
{
    !self.selectBtnClickBlock ? : self.selectBtnClickBlock(self);
    
    if (self.assetModel.isSelected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.selectBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.selectBtn.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
        
    }
    
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    
    return _timeLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
        _selectBtn.backgroundColor = [UIColor redColor];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
