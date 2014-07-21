//
//  TiUITableView+ParallaxHeader.m
//  TiParallaxHeader
//
//  Created by James Chow on 17/04/2014.
//  Edited by Do Lin on 21/07/2014.
//
//

#import "TiUITableView+ParallaxHeader.h"
#import "TiUtils.h"
#import "TiUIViewProxy.h"
#import "UIScrollView+APParallaxHeader.h"

#import <objc/runtime.h>

@implementation TiUITableView (ParallaxHeader)

BOOL isConstraint = NO;
CGFloat headerViewHeight = 0;

-(void)addParallaxWithView:(TiViewProxy *)headerview withHeight: (CGFloat)height isConstraintScrollViewTopInset:(BOOL)isConstraintScrollViewTopInset parallaxGradientColor:(NSString *)color
{
    isConstraint = isConstraintScrollViewTopInset;
    headerViewHeight = headerview.view.frame.size.height;
    [self.tableView addParallaxWithView: headerview andHeight:height parallaxGradientColor:color];
    
    [self.tableView setContentOffset:CGPointMake(0, -height) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( isConstraint ) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat h = headerViewHeight - 5;
        
        if ( offset.y <= -h ) {
            offset.y = -h;
        }
        
        scrollView.contentOffset = offset;
    }
    
}

@end
