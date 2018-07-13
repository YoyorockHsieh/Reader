//
//  PDFContentsHelper.m
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//
//  extract functino from: https://github.com/phaibin/PDFContents

#import "PDFContentsHelper.h"
#import "VoyeurNode.h"
#import "PDFContents.h"

@interface PDFContentsHelper()

@property(nonatomic, copy) NSString *pdfPath;

@end

@implementation PDFContentsHelper

- (instancetype)initWithPDFPath:(NSString *)pdfPath {
    self = [super init];
    if (self) {
        self.pdfPath = pdfPath;
    }
    return self;
}

- (NSArray<PDFContents *> *)getPDFContents {
    NSArray *contents = [self getPDFContents:_pdfPath];
    NSMutableArray<PDFContents *> *result = [NSMutableArray arrayWithCapacity:contents.count];
    for (NSDictionary *content in contents) {
        NSNumber *index = content[@"Index"];
        NSString *title = content[@"Title"];
        PDFContents *pdfcontents = [[PDFContents alloc] initWithIndex:index.integerValue title:title];
        [result addObject:pdfcontents];
    }
    return [result copy];
}

- (NSArray *)getPDFContents:(NSString *)pdfPath
{
    CGPDFDocumentRef myDocument = CGPDFDocumentCreateWithURL((CFURLRef)[NSURL fileURLWithPath:pdfPath]);
    CGPDFDictionaryRef mycatalog= CGPDFDocumentGetCatalog(myDocument);
    VoyeurNode *rootNode = [[VoyeurNode alloc] initWithCatalog:mycatalog];
    VoyeurNode *rootOutlineNode = [rootNode childrenForName:@"/Outlines"];
    VoyeurNode *pagesNode = [rootNode childrenForName:@"/Pages"];
    NSArray *pagesArray = [self getPagesFromPagesNode:pagesNode];
    VoyeurNode *destsNode = [rootNode childrenForName:@"/Dests"];
    
    return [self getContentsForOutlineNode:rootOutlineNode pages:pagesArray destsNode:destsNode];
}

- (NSArray *)getContentsForOutlineNode:(VoyeurNode *)rootOutlineNode pages:(NSArray *)pagesArray destsNode:(VoyeurNode *)destsNode
{
    NSMutableArray *outlineArray = [[NSMutableArray alloc] init];
    VoyeurNode *firstOutlineNode = [rootOutlineNode childrenForName:@"/First"];
    VoyeurNode *outlineNode = firstOutlineNode;
    while (outlineNode) {
        NSString *title = [[outlineNode childrenForName:@"/Title"] value];
        VoyeurNode *destNode = [outlineNode childrenForName:@"/Dest"];
        NSMutableDictionary *outline = [NSMutableDictionary dictionaryWithDictionary:@{@"Title": title}];
        int index = 0;
        if (destNode) {
            if ([[destNode typeAsString] isEqualToString:@"Dictionary"]) {
                CGPDFObjectRef dest = (__bridge CGPDFObjectRef)[[[destNode children] objectAtIndex:0] object];
                index = [self getIndexInPages:pagesArray forPage:dest];
            } else if ([[destNode typeAsString] isEqualToString:@"Name"]) {
                NSString *destName = [destNode value];
                CGPDFObjectRef dest = (__bridge CGPDFObjectRef)[[[[[destsNode childrenForName:destName] childrenForName:@"/D"] children] objectAtIndex:0] object];
                index = [self getIndexInPages:pagesArray forPage:dest];
            } else if ([[destNode typeAsString] isEqualToString:@"Array"]) {
                CGPDFObjectRef dest = (__bridge CGPDFObjectRef)[[[destNode children] objectAtIndex:0] object];
                index = [self getIndexInPages:pagesArray forPage:dest];
            }
        } else {
            VoyeurNode *aNode = [outlineNode childrenForName:@"/A"];
            if (aNode) {
                VoyeurNode *dNode = [aNode childrenForName:@"/D"];
                if (dNode) {
                    VoyeurNode *d0Node = [[dNode children] objectAtIndex:0];
                    if ([[d0Node typeAsString] isEqualToString:@"Dictionary"]) {
                        CGPDFObjectRef dest = (CGPDFObjectRef)[d0Node object];
                        index = [self getIndexInPages:pagesArray forPage:dest];
                    }
                }
            }
        }
        [outline setObject:@(index) forKey:@"Index"];
        NSArray *subOutlines = [self getContentsForOutlineNode:outlineNode pages:pagesArray destsNode:destsNode];
        [outline setObject:subOutlines forKey:@"SubContents"];
        [outlineArray addObject:outline];
        outlineNode = [outlineNode childrenForName:@"/Next"];
    }
    return outlineArray;
}

- (NSArray *)getPagesFromPagesNode:(VoyeurNode *)pagesNode
{
    NSMutableArray *pages = [NSMutableArray new];
    VoyeurNode *kidsNode = [pagesNode childrenForName:@"/Kids"];
    for (VoyeurNode *node in [kidsNode children]) {
        NSString *type = [[node childrenForName:@"/Type"] value];
        if ([type isEqualToString:@"/Pages"]) {
            NSArray *kidsPages = [self getPagesFromPagesNode:node];
            [pages addObjectsFromArray:kidsPages];
        } else {
            [pages addObject:node];
        }
    }
    return pages;
}

- (int)getIndexInPages:(NSArray *)pages forPage:(CGPDFObjectRef)page
{
    for (int k = 0; k < pages.count; k++) {
        VoyeurNode *node = [pages objectAtIndex:k];
        if ([node object] == page)
            return k+1;
    }
    return 1;
}

@end
