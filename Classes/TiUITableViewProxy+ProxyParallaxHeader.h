//
//  TiUITableViewProxy+ProxyParallaxHeader.h
//  TiParallaxHeader
//
//  Created by James Chow on 17/04/2014.
//  Edited by Do Lin on 21/07/2014.
//
//

#import "TiUITableViewProxy.h"
#import "TiUIViewProxy.h"
#import "TiProxy.h"
#import <objc/runtime.h>

@interface TiUITableViewProxy (ProxyParallaxHeader)

-(void)addParallaxWithView:(id)args;

@end
