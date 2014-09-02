//
//  DetailViewController.m
//  RichPhoto
//
//  Created by 吴福虎 on 14-9-1.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "DetailViewController.h"
#import "GesturePasswordController.h"
#import "UIImage+ResizableImage.h"


@interface DetailViewController ()<GesturePasswordVcDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *_libraryPicker;

}
@property (strong, nonatomic) UIButton      *btn_setting;
@property (strong, nonatomic) UIButton      *btn_back;
@property (strong, nonatomic) UIImageView   *iv_avatar;
@property (strong, nonatomic) UISwitch      *gesturePWSwitch;

@end

@implementation DetailViewController

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
    
    self.btn_setting = ({
        
        UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
        [setting setFrame:CGRectMake(320 - 90, 20, 70, 44)];
        [setting setTitle:@"设置手势密码" forState:0];
        [setting.layer setBorderWidth:1.0];
        [setting addTarget:self action:@selector(moreSetting:) forControlEvents:UIControlEventTouchUpInside];
        [setting.layer setBorderColor:RGB(63, 107, 252, 1.0).CGColor];
        [setting setTitleColor:RGB(63, 107, 252, 1.0) forState:0];
        setting.backgroundColor = RGB(255, 255,255, 1.0);
        setting.titleLabel.font = Font(11);
        setting.layer.cornerRadius = 5;
        
      
        if ([RP_CommonObj checkHasGesturePassWord]) {
            
            [setting setTitle:@"修改手势密码" forState:0];
            
        }else{
            //DO NOTHING
        }
        
        setting;
    });
    [self.view addSubview:_btn_setting];
    
    
    self.btn_back = ({
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setFrame:CGRectMake(20, 20, 44, 44)];
        [back setTitle:@"返回" forState:0];
        [back.layer setBorderWidth:1.0];
        [back setTitleColor:[UIColor blackColor] forState:0];
        [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [back.layer setBorderColor:RGB(63, 107, 252, 1.0).CGColor];
        [back setTitleColor:RGB(63, 107, 252, 1.0) forState:0];
        back.backgroundColor = RGB(255, 255,255, 1.0);
        back.titleLabel.font = Font(14);
        back.layer.cornerRadius = 5;
        
        back;
    });
    [self.view addSubview:_btn_back];
    
    
    self.gesturePWSwitch = ({
        
        UISwitch * gestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 84, 0, 0)];
        [gestureSwitch addTarget:self action:@selector(changeGesPW) forControlEvents:UIControlEventValueChanged];
        gestureSwitch.tintColor = RGB(63, 107, 252, 1.0);
        
        if ([RP_CommonObj checkLockisSetting]) {
            
            gestureSwitch.on = YES;
            
        }else{
            
            gestureSwitch.on = NO;
        }
        
        gestureSwitch;
        
       
    });
    
    [self.view addSubview:_gesturePWSwitch];
    
    _iv_avatar = [[UIImageView alloc] init];
    [_iv_avatar setFrame:CGRectMake(115, 50, 90, 90)];
    _iv_avatar.userInteractionEnabled = YES;
    [_iv_avatar setImage:[UIImage imageNamed:@"login_avatar" resizableDefault:YES]];
    [self.view addSubview:_iv_avatar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    [_iv_avatar addGestureRecognizer:tap];
    
}

#pragma mark - setting
- (void)moreSetting:(UIButton *)sender
{
    GesturePasswordController *gesturePW = [[GesturePasswordController alloc] initWithType:SettingType];
    gesturePW.delegate = self;
    [self presentViewController:gesturePW animated:YES completion:NULL];
}

#pragma mark - gesturepassword
- (void)changeGesPW
{
    if (_gesturePWSwitch.on == NO) {
        //关
        [RP_CommonObj settingLock:NO];

    }else{
        //开
        [RP_CommonObj settingLock:YES];
    }
}

#pragma mark - back
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -GesturePasswordVcDelegate
- (void)changeDetailBtnState
{
    [_btn_setting setTitle:@"修改手势密码" forState:0];
    
}

#pragma mark - 修改头像
- (void)changeAvatar
{
    DLog(@"修改头像");
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
}

#pragma mark - actionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"buttonIndex = %d",buttonIndex);
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            _libraryPicker = [[UIImagePickerController alloc] init];
            _libraryPicker.delegate = self;
            _libraryPicker.allowsEditing = NO;
            _libraryPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_libraryPicker animated:YES completion:NULL];
           
        }
        //拍照
    }else if (buttonIndex == 1){
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            _libraryPicker = [[UIImagePickerController alloc] init];
            _libraryPicker.delegate = self;
            _libraryPicker.allowsEditing = NO;
            _libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_libraryPicker animated:YES completion:NULL];
           
        }
        //相册
    }else{
        //do nothing
    }
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage = [UIImage processWithImageFilterType:MonochromeType usingImage:gotImage];
}
@end
