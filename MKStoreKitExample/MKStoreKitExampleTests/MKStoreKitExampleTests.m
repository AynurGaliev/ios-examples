//
//  MKStoreKitExampleTests.m
//  MKStoreKitExampleTests
//
//  Created by Nikita Asabin on 08.07.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface MKStoreKitExampleTests : XCTestCase

@end

@implementation MKStoreKitExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
