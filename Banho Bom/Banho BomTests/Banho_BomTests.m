//
//  Banho_BomTests.m
//  Banho BomTests
//
//  Created by Everson Trindade on 7/17/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "MapViewController.h"
#import "CustomAnnotation.h"
#import "DetalhesViewController.h"
#import "ClimaViewController.h"
#import "EstatisticaViewController.h"


@interface Banho_BomTests : XCTestCase

@end

@implementation Banho_BomTests

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

-(void)testViewControllerExists{
    ViewController *vc = [[ViewController alloc] init];
    XCTAssertNotNil(vc, @"ViewController Existe");
}

-(void)testMapViewControllerExists{
    MapViewController *mvc = [[MapViewController alloc] init];
    XCTAssertNotNil(mvc, @"MapViewController Existe");
}

-(void)testCustomAnnotationExists{
    CustomAnnotation *ca = [[CustomAnnotation alloc] init];
    XCTAssertNotNil(ca, @"CustomAnnotation Existe");
}

-(void)testDetalhesViewControllerExists{
    DetalhesViewController *dvc = [[DetalhesViewController alloc] init];
    XCTAssertNotNil(dvc, @"DetalhesViewController Existe");
}

-(void)testClimaViewControllerExists{
    ClimaViewController *cvc = [[ClimaViewController alloc] init];
    XCTAssertNotNil(cvc, @"ClimaViewController Existe");
}

-(void)testEstatisticaViewControllerExists{
    EstatisticaViewController *evc = [[EstatisticaViewController alloc] init];
    XCTAssertNotNil(evc, @"EstatisticaViewController Existe");
}

@end
