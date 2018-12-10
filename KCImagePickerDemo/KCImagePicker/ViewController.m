//
//  ViewController.m
//  KCImagePicker
//
//  Created by Erica on 2018/9/18.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "ViewController.h"
#import "KCImagePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    KCImagePicker *ipc = [[KCImagePicker alloc] init];
//    ipc.maxSelectedCount = 1;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

@end
