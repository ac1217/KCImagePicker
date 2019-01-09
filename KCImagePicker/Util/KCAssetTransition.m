//
//  KCAssetTransition.m
//  KCImagePicker
//
//  Created by Erica on 2018/12/10.
//  Copyright © 2018 Erica. All rights reserved.
//

#import "KCAssetTransition.h"

@interface KCAssetTransition()
{
    UINavigationControllerOperation _operation;
}

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation KCAssetTransition

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *containerView = [transitionContext containerView];
    
    if (_operation == UINavigationControllerOperationPush) { // push
        
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
//        [containerView addSubview:fromVC.view];
        [containerView addSubview:toVC.view];
        toVC.view.alpha = 0;
        
        
        UIImageView *imageView = self.imageView;
        imageView.image = self.image;
        imageView.frame = self.fromRect;
        
        [containerView addSubview:imageView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            toVC.view.alpha = 1;
             imageView.frame = self.toRect;
            
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            
//            self.image = nil;
        }];
        
    }else { // pop
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [containerView addSubview:toVC.view];
        
        UIImageView *imageView = self.imageView;
        imageView.image = self.image;
        imageView.frame = self.fromRect;
        
        [containerView addSubview:imageView];
        
//        displayImageView.frame = [displayImageView.superview convertRect:displayImageView.frame toView:containerView];
        
//        [containerView addSubview:displayImageView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromVC.view.alpha = 0;
            imageView.frame = self.toRect;
        } completion:^(BOOL finished) {

            [imageView removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            
//            self.image = nil;
            
            
        }];
    }
    
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationControxller
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if (self.image) {
        _operation = operation;
        return self;
    }
    
    return nil;
}



@end
