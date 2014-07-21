//
//  TiUITableView+ParallaxHeader.h
//  TiParallaxHeader
//
//  Created by James Chow on 17/04/2014.
//  Edited by Do Lin on 21/07/2014.
//
//

#import "TiUIView.h"
#import "TiUITableViewProxy.h"
#import "TiUITableView.h"
#import "TiViewProxy.h"
#import <UIKit/UIKit.h>

@interface TiUITableView (ParallaxHeader)

-(void)addParallaxWithView:(TiViewProxy *)headerview withHeight: (CGFloat) height isConstraintScrollViewTopInset:(BOOL)isConstraintScrollViewTopInset parallaxGradientColor:(NSString *)color;

@end
