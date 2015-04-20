//
//  OBDConstHelper.h
//  CarOnline
//
//  Created by James on 14-9-1.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#define kIncludeOBDConstHelper 1

#if kIncludeOBDConstHelper

#import <Foundation/Foundation.h>

@interface OBDConstHelper : NSObject

+ (NSMutableArray *)changeCodeToName:(NSString *)code;

@end

#endif
