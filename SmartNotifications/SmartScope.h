//
//  SmartScope.h
//  Run Away
//
//  Created by Andrei on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SmartScope;

extern SmartScope *currentScope;

typedef void(^ScopeLambda)();

@interface SmartScope : NSObject

@property (nonatomic, retain) NSMutableArray *subscopes;
@property (nonatomic, assign) SmartScope *superscope;

@property (nonatomic, retain) NSMutableArray *smartNotifications;

+ (SmartScope *)mainScope;
+ (SmartScope *)currentScope;
+ (SmartScope *)scope;

+ (void)push:(SmartScope *)scope;
+ (void)pop;

- (void)clear;

@end
