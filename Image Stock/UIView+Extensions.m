//
//  UIView+Extensions.m
//  Image Stock
//
//  Created by Alesia Adereyko on 27/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView(Extensions)

- (void)removeParentConstraints {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self || constraint.secondItem == self) {
            [self.superview removeConstraint:constraint];
        }
    }
}

@end
