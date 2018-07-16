//
//  MTSegmentMenuViewController.m
//  Masonry
//
//  Created by Jason Li on 2018/6/7.
//

#import "MTSegmentedMenuViewController.h"

@import Masonry;

@interface MTSegmentedMenuViewController ()
@property (nonatomic, strong) NSMutableArray *arrayTitles; // array of menu titles

/**
 array of segment's vertical dividers
 */
@property (nonatomic, strong) NSMutableArray *arrayVerticalDividers;

@end

@implementation MTSegmentedMenuViewController

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
            itemFormatterBlock:(MTMenuItemFormatterBlock)itemFormatter
              changedItemBlock:(MTSegmentedMenuViewControllerSelectedChangeBlock)itemChanged {
    self = [super init];
    
    if (self) {
        self.itemFormatter = itemFormatter;
        self.itemChanged = itemChanged;
        
        self.arrayTitles = [NSMutableArray arrayWithArray:titles];
        
        self.selectedIndex = MTSegmentedMenuViewControllerNoSegment;
        
        self.segmentInsets = UIEdgeInsetsZero;
        
        self.verticalDividerEnabled = NO;
        self.verticalDividerColor = [UIColor blackColor];
        self.verticalDividerWidth = 1.f;
    }
    
    return self;
}

- (void)toResetItemTitle:(NSString *)title atItemIndex:(NSInteger)index {
    if (index <= self.arrayItems.count - 1) {
        MTMenuItem *item = [self.arrayItems objectAtIndex:index];
        item.labTitle.text = title;
    }
}

- (void)toCancelSelected {
    if (self.selectedIndex != MTSegmentedMenuViewControllerNoSegment) {
        MTMenuItem *item = [self.arrayItems objectAtIndex:self.selectedIndex];
        item.selected = NO;
        
        self.selectedIndex = MTSegmentedMenuViewControllerNoSegment;
    }
    
}

//MARK: - Action
- (void)toSetSelectedItemIndex:(NSInteger)index selected:(BOOL)selected {
    if (self.selectedIndex != MTSegmentedMenuViewControllerNoSegment) {
        if (self.selectedIndex == index &&
            !selected) {
            // 通知调用者，点击了已经打开的菜单，菜单关闭
            if (self.itemChanged) {
                self.itemChanged(self.selectedIndex, MTSegmentedMenuViewControllerNoSegment);
            }
            
            self.selectedIndex = MTSegmentedMenuViewControllerNoSegment;
            return;
        }
        
        if (self.selectedIndex != index) {
            // 通知调用者并关闭已经选择的 菜单
            MTMenuItem *item = [self.arrayItems objectAtIndex:self.selectedIndex];
            item.selected = NO;
            if (self.itemChanged) {
                self.itemChanged(self.selectedIndex, index);
            }
            
            // 设置当前选择的菜单
            self.selectedIndex = index;
            return;
        }
    }
    
    // 通知调用者打开目标菜单
    if (self.itemChanged) {
        self.itemChanged(self.selectedIndex, index);
    }
    
    // 设置当前选择的菜单
    self.selectedIndex = index;
}

//MARK: - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self toLayoutMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: - Layout
- (void)toLayoutMenuItems {
    __weak typeof(self) weakSelf = self;
    NSInteger count = self.arrayTitles.count;
    
    [self.arrayTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTMenuItem *item = [[MTMenuItem alloc] initWithFormatter:weakSelf.itemFormatter];
        item.labTitle.text = (NSString *)obj;
        item.index = idx;
        
        [item setSelectedChangeBlock:^(MTMenuItem *item, BOOL selected) {
            [weakSelf toSetSelectedItemIndex:item.index selected:selected];
        }];
        
        [weakSelf.arrayItems addObject:item];
        [weakSelf.view addSubview:item];
        
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.segmentInsets.top);
            make.bottom.mas_equalTo(-weakSelf.segmentInsets.bottom);
            if (idx == 0) {
                make.left.mas_equalTo(weakSelf.segmentInsets.left);
            } else {
                MTMenuItem *lastItem = [weakSelf.arrayItems objectAtIndex:idx - 1];
                if (self.verticalDividerEnabled) {
                    UIView *lastVerticalDividerView = [weakSelf.arrayVerticalDividers objectAtIndex:idx - 1];
                    make.left.mas_equalTo(lastVerticalDividerView.mas_right);
                } else {
                    make.left.mas_equalTo(lastItem.mas_right);
                }
                make.width.mas_equalTo(lastItem.mas_width);
                if (idx == count - 1) {
                    make.right.mas_equalTo(-weakSelf.segmentInsets.right);
                }
            }
        }];
        
        if (self.verticalDividerEnabled && idx < count) {
            UIView *verticalDividerView = [[UIView alloc] init];
            verticalDividerView.backgroundColor = weakSelf.verticalDividerColor;
            
            [weakSelf.arrayVerticalDividers addObject:verticalDividerView];
            [weakSelf.view addSubview:verticalDividerView];
            
            [verticalDividerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(item.mas_right);
                make.width.mas_equalTo(weakSelf.verticalDividerWidth);
                make.top.mas_equalTo(weakSelf.segmentInsets.top);
                make.bottom.mas_equalTo(-weakSelf.segmentInsets.bottom);
            }];
        }
    }];
    
}


//MARK: - Getter And Setter
- (NSMutableArray<MTMenuItem *> *)arrayItems {
    if (_arrayItems) return _arrayItems;
    _arrayItems = [NSMutableArray arrayWithCapacity:0];
    
    return _arrayItems;
}

- (NSMutableArray *)arrayVerticalDividers {
    if (_arrayVerticalDividers) return _arrayVerticalDividers;
    _arrayVerticalDividers = [NSMutableArray arrayWithCapacity:0];
    
    return _arrayVerticalDividers;
}

@end
