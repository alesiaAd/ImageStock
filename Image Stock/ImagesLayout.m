//
//  ImagesLayout.m
//  Image Stock
//
//  Created by Alesia Adereyko on 20/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ImagesLayout.h"

static const CGFloat spacing = 10;

@interface ImagesLayout ()

@property (nonatomic, retain) NSMutableArray <UICollectionViewLayoutAttributes *> *imageItems;
@property (nonatomic, retain) NSMutableArray <NSNumber *> *columnsHeightsArray;

@end

@implementation ImagesLayout

- (CGSize) collectionViewContentSize {
    NSNumber *maxHeight = [self.columnsHeightsArray valueForKeyPath:@"@max.self"];
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight.floatValue);
}

- (void)prepareLayout {
    self.imageItems = [[NSMutableArray new] autorelease];
    self.columnsHeightsArray = [[NSMutableArray new] autorelease];
    for (int i = 0; i < self.columnsCount; i++) {
        NSNumber *height = @(0);
        [self.columnsHeightsArray addObject:height];
    }
    for (int i = 0; i < self.models.count; i++) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width = [self widthOfColumn];
        CGFloat height = [self heightOfColumn:i width:width];
        NSNumber *smallest = [self.columnsHeightsArray valueForKeyPath:@"@min.self"];
        for (int j = 0; j < self.columnsHeightsArray.count; j++) {
            if ([self.columnsHeightsArray[j] isEqualToNumber:smallest]) {
                y = self.columnsHeightsArray[j].floatValue + spacing;
                self.columnsHeightsArray[j] = [NSNumber numberWithFloat:(y + height)];
                x = (width + spacing) * j;
                break;
            }
        }
        attr.frame = CGRectMake(x, y, width, height);
        [self.imageItems addObject:attr];
    }
}

- (CGFloat)widthOfColumn {
    CGFloat width = (self.collectionView.bounds.size.width - (self.columnsCount - 1) * spacing) / (CGFloat)self.columnsCount;
    return width;
}

- (CGFloat)heightOfColumn:(NSInteger)index width:(CGFloat)width {
    CGFloat ratio = self.models[index].fullSize.width / width;
    CGFloat height = self.models[index].fullSize.height / ratio;
    return height;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.imageItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes * attr = (UICollectionViewLayoutAttributes *)object;
        return CGRectIntersectsRect(rect, attr.frame);
    }]];
}

- (void)dealloc {
    self.models = nil;
    self.imageItems = nil;
    self.columnsHeightsArray = nil;
    [super dealloc];
}

@end
