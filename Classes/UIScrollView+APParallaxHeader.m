//
//  UIScrollView+APParallaxHeader.m
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//
//  Edited by Do Lin on 21/07/2014.
//

#import "UIScrollView+APParallaxHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface APParallaxView ()

@property (nonatomic, readwrite) APParallaxTrackingState state;

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic) CGFloat parallaxHeight;
@property (nonatomic) CGFloat proxyViewHeight;
@property (nonatomic) NSString *gradientColor;

@property(nonatomic, assign) BOOL isObserving;

@end


#pragma mark - UIScrollView (APParallaxHeader)
#import <objc/runtime.h>

static char UIScrollViewParallaxView;
BOOL isConstraintScrollViewTopInset;
NSString *parallaxGradientColor;

@implementation UIScrollView (APParallaxHeader)

-(CGPoint)calcProxyViewCenter:(CGPoint)parallaxCenter proxyViewHeight:(CGFloat)proxyHeight parallaxHeight:(CGFloat)parallaxHeight {
    CGPoint center = CGPointMake( parallaxCenter.x / 2, parallaxCenter.y / 2 );
    center.y += ( proxyHeight - parallaxHeight ) / 2 - 10;
    return center;
}


- (void)addParallaxWithView:(TiViewProxy*)proxyView andHeight:(CGFloat)height parallaxGradientColor:(NSString *)color {
    
    parallaxGradientColor = color;
    
    if(self.parallaxView) {
        
        [self.parallaxView.currentSubView removeFromSuperview];
        //XXX: needed to be resized?
        //[proxyView.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        proxyView.view.center = CGPointMake(self.parallaxView.center.x, self.parallaxView.frame.size.height / 2);
        [self.parallaxView addSubview:proxyView.view];
        
        self.parallaxView.parallaxHeight = height;
        self.parallaxView.proxyViewHeight = proxyView.view.frame.size.height;
        
        self.parallaxView.originalTopInset = self.contentInset.top;
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
    } else {
        
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(proxyView.view.frame), height)];
        [parallaxView setClipsToBounds:YES];
        parallaxView.layer.zPosition = -10;
        //XXX: needed to be resized?
        //[proxyView.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

        [parallaxView addSubview:proxyView.view];
        
        //parallaxView.layer.borderColor = [UIColor redColor].CGColor;
        //parallaxView.layer.borderWidth = 1.0f;
        
        parallaxView.scrollView = self;
        parallaxView.parallaxHeight = height;
        parallaxView.proxyViewHeight = proxyView.view.frame.size.height;

        [self addSubview:parallaxView];
        
        proxyView.view.center = CGPointMake(parallaxView.center.x, parallaxView.frame.size.height / 2);
        //proxyView.view.center = [self calcProxyViewCenter:parallaxView.center proxyViewHeight:proxyView.view.frame.size.height parallaxHeight:height];
        
        parallaxView.originalTopInset = self.contentInset.top;
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
        //[self setDelegate:self];
    }
}

- (void)setParallaxView:(APParallaxView *)parallaxView {
    objc_setAssociatedObject(self, &UIScrollViewParallaxView,
                             parallaxView,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (APParallaxView *)parallaxView {
    return objc_getAssociatedObject(self, &UIScrollViewParallaxView);
}

- (void)setShowsParallax:(BOOL)showsParallax {
    self.parallaxView.hidden = !showsParallax;
    
    if(!showsParallax) {
        if (self.parallaxView.isObserving) {
            [self removeObserver:self.parallaxView forKeyPath:@"contentOffset"];
            self.parallaxView.isObserving = NO;
        }
    }
    else {
        if (!self.parallaxView.isObserving) {
            [self addObserver:self.parallaxView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            self.parallaxView.isObserving = YES;
        }
    }
}

- (BOOL)showsParallax {
    return !self.parallaxView.hidden;
}

@end

#pragma mark - ShadowLayer

@implementation APParallaxShadowView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {

    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
        
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ( nil != parallaxGradientColor ) {
        
        NSString *hexString = parallaxGradientColor;
        UIColor *color = [self colorFromHexString:hexString];
    
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        //// Gradient Declarations
        /*NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithRed:255.0 / 255.0 green:51.0  / 255.0 blue:102.0 / 255.0 alpha:1.0].CGColor,
                                (id)[UIColor clearColor].CGColor, nil];*/
        NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                    (id) color.CGColor,
                                    (id)[UIColor clearColor].CGColor, nil];
        CGFloat gradient3Locations[] = {0, 1};
        CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        CGContextSaveGState(context);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, CGRectGetHeight(rect)), CGPointMake(0, 0), 0);
        CGContextRestoreGState(context);
    
        //// Cleanup
        CGGradientRelease(gradient3);
        CGColorSpaceRelease(colorSpace);
        
    }
    
}


@end

#pragma mark - APParallaxView

@implementation APParallaxView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self setState:APParallaxTrackingActive];
        [self setAutoresizesSubviews:YES];
        
        if ( nil != parallaxGradientColor ) {
            self.shadowView = [[APParallaxShadowView alloc] initWithFrame:CGRectMake(0, /*CGRectGetHeight(frame) / 4*/2, CGRectGetWidth(frame), CGRectGetHeight(frame) )];
            [self.shadowView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
            self.shadowView.layer.zPosition = 100;
            [self addSubview:self.shadowView];
        }
        
        self.currentSubView = nil;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsParallax) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "APParallaxView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    self.currentSubView = view;
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    // We do not want to track when the parallax view is hidden
    if (contentOffset.y > 0) {
        [self setState:APParallaxTrackingInactive];
    } else {
        [self setState:APParallaxTrackingActive];
    }
    
    if(self.state == APParallaxTrackingActive) {
        CGFloat yOffset = contentOffset.y*-1;
        
        if (yOffset < self.proxyViewHeight) {
            [self setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(self.frame), yOffset)];
        }
    }
}

@end