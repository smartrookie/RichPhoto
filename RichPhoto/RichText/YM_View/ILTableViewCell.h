//
//  ILTableViewCell.h
//  ILCoretext
//
//  Created by 吴福虎 on 14/10/23.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextView.h"

@interface ILTableViewCell : UITableViewCell
{
    YMTextView *_ilcoreText;
}

@property (nonatomic,strong)YMTextView *ilcoreText;



@end
