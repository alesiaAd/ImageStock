//
//  FilterModel.h
//  Image Stock
//
//  Created by Alesia Adereyko on 26/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FilterModel : NSObject

@property (nonatomic, retain) NSString *filterNameForLabel;
@property (nonatomic, retain) NSString *filterNameForMethod;
@property (nonatomic, retain) UIImage *filterImage;

@end
