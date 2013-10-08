//
//  ViewController.m
//  Gestationaire
//
//  Created by admin on 08/10/13.
//  Copyright (c) 2013 Aurelien Fontaine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView* imgview;
@property (strong, nonatomic) UIImageView* trashOpenView;
@property (strong, nonatomic) UIImageView* trashCloseView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addImage];
    
    
    UIImage *trashClose = [UIImage imageNamed:@"Trash_Close"];
    UIImage *trashOpen = [UIImage imageNamed:@"Trash_Open"];
    
    CGRect trashPos = CGRectMake(0,350,trashClose.size.width/3, trashClose.size.height/3);

    self.trashOpenView = [[UIImageView alloc] initWithImage:trashOpen];
    self.trashCloseView = [[UIImageView alloc] initWithImage:trashClose];
    
    self.trashCloseView.frame = trashPos;
    self.trashOpenView.frame = trashPos;
    
    
    self.trashOpenView.alpha = 0;
    
    [self.view addSubview:self.trashCloseView];
    [self.view addSubview:self.trashOpenView];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(250, 0, 50, 50);
    [btn setTitle:@"+" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:btn];
}

-(void) addImage
{
    UIImage *img = [UIImage imageNamed:@"g"];
    
    self.imgview = [[UIImageView alloc] initWithImage:img];
    self.imgview.userInteractionEnabled = YES;
    [self.view addSubview:self.imgview];
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    
    tap.numberOfTapsRequired = 2;
    
    pinch.delegate = self;
    rotate.delegate = self;
    
    [self.imgview addGestureRecognizer:move];
    [self.imgview addGestureRecognizer:tap];
    [self.imgview addGestureRecognizer:pinch];
    [self.imgview addGestureRecognizer:rotate];

}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) handleRotate:(UIRotationGestureRecognizer *)gest
{
    gest.view.transform = CGAffineTransformRotate(gest.view.transform, gest.rotation);
    gest.rotation = 0;
}


-(void) handleMove:(UIPanGestureRecognizer *)gest
{
    CGPoint location = [gest translationInView:self.view];
    
    
    CGFloat x = gest.view.center.x +location.x;
    CGFloat y = gest.view.center.y + location.y;
    
    gest.view.center = CGPointMake(x, y);

    
    if(gest.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(self.trashCloseView.frame, gest.view.center)) {
        [self moveToTrash:gest];
    }
    
    [gest setTranslation:CGPointMake(0,0) inView:self.view];
}

-(void) handlePinch:(UIPinchGestureRecognizer *)gesture
{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
   
}

- (id)finishRemoveImage:(UIGestureRecognizer *)gest
{
    return ^(BOOL finished) {
        
        if(finished) {
            [gest.view removeFromSuperview];
        }
    };
}

- (void)moveToTrash:(UIGestureRecognizer *)gest
{
    [UIView animateWithDuration:0.5 animations:^{
        self.trashCloseView.alpha = 0;
        self.trashOpenView.alpha = 1;
        
        CGPoint point = [gest locationInView:self.view];
        
        CGFloat x = point.x - self.trashCloseView.center.x;
        CGFloat y = self.trashCloseView.center.y - point.y;
        
        CGFloat angle =  atanf(x/y);
        
        if(y < 0) {
            angle = angle + 180;
        }
        
        NSLog(@" x %f- y %f - angle %f",x, y, angle);
        
        
        [UIView animateWithDuration:4 animations:^{
            
            self.trashCloseView.transform = CGAffineTransformMakeRotation(angle);
            self.trashOpenView.transform = CGAffineTransformMakeRotation(angle);
            gest.view.transform = CGAffineTransformScale(gest.view.transform, 0, 0);
            gest.view.center = self.trashCloseView.center;
            

            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.trashCloseView.transform = CGAffineTransformMakeRotation(0);
                self.trashOpenView.transform = CGAffineTransformMakeRotation(0);
                    self.trashCloseView.alpha = 1;
                    self.trashOpenView.alpha = 0;
                } completion:[self finishRemoveImage:gest]];
            }];    
        }];
}

-(void) handleTap:(UIGestureRecognizer *)gest
{    
    [self moveToTrash:gest];
}

@end
