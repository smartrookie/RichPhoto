//
//  ILRegularExpressionManager.m
//  ILCoretext
//
//  Created by 吴福虎 on 14/10/22.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ILRegularExpressionManager.h"

@implementation ILRegularExpressionManager

+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString
{
    NSAssert(pattern != nil, @"%s: pattern 不可以为 nil", __PRETTY_FUNCTION__);
    NSAssert(findingString != nil, @"%s: findingString 不可以为 nil", __PRETTY_FUNCTION__);
    
    NSError *error = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:
                                   pattern options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    
    // 查找匹配的字符串
    NSArray *result = [regExp matchesInString:findingString options:
                       NSMatchingReportCompletion range:
                       NSMakeRange(0, [findingString length])];
    
    if (error) {
        NSLog(@"ERROR: %@", result);
        return nil;
    }
    
    NSUInteger count = [result count];
    // 没有查找到结果，返回空数组
    if (0 == count) {
        return [NSArray array];
    }
    
    // 将返回数组中的 NSTextCheckingResult 的实例的 range 取出生成新的 range 数组
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i = 0; i < count; i++)
    {
        @autoreleasepool {
            NSRange aRange = [[result objectAtIndex:i] range];
            [ranges addObject:[NSValue valueWithRange:aRange]];
        }
    }
    return ranges;
}

+ (NSMutableArray *)matchMobileLink:(NSString *)pattern{

    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    
    for( NSTextCheckingResult * result in array){
    
        NSString * string=[pattern substringWithRange:result.range];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dic];
    }

    return linkArr;
}


+ (NSMutableArray *)matchPhoneLink:(NSString *)pattern{

    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];

    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\d{11,12})|(\\d{7,8})|((\\d{4}|\\d{3})-(\\d{7,8}))|((\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|((\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    
    for( NSTextCheckingResult * result in array){
        
        NSRegularExpression*regular1=[[NSRegularExpression alloc]initWithPattern:@"^(\\(86\\))?(13[0-9]|15[7-9]|152|153|156|18[7-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
        
        NSString * string=[pattern substringWithRange:result.range];
        
        NSUInteger numberOfMatches = [regular1 numberOfMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])];
        if (numberOfMatches>0) {
            
            return nil;
        }
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dic];
    }
    
    return linkArr;
}



+ (NSMutableArray *)matchWebLink:(NSString *)pattern{

    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];

    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    
    for( NSTextCheckingResult * result in array){
        
        NSString * string=[pattern substringWithRange:result.range];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        
        [linkArr addObject:dic];
    }
   // NSLog(@"linkArr == %@",linkArr);
    return linkArr;

}

@end
