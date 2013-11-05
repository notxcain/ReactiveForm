	//
//  QWAnythingYouWantFactory.m
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import "RFFormPresentation.h"
#import <objc/runtime.h>

NSPredicate *RFPredicateForMatcher(id matcher)
{
	if ([matcher isKindOfClass:[NSPredicate class]]) return matcher;
	
	if ([matcher isKindOfClass:[NSString class]]) {
		return [NSPredicate predicateWithFormat:@"name == %@", matcher];
	}
	
	if (class_isMetaClass(object_getClass(matcher))) {
		return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return [evaluatedObject isMemberOfClass:matcher];
		}];
	}
	
	return nil;
}

@interface RFFormPresentation () <RFFormPresentationBuilder>
@property (nonatomic, strong, readonly) NSMutableArray *predicates;
@property (nonatomic, strong, readonly) NSMutableArray *instantiators;
@property (nonatomic, strong, readonly) void (^buildingBlock)(id<RFFormPresentationBuilder>);
@end

@implementation RFFormPresentation
@synthesize instantiators = _instantiators, predicates = _predicates;
+ (instancetype)createWithBlock:(void (^)(id<RFFormPresentationBuilder>))buildingBlock
{
	RFFormPresentation *factory = [[self alloc] initWithBuildingBlock:buildingBlock];
	return factory;
}

- (id)initWithBuildingBlock:(void (^)(id<RFFormPresentationBuilder>))buildingBlock
{
    self = [super init];
    if (self) {
		_buildingBlock = [buildingBlock copy];
    }
    return self;
}

- (RFFieldController *)controllerForField:(RFField *)field
{
	RFFieldViewControllerInstantiator block = [self instantiatorForObject:field];
	return block ? block(field) : nil;
}

- (RFFieldViewControllerInstantiator)instantiatorForObject:(id)object
{
	RFFieldViewControllerInstantiator __block instantiator = nil;
	[self.predicates enumerateObjectsUsingBlock:^(NSPredicate *predicate, NSUInteger idx, BOOL *stop) {
		if ([predicate evaluateWithObject:object]) {
			instantiator = [self.instantiators objectAtIndex:idx];
			*stop = YES;
		}
	}];
	return instantiator;
}

- (NSMutableArray *)predicates
{
	if (_predicates) return _predicates;
	
	_predicates = [NSMutableArray array];
	_instantiators = [NSMutableArray array];
	self.buildingBlock(self);
	
	return _predicates;
}

- (void)addMatcher:(id)matcher instantiator:(RFFieldViewControllerInstantiator)instantiator
{
	NSPredicate *predicate = RFPredicateForMatcher(matcher);
	[self.predicates addObject:predicate];
	[self.instantiators addObject:instantiator];
}

@end


