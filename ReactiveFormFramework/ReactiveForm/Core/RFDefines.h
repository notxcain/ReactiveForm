//
//  RFDefines.h
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RFAssertShouldBeOverriden() NSAssert(NO, @"Method %@ should be overriden by subclass", NSStringFromSelector(_cmd))