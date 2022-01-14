//
//  JHCCollectionFlowLayout.m
//  DataFactory
//
//  Created by 冀恒聪 on 2022/1/5.
//  Copyright © 2022 京东到家. All rights reserved.
//

#import "JHCCollectionFlowLayout.h"


#define kEstimatedItemSize CGSizeMake(45, 20)
//#define kEstimatedItemSize self.estimatedItemSize


@interface JHCCollectionFlowLayout ()

// 临时保存item的总宽度
@property (nonatomic, assign) CGFloat columnWidth;
// 记录一共有多少行
@property (nonatomic, assign) NSInteger columnNumber;
// 保存每一个item x y w h
@property (nonatomic, strong) NSMutableArray *arrForItemAtrributes;
// 保存item总数
@property (nonatomic, assign) NSUInteger numberOfItems;
// 保存每个item的X值
@property (nonatomic, assign) CGFloat xForItemOrigin;
// 保存每个item的Y值
@property (nonatomic, assign) CGFloat yForItemOrigin;
@property (nonatomic, assign) CGFloat maxWidth;
@end

@implementation JHCCollectionFlowLayout

// 准备布局
- (void)prepareLayout
{
    [super prepareLayout];
    //
    self.columnWidth = self.sectionInset.left;
    self.columnNumber = 0;
    self.arrForItemAtrributes = [NSMutableArray array];
    self.xForItemOrigin = self.sectionInset.left;
    self.yForItemOrigin = self.sectionInset.top;
    // 获取item的个数
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    /** 为每个item确定LayoutAttribute属性,同时将这些属性放入布局数组中 */
    for (int i = 0; i < self.numberOfItems; i++) {
        /** 确定每个Item的indexPath属性 */
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        /** 确定每个item的origin的x,y值 */
        /** 确定每个Item的frame属性,同时确定了每个Item的LayoutAttribute,放入到了布局属性数组中 */
        [self setFrame:indexPath];
    }
}

// 计算contentView的大小
- (CGSize)collectionViewContentSize
{
    // 获取collectionView的Size
    CGSize contentSize = self.collectionView.frame.size;
    // 最大高度+bottom
    CGFloat height = self.sectionInset.top + ((self.customHeight>0?self.customHeight:kEstimatedItemSize.height) * (self.columnNumber + 1)) + (self.minimumLineSpacing * self.columnNumber) + self.sectionInset.bottom;
    contentSize.height = height;
    contentSize.width = self.maxWidth;
    // 设置collectionView的大小自适应
    if (self.autoContentSize) {
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, contentSize.width, contentSize.height);
    }
    
    return contentSize;
}

// 返回每一个item的attribute
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 返回每一个item的Attribute
    return self.arrForItemAtrributes;
}

// 设置属性和frame
- (void)setFrame:(NSIndexPath *)indexPath
{
    // 设置Item LayoutAttribute 属性
    UICollectionViewLayoutAttributes *layoutArr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 获取item的宽
    CGFloat itemWidth = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:widthForItemAtIndexPath:)]) {
        // 使用代理方法获取item的宽
        itemWidth = [_delegate collectionView:self.collectionView widthForItemAtIndexPath:indexPath];
    }
    //之前item的宽总和 + 当前item的宽 + 间距 < 屏幕总宽
    if (self.columnWidth + itemWidth + self.minimumInteritemSpacing < self.layoutWidth) {
        // 设置x
        self.xForItemOrigin = self.columnWidth;
        self.columnWidth += itemWidth + self.minimumInteritemSpacing;
        if(self.maxWidth<self.columnWidth)
        {
            self.maxWidth = self.columnWidth;
        }
    } else {
        self.xForItemOrigin = self.sectionInset.left;
        // 如果宽度超过屏幕从新计算宽度
        self.columnWidth = self.sectionInset.left + itemWidth + self.minimumInteritemSpacing;
        self.columnNumber++;
    }
    // 计算是第几行 乘以高度
    self.yForItemOrigin = self.sectionInset.top + ((self.customHeight>0?self.customHeight:kEstimatedItemSize.height) + self.minimumLineSpacing) * self.columnNumber;
    // 设置frame
    layoutArr.frame = CGRectMake(self.xForItemOrigin, self.yForItemOrigin, itemWidth, (self.customHeight>0?self.customHeight:kEstimatedItemSize.height));
    // 放入数组
    [self.arrForItemAtrributes addObject:layoutArr];
}


@end
