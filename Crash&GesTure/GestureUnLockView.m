//
//  GestureUnLock.m
//  Crash&GesTure
//
//  Created by chedao on 17/3/14.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import "GestureUnLockView.h"
#pragma mark ====== 单个button

@implementation CircleView

+(CircleView*)circleView{
    CircleView *circleView = [CircleView new];
    return  circleView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage];
    }
    return self;
}

-(void)setBackgroundImage{

    [self setBackgroundImage:NORMAL_IMAGE forState:UIControlStateNormal];
    [self setBackgroundImage:HIGHLIGHTED_IMAGE forState:UIControlStateSelected];
    self.userInteractionEnabled = NO;
}

@end




#pragma  mark =============  view部分
@interface GestureUnLockView ()

/** 圆点数组 */
@property(nonatomic,strong)NSMutableArray *circleViewArr;
/** 初次设置手势密码的秘钥 */
@property(nonatomic,copy)NSString *fristGesturePassword;

@end

@implementation GestureUnLockView

-(NSMutableArray *)circleViewArr{
    
    if (!_circleViewArr) {
        _circleViewArr = [NSMutableArray array];
    }
    
    return  _circleViewArr;
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BG_COLOR;
        [self makeView];
    }
    return self;
}



/** 创建界面 */
-(void)makeView{
    for (int  i = 0; i < COL_COUNT * ROW_COUNT; i++) {
        CircleView *circleView = [CircleView circleView];
        circleView.tag = CIRCLEVIEW_TAG + i;
        [self addSubview:circleView];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@">>>>>>>>>>33333");
    
    CGFloat space = (self.bounds.size.width - 3 * CIRCLE_H)/4.0;
    for (int i = 0; i < COL_COUNT * ROW_COUNT; i++) {
        
        CGFloat x = space * (i%COL_COUNT + 1)  + CIRCLE_H * (i%COL_COUNT);
        CGFloat y = TOPMARGIN + space * (i/COL_COUNT) + CIRCLE_H * (i/COL_COUNT);
        
        CircleView *circleV = (CircleView*)[self viewWithTag:CIRCLEVIEW_TAG + i];
        circleV.frame = CGRectMake(x, y, CIRCLE_H, CIRCLE_H);
    }
    
}

-(void)drawRect:(CGRect)rect{

    if(self.circleViewArr.count <= 1) return;
    
    UIBezierPath *mPath = [UIBezierPath bezierPath];
   
    for (int i = 0; i < self.circleViewArr.count; i++) {
        CircleView * circleView = self.circleViewArr[i];
        if (i == 0) {
            [mPath moveToPoint:circleView.center];
        }else{
            [mPath addLineToPoint:circleView.center];
        }
  
    }
    mPath.lineWidth = 7;
    mPath.lineJoinStyle = kCGLineJoinBevel;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:1] set];
    [mPath stroke];
    

}




//触点的坐标
-(CGPoint)touchPoint:(NSSet*)touches{
    
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}
//触点坐标是都再circleView上
-(CircleView*)circleViewInPoint:(CGPoint )point{
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CircleView class]]) {
            if (CGRectContainsPoint(view.frame, point)) {
                return (CircleView*)view;
            }
            
        }
    }
    return  nil;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self clearLastSelected];
    CGPoint point = [self touchPoint:touches];
    CircleView *circleView = [self circleViewInPoint:point];
    
    if (circleView != nil && !circleView.selected) {

        circleView.selected = YES;
        [self.circleViewArr addObject:circleView];
    }

    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if(self.circleViewArr.count == 0) {
        return;
    }
    
    CGPoint point  = [self touchPoint:touches];
    CircleView *circleView = [self circleViewInPoint:point];
    if (circleView != nil && !circleView.selected) {
        
        circleView.selected = YES;
        [self.circleViewArr addObject:circleView];
    }
     [self setNeedsDisplay];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //触摸结束时，如果只选择了一个则不作处理，给出一个设置手势密码失败的
    if(self.circleViewArr.count <= 1) {
        [self clearLastSelected];
        return;
    }
    CGPoint point  = [self touchPoint:touches];
    CircleView *circleView = [self circleViewInPoint:point];
    if (circleView != nil && !circleView.selected) {
        circleView.selected = YES;
        [self.circleViewArr addObject:circleView];
    }
    [self gestrueOvers];
    [self clearLastSelected];

}

//触摸结束之后的操作
-(void)gestrueOvers{
    
    if (self.gestureType == 1) {
        
        if (self.fristGesturePassword == nil) {
            self.fristGesturePassword = [self gestrueWithNSString];
        }else{
            //再次确认手势密码的操作
            if ([self.fristGesturePassword isEqualToString:[self gestrueWithNSString]]) {
                if (self.setGestureBlock) {
                    [self saveGestruePassword];
                    self.setGestureBlock(YES);
                }
            }else{
                //确认密码失败
                self.fristGesturePassword = nil;
                NSLog(@"确认密码失败");
            }
        }
        
    }else{
        
        if ([[self gestrueWithNSString] isEqualToString:[self readGesturePassword]]) {
            //解锁成功回调
            if (self.finishBlock) {
                self.finishBlock();
            }
        }else{
            //解锁失败的操作
            NSLog(@"解锁失败");
            
        }
        
    }
    
}


//删除原有的手势
-(void)clearLastSelected{

//    [self.circleViewArr makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CircleView class]]) {
            ((CircleView *)view).selected = NO;
        }
    }
    [self.circleViewArr removeAllObjects];
    [self setNeedsDisplay];
}

#pragma  mark === 手势密码的存储
#define GESTURE_KEY  @"gesturePasswordKey"

-(NSString*)gestrueWithNSString{

    NSString * str = @"";
    for (CircleView *circleView in self.circleViewArr) {
        str = [str stringByAppendingFormat:@"%d",(int)circleView.tag];
    }
    return str;
}
-(void)saveGestruePassword{
    
    [[NSUserDefaults standardUserDefaults] setObject:[self gestrueWithNSString] forKey:GESTURE_KEY];
}
-(NSString*)readGesturePassword{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:GESTURE_KEY];
}

@end
