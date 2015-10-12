//
//  ViewController.m
//  Cal
//
//  Created by 杨志强 on 15/10/9.
//  Copyright © 2015年 ZNM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *backView;
    UIView *frontView;
    CGFloat r1;
    CGFloat r2;
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    
    CGPoint pointA;
    CGPoint pointB;
    CGPoint pointC;
    CGPoint pointD;
    CGPoint pointO;
    CGPoint pointP;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGRect oldBackViewFrame;
    CGPoint oldCenter;
    CAShapeLayer *shapeLayer;
    CGFloat springVector;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    springVector = 20;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    backView.center = self.view.center;
    oldBackViewFrame = backView.frame;
    oldCenter = backView.center;
    
    backView.backgroundColor = [UIColor redColor];
    r1 = backView.frame.size.width / 2;
    backView.layer.cornerRadius = r1;
    [self.view addSubview:backView];
    x1 = backView.center.x;
    y1 = backView.center.y;
    
    frontView = [[UIView alloc] initWithFrame:backView.frame];
    [self.view addSubview:frontView];
    frontView.backgroundColor = [UIColor redColor];
    r2 = frontView.frame.size.width / 2;
    frontView.layer.cornerRadius = r2;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    pointA = CGPointMake(x1-r1, y1);
    pointB = CGPointMake(x1+r1, y1);
    
    pointC = CGPointMake(x2+r2, y2);
    pointD = CGPointMake(x2-r2, y2);
    
    UIPanGestureRecognizer *panges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [frontView addGestureRecognizer:panges];
    
    shapeLayer = [CAShapeLayer layer];
}

- (void)pan:(UIPanGestureRecognizer*)ges
{
    CGPoint dragPoint = [ges locationInView:self.view];
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            backView.hidden = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            frontView.center = dragPoint;
            if (r1 <= 6)
            {
                backView.hidden = YES;
                [shapeLayer removeFromSuperlayer];
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                frontView.center = oldCenter;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        default:
            break;
    }
    
    [self dragPointChanged];
}

- (void)dragPointChanged
{
    x1 = backView.center.x;
    y1 = backView.center.y;
    
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }
    else
    {
        cosDigree = (y2-y1) / centerDistance;
        sinDigree = (x2-x1) / centerDistance;
    }
    
    r1 = oldBackViewFrame.size.width / 2 - centerDistance / springVector;
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree);
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree);
    pointO = CGPointMake(pointA.x+centerDistance/2*sinDigree, pointA.y+centerDistance/2*cosDigree);
    pointP = CGPointMake(pointB.x+centerDistance/2*sinDigree, pointB.y+centerDistance/2*cosDigree);
    
    [self drawRect];
}

- (void)drawRect
{
    backView.frame = CGRectMake(0, 0, 2*r1, 2*r1);
    backView.center = oldCenter;
    backView.layer.cornerRadius = r1;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addQuadCurveToPoint:pointD controlPoint:pointO];
    [path addLineToPoint:pointC];
    [path addQuadCurveToPoint:pointB controlPoint:pointP];
    [path moveToPoint:pointA];
    
    if (backView.hidden == NO)
    {
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor redColor].CGColor;
        [self.view.layer insertSublayer:shapeLayer below:frontView.layer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
