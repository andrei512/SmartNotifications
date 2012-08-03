//
//  DebugHelpers.h
//  Run Away
//
//  Created by Andrei on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_LINE NSLog(@"%d: %s", __LINE__, __PRETTY_FUNCTION__);
#define PO(O) NSLog(@"%d: %s - %s = %@", __LINE__, __PRETTY_FUNCTION__, #O, O);
#define PRect(rect) PO(NSStringFromCGRect(rect))
#define PPoint(point) PO(NSStringFromCGPoint(point))
#define PSize(size) PO(NSStringFromCGSize(size))

#define DeviceIsIPhone() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? YES : NO)

@interface DebugHelpers : NSObject

@end
