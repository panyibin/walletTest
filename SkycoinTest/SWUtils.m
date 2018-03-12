//
//  SWUtils.m
//  SkycoinTest
//
//  Created by PanYibin on 2018/3/11.
//  Copyright © 2018年 PanYibin. All rights reserved.
//

#import "SWUtils.h"

@implementation SWUtils

+ (NSDictionary*)dictionaryOfJsonString:(NSString*)jsonStr {
    NSDictionary *dict;
    NSError *error;
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if(!error) {
        return dict;
    } else {
        return nil;
    }
}

@end
