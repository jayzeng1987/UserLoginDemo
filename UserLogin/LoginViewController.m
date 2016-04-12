//
//  LoginViewController.m
//  UserLogin
//
//  Created by 曾晓江 on 16/4/11.
//  Copyright © 2016年 JayZ. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    int _keyboardHeight;
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
    [self addKeyboardObserver];
    [self initLoginView];
    
    self.txtAccount.delegate = self;
    self.txtPassword.delegate = self;
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

#pragma mark Login View Style
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

-(void)setLoginBtnStyle{
    self.btnLogin.layer.cornerRadius = 5.0f;
}

-(void)initLoginView{
    
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
    
    //set login button corner radius.
    [self setLoginBtnStyle];
    
    //[self addTextFieldDidChangeListener];
    
    //init navigation
    [self initNavigationBackButton];
}

-(void)initNavigationBackButton{
    //隐藏backBarButtonItem 文字，只显示<
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    //自定义返回按钮颜色
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

#pragma mark Keyboard Events
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
    
    _keyboardHeight = 253;
}

//当键盘出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    _keyboardHeight = height;
}

//当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

#pragma mark Listen TextField Events
//no need now.
//-(void) textFieldDidChange:(UITextField*) textField{
//    NSLog(@"TextFiled changed: %@", textField.text);
//}
//
//-(void) addTextFieldDidChangeListener{
//    [self.txtAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.txtPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//}



#pragma mark Process Events
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

#pragma mark TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldDidBeginEditing");
    self.currentTextField = textField;
    
    CGRect loginViewFrame = self.loginView.frame;
    int offset = self.view.frame.size.height - _keyboardHeight - (loginViewFrame.origin.y + loginViewFrame.size.height + 10);
    NSLog(@"offset : %d", offset);
    
    if(offset < 0){
        _hasMoveView = YES;
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldDidEndEditing");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"UITextField Delegate: textFieldShouldReturn");
    
    if (_hasMoveView) {
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    if (textField == self.txtAccount) {
        [self.txtPassword becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan!!!");
    [self.currentTextField resignFirstResponder];
}


@end
