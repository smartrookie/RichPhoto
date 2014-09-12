//
//  TextInputViewController.m
//  RichImageDemo
//
//  Created by Gueie on 14-7-15.
//  Copyright (c) 2014年 Gueie. All rights reserved.
//

#import "TextInputViewController.h"

@interface TextInputViewController ()<UITextViewDelegate>
{
    UIButton *saveButton;
}

@end

@implementation TextInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 20, 70, 30)];
    [cancelButton setBackgroundColor:[UIColor redColor]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(70, 20, 70, 30)];
    [saveButton setBackgroundColor:[UIColor greenColor]];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setEnabled:NO];
    [self.view addSubview:saveButton];
    
    self.textInputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 75, self.view.bounds.size.width - 20, self.view.bounds.size.height - 75)];
    [self.textInputView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.textInputView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textInputView setDelegate:self];
    [self.view addSubview:self.textInputView];
}

- (void)cancel:(UIButton *)button
{
    [self.dot removeFromSuperview];
    [self.textInputView resignFirstResponder];
    [self.textInputView setText:@""];
    [self.styleView dismiss];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}

- (void)save:(UIButton *)button
{
//    [self.dot.textLabel setText:self.textInputView.text];
//    [self.dot displayDotContent:YES];
    
    [self.dot setDotText:self.textInputView.text];
    
    [self.textInputView resignFirstResponder];
    [self.textInputView setText:@""];
    
    [self.styleView dismiss];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [saveButton setEnabled:YES];
    } else {
        [saveButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
