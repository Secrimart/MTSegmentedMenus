//
//  MTViewController.m
//  MTSegmentedMenus
//
//  Created by rstx_reg@aliyun.com on 06/06/2018.
//  Copyright (c) 2018 rstx_reg@aliyun.com. All rights reserved.
//

#import "MTViewController.h"

@import MTSegmentedMenus;
@import Masonry;

@interface MTViewController ()

@property (nonatomic, copy) MTMenuItemFormatterBlock itemFormatter;
@property (nonatomic, strong) MTMenuItem *item;

@property (nonatomic, strong) MTSegmentMenuViewController *segmentMenu;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) MTSegmentMenuViewController *segmentMenu1;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.item];

    [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64.f);
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.height.mas_equalTo(44.f);
    }];

    UIButton *btnControl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnControl setTitle:@"change Item status for code" forState:UIControlStateNormal];
    [btnControl addTarget:self action:@selector(toChangeMenuStatusForCode:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnControl];
    __weak typeof(self) weakSelf = self;
    [btnControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.item.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(weakSelf.view);
        make.height.top.mas_equalTo(weakSelf.item);
    }];

    [self toAddChildViewController:self.segmentMenu];
    [self.segmentMenu.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.item.mas_bottom).mas_offset(10.f);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"Menu title";
    [self.view addSubview:self.textField];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.segmentMenu.view.mas_bottom).mas_offset(10.f);
    }];
    
    UIButton *btnResetTitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnResetTitle setTitle:@"Reset title for mneu2" forState:UIControlStateNormal];
    [btnResetTitle addTarget:self action:@selector(toResetTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnResetTitle];
    
    [btnResetTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.textField.mas_right).mas_offset(10.f);
        make.top.height.mas_equalTo(weakSelf.textField);
        make.right.mas_equalTo(weakSelf.view).mas_offset(-15.f);
    }];
    
    UIButton *btnCancelSelected = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancelSelected setTitle:@"Cancel selected for code" forState:UIControlStateNormal];
    [btnCancelSelected addTarget:self action:@selector(toCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancelSelected];
    [btnCancelSelected mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(weakSelf.textField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(weakSelf.view).mas_offset(-15.f);
    }];
    
    [self toAddChildViewController:self.segmentMenu1];
    [self.segmentMenu1.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(btnCancelSelected.mas_bottom).mas_offset(10.f);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - Action
- (void)toChangeMenuStatusForCode:(UIButton *)button {
    self.item.selected = !self.item.selected;
}

- (void)toResetTitle:(UIButton *)button {
    if (self.textField.text.length == 0) {
        [self.textField becomeFirstResponder];
        return;
    }
    
    [self.segmentMenu toResetItemTitle:self.textField.text atItemIndex:1];
    [self.textField resignFirstResponder];
}

- (void)toCancelSelected:(UIButton *)button {
    [self.segmentMenu toCancelSelected];
}

- (void)toAddChildViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

//MARK: - Getter And Setter
- (MTMenuItemFormatterBlock)itemFormatter {
    if (_itemFormatter) return _itemFormatter;
    _itemFormatter = ^(MTMenuItem *item) {
        item.imgIndicator = [UIImage imageNamed:@"arrow"];
        item.imgIndicatorSelected = [UIImage imageNamed:@"arrowselected"];
        
        item.labTitle.font = [UIFont systemFontOfSize:13.f];
        
        item.selectedTitleColor = [UIColor blackColor];
        item.selectedItemColor = [UIColor groupTableViewBackgroundColor];
        
        item.rotationIndicatorEnable = YES;
        item.animationEnable = YES;
        
//        item.itemPaddingLeft = 40.f;
    };
    
    return _itemFormatter;
}

- (MTMenuItem *)item {
    if (_item) return _item;
    _item = [[MTMenuItem alloc] initWithFormatter:self.itemFormatter];
    _item.labTitle.text = @"DropDownMenu";
    [_item setSelectedChangeBlock:^(MTMenuItem *item, BOOL selected) {
        NSLog(@"item is selected :%@",selected?@"YES":@"NO");
    }];
    
    return _item;
}

- (MTSegmentMenuViewController *)segmentMenu {
    if (_segmentMenu) return _segmentMenu;
    _segmentMenu = [[MTSegmentMenuViewController alloc] initWithTitles:@[@"12345678901234567",@"menu2",@"menu3"] itemFormatterBlock:self.itemFormatter changedItemBlock:nil];
    
    return _segmentMenu;
}

- (MTSegmentMenuViewController *)segmentMenu1 {
    if (_segmentMenu1) return _segmentMenu1;
    _segmentMenu1 = [[MTSegmentMenuViewController alloc] initWithTitles:@[@"menu1",@"menu2",@"menu3"] itemFormatterBlock:self.itemFormatter changedItemBlock:^(NSInteger index, BOOL selected) {
        NSLog(@"item index is: %ld, item is: %@",index, selected?@"selected":@"canceled");
    }];
    
    _segmentMenu1.segmentInsets = UIEdgeInsetsMake(8.f, 0.f, 8.f, 0.f);
    _segmentMenu1.verticalDividerEnabled = YES;
    _segmentMenu1.verticalDividerColor = [UIColor lightGrayColor];
    _segmentMenu1.verticalDividerWidth = .5f;
    
    return _segmentMenu1;
    
}

@end
