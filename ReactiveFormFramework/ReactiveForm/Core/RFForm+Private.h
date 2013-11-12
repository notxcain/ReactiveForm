//
//  RForm_Private.h
//  RFKit
//
//  Created by Denis Mikhaylov on 29/07/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//


#import "RFForm.h"

@interface RFForm () <RFFormContent>
- (id)addSectionWithElement:(id<RFFormElement>)formElement;
- (void)removeSection:(id)section;
@end
