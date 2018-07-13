//
//  PDFContents.m
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//

#import "PDFContents.h"

@implementation PDFContents

- (instancetype)initWithIndex:(NSInteger)index title:(NSString *)title {
    self = [super init];
    if (self) {
        self.index = index;
        self.title = title;
    }
    return self;
}

@end
