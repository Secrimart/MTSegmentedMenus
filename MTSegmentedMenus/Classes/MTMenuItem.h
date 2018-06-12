//
//  MTMenuItem.h
//  MTSegmentedMenus
//
//  Created by Jason Li on 2018/6/6.
//

#import <UIKit/UIKit.h>

@class MTMenuItem;
typedef void (^MTMenuItemSelectedChangeBlock)(MTMenuItem *item, BOOL selected);
typedef void (^MTMenuItemFormatterBlock)(MTMenuItem *item);

@interface MTMenuItem : UIControl

@property (nonatomic, copy) MTMenuItemSelectedChangeBlock selectedChangeBlock; // called when selected status by changed.

@property (nonatomic) NSInteger index; // Menu index

@property (nonatomic, strong) UILabel *labTitle; // Menu title

@property (nonatomic, strong) UIImage *imgIndicator; // a Menu indicator, Default is nil

@property (nonatomic, strong) UIImage *imgIndicatorSelected; // a Menu indicator for selected, Default is nil

/**
 Padding-left for item.
 
 Default is `2.f`
 */
@property (nonatomic) CGFloat itemPaddingLeft;

/**
 Padding-right for item.
 
 Default is `2.f`
 */
@property (nonatomic) CGFloat itemPaddingRight;

/**
 Default is NO, enable rotation indicator when selected item.
 */
@property (nonatomic, getter=isRotationIndicatorEnable) BOOL rotationIndicatorEnable;

/**
 Default is NO, enable animation for indicator.
 */
@property (nonatomic, getter=isAnimationEnable) BOOL animationEnable;

/**
 Default is `0.2f`, Animation duration for indicator when selected control.
 */
@property (nonatomic) CFTimeInterval selectedDuration;

/**
 Default is `0.2f`, Animation duration for indicator when cancel selected control.
 */
@property (nonatomic) CFTimeInterval cancelDuration;

/**
 Default is `[UIColor whiteColor]`, Color for item when unselected status.
 */
@property (nonatomic, strong) UIColor *itemColor;

/**
 Default is `[UIColor lightGrayColor]`, Color for item when selected status.
 */
@property (nonatomic, strong) UIColor *selectedItemColor;

/**
 Default is `[UIColor grayColor]`, Color for title when unselected status.
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 Default is `[UIColor blackColor]`, Color for title when selected status.
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**
 used by a block, to custom item style with property when init.

 @param formatter MTMenuItemFormatterBlock
 @return MTMenuItem instancetype
 */
- (instancetype)initWithFormatter:(MTMenuItemFormatterBlock)formatter;

/**
 a block, called when selected status by changed.

 @param selectedChangeBlock MTMenuItemSelectedChangeBlock
 */
- (void)setSelectedChangeBlock:(MTMenuItemSelectedChangeBlock)selectedChangeBlock;

@end
