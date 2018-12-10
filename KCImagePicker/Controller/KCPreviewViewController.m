//
//  KCPreviewViewController.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCPreviewViewController.h"
#import "KCAssetBottomView.h"
#import <AVFoundation/AVFoundation.h>
#import "KCPreviewCell.h"
#import <AVKit/AVKit.h>
#import "KCImagePicker.h"

@interface KCPreviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) KCAssetBottomView *bottomView;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,assign) BOOL fullScreenPreview;

@property (nonatomic,strong) AVPlayerViewController *player;


@property (nonatomic,strong, readonly) KCPreviewCell *currentCell;
@property (nonatomic,strong, readonly) KCAssetModel *currentModel;

@property (nonatomic, weak) KCAssetModel *currentPlayModel;

@property (nonatomic, assign) BOOL playing;

@end

@implementation KCPreviewViewController

- (KCAssetModel *)currentModel
{
    return self.assetModels[self.currentIndex];
}

- (KCPreviewCell *)currentCell
{
    return (KCPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
}

- (BOOL)prefersStatusBarHidden
{
    return self.fullScreenPreview;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupData];
    [self setupLayout];
    [self setupNotification];
}

- (void)setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTimeNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidPlayToEndTimeNotification
{
    [self stopVideo];
    
    self.fullScreenPreview = NO;
    [self updateNavBar];
}

- (void)setupUI
{
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    self.bottomView.originBtn.selected = self.originalImage;
    
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    
    if (ip.maxSelectedCount > 1) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
        
    }else {
        
    }
    
    [self.collectionView registerClass:[KCPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([KCPreviewCell class])];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self updateBottomView];
    [self updateSelectedCount];
    [self updateNavTitle];
    
}

- (void)doubleTap
{
    
    KCPreviewCell *cell = (KCPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    
    [cell zooming];

}

- (void)singleTap
{
    
    if (self.currentModel.asset.mediaType == PHAssetMediaTypeVideo) {
        
        if (self.playing) {
            
            [self pauseVideo];
            
            self.fullScreenPreview = NO;
            
        }else {
            
            if (self.currentPlayModel == self.currentModel) {
                
                [self resumeVideo];
                
            }else {
                
                [self playVideo];
            }
            self.fullScreenPreview = YES;
            
        }
        
    }else {
        
        self.fullScreenPreview = !self.fullScreenPreview;
        
    }
    
    [self updateNavBar];
}

- (void)updateNavBar
{
    
    [self.navigationController setNavigationBarHidden:self.fullScreenPreview animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.fullScreenPreview) {
            
            
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height - self.bottomView.frame.origin.y);
        }else {
            
            self.bottomView.transform = CGAffineTransformIdentity;
        }
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)playVideo
{
    KCAssetModel *assetModel = self.currentModel;
    
    [assetModel fetchVideoWithCompletion:^(AVAsset * _Nonnull asset) {
        
        
        AVPlayer *player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
        
        self.player.player = player;
        self.player.view.frame = self.currentCell.contentView.frame;
        [self.currentCell addPlayerView:self.player.view];
        
        [player play];
        
        
    }];
    self.playing = YES;
    self.currentCell.playing = self.playing;
    self.currentPlayModel = assetModel;
}

- (void)resumeVideo
{
    [self.player.player play];
    [self.currentCell addPlayerView:self.player.view];
    self.playing = YES;
    self.currentCell.playing = self.playing;
}

- (void)pauseVideo
{
    
    [self.player.player pause];
    self.playing = NO;
    self.currentCell.playing = self.playing;
}

- (void)stopVideo
{
    [self.player.player pause];
    self.player.player = nil;
    [self.player.view removeFromSuperview];
    self.playing = NO;
    self.currentCell.playing = self.playing;
    self.currentPlayModel = nil;
}


- (void)setupLayout
{
   
    CGFloat bottomViewH = 44;
    CGFloat bottomViewW = self.view.bounds.size.width;
    CGFloat bottomViewY = self.view.bounds.size.height - bottomViewH;
    
    if (@available(iOS 11.0, *)) {
        bottomViewY -= [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    self.bottomView.frame = CGRectMake(0, bottomViewY, bottomViewW, bottomViewH);
    
    self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width + self.layout.minimumLineSpacing, self.view.bounds.size.height);
    
}

- (void)setupData
{
    
}

- (void)selectBtnClick
{
    KCAssetModel *assetModel = self.currentModel;
    if (assetModel.isSelected) {
        
        assetModel.selected = NO;
        
    }else {
        
        KCImagePicker *ip = (KCImagePicker *)self.navigationController;
        
        if (self.selectedAssetModels.count >= ip.maxSelectedCount) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片", ip.maxSelectedCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
        
        assetModel.selected = YES;
        
    }
    
    if (assetModel.isSelected) {
        [self.selectedAssetModels addObject:self.currentModel];
        
    }else {
        [self.selectedAssetModels removeObject:self.currentModel];
    }
    
    [self updateSelectedCount];
    
    !self.selectedUpdateBlock ? : self.selectedUpdateBlock();
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.currentIndex < self.assetModels.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        
    }
    
}

- (void)updateNavTitle
{
    self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd", self.currentIndex + 1, self.assetModels.count];
}

- (void)updateBottomView
{
    self.bottomView.originBtn.alpha = self.currentModel.asset.mediaType == PHAssetMediaTypeImage;
    
    
}

- (void)updateSelectedCount
{
    
    self.selectBtn.selected = [self.selectedAssetModels containsObject:self.currentModel];
    
    if (self.selectedAssetModels.count > 0) {
        
        self.bottomView.sendBtn.enabled = YES;
        [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"发送(%zd)", self.selectedAssetModels.count] forState:UIControlStateNormal];
        
    }else {
        
        self.bottomView.sendBtn.enabled = NO;
        [self.bottomView.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    }
    
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KCPreviewCell class]) forIndexPath:indexPath];
    
    KCAssetModel *assetModel = self.assetModels[indexPath.item];
    
    cell.assetModel = assetModel;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger currentIndex = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width) + 0.5);
    
    if (currentIndex != self.currentIndex) {
        [self stopVideo];
        self.currentIndex = currentIndex;
        [self updateBottomView];
        [self updateSelectedCount];
        [self updateNavTitle];
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseVideo];
}


- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.itemSize = self.view.bounds.size;
        
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, _layout.minimumLineSpacing);
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
    }
    return _collectionView;
}

- (KCAssetBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [KCAssetBottomView new];
//        [_bottomView.funcBtn setTitle:@"编辑" forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        _bottomView.originBtnClickBlock = ^{
            weakSelf.originalImage = !weakSelf.originalImage;
            weakSelf.bottomView.originBtn.selected = weakSelf.originalImage;
            !weakSelf.orginalImageUpdateBlock ? : weakSelf.orginalImageUpdateBlock(weakSelf.originalImage);
        };
        
        
    }
    return _bottomView;
}

- (AVPlayerViewController *)player
{
    if (!_player) {
        // player的控制器对象
        _player = [[AVPlayerViewController alloc] init];
        _player.view.backgroundColor = [UIColor clearColor];
        // 试图的填充模式
        _player.videoGravity = AVLayerVideoGravityResizeAspect;
        // 是否显示播放控制条
        _player.showsPlaybackControls = NO;
        
    }
    return _player;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectBtn setTitle:@"未选中" forState:UIControlStateNormal];
        [_selectBtn setTitle:@"选中" forState:UIControlStateSelected];
        
        [_selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
