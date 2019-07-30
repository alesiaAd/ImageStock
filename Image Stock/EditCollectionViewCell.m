//
//  EditCollectionViewCell.m
//  Image Stock
//
//  Created by Alesia Adereyko on 25/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "EditCollectionViewCell.h"

@implementation EditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.filterImageView = [[UIImageView new] autorelease];
        [self.contentView addSubview:self.filterImageView];
        self.filterImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.filterNameLabel.textAlignment = NSTextAlignmentCenter;
        [NSLayoutConstraint activateConstraints:@[
            [self.filterImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor],
            [self.filterImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor],
            [self.filterImageView.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-10],
            [self.filterImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor]
        ]
        ];
        
        self.filterNameLabel = [[UILabel new] autorelease];
        [self.contentView addSubview:self.filterNameLabel];
        self.filterNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.filterNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor],
            [self.filterNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor],
            [self.filterNameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor],
            [self.filterNameLabel.heightAnchor constraintEqualToConstant:20]
        ]
        ];
    }
    return self;
}

- (void)dealloc {
    self.filterImageView = nil;
    self.filterNameLabel = nil;
    [super dealloc];
}

@end
