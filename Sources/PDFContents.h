//
//  PDFContents.h
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface PDFContents : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithIndex:(NSInteger)index title:(NSString *)title;

@end
