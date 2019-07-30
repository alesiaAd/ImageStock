//
//  ImageCollectionViewCell.m
//  Image Stock
//
//  Created by Alesia Adereyko on 20/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView new] autorelease];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
            ]
         ];
    }
    return self;
}

- (void)dealloc {
    self.imageView = nil;
    [super dealloc];
}

@end
