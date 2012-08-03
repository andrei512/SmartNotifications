//
//  SmartNotification.m
//  Clomp
//
//  Created by Andrei on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmartNotification.h"
#import "SmartScope.h"
#import "DebugHelpers.h"

id tab00 = nil;
SmartNotification *currentNotification = nil;

// FLAGS

BOOL didStopLastNotification = NO;

void when(NSString *name, SmartNotificationLambda action) {
    [SmartNotification notificationWithName:name 
                                  andAction:action];
}

void once(NSString *name, SmartNotificationLambda action) {
    [SmartNotification notificationWithName:name 
                                     action:action 
                                      limit:1];
}

void just(int times, NSString *name, SmartNotificationLambda action) {
    [SmartNotification notificationWithName:name 
                                     action:action
                                      limit:times];
}

void post(NSString *name) {
    tab00 = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:name 
                                                        object:nil];
}

void posto(NSString *name, id object) {
    tab00 = object;
    [[NSNotificationCenter defaultCenter] postNotificationName:name 
                                                        object:nil];
}

void invalidate_current_scope(void) {
    [currentNotification.scope clear];
    didStopLastNotification = YES;
}


@implementation SmartNotification

@synthesize name = _name, action = _action, valid;
@synthesize notifications = _notifications, compositionType, okNotifications;
@synthesize actionCount, actionLimit, scope;

+ (void)test {
    when(@"a & b", ^{
        NSLog(@"when a & b");
    });
    
    once(@"a | b", ^{
        NSLog(@"once a | b");
    });
    
    
    when(@"a", ^{
        NSLog(@"when a");
    });
    
    post(@"a");
    post(@"a");
    
    once(@"b", ^{
        NSLog(@"once b");
    });
    
    post(@"b");
    post(@"b");    
    
    when(@"thisEvent and thatEvent", ^{
        NSLog(@"whhoooo duude ...");
    });
    
    post(@"thisEvent");
    post(@"thatEvent");
    post(@"thatEvent");
    
    just(3, @"a", ^{
        NSLog(@"just 3 times a");
    });
    
    post(@"a");
    post(@"a");
    post(@"a");
    post(@"a");

    once(@"scope_test", ^{
        PO(currentScope)
        PO(currentScope.superscope)
        once(@"inner_scope_1", ^{
            PO(currentScope)
            PO(currentScope.superscope)
            once(@"inner_scope_2", ^{
                PO(currentScope)                
                PO(currentScope.superscope)
            });
            post(@"inner_scope_2");
        });
        post(@"inner_scope_1");
    });
    post(@"scope_test");
    post(@"inner_scope_1");
    
    just(2, @"x", ^{
        NSLog(@"if just one stop() works ok ;)");
        stop
        once(@"y", ^{
            NSLog(@"this should not work");
        });
    });
    
    post(@"x");
    post(@"y");
    post(@"x");
}

- (id)init {
    if (self = [super init]) {
        self.valid = YES;
        self.okNotifications = [NSMutableArray array];
        self.scope = [SmartScope scope];
        [self.scope.smartNotifications addObject:self];
    }
    return self;
}

+ (SmartNotification *)notificationWithName:(NSString *)name 
                                  andAction:(SmartNotificationLambda)action {
    return [SmartNotification notificationWithName:name 
                                            action:action 
                                             limit:INT32_MAX];
}

+ (SmartNotification *)notificationWithName:(NSString *)name
                                     action:(SmartNotificationLambda)action
                                       limit:(int)times {
    SmartNotification *notification = [[SmartNotification new] autorelease];
    notification.name = name;
    notification.action = action;
    notification.actionLimit = times;
    
    return notification;
}

- (void)clearScope {
    [self.scope clear];
}

- (void)triggerAction {
    [SmartScope push:self.scope];
    
    SmartNotification *oldNotification = currentNotification;
    currentNotification = self;
    
    didStopLastNotification = NO;
    
    self.action();
    
    currentNotification = oldNotification;
    
    [SmartScope pop];    
    
    if (self.compositionType == SmartNotificationCompositionTypeAnd) {
        self.okNotifications = [NSMutableArray array];
    }

    if (++self.actionCount >= self.actionLimit) {
        self.valid = NO;
        [self clearScope];
    }
}

- (void)goodNews:(NSNotification *)notification {    
    if (self.valid == YES) {
        if (self.compositionType == SmartNotificationCompositionTypeOr) {
            [self triggerAction];
        } else {
            BOOL isNew = YES;
            for (NSString *name in self.okNotifications) {
                if ([name isEqualToString:[notification name]]) {
                    isNew = NO;
                    break ;
                }
            }
            if (isNew) {
                [self.okNotifications addObject:[notification name]];
            }
            if ([self.okNotifications count] == [self.notifications count]) {
                [self triggerAction];
            }
        }
    }
}

- (void)removeNotifications:(NSArray *)notifications {
    for (NSString *notification in notifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:notification 
                                                      object:nil];
    }
}

- (void)listenToNotifications:(NSArray *)notifications {
    for (NSString *notification in notifications) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(goodNews:) 
                                                     name:notification 
                                                   object:nil];
    }    
}

- (void)processName {
    [self removeNotifications:self.notifications];
    if (self.name != nil) {
        NSString *notificationName = self.name;
        while ([notificationName rangeOfString:@"  "].location != NSNotFound) {
            notificationName = [notificationName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        }
        
        NSArray *tokens = [notificationName componentsSeparatedByString:@" "];
        NSMutableArray *notifications = [NSMutableArray array];

        BOOL hasAnd = NO;
        BOOL hasOr = NO;
        
        for (NSString *token in tokens) {
            if ([[token lowercaseString] isEqualToString:@"|"] ||
                [[token lowercaseString] isEqualToString:@"or"]) {
                hasOr = YES;
            } else if ([[token lowercaseString] isEqualToString:@"&"] ||
                       [[token lowercaseString] isEqualToString:@"and"]) {
                hasAnd = YES;
            } else { 
                [notifications addObject:token];
            }
        }        
        
        if (!(hasAnd & hasOr)) {
            self.valid = YES;
            self.compositionType = hasOr ? SmartNotificationCompositionTypeOr : SmartNotificationCompositionTypeAnd;
            self.notifications = notifications;
            [self listenToNotifications:notifications];
        } else {
            self.valid = NO;
        }
    }
}

- (void)setName:(NSString *)name {
    [_name release];
    _name = [name retain];    
    [self processName];
}

- (NSString *)name {
    return _name;
}

- (void)dealloc {
    self.name = nil;
    self.scope = nil;
    
    [super dealloc];
}

@end
