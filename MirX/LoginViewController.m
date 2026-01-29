//
//  LoginViewController.m
//  MirX
//
//  Created by OpenAI on 2026/01/28.
//

#import "LoginViewController.h"
#import "ViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackground];
    [self setupLoginControls];
}

- (void)setupBackground {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background"]];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.clipsToBounds = YES;
    self.backgroundView = backgroundView;

    [self.view addSubview:backgroundView];

    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
}

- (void)setupLoginControls {
    UITextField *accountField = [[UITextField alloc] init];
    accountField.translatesAutoresizingMaskIntoConstraints = NO;
    accountField.placeholder = @"输入账号";
    accountField.borderStyle = UITextBorderStyleRoundedRect;
    accountField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    accountField.textColor = [UIColor blackColor];
    accountField.returnKeyType = UIReturnKeyDone;
    accountField.delegate = self;
    accountField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    accountField.leftViewMode = UITextFieldViewModeAlways;
    self.accountField = accountField;

    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    enterButton.translatesAutoresizingMaskIntoConstraints = NO;
    [enterButton setTitle:@"进入游戏" forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterButton.backgroundColor = [[UIColor colorWithRed:0.20 green:0.55 blue:0.95 alpha:1.0] colorWithAlphaComponent:0.9];
    enterButton.layer.cornerRadius = 6.0;
    [enterButton addTarget:self action:@selector(handleEnterButton) forControlEvents:UIControlEventTouchUpInside];
    self.enterButton = enterButton;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[accountField, enterButton]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 16.0;

    [self.view addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:80.0],
        [stackView.widthAnchor constraintEqualToConstant:240.0],
        [accountField.heightAnchor constraintEqualToConstant:44.0],
        [enterButton.heightAnchor constraintEqualToConstant:44.0],
    ]];
}

- (void)handleEnterButton {
    [self.accountField resignFirstResponder];

    ViewController *viewController = [[ViewController alloc] init];
    viewController.accountName = self.accountField.text;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleEnterButton];
    return YES;
}

@end
