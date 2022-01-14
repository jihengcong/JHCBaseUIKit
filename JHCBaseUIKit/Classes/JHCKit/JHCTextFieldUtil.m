//
//  JHCTextFieldUtil.m
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "JHCTextFieldUtil.h"
#import "NSString+JHCTextField.h"

/*
只要方法：
法1> 主要用来判断可以不可以输入
法2> 处理超过规定后，截取想要的范围！

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

-(void)setupLimits:(NSString *)toBeString;

*/

#define kNumbersPeriod  @"0123456789."
#define kOnlyNumber  @"0123456789"
#define KOnlyCharacter @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define KCharacterNumber @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define NumbersWithDot     @"0123456789.\n"
#define NumbersWithoutDot  @"0123456789\n"

#define kColorPlaceholder [self colorWithHex:@"#cccccc"]
#define FONT_BOLD(size)  [UIFont boldSystemFontOfSize:size]
#define FONT_THIN(size)  [UIFont systemFontOfSize:size]

#define PFFONT_BOLD(fontSize)  [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]
#define PFFONT_THIN(fontSize)  [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]


static JHCTextFieldType _textFieldType = JHCTextFieldType_Normal;

@implementation JHCTextFieldUtil

+ (UIColor *) colorWithHex:(NSString *)hexColor
{
    return [self colorWithHex:hexColor withAlpha:1.0f];
}

+ (UIColor *) colorWithHex:(NSString *)hexColor withAlpha:(CGFloat)alpha
{
    
    if (hexColor == nil || hexColor.length == 0) {
        return [UIColor whiteColor];
    }
    
    if (![hexColor containsString:@"#"]) {
        NSMutableString *tmpString = [[NSMutableString alloc]initWithFormat:@"%@", hexColor];
        [tmpString insertString:@"#" atIndex:0];
        hexColor =  [NSString stringWithString:tmpString];
    }
    
    if ([hexColor length] < 7 ) {
        return [UIColor whiteColor];
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}


+ (JHCTextFieldUtil *)createTextFieldWithFrame:(CGRect)frame placeHolder:(NSString * _Nullable)placeHolder titleFont:(UIFont * _Nullable)titleFont titleColor:(UIColor * _Nullable)titleColor backgroundColor:(UIColor * _Nullable)backColor
{
    JHCTextFieldUtil *textField = [[JHCTextFieldUtil alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.font = titleFont;
    textField.textColor = titleColor;
    textField.backgroundColor = backColor;
    textField.isEditingEnabled = YES;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    if (placeHolder.length > 0) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes: @{NSForegroundColorAttributeName:kColorPlaceholder, NSFontAttributeName:titleFont}];
    }
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

+ (JHCTextFieldUtil *)createTextFieldWithFrame:(CGRect)frame
                                   placeHolder:(NSString * _Nullable)placeHolder
                                     titleFont:(UIFont * _Nullable)titleFont
                                    titleColor:(UIColor * _Nullable)titleColor
                               backgroundColor:(UIColor * _Nullable)backColor
                                 textFieldType:(JHCTextFieldType)type
{
    _textFieldType = type;
    JHCTextFieldUtil *textField = [self createTextFieldWithFrame:frame placeHolder:placeHolder titleFont:titleFont titleColor:titleColor backgroundColor:backColor];
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 2;
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    JHCLabelUtil *leftLabel = [JHCLabelUtil createLabelWithFrame:CGRectMake(0, 0, 10, 40) labelText:@"" textColor:textField.backgroundColor textFont:FONT_THIN(15) textAligment:NSTextAlignmentLeft];
    leftLabel.contentInset = UIEdgeInsetsMake(0, 5, 0, 0);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [leftView addSubview:leftLabel];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.leftLabel = leftLabel;
    
    switch (type) {
        case JHCTextFieldType_Normal:
            break;
        case JHCTextFieldType_RightView_Text:
            [self addTextRightViewWithTextField:textField];
            break;
        case JHCTextFieldType_RightView_AddAndDec:
            [self addAddAndDecRightViewWithTextField:textField];
            break;
        case JHCTextFieldType_RightView_Arrow:
            [self addArrowRightViewWithTextField:textField];
            break;
        default:
            break;
    }
    return textField;
}

+ (void)addArrowRightViewWithTextField:(JHCTextFieldUtil *)textField
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    JHCButtonUtil *rightButton = [JHCButtonUtil createButtonWithFrame:CGRectMake(0, 0, 40, 30) buttonNormalImage:@"eye_off" buttonSelectedImage:@"eye_on" backgroundColor:textField.backgroundColor];
    rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:rightButton];
    textField.rightView = view;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    textField.rightButton = rightButton;
}

// 添加右视图视图
+ (void)addTextRightViewWithTextField:(JHCTextFieldUtil *)textField
{
    JHCLabelUtil *rightLabel = [JHCLabelUtil createLabelWithFrame:CGRectMake(0, 0, 50, 40) labelText:@"--" textColor:kColorPlaceholder textFont:FONT_THIN(12) textAligment:NSTextAlignmentRight];
    rightLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 5);
    textField.rightView = rightLabel;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    textField.rightLabel = rightLabel;
}

// 添加右视图视图
+ (void)addAddAndDecRightViewWithTextField:(JHCTextFieldUtil *)textField
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64.5, 40)];
    JHCButtonUtil *addButton = [JHCButtonUtil createButtonWithFrame:CGRectMake(32.5, 0, 32, 40) buttonNormalImage:@"trade_add" buttonSelectedImage:@"trade_add" backgroundColor:textField.backgroundColor];
    JHCButtonUtil *decButton = [JHCButtonUtil createButtonWithFrame:CGRectMake(0, 0, 32, 40) buttonNormalImage:@"trade_dec" buttonSelectedImage:@"trade_dec" backgroundColor:textField.backgroundColor];
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 40)];
//    leftLine.backgroundColor = NEC_Board_Main_Layer_Color;
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(32, 14, 0.5, 12)];
//    centerLine.backgroundColor = NEC_Board_Main_Layer_Color;
    [view addSubview:addButton];
    [view addSubview:decButton];
    [view addSubview:leftLine];
    [view addSubview:centerLine];
    textField.rightView = view;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    textField.addButton = addButton;
    textField.decButton = decButton;
}


-(void)configureJHCTextField
{
    self.delegate = (id<UITextFieldDelegate>)self;
    self.autocorrectionType = UITextAutocorrectionTypeNo;//不自动提示
    [self addTargetEditingChanged];
    [self setupDefaultConfigure];
    
}


// 控制文本的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _leftMargin, 0);
}

// 控制文本的位置，左
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _leftMargin, 0 );
}


#pragma mark --- 配置默认设置
-(void)setupDefaultConfigure
{
    _isOnlyNumber = NO;
    _isPriceHeaderPoint = NO;
    _priceDigitNum = 8;
//    _maxPriceCount = 20;
    
    //清楚按钮默认设置
    _isClearWhileEditing = YES;
    if (_isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    _isSpecialCharacter = YES;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureJHCTextField];
    }
    return self;
}
#pragma mark --- 支持xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self configureJHCTextField];
    }
    return self;
}

-(void)setIsClearWhileEditing:(BOOL)isClearWhileEditing
{
    _isClearWhileEditing = isClearWhileEditing;
    if (isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.clearButtonMode = UITextFieldViewModeNever;
    }
}
-(void)setIsSpecialCharacter:(BOOL)isSpecialCharacter
{
    _isSpecialCharacter = isSpecialCharacter;
}
-(void)setCanInputCharacters:(NSArray<NSString *> *)canInputCharacters
{
    //再次说明：当不可以输入特殊字符，但是特殊字符中的某个或某几个又是需要的时，所以前提是不可以输入特殊字符
    _canInputCharacters = canInputCharacters;
    [self setIsSpecialCharacter:NO];
    
}
-(void)setCanotInputCharacters:(NSArray<NSString *> *)canotInputCharacters
{
    _canotInputCharacters = canotInputCharacters;
}

-(void)setIsOnlyNumber:(BOOL)isOnlyNumber
{
    _isOnlyNumber = isOnlyNumber;
    _isSpecialCharacter = NO;
    if (_isOnlyNumber) {
        _isPrice = NO;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

-(void)setIsPrice:(BOOL)isPrice
{
    _isPrice = isPrice;
    _isSpecialCharacter = NO;
    if (_canotInputCharacters) {
        _canotInputCharacters = [NSArray array];
    }
    //防止冲突
    if (_isPrice) {
        _isOnlyNumber = NO;
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
}
-(void)setIsPriceHeaderPoint:(BOOL)isPriceHeaderPoint
{
    _isPriceHeaderPoint = isPriceHeaderPoint;
    [self setIsPrice:YES];
}
- (void)setPriceDigitNum:(NSInteger)priceDigitNum
{
    _priceDigitNum = priceDigitNum;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

#pragma mark --- 最大纯数字数量
-(void)setMaxNumberCount:(NSInteger)maxNumberCount
{
    _maxNumberCount = maxNumberCount;
    [self setIsOnlyNumber:YES];
}
#pragma mark ---  电话号码
-(void)setIsPhoneNumber:(BOOL)isPhoneNumber
{
    _isPhoneNumber = isPhoneNumber;
    [self setIsOnlyNumber:YES];
    [self setMaxNumberCount:11];
    
}
#pragma mark --- 是不是密码
-(void)setIsPassword:(BOOL)isPassword
{
    _isPassword = isPassword;
    self.secureTextEntry = YES;
    _isSpecialCharacter = NO;
}
-(void)setCanInputPassword:(NSArray<NSString *> *)canInputPasswords
{
    //再次说明：密码默认只能输入字母和数字，但有时又要可以输入某个或某些非字母或数字的字符，所以前提是（是输入密码）
    _canInputPasswords = canInputPasswords;
    [self setIsPassword:YES];
}

-(void)setMaxCharactersLength:(NSInteger)maxCharactersLength
{
    _maxCharactersLength = maxCharactersLength;
    //说明：maxCharactersLength和maxTextLength互斥，无论谁，都是要判断其值是否大于0，所以，其中一个大于0时，另一个就要为0
    if (_maxCharactersLength > 0) {
        _maxTextLength = 0;
    }
}
-(void)setMaxTextLength:(NSInteger)maxTextLength
{
    _maxTextLength = maxTextLength;
    if (_maxTextLength > 0) {
        _maxCharactersLength = 0;
    }
}

- (void)setMaxPriceCount:(NSInteger)maxPriceCount
{
    _maxPriceCount = maxPriceCount;
    [self setIsPrice:YES];
}

- (void)setIsEditingEnabled:(BOOL)isEditingEnabled
{
    _isEditingEnabled = isEditingEnabled;
}


//===================---☮☮☮UITextFieldDelegate☮☮☮---===================

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldReturnTypeBlock) {
        self.textFieldReturnTypeBlock(self);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //必须textFieldShouldEndEditing返回为YES
    if (self.textFieldEndEditBlock) {
        self.textFieldEndEditBlock(self);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.textFieldBeginEditBlock){
        self.textFieldBeginEditBlock(self);
    }
    return _isEditingEnabled;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //【注】此方法里面不需要根据字符串最大个数判断是否可以输入,截取方法里面用到，超过了就截取！！！
    
    //  判断输入的是否为数字 (只能输入数字)
    if (_isOnlyNumber) {
        //如果是数字了，但是该数字包含在数组canotInputCharacters里，同样不能输入
        if ([string isNSC:JHCTextFieldStringTypeNumber]) {
            if ([self.canotInputCharacters containsObject:string]) {
                return NO;
            }else{
                return YES;
            }
        }else{
            return NO;
        }
    }
    
    //密码
    if (_isPassword) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:KCharacterNumber] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            if ([self.canInputPasswords containsObject:string]) {
                return YES;
            }
            return NO;
        }else{
            return YES;
        }
    }
    //与_isSpecialCharacter互斥，所以此处必须写，要不走下面的_isSpecialCharacter的判断
    if (_isPrice) {
        return [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    //特殊字符 【一定要放在该方法最后一个判断，要不会影响哪些它互斥的设置】
    if (!_isSpecialCharacter) {
        if ([self.canInputCharacters containsObject:string] ||[self.canInputPasswords containsObject:string]) {
            return YES;
        }else{
            if ([string isSpecialLetter] || [self.canotInputCharacters containsObject:string]) {
                return NO;
            }
            return YES;
        }
    }
    return YES;
}
-(BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //参考：[UITextField 的限制输入金额(可为小数的正确金额)](http://www.cnblogs.com/fcug/p/5500349.html)

    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
       
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            /*
             [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
             
             在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
            if (range.location >= (_maxPriceCount > 0 ? _maxPriceCount : 20)) {
                if ([string isEqualToString:@"."] && range.location == (_maxPriceCount > 0 ? _maxPriceCount : 9)) {
                    return YES;
                }
                
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            if (range.location >= (_maxPriceCount > 0 ? _maxPriceCount : 20)) {
                if ([string isEqualToString:@"."] && range.location == (_maxPriceCount > 0 ? _maxPriceCount : 9)) {
                    return YES;
                }
                
            }
        }
        
        // 按cs分离出数组,数组按@""分离出字符串
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + _priceDigitNum) {
            return NO;
        }
        
    }
    
    return YES;
}


- (void)addTargetEditingChanged
{
    [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextEditingChanged:(id)sender
{
    
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }else{
        isChinese = true;
    }
    
    if(sender == self) {
        NSString *toBeString = self.text;
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                [self setupLimits:toBeString];
            }
        }else{
            [self setupLimits:toBeString];
        }
    }
    
    //所有都处理完了来回调
    if (self.textFieldTextChangedBlock) {
        self.textFieldTextChangedBlock(self);
    }
}

-(void)setupLimits:(NSString *)toBeString
{
    if (toBeString.length == 0) {
        return;
    }
    
    //价格 【return 不然的话会走（特殊字符处理），这样就把.去掉了】
    if (_isPrice) {
        self.text = toBeString;
        //价格要放在【特殊字符处理】前，并且不让再继续下去。
        return;
    }
    
    
    //特殊字符处理
    if (!_isSpecialCharacter) {
        NSMutableArray *filterArrs = [NSMutableArray arrayWithArray:self.canInputCharacters];
        //要处理
        if (_isPassword && self.canInputPasswords.count > 0) {
            [filterArrs addObjectsFromArray:self.canInputPasswords];
        }
        self.text = [toBeString removeSpecialLettersExceptLetters:filterArrs];

    }
    
    //纯数字限制：如果限制最大个数大于0，就配置_maxNumberCount，不允许多输入
    //☠要放在特殊字符处理后，因为放在前，走特殊字符时，toBeString并没有被裁剪，而self.text又=toBeString，所以放后面☠
    if (_isOnlyNumber) {
        if ([toBeString isNSC:JHCTextFieldStringTypeNumber]) {
            if (_maxNumberCount > 0) {
                if (toBeString.length > _maxNumberCount) {
                    self.text = [toBeString substringToIndex:_maxNumberCount];
                }else{
                    self.text = toBeString;
                }
            }
        }
    }
    
    //区分中英文
    if (_maxCharactersLength > 0) {
        if (!_isPhoneNumber) {  //电话号码时_maxCharactersLength无效
            int totalCountAll = [toBeString getStrLengthWithCh2En1];
            if (totalCountAll > _maxCharactersLength) {
                int totalCount = 0;
                for (int i = 0; i < toBeString.length; i++) {
                    NSString *str1 = [toBeString substringWithRange:NSMakeRange(i, 1)];
                    BOOL currentIsCN = [str1 isNSC:JHCTextFieldStringTypeChinese]; //当前字符是不是中文
                    if (currentIsCN) {
                        totalCount +=2;
                    }else{
                        totalCount +=1;
                    }
                    
                    //点击过快，会替换到最后一个字符串？？？为啥？？
                    if (totalCount > _maxCharactersLength) {
                        self.text = [toBeString substringToIndex:i];
                        return;
                    }
                }
            }
        }
        
    }
    
    //不区分中英文
    if (_maxTextLength > 0) {
        if (!_isPhoneNumber) {  //电话号码时_maxTextLength无效
            if (toBeString.length > _maxTextLength) {
                self.text = [toBeString substringToIndex:_maxTextLength];
            }
        }
        
    }
    
    
    
}

@end


