//
//  LoginViewController.m
//  UserLogin
//
//  Created by 曾晓江 on 16/4/11.
//  Copyright © 2016年 JayZ. All rights reserved.
//

#import "LoginViewController.h"
#import "Define.h"
#import <SVProgressHUD.h>

@interface LoginViewController (){
    int _offset;
    BOOL _hasMoveView;
}

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) UITextField *currentTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initProcessView];
    [self initLoginView];

}

- (void)viewWillAppear:(BOOL)animated{
    [self addKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark - Init Process Alert view
-(void)initProcessView{
     //setDefaultStyle设置为SVProgressHUDStyleCustom时，setBackgroundColor和setForegroundColor才有效
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - Init Login View Style
-(void)initLoginView{
    
    //set navigationBar style
    [self setNavigationBarStyle];
    
    //set login view style
    [self setLoginViewStyle];
    
    //set login button corner radius.
    [self setLoginBtnStyle];
    
    //[self addTextFieldDidChangeListener];
    
    //set textfield delegate
    self.txtAccount.delegate = self;
    self.txtPassword.delegate = self;
}

-(void)setTextFieldLeftView:(UITextField*)object leftView:(CGRect) imgRect image:(NSString*)name backgroundView:(CGRect) bgRect{
    //创建UIImageView
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    
    //设置UIImageView的(x, y, width, height)
    imageView.alpha = 0.5f;
    imageView.frame = imgRect;
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:bgRect];
    [bgView addSubview:imageView];
    
    [object setLeftViewMode:UITextFieldViewModeAlways];
    [object setLeftView:bgView];

}

-(void)setLoginViewStyle{
    //set login view style.
    [self.loginView setBackgroundColor:[UIColor whiteColor]];
    //[[self.loginView layer] setCornerRadius:4];
    [[self.loginView layer] setMasksToBounds:YES];
    [[self.loginView layer] setBorderWidth:0.6f];
    //[[self.loginView layer] setBorderColor:[UIColor grayColor].CGColor];
    CGColorRef borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    [[self.loginView layer] setBorderColor:borderColor];
    
    [self setTextFieldLeftView:self.txtAccount leftView:CGRectMake(2,3,20,22) image:@"user" backgroundView:CGRectMake(0, 0, 35, 30)];
    [self setTextFieldLeftView:self.txtPassword leftView:CGRectMake(0,0,25,25) image:@"lock" backgroundView:CGRectMake(0, 0, 35, 30)];
    
    //self.loginView.layer.cornerRadius = 4.0f;
    //self.loginView.layer.borderWidth = 1.5f;
    //self.loginView.layer.borderColor = [UIColor grayColor].CGColor;

}

-(void)setLoginBtnStyle{
    self.btnLogin.layer.cornerRadius = 5.0f;
}

-(void)setNavigationBarStyle {
//    //设置navigationBar title 颜色
//    UIColor * color = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
//    method 1:
//    NSDictionary* dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    
//    method 2:
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
//    
//    method 3:
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
    
    
    //NavigationBar title字体、大小及颜色
    //UIFont *font = [UIFont fontWithName:@"Heiti SC" size:20 ];
    //UIColor *color = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];

    UIFont *font = [UIFont systemFontOfSize:18];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    //设置NavigationBar背景颜色
    UIColor *bgColor = UIColorFromRGB(0xC00000); //UIColorFromRGB 是自己定义的宏
    [[UINavigationBar appearance] setBarTintColor:bgColor];
    
    //设置backBarButtonItem
    //隐藏backBarButtonItem 文字，只显示<
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    //自定义返回按钮颜色
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

#pragma mark - Keyboard Events
-(void)addKeyboardObserver{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    int keyboardHeight = keyboardRect.size.height;
    NSLog(@"键盘高度是  %d", keyboardHeight);
    
    // Get animation info from userInfo
    CGRect loginViewFrame = self.loginView.frame;
    
    //计算偏移量
    _offset = self.view.frame.size.height - keyboardHeight - (loginViewFrame.origin.y + loginViewFrame.size.height + 10);
    NSLog(@"offset: %d", _offset);
    
    if (_offset < 0 && !_hasMoveView) {
        _hasMoveView = YES;
        CGRect frame = self.view.frame;
        frame.origin.y = _offset;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.view.frame = frame;
                         }];
    }
    
}

//当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _hasMoveView = NO;
    
    CGRect inputFrame = self.view.frame;
    
    if (_offset<0) {
        inputFrame.origin.y = 0;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.view.frame = inputFrame;
                         }];
    }
   
}

//#pragma mark - Listen TextField Events
//no need now.
//-(void) textFieldDidChange:(UITextField*) textField{
//    NSLog(@"TextFiled changed: %@", textField.text);
//}
//
//-(void) addTextFieldDidChangeListener{
//    [self.txtAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.txtPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//}



#pragma mark - Process Events
-(void) textFieldDidChange:(UITextField*) textField{
    NSLog(@"TextFiled changed: %@", textField.text);
    NSString* account = [self.txtAccount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* pwd = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![account isEqualToString:@""] && ![pwd isEqualToString:@""]) {
        self.btnLogin.layer.backgroundColor = [UIColor colorWithRed:210/255.0 green:40/255.0 blue:40/255.0 alpha:0.9].CGColor;
    }else{
        self.btnLogin.layer.backgroundColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1].CGColor;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan!!!");
    
    if (self.currentTextField != nil && ![self.currentTextField isExclusiveTouch]) {
        [self.currentTextField resignFirstResponder];
    }
}
    
- (IBAction)onCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"点击Cancel按钮，关闭模态视图");
    }];
}

- (IBAction)onTxtAccountEditingChanged:(id)sender {
    //UITextField* curTextField = (UITextField*)sender;
    //NSLog(@"Account textFiled changed: %@", curTextField.text);
    [self textFieldDidChange:(UITextField*)sender];
}

- (IBAction)onTxtPwdEditingChanged:(id)sender {
    //UITextField* curTextField = (UITextField*)sender;
    //NSLog(@"Password textFiled changed: %@", curTextField.text);
    [self textFieldDidChange:(UITextField*)sender];
}

- (IBAction)onLoginClicked:(id)sender {
    //closed keyboard
    if (self.currentTextField != nil && ![self.currentTextField isExclusiveTouch]) {
        [self.currentTextField resignFirstResponder];
    }
    
    [SVProgressHUD showWithStatus:@"登录中......"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        [NSThread sleepForTimeInterval:3.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}


#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldDidBeginEditing");
    self.currentTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldDidEndEditing");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldShouldReturn");

    if (textField == self.txtAccount) {
        [self.txtPassword becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Helpful methods
//no need now.
-(void)moveView:(CGRect)frame animationDuration:(NSTimeInterval)intervial
{
    NSTimeInterval animationDuration = intervial;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = frame;
    
    [UIView commitAnimations];
}


@end
