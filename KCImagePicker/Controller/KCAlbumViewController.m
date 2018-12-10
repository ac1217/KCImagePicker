//
//  KCAlbumViewController.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAlbumViewController.h"
#import "KCAssetManager.h"
#import "KCAlbumCell.h"
#import "KCAssetViewController.h"
#import "KCImagePicker.h"

@interface KCAlbumViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;


@property (nonatomic,strong) NSArray *albumModels;

@end

@implementation KCAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.albumModels.count) {
        [self setupData];
    }
    
    
}

- (void)setupUI
{
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[KCAlbumCell class] forCellWithReuseIdentifier:NSStringFromClass([KCAlbumCell class])];
    
    self.title = @"相簿";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
}

- (void)cancelBtnClick
{
    
    KCImagePicker *ip = (KCImagePicker *)self.navigationController;
    
    if ([ip.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [ip.delegate imagePickerDidCancel:ip];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setupLayout
{
    self.collectionView.frame = self.view.bounds;
    
}

- (void)setupData
{
    
    [[KCAssetManager defaultManager] fetchAllAlbumsWithCompletion:^(NSArray<KCAlbumModel *> * _Nonnull models) {
        self.albumModels = models;
        [self.collectionView reloadData];
    }];
}


#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KCAlbumCell class]) forIndexPath:indexPath];
    
    cell.albumModel = self.albumModels[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCAssetViewController *assetVC = [[KCAssetViewController alloc] init];
    assetVC.albumModel = self.albumModels[indexPath.item];
    [self.navigationController pushViewController:assetVC animated:YES];
}


- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        CGFloat wh = (self.view.frame.size.width - _layout.sectionInset.left - _layout.sectionInset.right - _layout.minimumInteritemSpacing) * 0.5;
        _layout.itemSize = CGSizeMake(wh, wh + 40);
    }
    return _layout;
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
