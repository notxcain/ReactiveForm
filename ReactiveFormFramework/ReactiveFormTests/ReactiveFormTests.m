//
//  ReactiveFormTests.m
//  ReactiveFormTests
//
//  Created by Denis Mikhaylov on 01/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(KiwiSpec)
describe(@"Kiwi test", ^{
   it(@"works", ^{
       [[@1 should] equal:@1];
   });
});
SPEC_END