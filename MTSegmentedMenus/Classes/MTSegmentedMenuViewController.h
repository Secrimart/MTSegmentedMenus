//
//  MTSegmentedMenuViewController.h
//  Masonry
//
//  Created by Jason Li on 2018/6/7.
//

#import <UIKit/UIKit.h>
#import "MTMenuItem.h"

enum {
    MTSegmentedMenuViewControllerNoSegment = -1   // Segment index for no selected segment
};

typedef void (^MTSegmentedMenuViewControllerSelectedChangeBlock)(NSInteger cancelIndex, NSInteger selectIndex);

@interface MTSegmentedMenuViewController : UIViewController

@property (nonatomic, copy) MTMenuItemFormatterBlock itemFormatter; // a block, to custom item style with property

@property (nonatomic, copy) MTSegmentedMenuViewControllerSelectedChangeBlock itemChanged; // a block, called when changed by selection item.

/**
 Edge insets for this set of menus.
 
 Default is `UIEdgeInsetsZero`
 */
@property (nonatomic) UIEdgeInsets segmentInsets;

/**
 Array for menu item objects.
 */
@property (nonatomic, strong) NSMutableArray<MTMenuItem *> *arrayItems;

/**
 Record of index for selected menu item.
 
 Default is `MTSegmentedMenuViewControllerNoSegment`
 */
@property (nonatomic) NSInteger selectedIndex;

/**
 Default is NO. Set to YES to show a vertical divider between the menu item.
 */
@property (nonatomic, getter = isVerticalDividerEnabled) BOOL verticalDividerEnabled;

/**
 Color for the vertical divider between segments.
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *verticalDividerColor;

/**
 Width the vertical divider between segments that is added when `verticalDividerEnabled` is set to YES.
 
 Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat verticalDividerWidth;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
            itemFormatterBlock:(MTMenuItemFormatterBlock)itemFormatter
              changedItemBlock:(MTSegmentedMenuViewControllerSelectedChangeBlock)itemChanged;

- (void)toResetItemTitle:(NSString *)title atItemIndex:(NSInteger)index;

- (void)toCancelSelected;

@end

typedef MTSegmentedMenuViewController MTSegmentedMenus;
