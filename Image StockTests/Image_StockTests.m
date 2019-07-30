//
//  Image_StockTests.m
//  Image StockTests
//
//  Created by Alesia Adereyko on 19/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <XCTest/XCTest.h>
//@import Image_Stock
#import "NetworkManager.h"

@interface Image_StockTests : XCTestCase <NetworkManagerDelegate>

@property (nonatomic, retain) NetworkManager *manager;
@property (assign) NSInteger imageModelsDownloaded;
@property (assign) NSInteger errorsOccured;
@property (nonatomic, retain) XCTestExpectation *expectation;

@end

@implementation Image_StockTests

- (void)setUp {
    self.manager = [[[NetworkManager alloc] init] autorelease];
    self.manager.delegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testImageModelsDownload {
    self.expectation = [[[XCTestExpectation alloc] initWithDescription:@"waitForImagesDownload"] autorelease];
    [self.manager loadImageModels];
    [self waitForExpectations:@[self.expectation] timeout:10.0f];
    if (self.errorsOccured) {
        XCTFail(@"errors occured during downloading images");
    }
    if (self.imageModelsDownloaded < 10) {
        XCTFail(@"Less than 10 images, loaded only %@", @(self.imageModelsDownloaded));
    }
}

- (void)imageModelLoaded:(ImageModel *)model {
    if (model) {
        self.imageModelsDownloaded ++;
    } else {
        self.errorsOccured ++;
    }
    if (self.imageModelsDownloaded + self.errorsOccured == 10) {
        [self.expectation fulfill];
    }
}

- (void)loginCompleted:(NetworkManager *)manager {
    
}

- (void)didFailWithError:(NSError *)error {
    self.errorsOccured ++;
    if (self.imageModelsDownloaded + self.errorsOccured == 10) {
        [self.expectation fulfill];
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
