//
//  ImageModel.m
//  Image Stock
//
//  Created by Alesia Adereyko on 20/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

- (void)dealloc {
    self.url = nil;
    self.image = nil;
    self.imgDescription = nil;
    self.userName = nil;
    self.creationDate = nil;
    self.location = nil;
    self.imageId = nil;
    [super dealloc];
}

@end
