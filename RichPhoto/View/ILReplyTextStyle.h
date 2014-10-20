//
//  ILReplyTextStyle.h
//  RichView
//
//  Created by 吴福虎 on 14/10/20.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

//******样式********

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ILReplyTextStyle : NSObject

+ (NSAttributedString *)creatFromUserNameStrRange:(NSRange)fromRange
                                andFromNameString:(NSString*)fromString
                               toUserNameStrRange:(NSRange)toRange
                                  andToNameString:(NSString *)toString
                                    appendContent:(NSString *)contentString;

@end
