//
//  FilterModel.m
//  Image Stock
//
//  Created by Alesia Adereyko on 26/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

- (void)dealloc {
    self.filterNameForLabel = nil;
    self.filterImage = nil;
    self.filterNameForMethod = nil;
    [super dealloc];
}

@end
