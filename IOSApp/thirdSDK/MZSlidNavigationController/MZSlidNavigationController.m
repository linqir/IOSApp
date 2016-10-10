//
//  MZSlidNavigationController.m
//  MZSlideNavigation
//
//  Created by Zhangle on 15/10/29.
//  Copyright © 2015年 Machelle. All rights reserved.
//

#import "MZSlidNavigationController.h"

//开始点在这个范围内才会触发效果
#define TOUCH_ACTION_IN_RANG 100
//超过这个距离，就自动返回上一级
#define BACK_ACTION_IN_RANG 100
//背景图的偏移量（0～1）
#define SCREENSHOT_OFFSET   0.65
//屏幕宽，高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface MZSlidNavigationController ()

//开始点
@property (nonatomic) CGPoint startPoint;
//屏幕截图数组
@property (nonatomic, strong) NSMutableArray *screenShotsArray;
//上一个界面的截图
@property (nonatomic, strong) UIImageView *lastScrrenShot;

@end

@implementation MZSlidNavigationController

//截图数组的getter
- (NSMutableArray *)screenShotsArray {
    if (!_screenShotsArray) {
        _screenShotsArray = [[NSMutableArray alloc] init];
    }
    return _screenShotsArray;
}

/**
 *  增加边界阴影，以便区分
 *  添加拖动手势
 */
- (void)viewDidLoad {
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity = 0.7;
    self.view.layer.shadowRadius = 10;
    UIPanGestureRecognizer *slideBackGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideBackAction:)];
    [self.view addGestureRecognizer:slideBackGesture];
}

//手势事件响应
- (void)slideBackAction:(UIPanGestureRecognizer *)gesture {
    //首页不需要该效果
    if (self.viewControllers.count <= 1) {
        return;
    }
    
    CGPoint touchesPoint = [gesture locationInView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat offsetX = touchesPoint.x - self.startPoint.x;
    
    //手势开始时进行初始化，记录开始点，上个界面截图显示
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.startPoint = touchesPoint;
        [self prepareViews];
        _lastScrrenShot.hidden = NO;
    }
    
    //在范围内才触发效果
    if (self.startPoint.x < TOUCH_ACTION_IN_RANG) {
        //移动中
        [UIView animateWithDuration:0.3f animations:^{
            [self moveWithOffset:offsetX];
        }];
        
        //手势停止，超过一定距离就返回上一个界面，否则恢复现场
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if (offsetX > BACK_ACTION_IN_RANG) {
                [UIView animateWithDuration:0.3f animations:^{
                    [self moveWithOffset:SCREEN_WIDTH];
                } completion:^(BOOL finished) {
                    [self completeMoving];
                }];
            } else {
                [UIView animateWithDuration:0.3f animations:^{
                    [self moveWithOffset:0];
                }];
            }
        }
        
        //手势取消，拖动过程中按了home键或其它事件导致取消，取消后进行现场恢复
        if (gesture.state == UIGestureRecognizerStateCancelled) {
            [UIView animateWithDuration:0.3f animations:^{
                [self moveWithOffset:0];
            } completion:^(BOOL finished) {
                _lastScrrenShot.hidden = YES;
            }];
        }
    }
}

//上一个界面截图准备
- (void)prepareViews {
    UIImage *image = [_screenShotsArray lastObject];
    if (!_lastScrrenShot) {
        _lastScrrenShot = [[UIImageView alloc] initWithImage:image];
    } else {
        _lastScrrenShot.image = image;
    }
    _lastScrrenShot.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.superview insertSubview:_lastScrrenShot belowSubview:self.view];
}

//重写push，push前需要截屏保存在数组中
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        [self.screenShotsArray addObject:[self capture]];
    }
    [super pushViewController:viewController animated:animated];
}

//重写pop，pop前需要清理数据
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotsArray removeLastObject];
    _lastScrrenShot.image = nil;
    return [super popViewControllerAnimated:animated];
}

//截屏，返回图片
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//根据偏移量移动frame
- (void)moveWithOffset:(CGFloat)offset {
    offset = offset > SCREEN_WIDTH ? SCREEN_WIDTH : offset;
    offset = offset < 0 ? 0 : offset;
    CGRect frame = self.view.frame;
    frame.origin.x = offset;
    self.view.frame = frame;
    _lastScrrenShot.frame = CGRectMake((offset-SCREEN_WIDTH)*SCREENSHOT_OFFSET, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

//完成移动时调用
- (void)completeMoving {
    [self popViewControllerAnimated:NO];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    _lastScrrenShot.hidden = YES;
}

@end
