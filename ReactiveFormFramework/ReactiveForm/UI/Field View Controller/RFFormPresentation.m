//
//  QWAnythingYouWantFactory.m
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import "RFFormPresentation.h"

@interface RFFormPresentation () <RFFormPresentationBuilder>
@property (nonatomic, strong, readonly) NSMutableDictionary *instantiators;
@end

@implementation RFFormPresentation

+ (instancetype)createWithBlock:(void (^)(id<RFFormPresentationBuilder>))buildingBlock
{
	RFFormPresentation *factory = [[self alloc] init];
	buildingBlock(factory);
	return factory;
}

- (id)init
{
    self = [super init];
    if (self) {
		_instantiators = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addPredicate:(NSPredicate *)predicate instantiator:(RFFieldViewController *(^)(RFField *))instantiator
{
	[self.instantiators setObject:[instantiator copy] forKey:predicate];
}

- (RFFieldViewController *)controllerForField:(RFField *)field
{
	RFFieldViewControllerInstantiator block = [self instantiatorForObject:field];
	return block ? block(field) : nil;
}

- (RFFieldViewControllerInstantiator)instantiatorForObject:(id)object
{
	for (NSPredicate *predicate in self.instantiators) {
		if ([predicate evaluateWithObject:object]) {
			return self.instantiators[predicate];
		}
	}
	return nil;
}
@end