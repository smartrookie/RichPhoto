//
//  ILTableViewCell.m
//  ILCoretext
//
//  Created by 吴福虎 on 14/10/23.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ILTableViewCell.h"

#define offSet_X 10


@implementation ILTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _ilcoreText = [[YMTextView alloc] initWithFrame:CGRectMake(offSet_X,10, self.frame.size.width - offSet_X * 2, 0)];
        
        [self.contentView addSubview:_ilcoreText];
        
      
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
