//
//  RFSectionsBuilder.h
//  Form
//
//  Created by Denis Mikhaylov on 18.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RFBackingObject;
@interface RFBackingStructureBuilder : NSObject
- (void)addBackingObject:(RFBackingObject *)backingObject;
- (NSOrderedSet *)sections;
- (NSDictionary *)nameMap;
@end
