//
//  GestureUnLock.h
//  Crash&GesTure
//
//  Created by chedao on 17/3/14.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark =========  SoureInfo

#define BG_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]]
#define NORMAL_IMAGE [UIImage imageNamed:@"gesture_node_normal"]
#define HIGHLIGHTED_IMAGE [UIImage imageNamed:@"gesture_node_highlighted"]


#define  CIRCLEVIEW_TAG 1000

#define COL_COUNT 3
#define ROW_COUNT 3
#define CIRCLE_H 74.0
#define TOPMARGIN 200.0


@interface CircleView : UIButton

+(CircleView*)circleView;

@end



#pragma mark ===== 主展示界面

typedef   void(^GestureFinish)(void);
typedef void(^SetGesture)(BOOL finish);
@interface GestureUnLockView : UIView

/** 1.设置手势密码 2.解锁手势密码 */
@property(nonatomic,assign)int gestureType;

/**   输入手势的回调  */
@property(nonatomic,assign)GestureFinish finishBlock;
/**   设置手势的回调 */
@property(nonatomic,assign)SetGesture setGestureBlock;

@end
