//
//  RFFieldMatcher.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFieldMatcher.h"

@implementation NSPredicate (RFFieldMatching)
+ (instancetype)matcherWithClass:(Class)class
{
	return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isMemberOfClass:class];
	}];
}

+ (instancetype)matcherWithClass:(Class)class name:(NSString *)fieldName
{
	return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isMemberOfClass:class] && [[evaluatedObject valueForKey:@"name"] isEqualToString:fieldName];
	}];
}

+ (instancetype)matcherWithName:(NSString *)name
{
	return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [[evaluatedObject valueForKey:@"name"] isEqualToString:name];
	}];
}
@end
