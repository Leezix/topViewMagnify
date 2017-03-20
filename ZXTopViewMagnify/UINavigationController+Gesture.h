//
//  UINavigationController+Gesture.h
//  ZXTopViewMagnify
//
//  Created by lzx on 17/3/20.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Gesture)

/// 自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *zx_panGesture;

@end
