//
//  PDFContentsHelper.h
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@class PDFContents;

@interface PDFContentsHelper : NSObject

- (instancetype)initWithPDFPath:(NSString *)pdfPath;
- (NSArray<PDFContents *> *)getPDFContents;

@end
