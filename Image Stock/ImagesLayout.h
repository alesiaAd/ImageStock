//
//  ImagesLayout.h
//  Image Stock
//
//  Created by Alesia Adereyko on 20/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@interface ImagesLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnsCount;
@property (nonatomic, retain) NSArray <ImageModel *> *models;

@end
