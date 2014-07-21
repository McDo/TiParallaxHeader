//
//  UIScrollView+APParallaxHeader.h
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//
//  Edited by Do Lin on 21/07/2014.
//

#import <UIKit/UIKit.h>

@class APParallaxView;
@class APParallaxShadowView;

@interface UIScrollView (APParallaxHeader)<UIScrollViewDelegate>

- (void)addParallaxWithView:(TiViewProxy*)view andHeight:(CGFloat)height parallaxGradientColor:(NSString *)color;
- (CGPoint)calcProxyViewCenter:(CGPoint)parallaxCenter proxyViewHeight:(CGFloat)proxyHeight parallaxHeight:(CGFloat)parallaxHeight;

@property (nonatomic, strong, readonly) APParallaxView *parallaxView;
@property (nonatomic, assign) BOOL showsParallax;

@end

enum {
    APParallaxTrackingActive = 0,
    APParallaxTrackingInactive
};

typedef NSUInteger APParallaxTrackingState;

@interface APParallaxView : UIView

@property (nonatomic, readonly) APParallaxTrackingState state;
@property (nonatomic, strong) UIView *currentSubView;
@property (nonatomic, strong) APParallaxShadowView *shadowView;

@end

@interface APParallaxShadowView : UIView

-(UIColor *)colorFromHexString:(NSString *)hexString;

@end