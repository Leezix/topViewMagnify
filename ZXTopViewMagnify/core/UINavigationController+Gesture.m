//
//  UINavigationController+Gesture.m
//  ZXTopViewMagnify
//
//  Created by lzx on 17/3/20.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "UINavigationController+Gesture.h"
#import <objc/runtime.h>

@interface ZXFullScreenGestureDelegate : NSObject<UIGestureRecognizerDelegate>

@property(nonatomic, weak) UINavigationController *navigationController;

@end

@implementation ZXFullScreenGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

@end

@implementation UINavigationController (Gesture)

//该方法: 加载完毕才会调用
+ (void)load{
    Method orginalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"pushViewController:animated:"));
    Method swizzledMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"zx_pushViewController:animated:"));
    method_exchangeImplementations(orginalMethod, swizzledMethod);
}

- (void)zx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.zx_panGesture]) {
        //拿到target
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id target = [targets.firstObject valueForKey:@"target"];
        SEL selector = NSSelectorFromString(@"handleNavigationTransition:");
        //给手势addTarget
        [self.zx_panGesture addTarget:target action:selector];
        //禁用系统手势
        self.interactivePopGestureRecognizer.enabled = NO;
        self.zx_panGesture.delegate = self.zxFullScreenGestureDelegate;
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.zx_panGesture];
    }
    
    if(![self.viewControllers containsObject:viewController]) {
        [self zx_pushViewController:viewController animated:animated];
    }
}

- (ZXFullScreenGestureDelegate *)zxFullScreenGestureDelegate{
    
    ZXFullScreenGestureDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[ZXFullScreenGestureDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}


- (UIPanGestureRecognizer *)zx_panGesture{
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
    if (!gesture || ![gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        gesture = [[UIPanGestureRecognizer alloc] init];
        gesture.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gesture;
}
@end
