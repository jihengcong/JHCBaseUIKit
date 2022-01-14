//
//  JHCTextFieldUtil.h
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCLabelUtil.h"
#import "JHCButtonUtil.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCTextFieldType)
{
    JHCTextFieldType_Normal   = 0, // 正常
    JHCTextFieldType_RightView_AddAndDec,    // 右视图是加减号
    JHCTextFieldType_RightView_Text,   // 右视图是文字
    JHCTextFieldType_RightView_Arrow  // 右视图是下拉箭头
};


@interface JHCTextFieldUtil : UITextField

/*
已知bug:设置maxCharactersLength或者maxTextLength大于0，如果输入达到最大限制，虽然可以输入，但是快速点击键盘，会替换最后一个字符串
默认都不能输入特殊字符
*/

/**
 【1-001】是否当编辑的时候显示clearButton 默认为yes
 */
@property(nonatomic,assign)BOOL isClearWhileEditing;
/**
 【1-002】是否可以输入特殊字符 （默认YES，即可以输入）
 */
@property(nonatomic,assign)BOOL isSpecialCharacter;
/**
 【1-003】可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】
 只有当isSpecialCharacter为NO时，有效
 */
@property(nonatomic,strong)NSArray<NSString *> *canInputCharacters;
/**
 【1-004】不可以输入的字符串数组 【全局限制，没有前提条件】
 */
@property(nonatomic,strong)NSArray<NSString *> *canotInputCharacters;
/**
 【1-005】是否只能输入数字,默认为NO，
 */
@property(nonatomic,assign)BOOL isOnlyNumber;
/**
 【1-006】最多纯数字个数，比如手机11位，商品条码13位等 【
 设置了maxNumberCount,就默认 isOnlyNumber = YES
 */
@property(nonatomic,assign)NSInteger maxNumberCount;
/**
 【1-007】是否是手机号码
 设置了isPhoneNumber,就默认 isOnlyNumber = YES && maxNumberCount == 11 ,此时maxTextLength和maxCharactersLength无效
 */
@property(nonatomic,assign)BOOL isPhoneNumber;

/**
 【1-008】价格(只有一个"."，小数点后保留2位小数)
 首位不能输入.
 首位输入0，第二位不是.，会自动补充
 如果isPrice==YES,则isOnlyNumber=No,即使isOnlyNumber设置为YES也没用,此时canotInputCharacters无效
  如果isPrice==YES, 默认小数位为2两位，如果特殊设置，使用priceDigitNum
 */
@property(nonatomic,assign)BOOL isPrice;
@property (nonatomic, assign) NSInteger priceDigitNum; // 价格的小数点位数
/**
 【1-009】价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES
 设置了isPriceHeaderPoint,则isPrice = YES,此时canotInputCharacters无效
 */
@property(nonatomic,assign)BOOL isPriceHeaderPoint;

/** 输入的整数部分的最长位数 */
@property (nonatomic,assign) NSInteger  maxPriceCount;
/**
 【1-010】是不是密码 （默认只能字母和数字）
 */
@property(nonatomic,assign)BOOL isPassword;
/**
 【1-011】密码可以输入的字符串数组  【只有当isPassword为YES时，有效 】
 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】
 */
@property(nonatomic,strong)NSArray<NSString *> *canInputPasswords;
/**
 【1-012】tf.text最大长度（不考虑中英文）
 */
@property(nonatomic,assign)NSInteger maxTextLength;
/**
 【1-013】字符串最大长度（一个中文2个字符，一个英文1个字符【中文输入法下的都算中文】）
 */
@property(nonatomic,assign)NSInteger maxCharactersLength;

/**
 输入框是否可以编辑, 默认YES
 */
@property (nonatomic, assign) BOOL isEditingEnabled;

//---JHCTextFieldUtil Block回调---

/**
 【2-001】文本框字符变动，回调block【实时监测tf的文字】
 */
@property(nonatomic,copy)void(^textFieldTextChangedBlock)(JHCTextFieldUtil *textField);

/**
 【2-002】结束编辑or失去第一响应，回调block
 */
@property(nonatomic,copy)void(^textFieldBeginEditBlock)(JHCTextFieldUtil *textField);

/**
 【2-002】结束编辑or失去第一响应，回调block
 */
@property(nonatomic,copy)void(^textFieldEndEditBlock)(JHCTextFieldUtil *textField);
/**
 【2-003】键盘右下角returnType点击
 */
@property(nonatomic,copy)void(^textFieldReturnTypeBlock)(JHCTextFieldUtil *textField);

/**
 【2-004】设置文本框输入的左右距离
 */
@property (nonatomic, assign) CGFloat leftMargin;

@property (nonatomic, strong) JHCLabelUtil *leftLabel;
@property (nonatomic, strong) JHCLabelUtil *rightLabel;
@property (nonatomic, strong) JHCButtonUtil *addButton;
@property (nonatomic, strong) JHCButtonUtil *decButton;
@property (nonatomic, strong) JHCButtonUtil *rightButton;

/**
 * 创建textField
 **/
+ (JHCTextFieldUtil *)createTextFieldWithFrame:(CGRect)frame
                                  placeHolder:(NSString * _Nullable)placeHolder
                                    titleFont:(UIFont * _Nullable)titleFont
                                   titleColor:(UIColor * _Nullable)titleColor
                              backgroundColor:(UIColor * _Nullable)backColor;


/**
 * 创建textField, 带右视图
 **/
+ (JHCTextFieldUtil *)createTextFieldWithFrame:(CGRect)frame
                                   placeHolder:(NSString * _Nullable)placeHolder
                                     titleFont:(UIFont * _Nullable)titleFont
                                    titleColor:(UIColor * _Nullable)titleColor
                               backgroundColor:(UIColor * _Nullable)backColor
                                  textFieldType:(JHCTextFieldType)type;

@end

NS_ASSUME_NONNULL_END
