//
//  GalleryCollectionViewCell.m
//  Image Stock
//
//  Created by Alesia Adereyko on 27/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

static const CGFloat padding = 10;

@implementation GalleryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView new] autorelease];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-padding],
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:padding],
            [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:padding],
            [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-padding]
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
