//
//  SmartNotification.h
//  Clomp
//
//  Created by Andrei on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SmartScope;
@class SmartNotification;

typedef void(^SmartNotificationLambda)();

typedef enum SmartNotificationType {
    SmartNotificationTypeRepeated = 0,
    SmartNotificationTypeOnce     = 1,  
} SmartNotificationType;

typedef enum SmartNotificationCompositionType {
    SmartNotificationCompositionTypeAnd = 0,
    SmartNotificationCompositionTypeOr
} SmartNotificationCompositionType;

void when(NSString *name, SmartNotificationLambda action);
void once(NSString *name, SmartNotificationLambda action);
void just(int times, NSString *name, SmartNotificationLambda action);

void post(NSString *name);
void posto(NSString *name, id object);

void invalidate_current_scope(void);

#define stop invalidate_current_scope(); return ;


extern SmartNotification *currentNotification;
extern id tab00;

//FLAGS

extern BOOL didStopLastNotification;


@interface SmartNotification : NSObject

@property (nonatomic, retain) NSString *name;
@property SmartNotificationLambda action;
@property BOOL valid;
@property (nonatomic, retain) NSMutableArray *notifications;
@property SmartNotificationCompositionType compositionType;
@property (nonatomic, retain) NSMutableArray *okNotifications;
@property int actionCount;
@property int actionLimit;
@property (nonatomic, retain) SmartScope *scope;

+ (void)test;

+ (SmartNotification *)notificationWithName:(NSString *)name
                                     action:(SmartNotificationLambda)action
                                       limit:(int)times;
+ (SmartNotification *)notificationWithName:(NSString *)name
                                  andAction:(SmartNotificationLambda)action;
    

@end
