//
//  TiUITableViewProxy+ProxyParallaxHeader.m
//  TiParallaxHeader
//
//  Created by James Chow on 17/04/2014.
//  Edited by Do Lin on 21/07/2014.
//
//

#import "TiUITableViewProxy+ProxyParallaxHeader.h"
#import "TiUITableView+ParallaxHeader.h"
#import "TiUITableViewProxy.h"
#import "TiProxy.h"
#import <objc/runtime.h>

@implementation TiUITableViewProxy (ProxyParallaxHeader)

-(void)addParallaxWithView:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    TiViewProxy *headerView = nil;
    ENSURE_ARG_AT_INDEX(headerView,args,0,TiViewProxy);
    
    NSNumber *height = nil;
    ENSURE_ARG_AT_INDEX(height,args,1,NSNumber);
    
    BOOL isConstraintScrollViewTopInset = NO;
    if ([args isKindOfClass:[NSArray class]] && [args count] > 2 ) {
        isConstraintScrollViewTopInset = (BOOL)[args objectAtIndex:2];
    }
    
    NSString *hexString = nil;
    if ( [args isKindOfClass:[NSArray class]] && [args count] > 3 ) {
        hexString = [[NSString alloc] initWithString:[args objectAtIndex:3]];
    }
    
    TiUITableView *convert = (TiUITableView*) self.view;
    [convert addParallaxWithView:headerView withHeight:[height floatValue] isConstraintScrollViewTopInset:isConstraintScrollViewTopInset parallaxGradientColor:hexString];
}

@end
