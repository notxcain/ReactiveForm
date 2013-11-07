//
//  ViewController.m
//  ReactiveFormExample
//
//  Created by Alexander Desyatov on 06.11.13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveForm/RFForm.h>
#import <ReactiveForm/RFFormTableViewDataSource.h>
#import <ReactiveForm/RFFormPresentation.h>
#import <ReactiveForm/RFTextField.h>
#import <ReactiveForm/RFFieldViewController.h>
#import <ReactiveForm/RFContainer.h>

@interface ViewController ()
@property(nonatomic,strong,readonly) UITableView *tableView;
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RFTextField *textField = [RFTextField fieldWithName:@"textField" title:@"title"];
    RFContainer *container = [RFContainer container];
    [container addElement:textField];
    RFFieldController *textFieldController = [[RFFieldController alloc] init];
    RFFormPresentation *formPresentation = [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^RFFieldController *(RFField *field) {
            return textFieldController;
        }];
    }];
    
    RFForm *form = [RFForm form];
    [form addSectionWithElement:container];
    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:formPresentation];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self.dataSourceModel;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
