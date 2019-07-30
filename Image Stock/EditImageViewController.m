//
//  EditImageViewController.m
//  Image Stock
//
//  Created by Alesia Adereyko on 25/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "EditImageViewController.h"
#import "EditCollectionViewCell.h"
#import <CoreImage/CoreImage.h>
#import "FilterModel.h"
#import "UIView+Extensions.h"

static NSString *cellReuseIdentifier = @"EditCollectionViewCell";

@interface EditImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSDictionary *filters;
@property (nonatomic, retain) NSMutableArray <FilterModel *> *models;
@property (nonatomic, retain) NSMutableArray *paths;
@property (nonatomic, strong) NSString *selectedFilterName;

@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    [self setupSubviews];
    
    self.filters = @{@"Process": @"CIPhotoEffectProcess", @"SepiaTone": @"CISepiaTone", @"Mono": @"CIPhotoEffectMono", @"Invert": @"CIColorInvert", @"Instant": @"CIPhotoEffectInstant"};
    self.models = [NSMutableArray new];
    for (NSString *key in self.filters) {
        FilterModel *model = [FilterModel new];
        model.filterNameForLabel = key;
        model.filterNameForMethod = self.filters[key];
        [self.models addObject:model];
        [model release];
    }
    [self.models release];
    
    self.paths = [[NSMutableArray new] autorelease];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"paths"]) {
        self.paths = [[[NSUserDefaults standardUserDefaults] objectForKey:@"paths"] mutableCopy];
    }
    self.selectedFilterName = @"";
}

- (void)setupSubviews {
    self.imageView = [[UIImageView new] autorelease];
    [self.view addSubview:self.imageView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = self.imageToEdit;
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout] autorelease];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [collectionViewFlowLayout release];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:EditCollectionViewCell.class forCellWithReuseIdentifier:cellReuseIdentifier];
}

- (void)save {
    NSString *fileName = [NSString stringWithFormat:@"%@-%@", self.imageId, self.selectedFilterName];
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self saveImage:self.imageView.image withFileName:fileName ofType:@"jpg" inDirectory:documentsDirectory];
    [self.paths addObject:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:self.paths forKey:@"paths"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(imageCopy, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (JPG)", extension);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (statusBarOrientation == UIInterfaceOrientationPortrait || statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self makeCompactConstraints];
    } else {
        [self makeRegularConstraints];
    }
}

- (void)makeRegularConstraints {
    [self.imageView removeParentConstraints];
    [self.collectionView removeParentConstraints];
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.imageView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.8],
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.2],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
}

- (void)makeCompactConstraints {
    [self.imageView removeParentConstraints];
    [self.collectionView removeParentConstraints];
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.8],
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]
    ];

    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.2],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
             [self makeCompactConstraints];
         } else {
             [self makeRegularConstraints];
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EditCollectionViewCell *cell = (EditCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    FilterModel *model = self.models[indexPath.item];
    if (!model.filterImage) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            model.filterImage = [self filterImage:self.imageToEdit withFilter:model.filterNameForMethod];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                cell.filterImageView.alpha = 0.0f;
                cell.filterImageView.image = model.filterImage;
                [UIView animateWithDuration:0.2 animations:^(void){
                    cell.filterImageView.alpha = 1.0f;
                }];
            });
        });
    }
    cell.filterImageView.image = model.filterImage;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    cell.filterNameLabel.attributedText=[[[NSAttributedString alloc]
                                          initWithString:model.filterNameForLabel
                                          attributes:@{
                                                       NSStrokeWidthAttributeName: @-5.0,
                                                       NSStrokeColorAttributeName:[UIColor blackColor],
                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                       NSFontAttributeName:[UIFont systemFontOfSize:20 weight: UIFontWeightBold],
                                                       NSParagraphStyleAttributeName:paragraphStyle
                                                       }
                                          ] autorelease];
    [paragraphStyle release];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UIImage *)filterImage:(UIImage *)image withFilter:(NSString *)filterName {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIImage *filterImage = [ciImage imageByApplyingFilter:filterName];
    UIImage *result = [self makeUIImageFromCIImage:filterImage];
    [ciImage release];
    return result;
}

- (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return uiImage;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterModel *model = self.models[indexPath.item];
    self.imageView.image = model.filterImage;
    self.selectedFilterName = model.filterNameForLabel;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (void)dealloc {
    self.imageToEdit = nil;
    self.imageId = nil;
    self.imageView = nil;
    self.collectionView = nil;
    self.filters = nil;
    self.models = nil;
    self.paths = nil;
    [super dealloc];
}

@end
