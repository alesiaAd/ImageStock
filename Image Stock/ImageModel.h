//
//  ImageModel.h
//  Image Stock
//
//  Created by Alesia Adereyko on 20/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadingProgressStatus) {
    LoadingProgressStatusNotLoaded,
    LoadingProgressStatusLoading,
    LoadingProgressStatusLoaded,
    LoadingProgressStatusError
};

@interface ImageModel : NSObject

@property (nonatomic, assign) CGSize fullSize;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) LoadingProgressStatus status;
@property (nonatomic, retain) NSString *imgDescription;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, assign) NSInteger likesAmount;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *imageId;

@end
