//
//  E_ReaderViewController.m
//  E_Reader
//
//  Created by 吴福虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderViewController.h"
#import "E_ReaderView.h"
#import "E_CommonManager.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface E_ReaderViewController ()
{
    E_ReaderView *_readerView;
}
@property (nonatomic,strong) UIButton *smallFontButton;
@property (nonatomic,strong) UIButton *bigFontButton;
@end

@implementation E_ReaderViewController

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
   
    self.view.backgroundColor = [UIColor clearColor];
    _readerView = [[E_ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y, 320 - 2 * offSet_x, self.view.frame.size.height - offSet_y - 60)];
    [self.view addSubview:_readerView];
    
#warning todo -- 暂时写在这 根据需求变  按钮变字号
    
    _bigFontButton = [UIButton buttonWithType:0];
    [_bigFontButton setTitle:@"变大咯" forState:0];
    _bigFontButton.frame = CGRectMake(20, self.view.frame.size.height - 40, 100, 40);
    [self.view addSubview:_bigFontButton];
    _bigFontButton.backgroundColor = [UIColor redColor];
    [_bigFontButton addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    
    _smallFontButton = [UIButton buttonWithType:0];
    [_smallFontButton setTitle:@"变小咯" forState:0];
    _smallFontButton.frame = CGRectMake(200, self.view.frame.size.height - 40, 100, 40);
    [self.view addSubview:_smallFontButton];
    _smallFontButton.backgroundColor = [UIColor redColor];
    [_smallFontButton addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    
    

}

#pragma mark - 小
- (void)changeSmall
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        return;
    }
    fontSize--;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
}

- (void)changeBig
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        return;
    }
    fontSize++;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
}


- (void)updateFontButtons
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    self.bigFontButton.enabled = fontSize < MAX_FONT_SIZE;
    self.smallFontButton.enabled = fontSize > MIN_FONT_SIZE;
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
   
    [_readerView render];
}

- (NSUInteger )font
{
    return _readerView.font;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}
@end
