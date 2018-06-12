//
//  MTMenuItem.m
//  MTSegmentedMenus
//
//  Created by Jason Li on 2018/6/6.
//

#import "MTMenuItem.h"

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

@import Masonry;

@interface MTMenuItem ()
@property (nonatomic, strong) UIImageView *imageViewIndicator;

@property (nonatomic) BOOL enableIndicator;

@end

@implementation MTMenuItem

//MARK: - Action
- (void)toSetDefaultValue {
    self.rotationIndicatorEnable = NO;
    self.animationEnable = NO;
    self.selectedDuration = .2f;
    self.cancelDuration = .2f;
    
    self.itemColor = [UIColor whiteColor];
    self.selectedItemColor = [UIColor lightGrayColor];
    
    self.titleColor = [UIColor grayColor];
    self.selectedTitleColor = [UIColor blackColor];
    
    self.itemPaddingLeft = 2.f;
    self.itemPaddingRight = 2.f;
}

- (void)toTouchItem:(MTMenuItem *)item {
    // changed selected status
    item.selected = !item.selected;
    
    if (self.selectedChangeBlock) {
        self.selectedChangeBlock(self, item.selected);
    }
}

- (void)toChangedItemBackgroundColor {
    if (self.isSelected) {
        self.backgroundColor = self.selectedItemColor;
    } else {
        self.backgroundColor = self.itemColor;
    }
    
}

- (void)toChangeTitleColor {
    if (self.isSelected) {
        self.labTitle.textColor = self.selectedTitleColor;
    } else {
        self.labTitle.textColor = self.titleColor;
    }
    
}

- (void)toRotationIndicator{
    CALayer *layer = self.imageViewIndicator.layer;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.duration = 0.01f;
    if (self.isSelected) {
        anim.values = @[@(Angle2Radian(30)),@(Angle2Radian(60)),@(Angle2Radian(90)),@(Angle2Radian(120)),@(Angle2Radian(150)),@(Angle2Radian(180))];
        if (self.animationEnable) {
            anim.duration = self.selectedDuration;
        }
    } else {
        anim.values = @[@(Angle2Radian(180)),@(Angle2Radian(150)),@(Angle2Radian(120)),@(Angle2Radian(90)),@(Angle2Radian(60)),@(Angle2Radian(30)),@(Angle2Radian(0))];
        if (self.animationEnable) {
            anim.duration = self.cancelDuration;
        }
    }
    // 动画的重复执行次数
    anim.repeatCount = 1;//MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:anim forKey:@"rotation"];
    
}

//MARK: - Life Cycle
- (instancetype)initWithFormatter:(MTMenuItemFormatterBlock)formatter {
    self = [super init];
    if (self) {
        
        if (formatter) {
            formatter(self);
        }
        // Initialization code
        [self initView];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // set default value
        [self toSetDefaultValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // set default value
        [self toSetDefaultValue];
    }
    return self;
}

- (void)initView {
    // added control
    [self addSubview:self.labTitle];
    [self toLayoutMenuTitle];
    
    if (self.imgIndicator) {
        [self addSubview:self.imageViewIndicator];
        [self toLayoutIndicator];
    }
    
    // set default color
    [self toChangedItemBackgroundColor];
    [self toChangeTitleColor];
    
    // added action
    [self addTarget:self action:@selector(toTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    
}

//MARK: - Layout
- (void)toLayoutMenuTitle {
    __weak typeof(self) weakSelf = self;
    CGFloat height = ceilf(weakSelf.labTitle.font.lineHeight);
    CGFloat offsetCenterX = height/2.f +  (self.itemPaddingRight - self.itemPaddingLeft)/2.f;
    
    [self.labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(weakSelf.itemPaddingLeft);
        if (self.imgIndicator) {
            make.centerY.mas_equalTo(weakSelf);
            make.centerX.mas_equalTo(weakSelf).mas_offset(- offsetCenterX);
            make.height.mas_equalTo(height);
        } else {
            make.right.mas_greaterThanOrEqualTo(-weakSelf.itemPaddingRight);
            make.top.mas_greaterThanOrEqualTo(0.f);
            make.bottom.mas_greaterThanOrEqualTo(-0.f);
            make.center.mas_equalTo(weakSelf);
        }
    }];
}

- (void)toLayoutIndicator {
    __weak typeof(self) weakSelf = self;
    CGFloat height = ceilf(weakSelf.labTitle.font.lineHeight);
    [self.imageViewIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(height);
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.labTitle.mas_right);
    }];
}

//MARK: - Getter And Setter
- (void)setImgIndicator:(UIImage *)imgIndicator {
    _imgIndicator = imgIndicator;
    [self.imageViewIndicator setImage:imgIndicator];
    
}

- (UILabel *)labTitle {
    if (_labTitle) return _labTitle;
    _labTitle = [[UILabel alloc] init];
    _labTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labTitle.text = @"itemTitle"; // default value
    
    _labTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return _labTitle;
}

- (UIImageView *)imageViewIndicator {
    if (_imageViewIndicator) return _imageViewIndicator;
    _imageViewIndicator = [[UIImageView alloc] init];
    _imageViewIndicator.backgroundColor = [UIColor clearColor];
    _imageViewIndicator.contentMode = UIViewContentModeScaleAspectFit;
    _imageViewIndicator.clipsToBounds = YES;
    
    return _imageViewIndicator;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    [self toChangedItemBackgroundColor];
    [self toChangeTitleColor];
    
    if (self.imgIndicator &&
        self.rotationIndicatorEnable) {
        if (self.imgIndicatorSelected && selected) {
            [self.imageViewIndicator setImage:self.imgIndicatorSelected];
        } else if (self.imgIndicatorSelected && !selected) {
            [self.imageViewIndicator setImage:self.imgIndicator];
        }
        
        [self toRotationIndicator];
    }
}

@end
