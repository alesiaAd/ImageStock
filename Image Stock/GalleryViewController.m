//
//  GalleryViewController.m
//  Image Stock
//
//  Created by Alesia Adereyko on 27/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCollectionViewCell.h"

static NSString *cellReuseIdentifier = @"GalleryCollectionViewCell";

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *imagesArray;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout] autorelease];
    [collectionViewFlowLayout release];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]
    ];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.imagesArray = [NSMutableArray new];
    NSMutableArray *pathsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"paths"];
    for (NSString *path in pathsArray) {
        NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        UIImage * image = [self loadImageWithFileName:path ofType:@"jpg" inDirectory:documentsDirectory];
        [self.imagesArray addObject:image];
    }
    [self.imagesArray release];

    [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    [self.collectionView registerClass:GalleryCollectionViewCell.class forCellWithReuseIdentifier:cellReuseIdentifier];
}

-(UIImage *)loadImageWithFileName:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, [extension lowercaseString]]];
    return result;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.imagesArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 150);
}

- (void)dealloc {
    self.collectionView = nil;
    self.imagesArray = nil;
    [super dealloc];
}

@end
