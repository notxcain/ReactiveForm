//
//  UnistreamPaymentForm.m
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "UnistreamPaymentForm.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveForm/ReactiveForm.h>

@interface UnistreamPaymentForm ()
@property (nonatomic, strong, readonly) RFMutableFormContentProvider *contentProvider;
@end

@implementation UnistreamPaymentForm

- (NSString *)title
{
    return @"МТС. Домашний интернет и ТВ (ввод лицевого счета)";
}

- (id)init
{
    self = [super init];
    if (self) {
		_contentProvider = [RFMutableFormContentProvider contentProvider];

        RFTextField *phoneNumberField = [RFTextField fieldWithName:@"card_num" title:@"Номер телефона"];
		[phoneNumberField setValidator:[[NSRegularExpression regularExpressionWithPattern:@"\\(\\d{3}\\)\\d{3}-\\d{2}-\\d{2}" options:kNilOptions error:NULL] validatorWithFailureError:nil]];
		[phoneNumberField setTextInputController:[RFMask maskWithPattern:@"(ddd)ddd-dd-dd"]];
		
		RFChoiceField *recipientField = [RFChoiceField fieldWithName:@"recipient" title:@"Получатель"];
		
		RACCommand *recipientListLoadCommand = [[RACCommand alloc] initWithSignalBlock:^(id _) {
			return [self loadRecipientsForPhoneNumber:phoneNumberField.value];
		}];
		
		RAC(recipientField, choices) = [[recipientListLoadCommand executionSignals] switchToLatest];
		
		RFActionField *cardCheckField = [RFActionField fieldWithName:@"card_num_check" title:@"Загрузить данные"];
		cardCheckField.command = recipientListLoadCommand;
		
		RAC(cardCheckField, value) = [RACObserve(phoneNumberField, value) mapReplace:@NO];
		
		RACSignal *cardCheckActionVisibilitySignal = [RACSignal combineLatest:@[[RACSignal return:@YES], RACObserve(cardCheckField, value)]
																	   reduce:^(NSNumber *cardNumberIsValid, NSNumber *isChecked) {
																		   return @([cardNumberIsValid boolValue] && ![isChecked boolValue]);
																	   }];
		
		[_contentProvider addSectionWithElement:[RFContainer containerWithElements:@[[RFTextField fieldWithName:@"rec_surename" title:@"Фамилия получателя"],
																					 [RFTextField fieldWithName:@"rec_name" title:@"Имя получателя"],
																					 [RFTextField fieldWithName:@"rec_mname" title:@"Отчество получателя"],
																					 [RFTextField fieldWithName:@"s_surename" title:@"Фамилия отправителя"],
																					 [RFTextField fieldWithName:@"s_name" title:@"Имя отправителя"],
																					 [RFTextField fieldWithName:@"s_mname" title:@"Отчество отправителя"]
																					 ]]];
		[_contentProvider addSectionWithElement:
		 [RFChoiceField fieldWithName:@"identity_type"
								title:@"Тип идентификатора"
							  choices:@[[@1 choiceWithTitle:@"Номер телефона"
												  formElement:[RFContainer containerWithElements:@[phoneNumberField,
																								   [RFSwitch switchWithBooleanSignal:cardCheckActionVisibilitySignal then:cardCheckField],
																								   [RFSwitch switchWithBooleanSignal:RACObserve(cardCheckField, value) then:recipientField]
																								   ]]],
										[@2 choiceWithTitle:@"Фамилия Имя Отчество"
												  formElement:[RFContainer containerWithElements:@[[RFTextField fieldWithName:@"rec_surename" title:@"Фамилия получателя"],
																								   [RFTextField fieldWithName:@"rec_name" title:@"Имя получателя"],
																								   [RFTextField fieldWithName:@"rec_mname" title:@"Отчество получателя"],
																								   [RFTextField fieldWithName:@"s_surename" title:@"Фамилия отправителя"],
																								   [RFTextField fieldWithName:@"s_name" title:@"Имя отправителя"],
																								   [RFTextField fieldWithName:@"s_mname" title:@"Отчество отправителя"]
																								   ]]]
										]]];
    }
    return self;
}

- (RACSignal *)visibleSections
{
	return [self.contentProvider visibleSections];
}


- (RACSignal *)loadRecipientsForPhoneNumber:(NSString *)phoneNumber
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSMutableArray *recipientChoices = [NSMutableArray array];
            for (int i = 0; i < 10; i++) {
                [recipientChoices addObject:[@(i) choiceWithTitle:[NSString stringWithFormat:@"Получатель %d", i]]];
            }
            [subscriber sendNext:recipientChoices];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


@end
