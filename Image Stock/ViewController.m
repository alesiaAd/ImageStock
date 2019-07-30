//
//  ViewController.m
//  Image Stock
//
//  Created by Alesia Adereyko on 19/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "ImageCollectionViewCell.h"
#import "ImageModel.h"
#import "ImagesLayout.h"
#import "ImageDetailsViewController.h"
#import <WebKit/WebKit.h>
#import "GalleryViewController.h"

static NSString *cellReuseIdentifier = @"ImageCollectionViewCell";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NetworkManagerDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray <ImageModel *> *models;
@property (nonatomic, assign) NSInteger columnsCount;
@property (nonatomic, retain) NetworkManager *networkManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithTitle:@"Gallery" style:UIBarButtonItemStylePlain target:self action:@selector(pushToGallery)];
    self.navigationItem.leftBarButtonItem = galleryButton;
    [galleryButton release];
    
    [self countColumns];
    self.models = [[NSMutableArray new] autorelease];
    
    self.networkManager = [[NetworkManager new] autorelease];
    self.networkManager.delegate = self;
    
    [self loadImages];
    [self setCorrectLoginStatus];
    
    ImagesLayout *imagesLayout = [ImagesLayout new];
    self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:imagesLayout] autorelease];
    imagesLayout.models = self.models;
    imagesLayout.columnsCount = self.columnsCount;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
        ]
    ];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:ImageCollectionViewCell.class forCellWithReuseIdentifier:cellReuseIdentifier];
    
    [imagesLayout release];
}

- (void)pushToGallery {
    GalleryViewController *galleryViewController = [GalleryViewController new];
    [self.navigationController pushViewController:galleryViewController animated:YES];
    [galleryViewController release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) setCorrectLoginStatus {
    if ([self.networkManager isLoggedIn]) {
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logOutButton;
        [logOutButton release];
    } else {
        UIBarButtonItem *logInButton = [[UIBarButtonItem alloc] initWithTitle:@"Log in" style:UIBarButtonItemStylePlain target:self action:@selector(logIn)];
        self.navigationItem.rightBarButtonItem = logInButton;
        [logInButton release];
    }
}

- (void)logout {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records)
                         {
                             if ( [record.displayName containsString:@"unsplash"])
                             {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                            [self setCorrectLoginStatus];
                                                                        }];
                             }
                         }
                     }];
}

- (void)logIn {
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.networkManager.webview = [[[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration] autorelease];
    [self.networkManager authorize];
    [self.view addSubview:self.networkManager.webview];
    [theConfiguration release];
}

- (void)loadImages {
    [self.networkManager loadImageModels];
}

- (void)didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error occured" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        [self countColumns];
        ImagesLayout * layout = (ImagesLayout *)self.collectionView.collectionViewLayout;
        layout.columnsCount = self.columnsCount;
        [layout invalidateLayout];
        [self.collectionView layoutIfNeeded];        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)countColumns {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.columnsCount = 2;
    } else {
        self.columnsCount = 3;
    }
}

- (void)imageModelLoaded:(ImageModel *)model {
    [self.models addObject:model];
    [self.collectionView reloadData];    
}

- (void)loginCompleted:(NetworkManager *)manager {
    [manager.webview removeFromSuperview];
    [self setCorrectLoginStatus];
}


#pragma mark DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    ImageModel *model = self.models[indexPath.item];
    switch (model.status) {
        case LoadingProgressStatusNotLoaded: {
            cell.imageView.image = model.image;
            model.status = LoadingProgressStatusLoading;
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                NSURL *url = [NSURL URLWithString:model.url];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    //  no need to cache images in this scenario because images are always random. Gallery is kind of caching example.
                    model.image = image;
                    model.status = LoadingProgressStatusLoaded;
                }
                else {
                    model.status = LoadingProgressStatusError;
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.collectionView reloadData];
                });
            });
            break;
        }
        case LoadingProgressStatusLoading: {
            model.image = [UIImage imageNamed:@"loading"];
            break;
        }
        case LoadingProgressStatusLoaded: {
            break;
        }
        case LoadingProgressStatusError: {
            model.image = [UIImage imageNamed:@"error"];
            break;
        }
        default:
            break;
    }
    cell.imageView.image = model.image;
    if (indexPath.item == self.models.count - 3) {
        [self loadImages];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

#pragma mark Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageModel *model = self.models[indexPath.item];
    ImageDetailsViewController *imageDetailsViewController = [ImageDetailsViewController new];
    imageDetailsViewController.model = model;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:imageDetailsViewController animated:NO];
    [imageDetailsViewController release];
}

- (void)dealloc {
    self.collectionView = nil;
    self.models = nil;
    self.networkManager = nil;
    [super dealloc];
}

@end
