//
//  RFFieldMatcher.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (RFFieldMatching)
+ (instancetype)matcherWithClass:(Class)class;
+ (instancetype)matcherWithName:(NSString *)name;
+ (instancetype)matcherWithClass:(Class)class name:(NSString *)fieldName;
@end

