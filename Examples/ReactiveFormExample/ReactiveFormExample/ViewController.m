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

@interface ViewController ()
@property(nonatomic,strong,readonly) UITableView *tableView;
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    RFFormPresentation *formPresentation = [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^(RFTextField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.textField = field;
            return controller;
        }];
    }];
    
	RFMutableFormContentProvider *provider = [RFMutableFormContentProvider contentProvider];
	RFTextField *textField = [RFTextField fieldWithName:@"textField" title:@"Title"];
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
	
    RFForm *form = [RFForm formWithFormContentProvider:provider];

    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:formPresentation];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self.dataSourceModel;
    self.tableView.tableFooterView = [[UIView alloc] init];
	_dataSourceModel.tableView = self.tableView;
	
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
