//
//  JHCCollectionFlowLayout.h
//  DataFactory
//
//  Created by 冀恒聪 on 2022/1/5.
//  Copyright © 2022 京东到家. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@protocol JHCCollectionFlowLayoutDelegate <NSObject>

// 获取item宽度
- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JHCCollectionFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <JHCCollectionFlowLayoutDelegate> delegate;
@property (nonatomic, assign) CGFloat layoutWidth; // 视图宽
@property (nonatomic, assign) BOOL autoContentSize; // 是否自适应collection大小,默认NO
@property (nonatomic, assign) CGFloat customHeight; // item自定义高

@end

NS_ASSUME_NONNULL_END
