//
//  RFChoiceFieldSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFChoiceField.h"
#import "RFField.h"
#import "RFChoice.h"

SPEC_BEGIN(RFChoiceFieldSpec)
describe(@"Choice field", ^{
	context(@"when created with choices", ^{
		RFField *field1 = [RFField fieldWithName:@"choiceField1" title:@""];
		RFChoice *choice1 = [@1 choiceWithTitle:@"Choice 1" formElement:field1];
		RFField *field2 = [RFField fieldWithName:@"choiceField2" title:@""];
		RFChoice *choice2 = [@2 choiceWithTitle:@"Choice 2" formElement:field2];
		
		__block RFChoiceField *choiceField;
        beforeEach(^{
            choiceField = [RFChoiceField fieldWithName:@"choiceField"
                                                 title:@"Coice field"
                                               choices:@[choice1, choice2]];

        });
        
		it(@"should send dependent formElements when choice is made", ^{
			__block NSArray *visibleFields = nil;
			[[choiceField visibleFields] subscribeNext:^(id x) {
				visibleFields = x;
			}];
			[[visibleFields should] equal:@[choiceField]];
			choiceField.value = choice1;
			[[visibleFields should] equal:@[choiceField, field1]];
			choiceField.value = choice2;
			[[visibleFields should] equal:@[choiceField, field2]];
			choiceField.value = nil;
			[[visibleFields should] equal:@[choiceField]];
		});
        
        it(@"should be valid only if its value is one of this choices", ^{
            [[@([choiceField validate:NULL]) should] equal:@NO];
            choiceField.value = choice1;
            [[@([choiceField validate:NULL]) should] equal:@YES];
            choiceField.value = @"ddd";
            [[@([choiceField validate:NULL]) should] equal:@NO];
        });
	});
	
});
SPEC_END