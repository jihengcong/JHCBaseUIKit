//
//  NSString+JHCTextField.m
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "NSString+JHCTextField.h"

@implementation NSString (JHCTextField)

- (BOOL)isNSC:(JHCTextFieldStringType)stringType
{
    return [self matchRegularWith:stringType];
}
- (BOOL)isSpecialLetter
{
    if ([self isNSC:JHCTextFieldStringTypeNumber] || [self isNSC:JHCTextFieldStringTypeLetter] || [self isNSC:JHCTextFieldStringTypeChinese]) {
        return NO;
    }
    return YES;
}
#pragma mark --- 用正则判断条件
- (BOOL)matchRegularWith:(JHCTextFieldStringType)type
{
    NSString *regularStr = @"";
    switch (type) {
        case JHCTextFieldStringTypeNumber:      //数字
            regularStr = @"^[0-9]*$";
            break;
        case JHCTextFieldStringTypeLetter:      //字母
            regularStr = @"^[A-Za-z]+$";
            break;
        case JHCTextFieldStringTypeChinese:     //汉字
            regularStr = @"^[\u4e00-\u9fa5]{0,}$";
            break;
        default:
            break;
    }
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    if ([regextestA evaluateWithObject:self] == YES){
        return YES;
    }
    return NO;
}
- (int)getStrLengthWithCh2En1
{
    int strLength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strLength++;
        }else {
            p++;
        }
    }
    return strLength;
}

- (NSString *)removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters
{
    if (self.length > 0) {
        NSMutableString *resultStr = [[NSMutableString alloc]init];
        for (int i = 0; i<self.length; i++) {
            NSString *indexStr = [self substringWithRange:NSMakeRange(i, 1)];
            
            if (![indexStr isSpecialLetter] || (exceptLetters && [exceptLetters containsObject:indexStr])) {
                [resultStr appendString:indexStr];
            }
        }
        if (resultStr.length > 0) {
            return resultStr;
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

/**
 防止添加到容器中时为nil
 */
- (NSString *)isRealString
{
    if (!self) return @"";
    return self;
}

@end
