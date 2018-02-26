//
//  YMRemindTitleViewController.m
//  Health
//
//  Created by 金朗泰晟 on 17/3/27.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "YMRemindTitleViewController.h"

@interface YMRemindTitleViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIView      *bgBtnView;
//@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, strong) UIButton    *clearButton;
@property (nonatomic, strong) NSArray     *titleArray;
@property (nonatomic, strong) NSArray     *imgArray;
@property (nonatomic, strong) NSMutableString    *titleStr;
@property (nonatomic, assign) NSInteger    titleCount;
@property (nonatomic, strong) UITextField *textFiled;


@end

@implementation YMRemindTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleArray = [NSArray arrayWithObjects:@"定时吃药",@"一天1次",@"一天2次",@"一天3次",@"感冒药",@"胃药",@"胰岛素",@"按时喝水", nil];
    self.imgArray = [NSArray arrayWithObjects:@"btn_drug",@"btn_one",@"btn_two",@"btn_three",@"btn_cold",@"btn_stomach",@"btn_insulin",@"btn_drink", nil];
    self.titleStr = [NSMutableString string];
    [self initUI];
}

- (void)initUI{
    self.navigationTitle = LOCALIZED(@"标题");
    
    DZXBarButtonItem *leftItem = [DZXBarButtonItem buttonWithImageNormal:IMGNAME(@"back") imageSelected:IMGNAME(@"back")];
    [leftItem addTarget:self action:@selector(leftItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    leftItem.exclusiveTouch = YES;
    self.navigationLeftButton = leftItem;
    
    DZXBarButtonItem *rightBarItem = [DZXBarButtonItem buttonWithTitle:LOCALIZED(@"保存")];
    [rightBarItem setTitleColor:COLOR_002 forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBarItem setExclusiveTouch:YES];
    self.navigationRightButton   = rightBarItem;
    
    [self bgView];
    [self textFiled];
//    [self bgBtnView];
    
}

- (void)setShowButtons:(BOOL)showButtons{

    _showButtons = showButtons;
    _showButtons = NO;
    self.bgBtnView.hidden = !_showButtons;
}

- (void)setRemindTitle:(NSString *)remindTitle{

    _remindTitle = remindTitle;
    if (_remindTitle.length > 0) {
        self.textFiled.text = _remindTitle;
    }
}

- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APPSCREEN_WIDTH,50 )];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
//        _bgView.layer.borderWidth = 1;
//        _bgView.layer.borderColor = COLOR_002.CGColor;
        [self.view addSubview:_bgView];
        
    }
    return _bgView;
}

//- (UILabel *)textLabel{
//    
//    if (!_textLabel) {
//        
//        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, APPSCREEN_WIDTH - 60,50 )];
//        _textLabel.textColor = [Tools hexStringToColor:@"183b7b"];
//        _textLabel.backgroundColor = [UIColor clearColor];
//        _textLabel.font = [UIFont systemFontOfSize:18];
//        [self.bgView addSubview:_textLabel];
//        
//        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *img = [UIImage imageNamed:@"regis_delete"];
//        _clearButton.size = img.size;
//        _clearButton.centerY = _textLabel.centerY;
//        _clearButton.right = APPSCREEN_WIDTH - 20 ;
//        [_clearButton setImage:[UIImage imageNamed:@"regis_delete"] forState:UIControlStateNormal];
//        [_clearButton setImage:[UIImage imageNamed:@"regis_delete"] forState:UIControlStateSelected];
//        [_clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
//        [self.bgView addSubview:_clearButton];
//        
//    }
//    return _textLabel;
//}


- (UITextField *)textFiled{
    
    if (!_textFiled) {
        
        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, APPSCREEN_WIDTH - 60,50 )];
        _textFiled.textColor = COLOR_002;//[Tools hexStringToColor:@"183b7b"];
        _textFiled.backgroundColor = [UIColor clearColor];
        _textFiled.font = [UIFont systemFontOfSize:18];
        _textFiled.text = self.remindTitle;
        _textFiled.delegate = self;
        [self.bgView addSubview:_textFiled];
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"regis_delete"];
        _clearButton.size = img.size;
        _clearButton.centerY = _textFiled.centerY;
        _clearButton.right = APPSCREEN_WIDTH - 20 ;
        [_clearButton setImage:[UIImage imageNamed:@"regis_delete"] forState:UIControlStateNormal];
        [_clearButton setImage:[UIImage imageNamed:@"regis_delete"] forState:UIControlStateSelected];
        [_clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_clearButton];
        
    }
    return _textFiled;
}


- (UIView *)bgBtnView{

    if (!_bgBtnView) {
        
        _bgBtnView = [[UIView alloc] initWithFrame:CGRectMake(20 * WIDTH_PROPORTION, self.bgView.bottom + 5, SCREEN_WIDTH - 40 * WIDTH_PROPORTION, 55)];
        _bgBtnView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgBtnView];
        
        for (NSInteger i = 0; i < self.imgArray.count; i++) {
            
            UIImage *img = IMGNAME(self.imgArray[i]);
            CGFloat space = (SCREEN_WIDTH - 40*WIDTH_PROPORTION - img.size.width * 4) /3.0;
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            imgView.origin = CGPointMake((img.size.width + space) * (i%4), (55 - img.size.height) * (i/4));
            imgView.tag = 100 + i;
            imgView.userInteractionEnabled = YES;
            [_bgBtnView addSubview:imgView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnDidClicked:)];
            [imgView addGestureRecognizer:tap];
        }
    }
    return _bgBtnView;
}

#pragma mark - actions

- (void)leftItemDidClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemDidClicked{
    if ([self.delegate respondsToSelector:@selector(remindTitleDidEdited:)]) {
        [self.delegate remindTitleDidEdited:self.textFiled.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clearText{
    
    self.textFiled.text = @"";
    
    if (self.showButtons) {
        self.titleCount = 0;
        NSRange range = NSMakeRange(0, self.titleStr.length);
        [self.titleStr deleteCharactersInRange:range];
    }
}

- (void)btnDidClicked:(UIGestureRecognizer *)tap{

    if (self.titleCount >= 3) {
        
        [HUDUtils showHUDToast:@"至多选择3项"];

        return;
    }
    self.titleCount ++;
    [self.titleStr appendString:self.titleArray[tap.view.tag - 100]];
    [self.titleStr appendString:@" "];
    self.textFiled.text = self.titleStr;
    
}

//12个字
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    if ([text length] >12) {
        [HUDUtils showHUDToast:@"至多12个字"];
    }
    return [text length] <=12;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
