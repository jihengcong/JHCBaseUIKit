//
//  JHCButtonUtil.h
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHCButtonTitleType)
{
    JHCButtonTitleType_Default  =  0, // 常态
    JHCButtonTitleType_Left,   // 文字靠左
    JHCButtonTitleType_Right   // 文字靠右
};


@interface JHCButtonUtil : UIButton


@property (nonatomic, assign) JHCButtonTitleType titleType;


/**
 * 创建文字button
 **/
+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame buttonTitle:(NSString *_Nullable)buttonTitle titleFont:(UIFont *_Nullable)titleFont titleColor:(UIColor *_Nullable)titleColor backgroundColor:(UIColor * _Nullable)backColor;

/**
* 根据图片名称创建button
**/
+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame buttonNormalImage:(NSString *_Nullable)normalImageName buttonSelectedImage:(NSString *_Nullable)selectedImageName backgroundColor:(UIColor * _Nullable)backColor;

/**
* 根据图片创建button
**/
+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame normalImage:(UIImage *_Nullable)normalImage selectedImage:(UIImage *_Nullable)selectedImage backgroundColor:(UIColor * _Nullable)backColor;

// 设置左边文字，右边图片
- (void)resetButtonWithLeftTitleRightImage;

// 设置左边图片，右边文字
- (void)resetButtonWithLeftImageRightTitle;

// 设置上边图片, 下边文字
- (void)resetButtonWithUpImageDownTitle;
// alignment: 0-center, 1-left, 2-right
- (void)resetButtonWithUpImageDownTitleWithContentAlignment:(NSInteger)alignment;


@end

NS_ASSUME_NONNULL_END
