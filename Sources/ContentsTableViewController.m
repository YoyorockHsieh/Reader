//
//  ContentsTableViewController.m
//  Reader
//
//  Created by Lorder.Hsieh - 謝旻哲 on 2018/7/13.
//

#import "ContentsTableViewController.h"
#import "PDFContents.h"

static NSString *PDFContentsCellIdentifier = @"ContentsCell";

@interface ContentsTableViewController ()

@property (nonatomic, strong) NSArray<PDFContents *> *content;

@end

@implementation ContentsTableViewController

- (instancetype)initWithContents:(NSArray<PDFContents *> *)content {
    self = [super init];
    if (self) {
        self.content = content;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PDFContentsCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _content.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDFContents *contnet = _content[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PDFContentsCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PDFContentsCellIdentifier];
        cell.textLabel.numberOfLines = 0;
    }
    
    [cell.textLabel setText:contnet.title];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)contnet.index]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(gotoPage:)]) {
        NSInteger page = _content[indexPath.row].index;
        [_delegate gotoPage:page];
    }
}
@end
