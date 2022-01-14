//
//  JHCButtonUtil.m
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "JHCButtonUtil.h"



#define kGap 6.f
#define  kImageNamed(a) [UIImage imageNamed:a]


@implementation JHCButtonUtil

/** 创建文字button **/
+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame buttonTitle:(NSString *_Nullable)buttonTitle titleFont:(UIFont *_Nullable)titleFont titleColor:(UIColor *_Nullable)titleColor backgroundColor:(UIColor * _Nullable)backColor
{
    JHCButtonUtil *button = [[JHCButtonUtil alloc] initWithFrame:buttonFrame];
    if (buttonTitle) [button setTitle:buttonTitle forState:UIControlStateNormal];
    if (titleColor) [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (backColor) [button setBackgroundColor:backColor];
    if (titleFont) {
        button.titleLabel.font = titleFont;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    
    return button;
}

/** 创建图片button **/
+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame buttonNormalImage:(NSString *_Nullable)normalImageName buttonSelectedImage:(NSString *_Nullable)selectedImageName backgroundColor:(UIColor * _Nullable)backColor
{
    JHCButtonUtil *button = [[JHCButtonUtil alloc] initWithFrame:buttonFrame];
    [button setBackgroundColor:backColor];
    if (normalImageName.length > 0) {
        [button setImage:kImageNamed(normalImageName) forState:UIControlStateNormal];
    }
    if (selectedImageName.length > 0) {
        [button setImage:kImageNamed(selectedImageName) forState:UIControlStateSelected];
    }
    return button;
}

+ (JHCButtonUtil *)createButtonWithFrame:(CGRect)buttonFrame normalImage:(UIImage *_Nullable)normalImage selectedImage:(UIImage *_Nullable)selectedImage backgroundColor:(UIColor * _Nullable)backColor
{
    JHCButtonUtil *button = [[JHCButtonUtil alloc] initWithFrame:buttonFrame];
    [button setBackgroundColor:backColor];
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    return button;
}


- (void)setTitleType:(JHCButtonTitleType)titleType
{
    _titleType = titleType;
    switch (titleType) {
        case JHCButtonTitleType_Left:
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        case JHCButtonTitleType_Right:
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        default:
            break;
    }
}

- (void)resetButtonWithLeftTitleRightImage
{
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width+kGap/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+kGap, 0, -self.titleLabel.bounds.size.width-kGap/2.0)];
    }
    else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width-kGap, 0, self.imageView.frame.size.width+kGap)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+kGap/2.0, 0, -self.titleLabel.bounds.size.width)];
    }
    else
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width-kGap/2.0, 0, self.imageView.frame.size.width+kGap/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+kGap/2.0, 0, -self.titleLabel.bounds.size.width-kGap/2.0)];
    }
}

// 设置左边图片，右边文字
- (void)resetButtonWithLeftImageRightTitle
{
    //使图片和文字水平靠左显示
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)resetButtonWithUpImageDownTitle
{
    //使图片和文字水平居中显示
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+kGap/2.0 ,-self.imageView.frame.size.width, 0.0, 0.0)];
    
    //图片距离右边框距离减少图片的宽度，其它不边
    [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-kGap/2.0, 0.0, 0.0, -self.titleLabel.bounds.size.width)];
}

// alignment: 0-center, 1-left, 2-right
- (void)resetButtonWithUpImageDownTitleWithContentAlignment:(NSInteger)alignment
{
    if (alignment == 0) {
        //使图片和文字水平居中显示
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+kGap/2.0, -self.imageView.frame.size.width, 0.0, 0.0)];
        
        //图片距离右边框距离减少图片的宽度，其它不边
        [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-kGap/2.0, 0.0, 0.0, -self.titleLabel.bounds.size.width/2.0)];
    } else if (alignment == 1) {
        //使图片和文字水平居中显示
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+kGap/2.0, -self.imageView.frame.size.width, 0.0, 0.0)];
        
        //图片距离右边框距离减少图片的宽度，其它不边
        [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-kGap/2.0, (self.titleLabel.bounds.size.width-self.imageView.frame.size.width)/2.0, 0.0, 0)];
    } else if (alignment == 2) {
        //使图片和文字水平居中显示
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+kGap/2.0, -self.imageView.frame.size.width, 0.0, 0.0)];
        
        //图片距离右边框距离减少图片的宽度，其它不边
        [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-kGap/2.0, 0.0, 0.0, self.imageView.frame.size.width/2.0-self.titleLabel.bounds.size.width)];
    }
}


@end
