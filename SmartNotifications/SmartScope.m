//
//  SmartScope.m
//  Run Away
//
//  Created by Andrei on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmartScope.h"
#import "SmartNotification.h"

SmartScope *currentScope;

@implementation SmartScope

@synthesize subscopes, superscope, smartNotifications;

+ (SmartScope *)mainScope {
    static SmartScope *mainScope = nil;
    if (mainScope == nil) {
        mainScope = [SmartScope new];
        mainScope.superscope = mainScope;
    }
    return mainScope;
}

+ (SmartScope *)currentScope {
    if (currentScope == nil) {
        currentScope = [SmartScope mainScope];
    }
    return currentScope;                              
}

+ (SmartScope *)scope {
    SmartScope *scope = [[SmartScope new] autorelease];    
    return scope;
}

+ (void)push:(SmartScope *)scope {
    scope.superscope = [SmartScope currentScope];
    if ([currentScope.subscopes containsObject:scope] == NO) {
        [currentScope.subscopes addObject:scope];
    }
    currentScope = scope;
}

+ (void)pop {
    currentScope = currentScope.superscope;    
}

- (void)clear {
    for (SmartNotification *notification in self.smartNotifications) {
        notification.scope = nil;
        notification.valid = NO;
    }
    [self.smartNotifications removeAllObjects];
    self.smartNotifications = nil;
    
    for (SmartScope *scope in self.subscopes) {
        [scope clear];
    }
    [self.subscopes removeAllObjects];
    self.subscopes = nil;
    
    [self.superscope.subscopes removeObjectIdenticalTo:self];
}


- (id)init {
    if (self = [super init]) {
        self.smartNotifications = [NSMutableArray array];
        self.subscopes = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    self.subscopes = nil;
    self.superscope = nil;
    self.smartNotifications = nil;
    
    [super dealloc];
}

@end
