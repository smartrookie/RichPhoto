//
//  YMViewController.m
//  RichPhoto
//
//  Created by 吴福虎 on 14/10/24.
//  Copyright (c) 2014年 smart. All rights reserved.
//

#import "YMViewController.h"

#import "YMTextView.h"
#import "ILTableViewCell.h"

#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"

#define PlaceHolder @" "
#define offSet_X 10
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"

#define kContentText1 @"1.魔兽世界中有许多2837168未解之谜，虽然魔兽给我们带来一个[em:03:]庞大的18618151892故事和世界，也很健全的解释[em:03:]了历史，但是仍有许多谜留在了世界各地。这一期魔兽世界经典http://www.baidu.com 任务为大家带[em:02:]来月神的镰刀，带领你走进狼人的世界"

#define kContentText2 @"2.本人今年主要在负责猿题库iOS客户端的开发，本文旨在通过分享猿题库iOS客户端开发过程中的技术细节，达到总结和交流的目的。"

#define kContentText3 @"3.采用类似UItableview的委托形式，创建18618151892滚动的Banners效果控件本人今年主要在负责猿题库iOS客户端的开发，本文旨在通过分享猿题库iOS客户端开发过程中的技术细节，达到总结和交流的目的。"

#define kContentText4 @"4.我最近在忙着回归到过去测试代码的老路子，使用KIF和XCTest框架，这样会使得iOS中的测试变得简单。当我开始捣鼓KIF的时候，我用Swift写的应用出了点小问题，不过最终还是很机智的搞定了[em:03:]。在我写Swift的时候我还发现了不少Swift独有的模式，[em:02:]这是个令我相当愉快的事，所以我们可以拿来分享分享"

#define kContentText5 @"5.在这场盛大的“Apple China Party”上，Cook 谈了几件事。说真的如果你读完了这篇文章会发现会比那些所谓“xxxx 专访库克”的文章来得扎实紧凑得多http://www.baidu.com "

#define kContentText6 @"6.在手机本身的亮点已经几乎乏善可陈时，各厂商[em:03:]正试图通过提供更加完善的服务来提升品牌溢价，于是自打年中罗永浩的锤子手机推出意外保这一概念之后，各种受到18618888888官方认证的售后服务在行业内蔓延开来，不过说到官方售后支持，苹果一定是个绕不开的话题"



@interface YMViewController ()<UITableViewDataSource,UITableViewDelegate,ILCoretextDelegate>
{
    NSMutableArray *_dataArr;//原字符串数组
    
    NSMutableArray *_manageArr;//处理后的字符串数组，在viewcontroller里处理 （在view处理 会在tableview滑动时反复调用增加消耗）
    
    NSMutableArray *_matchedArr;//存储正则后的电话号码 以及 url的数组  数组元素为  key为NSRange（url或者电话号码的range） value为NSString的字典  对其中的每个元素扩展便可添加可点击并变色的文字类似 url 和电话号码
}

@end

@implementation YMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YMRichText";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    _manageArr = [[NSMutableArray alloc] initWithCapacity:0];
    _matchedArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    //数据源
    [_dataArr addObject:kContentText1];
    [_dataArr addObject:kContentText2];
    [_dataArr addObject:kContentText3];
    [_dataArr addObject:kContentText4];
    [_dataArr addObject:kContentText5];
    [_dataArr addObject:kContentText6];
    
    //********
    
    //处理以及正则字符串操作
    [self matchData:_dataArr];
    
    
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    
    
    //************************DEMO 2*************************
    
    //    YMTextView *ymT = [[YMTextView alloc] initWithFrame:CGRectMake(20, 50, 280, 0)];
    //    ymT.delegate = self;
    //    ymT.attributedData = [_matchedArr objectAtIndex:0];
    //    [ymT setOldString:[_dataArr objectAtIndex:0] andNewString:[_manageArr objectAtIndex:0]];
    //    [ymT fitToSuggestedHeight];
    //    [self.view addSubview:ymT];
    
    //********************************************************
}


- (void)matchData:(NSMutableArray *)dataSource{
    
    for (int i = 0; i<_dataArr.count; i ++) {
        
        NSString *matchString = [dataSource objectAtIndex:i];
        NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
        NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                           withString:PlaceHolder];
        //存新的
        [_manageArr addObject:newString];
        
        //正则字符串
        [self matchString:newString];
    }
    
}

- (void)matchString:(NSString *)dataSourceString{
    
    NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
    
    //**********号码******
    
    for (int i = 0; i < [ILRegularExpressionManager matchPhoneLink:dataSourceString].count; i ++) {
        
        [totalArr addObject:[[ILRegularExpressionManager matchPhoneLink:dataSourceString] objectAtIndex:i]];
    }
    
    //*************************
    
    
    //***********匹配网址*********
    
    for (int i = 0; i < [ILRegularExpressionManager matchWebLink:dataSourceString].count; i ++) {
        
        [totalArr addObject:[[ILRegularExpressionManager matchWebLink:dataSourceString] objectAtIndex:i]];
    }
    
    [_matchedArr addObject:totalArr];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMTextView *_ilcoreText = [[YMTextView alloc] initWithFrame:CGRectMake(offSet_X,10, self.view.frame.size.width - offSet_X * 2, 0)];
    
    [_ilcoreText setOldString:[_dataArr objectAtIndex:indexPath.row] andNewString:[_manageArr objectAtIndex:indexPath.row]];
    
    return [_ilcoreText getSuggestedHeight] + 40;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    ILTableViewCell *cell = (ILTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ILTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.ilcoreText.delegate = self;
    cell.ilcoreText.attributedData = [_matchedArr objectAtIndex:indexPath.row];
    [cell.ilcoreText setOldString:[_dataArr objectAtIndex:indexPath.row] andNewString:[_manageArr objectAtIndex:indexPath.row]];
    [cell.ilcoreText fitToSuggestedHeight];
    
    
    
    return cell;
    
}


#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
