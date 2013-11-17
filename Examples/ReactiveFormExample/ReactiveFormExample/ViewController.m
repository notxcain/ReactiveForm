//
//  ViewController.m
//  ReactiveFormExample
//
//  Created by Alexander Desyatov on 06.11.13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveForm/ReactiveForm.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFETextFieldController.h"
#import "UnistreamPaymentForm.h"
#import "RFEChoiceFieldController.h"

@interface ViewController ()
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UnistreamPaymentForm *f = [UnistreamPaymentForm contentProvider];
    RFFormPresentation *formPresentation = [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^(RFTextField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFChoiceField class] instantiator:^(RFChoiceField *field) {
			RFEChoiceFieldController *controller = [[RFEChoiceFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFActionField class] instantiator:^(RFTextField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
    }];
    
	RFMutableFormContentProvider *provider = [RFMutableFormContentProvider contentProvider];
	RFTextField *textField = [RFTextField fieldWithName:@"phoneNumber" title:@"Phone number"];
	textField.textInputController = [RFMask maskWithPattern:@"(ddd) ddd-dd-dd"];
    RFContainer *container = [RFContainer container];

    [container addElement:textField];
	[container addElement:[RFSwitch
						   switchWithBooleanSignal:[RACObserve(textField, value)
													map:^(id value) {
														return @([value length] > 3);
													}]
						   then:[RFTextField fieldWithName:@"test" title:@"test"]
						   else:[RFContainer container]]];
	[provider addSectionWithElement:container];
	
    RFForm *form = [RFForm formWithFormContentProvider:f];

    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:formPresentation];

	
    self.tableView.dataSource = self.dataSourceModel;
    self.tableView.tableFooterView = [[UIView alloc] init];
	self.tableView.backgroundView = nil;
	_dataSourceModel.tableView = self.tableView;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
