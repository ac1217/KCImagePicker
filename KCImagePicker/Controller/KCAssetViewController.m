//
//  KCAssetViewController.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAssetViewController.h"
#import "KCAssetCell.h"
#import "KCAssetManager.h"
#import "KCPreviewViewController.h"
#import "KCAssetFooterView.h"
#import "KCImagePicker.h"
#import "KCAssetBottomView.h"
#import "KCAssetTransition.h"

@interface KCAssetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) NSArray *assetModels;

@property (nonatomic,strong) NSMutableArray *selectedAssetModels;


@property (nonatomic,assign, getter=isOriginalImage) BOOL originalImage;

@property (nonatomic,strong) KCAssetBottomView *bottomView;

@end

@implementation KCAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupData];
    [self setupLayout];
}

- (void)setupUI
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[KCAssetCell class] forCellWithReuseIdentifier:NSStringFromClass([KCAssetCell class])];
    
    [self.collectionView registerClass:[KCAssetFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([KCAssetFooterView class])];
    
    self.title = self.albumModel.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
    
    [self.bottomView.originBtn setImage:[UIImage imageNamed:@"nor_img"] forState:UIControlStateNormal];
    [self.bottomView.originBtn setImage:[UIImage imageNamed:@"org_img"] forState:UIControlStateSelected];
    
    
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    self.bottomView.sendBtn.backgroundColor = ip.themeColor;
    
}


- (void)cancelBtnClick
{
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    
//    if ([ip.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
//        [ip.delegate imagePickerDidCancel:ip];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    
    CGFloat collectionViewH = bottomViewY;
    CGFloat collectionViewW = self.view.bounds.size.width;
    self.collectionView.frame = CGRectMake(0, 0, collectionViewW, collectionViewH);
    
}

- (void)setupData
{
    
    [[KCAssetManager defaultManager] fetchAssetWithResult:self.albumModel.result completion:^(NSArray<KCAssetModel *> * _Nonnull models) {
        
        self.assetModels = models;
        [self.collectionView reloadData];
//        [self.collectionView setNeedsLayout];
//        [self.collectionView layoutIfNeeded];
        
    }];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.assetModels.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assetModels.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

- (void)updateSelectedCount
{
    for (KCAssetCell *vidableCell in self.collectionView.visibleCells) {
        
        NSInteger selectedIndex = 0;
        if (vidableCell.assetModel.isSelected) {
            selectedIndex = [self.selectedAssetModels indexOfObject:vidableCell.assetModel];
        }
        
        [vidableCell setSelected:vidableCell.assetModel.isSelected selectedIndex:selectedIndex];
    }
    
    
    if (self.selectedAssetModels.count > 0) {
        self.bottomView.funcBtn.enabled = YES;
        self.bottomView.sendBtn.enabled = YES;
        
        [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"发送(%zd)", self.selectedAssetModels.count] forState:UIControlStateNormal];
        
    }else {
        
        self.bottomView.funcBtn.enabled = NO;
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
    KCAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KCAssetCell class]) forIndexPath:indexPath];
    
    KCAssetModel *assetModel = self.assetModels[indexPath.item];
    
    cell.assetModel = assetModel;
    
    NSInteger selectedIndex = 0;
    if (assetModel.isSelected) {
        selectedIndex = [self.selectedAssetModels indexOfObject:assetModel];
    }
    
    [cell setSelected:assetModel.isSelected selectedIndex:selectedIndex];
    
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    cell.selectBtn.hidden = ip.maxSelectedCount == 1;
    [cell.selectBtn setBackgroundImage:ip.normalButtonImage forState:UIControlStateNormal];
    [cell.selectBtn setBackgroundImage:ip.selectedButtonImage forState:UIControlStateSelected];
    
    __weak typeof(self) weakSelf = self;
    cell.selectBtnClickBlock = ^(KCAssetCell * _Nonnull cell) {
        
        if (cell.assetModel.isSelected) {
            
            cell.assetModel.selected = NO;
            
        }else {
            
            KCImagePicker *ip = (KCImagePicker *)weakSelf.navigationController;
            
            if (weakSelf.selectedAssetModels.count >= ip.maxSelectedCount) {
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片", ip.maxSelectedCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alertC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                
                return;
            }
            
            cell.assetModel.selected = YES;
            
        }
        
        if (cell.assetModel.isSelected) {
            [weakSelf.selectedAssetModels addObject:cell.assetModel];
            
        }else {
            [weakSelf.selectedAssetModels removeObject:cell.assetModel];
        }
        
        [weakSelf updateSelectedCount];
        
        
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToPreview:self.assetModels index:indexPath.item];
}

- (void)pushToPreview:(NSArray *)assetModels index:(NSInteger)index
{
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    KCAssetTransition *transition = [ip valueForKey:@"transition"];
    
    KCAssetModel *assetModel =  [assetModels objectAtIndex:index];
    
    NSInteger i = [self.assetModels indexOfObject:assetModel];
    
    KCAssetCell *cell = (KCAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    transition.image = cell.imageView.image;
    transition.fromRect = [cell.imageView convertRect:cell.imageView.frame toView:nil];
    
    CGFloat imageWidth = assetModel.naturalSize.width;
    CGFloat imageHeight = assetModel.naturalSize.height;
    CGFloat maxW = self.view.bounds.size.width;
    if (imageWidth > maxW) {

        imageHeight = maxW * imageHeight / imageWidth;
        imageWidth = maxW;

    }
    CGSize displayImgSize = CGSizeMake(imageWidth, imageHeight);
    CGFloat width = displayImgSize.width;
    CGFloat height = displayImgSize.height;
    CGFloat x = (self.view.bounds.size.width - width) * 0.5;
    CGFloat y = (self.view.bounds.size.height - height) * 0.5;
    transition.toRect = CGRectMake(x, y, width, height);
    
//    transition.toRect =
//    transition.fromImageView = cell.imageView;
    
    KCPreviewViewController *previewVC = [KCPreviewViewController new];
    previewVC.currentIndex = index;
    previewVC.assetModels = assetModels;
    previewVC.selectedAssetModels = self.selectedAssetModels;
    previewVC.originalImage = self.isOriginalImage;
    
    __weak typeof(self) weakSelf = self;
    previewVC.sourceImageViewBlock = ^UIImageView * _Nonnull(int idx) {
        
        KCAssetModel *assetModel =  [assetModels objectAtIndex:idx];
        
        NSInteger index = [weakSelf.assetModels indexOfObject:assetModel];
        
        KCAssetCell *cell = (KCAssetCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        return cell.imageView;
    };
    
    [self.navigationController pushViewController:previewVC animated:YES];
    
    previewVC.selectedUpdateBlock = ^{
        [weakSelf updateSelectedCount];
    };
    previewVC.orginalImageUpdateBlock = ^(BOOL r) {
        
        weakSelf.originalImage = r;
        weakSelf.bottomView.originBtn.selected = weakSelf.originalImage;
        
    };
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    
       KCAssetFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([KCAssetFooterView class]) forIndexPath:indexPath];
        footerView.assetModels = self.assetModels;
        return footerView;
        
    }
    return nil;
    
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 1;
        _layout.minimumLineSpacing = margin;
        _layout.minimumInteritemSpacing = margin;
        _layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        CGFloat wh = (self.view.frame.size.width - _layout.sectionInset.left - _layout.sectionInset.right - _layout.minimumInteritemSpacing * 3) / 4;
        _layout.itemSize = CGSizeMake(wh, wh);
        
        _layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 44);
        
    }
    return _layout;
}

- (NSMutableArray *)selectedAssetModels
{
    if (!_selectedAssetModels) {
        _selectedAssetModels = @[].mutableCopy;
    }
    return _selectedAssetModels;
}

- (KCAssetBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [KCAssetBottomView new];
        [_bottomView.funcBtn setTitle:@"预览" forState:UIControlStateNormal];
        _bottomView.funcBtn.enabled = NO;
        _bottomView.sendBtn.enabled = NO;
        
        __weak typeof(self) weakSelf = self;
        
        _bottomView.funcBtnClickBlock = ^{
            
            [weakSelf pushToPreview:weakSelf.selectedAssetModels.copy index:0];
            
        };
        
        _bottomView.originBtnClickBlock = ^{
          
            weakSelf.originalImage = !weakSelf.originalImage;
            weakSelf.bottomView.originBtn.selected = weakSelf.originalImage;
            
        };
        
        _bottomView.sendBtnClickBlock = ^{
            
            KCImagePicker *ip = (KCImagePicker *)weakSelf.navigationController;
            
//            if ([ip.delegate respondsToSelector:@selector(imagePicker:didFinishPickingImages:assets:)]) {
            
                NSMutableArray *images = @[].mutableCopy;
                NSMutableArray *assets = @[].mutableCopy;
                
                dispatch_group_t group = dispatch_group_create();
                
                for (KCAssetModel *am in weakSelf.selectedAssetModels) {
                    
                    CGFloat width = weakSelf.view.frame.size.width;
                    if (weakSelf.originalImage) {
                        width = CGFLOAT_MAX;
                    }
                    dispatch_group_enter(group);
                    [am fetchImageWithWidth:width completion:^(UIImage * _Nonnull image) {
                        [images addObject:image];
                        dispatch_group_leave(group);
                    }];
                    
                    [assets addObject:am.asset];
                }
                
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    
//                    [ip.delegate imagePicker:ip didFinishPickingImages:images assets:assets];
                    
                });
                
//            }
            
            
        };
        
    }
    return _bottomView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
    }
    return _collectionView;
}

@end
