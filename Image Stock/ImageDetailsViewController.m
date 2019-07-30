//
//  ImageDetailsView.m
//  Image Stock
//
//  Created by Alesia Adereyko on 24/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ImageDetailsViewController.h"
#import "EditImageViewController.h"
#import "UIView+Extensions.h"

@interface ImageDetailsViewController ()

@property (nonatomic, retain) UIStackView *imageStackView;
@property (nonatomic, retain) UIStackView *detailsStackView;

@end

@implementation ImageDetailsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupStackViews];
    [self setupSubviews];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
}

- (void)setupSubviews {
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.text = self.model.imgDescription;
    if (descriptionLabel.text) {
        [descriptionLabel setHidden:NO];
    } else {
        [descriptionLabel setHidden:YES];
    }
    descriptionLabel.numberOfLines = 0;
    [self.view addSubview:descriptionLabel];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = self.model.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    [self.imageStackView addArrangedSubview:descriptionLabel];
    [self.imageStackView addArrangedSubview:imageView];
    [descriptionLabel release];
    [imageView release];
    
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.numberOfLines = 0;
    userNameLabel.text = self.model.userName;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.numberOfLines = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    dateLabel.text = [dateFormatter stringFromDate:self.model.creationDate];
    [dateFormatter release];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *likesView = [UIView new];
    likesView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *likes = [UILabel new];
    [likesView addSubview:likes];
    likes.translatesAutoresizingMaskIntoConstraints = NO;
    likes.text = @"Likes";
    [NSLayoutConstraint activateConstraints:@[
                                              [likes.leadingAnchor constraintEqualToAnchor:likesView.leadingAnchor],
                                              [likes.widthAnchor constraintEqualToConstant:50],
                                              [likes.topAnchor constraintEqualToAnchor:likesView.topAnchor],
                                              [likes.bottomAnchor constraintEqualToAnchor:likesView.bottomAnchor]
                                              ]
     ];
    [likes release];
    
    UILabel *likesAmountLabel = [UILabel new];
    likesAmountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.model.likesAmount];
    [likesView addSubview:likesAmountLabel];
    likesAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [likesAmountLabel.leadingAnchor constraintEqualToAnchor:likes.trailingAnchor constant:5],
                                              [likesAmountLabel.trailingAnchor constraintEqualToAnchor:likesView.trailingAnchor],
                                              [likesAmountLabel.topAnchor constraintEqualToAnchor:likesView.topAnchor],
                                              [likesAmountLabel.bottomAnchor constraintEqualToAnchor:likesView.bottomAnchor]
                                              ]
     ];
    [likesAmountLabel release];
    
    UILabel *locationLabel = [UILabel new];
    locationLabel.numberOfLines = 0;
    locationLabel.text = self.model.location;
    if (locationLabel.text) {
        [locationLabel setHidden:NO];
    } else {
        [locationLabel setHidden:YES];
    }
    locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    locationLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.detailsStackView addArrangedSubview:userNameLabel];
    [self.detailsStackView addArrangedSubview:dateLabel];
    [self.detailsStackView addArrangedSubview:likesView];
    [self.detailsStackView addArrangedSubview:locationLabel];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [userNameLabel.widthAnchor constraintEqualToAnchor:self.detailsStackView.widthAnchor],
                                              [dateLabel.widthAnchor constraintEqualToAnchor:self.detailsStackView.widthAnchor],
                                              [locationLabel.widthAnchor constraintEqualToAnchor:self.detailsStackView.widthAnchor],
                                              ]
     ];
    
    [userNameLabel release];
    [dateLabel release];
    [likesView release];
    [locationLabel release];
}

- (void) setupStackViews {
    self.imageStackView = [[UIStackView new] autorelease];
    self.imageStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.imageStackView];
    
    [self.imageStackView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.imageStackView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.imageStackView.axis = UILayoutConstraintAxisVertical;
    self.imageStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.imageStackView.alignment = UIStackViewAlignmentCenter;
    self.imageStackView.spacing = 5;
    
    self.detailsStackView = [[UIStackView new] autorelease];
    self.detailsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.detailsStackView];
    
    
    [self.detailsStackView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.detailsStackView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.detailsStackView.axis = UILayoutConstraintAxisVertical;
    self.detailsStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.detailsStackView.alignment = UIStackViewAlignmentCenter;
    self.detailsStackView.spacing = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self makeStackViewCompact];
    } else {
        [self makeStackViewsRegular];
    }
}

- (void)edit {
    EditImageViewController *editImageViewController = [EditImageViewController new];
    editImageViewController.imageToEdit = self.model.image;
    editImageViewController.imageId = self.model.imageId;
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:editImageViewController animated:NO];
    [editImageViewController release];
}

- (void)makeStackViewsRegular {
    [self.imageStackView removeParentConstraints];
    [self.detailsStackView removeParentConstraints];

    [NSLayoutConstraint activateConstraints:@[
        [self.imageStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.imageStackView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.8],
        [self.imageStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.detailsStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.detailsStackView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.2],
        [self.detailsStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:14],
        [self.detailsStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-14]
    ]
    ];
}

- (void)makeStackViewCompact {
    [self.imageStackView removeParentConstraints];
    [self.detailsStackView removeParentConstraints];

    [NSLayoutConstraint activateConstraints:@[
        [self.imageStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.imageStackView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.8],
        [self.imageStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]
    ];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.detailsStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.detailsStackView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.2],
        [self.detailsStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.detailsStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
             [self makeStackViewCompact];
         } else {
             [self makeStackViewsRegular];
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)dealloc {
    self.model = nil;
    self.imageStackView = nil;
    self.detailsStackView = nil;
    [super dealloc];
}

@end
