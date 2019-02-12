//
//  KCPreviewCell.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/19.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCPreviewCell.h"

@interface KCPreviewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) UIImageView *playView;
@end

@implementation KCPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

#pragma mark -Private Method
- (void)setup
{
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.playView];
    
}

- (void)addPlayerView:(UIView *)view
{
//    UIViewControllerInteractiveTransitioning
//    [self.scrollView addSubview:view];
    [self.contentView insertSubview:view belowSubview:self.playView];
}

- (void)layoutImageView
{
    self.scrollView.zoomScale = 1;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.contentSize = CGSizeZero;
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat maxW = self.contentView.bounds.size.width;
    
    if (imageWidth > maxW) {
        
        
        imageHeight = maxW * imageHeight / imageWidth;
        imageWidth = maxW;
        
        
    }
    
    CGSize displayImgSize = CGSizeMake(imageWidth, imageHeight);
    
    CGFloat width = displayImgSize.width;
    CGFloat height = displayImgSize.height;
    
    CGFloat insetH = (self.contentView.frame.size.width - width) * 0.5;
    CGFloat insetV = (self.contentView.frame.size.height - height) * 0.5;
    
    
    if (insetH < 0) {
        insetH = 0;
    }
    
    if (insetV < 0) {
        insetV = 0;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(insetV, insetH, insetV, insetH);
    
    self.imageView.frame =  CGRectMake(0, 0, width, height);
    
    self.scrollView.contentSize = self.imageView.frame.size;
    
}


#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize imgSize = self.imageView.frame.size;
    
    CGFloat width = imgSize.width;
    CGFloat height = imgSize.height;
    
    CGFloat insetH = (self.contentView.frame.size.width - width) * 0.5;
    CGFloat insetV = (self.contentView.frame.size.height - height) * 0.5;
    
    
    if (insetH < 0) {
        insetH = 0;
    }
    
    if (insetV < 0) {
        insetV = 0;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(insetV, insetH, insetV, insetH);
    
    
}

#pragma mark -Event
- (void)zooming
{
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        
        [self.scrollView setZoomScale:1 animated:YES];
    }else {
        
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
    
}

#pragma mark -Setter
- (void)setAssetModel:(KCAssetModel *)assetModel
{
    _assetModel = assetModel;
    
    [assetModel fetchImageWithWidth:self.contentView.frame.size.width completion:^(UIImage * _Nonnull image) {
        self.imageView.image = image;
        
        [self layoutImageView];
    }];
    
    self.playView.hidden = assetModel.asset.mediaType != PHAssetMediaTypeVideo;
    
//    self.scrollView.userInteractionEnabled = assetModel.asset.mediaType == PHAssetMediaTypeImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat playBtnWH = 100;
    CGFloat playBtnX = (self.contentView.frame.size.width - playBtnWH) * 0.5;
    CGFloat playBtnY = (self.contentView.frame.size.height - playBtnWH) * 0.5;
    self.playView.frame = CGRectMake(playBtnX, playBtnY, playBtnWH, playBtnWH);
    
}

- (void)setPlaying:(BOOL)playing
{
    _playing = playing;
    
    if (playing) {
        
        self.playView.alpha = 0;
    }else {
        
        self.playView.alpha = 1;
    }
    
}


#pragma mark -Getter


- (UIImageView *)playView
{
    if (!_playView) {
        _playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_img"]];
    }
    return _playView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = self.contentView.bounds;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

@end
