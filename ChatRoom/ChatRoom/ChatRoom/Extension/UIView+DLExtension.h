//
//  UIView+DLExtension.h
//  DLKit
//
//  Created by XueYulun on 15/3/25.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DLExtension)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;
@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;

- (void)shakeView;

@end
