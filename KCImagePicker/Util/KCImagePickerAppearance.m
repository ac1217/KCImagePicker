//
//  KCImagePickerAppearance.m
//  KCImagePicker
//
//  Created by Erica on 2019/1/23.
//  Copyright © 2019 Erica. All rights reserved.
//

#import "KCImagePickerAppearance.h"

@implementation KCImagePickerAppearance


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalCheckButtonImage = [self imageWithNamed:@"deselect_img"];
        self.selectedCheckButtonImage = [self imageWithNamed:@"select_img"];
        self.normalSendButtonImage = [self imageWithNamed:@"send_nor"];
        self.disabledSendButtonImage = [self imageWithNamed:@"send_dis"];
        self.themeColor = [UIColor colorWithRed:106/256.0 green:184/256.0 blue:77/256.0 alpha:1];
    }
    return self;
}






- (UIImage *)imageWithNamed:(NSString *)named
{
    
    return [UIImage imageNamed:named];
    
}

@end
