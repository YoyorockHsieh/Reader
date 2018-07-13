//
//  ContentsTableViewController.h
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//

#import <UIKit/UIKit.h>

@class PDFContents;
@class ContentsTableViewController;

@protocol ContentsTableViewControllerDelegate <NSObject>

- (void)gotoPage:(NSInteger)page;

@end

@interface ContentsTableViewController : UITableViewController

@property (nonatomic, weak) id <ContentsTableViewControllerDelegate> delegate;
- (instancetype)initWithContents:(NSArray<PDFContents *> *)content;

@end
