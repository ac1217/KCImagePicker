//
//  KCAssetBottomView.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/19.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAssetBottomView.h"

@interface KCAssetBottomView ()


@end

@implementation KCAssetBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.funcBtn];
        [self addSubview:self.sendBtn];
        [self addSubview:self.originBtn];
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.funcBtn sizeToFit];
    CGFloat funcBtnH = self.bounds.size.height;
    CGFloat funcBtnX = 10;
    CGFloat funcBtnW = self.funcBtn.frame.size.width;
    self.funcBtn.frame = CGRectMake(funcBtnX, 0, funcBtnW, funcBtnH);
    
    
    [self.originBtn sizeToFit];
    CGFloat orginBtnH = self.bounds.size.height;
    CGFloat orginBtnW = self.originBtn.frame.size.width;
    CGFloat orginBtnX = (self.bounds.size.width - orginBtnW) * 0.5;
    
    self.originBtn.frame = CGRectMake(orginBtnX, 0, orginBtnW, orginBtnH);
    
    
    CGFloat sendBtnH = 30;
    CGFloat sendBtnW = 70;
    CGFloat sendBtnX = self.bounds.size.width - sendBtnW - 10;
    CGFloat sendBtnY = (self.bounds.size.height - sendBtnH) * 0.5;
    
    self.sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);
    
    
}

- (void)sendBtnClick
{
    !self.sendBtnClickBlock ? : self.sendBtnClickBlock();
}

- (void)originBtnClick
{
    !self.originBtnClickBlock ? : self.originBtnClickBlock();
    
}

- (void)funcBtnClick
{
    !self.funcBtnClickBlock ? : self.funcBtnClickBlock();
    
}


- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton new];
        
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor greenColor];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)originBtn
{
    if (!_originBtn) {
        _originBtn = [UIButton new];
        
        _originBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_originBtn setTitle:@"  原图" forState:UIControlStateNormal];
        
        [_originBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
                [_originBtn addTarget:self action:@selector(originBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originBtn;
}

- (UIButton *)funcBtn
{
    if (!_funcBtn) {
        _funcBtn = [UIButton new];
        
        _funcBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_funcBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_funcBtn addTarget:self action:@selector(funcBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _funcBtn;
}
@end
