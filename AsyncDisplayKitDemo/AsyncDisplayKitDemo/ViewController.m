

#import "ViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "Util.h"
#import "BlurbNode.h"
#import "KittenNode.h"

@interface ViewController () <ASTableViewDataSource, ASTableViewDelegate> {
    
    ASTableView * _tableView;
    NSArray *_kittenDataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initASTableView];
    [self initDataSource];
}

- (void)initASTableView {
        
        _tableView = [[ASTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
    
        [self.view addSubview:_tableView];
}

- (void)initDataSource {
    
    NSMutableArray *kittenDataSource = [NSMutableArray arrayWithCapacity:20];
    for (NSInteger i = 0; i < 20; i++) {
        u_int32_t deltaX = arc4random_uniform(10) - 5;
        u_int32_t deltaY = arc4random_uniform(10) - 5;
        CGSize size = CGSizeMake(350 + 2 * deltaX, 350 + 4 * deltaY);
        
        [kittenDataSource addObject:[NSValue valueWithCGSize:size]];
    }
    _kittenDataSource = kittenDataSource;
}

#pragma mark - 屏幕旋转事件
- (void)viewWillLayoutSubviews
{
    _tableView.frame = self.view.bounds;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - ASTableViewDataSource
- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        BlurbNode *node = [[BlurbNode alloc] init];
        return node;
    }
    
    NSValue *size = _kittenDataSource[indexPath.row - 1];
    KittenNode *node = [[KittenNode alloc] initWithKittenOfSize:size.CGSizeValue];
    return node;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // blurb node + kLitterSize kitties
    return 1 + _kittenDataSource.count;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // disable row selection
    return NO;
}

@end
