//
//  NSString+JHCTextField.h
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHCTextFieldStringType) {
    JHCTextFieldStringTypeNumber,         //数字
    JHCTextFieldStringTypeLetter,         //字母
    JHCTextFieldStringTypeChinese         //汉字
};

@interface NSString (JHCTextField)

/**
 某个字符串是不是数字、字母、汉字。
 */
- (BOOL)isNSC:(JHCTextFieldStringType)stringType;


/**
 字符串是不是特殊字符，此时的特殊字符就是：出数字、字母、汉字以外的。
 */
- (BOOL)isSpecialLetter;

/**
 获取字符串长度 【一个汉字算2个字符串，一个英文算1个字符串】
 */
- (int)getStrLengthWithCh2En1;

/**
 移除字符串中除exceptLetters外的所有特殊字符
 */
- (NSString *)removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters;

/**
 防止添加到容器中时为nil
 */
- (NSString *)isRealString;


@end

NS_ASSUME_NONNULL_END
