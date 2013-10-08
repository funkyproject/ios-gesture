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
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *img = [UIImage imageNamed:@"g"];

    CGFloat w = img.size.width;
    CGFloat h = img.size.height;
    
    CGRect rect = CGRectMake(0,0,w,h);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = img.CIImage;
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"InputIntensity"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey]; // 4
    CGImageRef cgImage = [context createCGImage:result fromRect:rect];
    
    UIImage *imgFiltered = [UIImage imageWithCGImage:cgImage];
    
    self.imgview = [[UIImageView alloc] initWithImage:imgFiltered];
    self.imgview.userInteractionEnabled = YES;
    [self.view addSubview:self.imgview];
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    
    tap.numberOfTapsRequired = 2;
    
    [self.imgview addGestureRecognizer:move];
    [self.imgview addGestureRecognizer:tap];
    [self.imgview addGestureRecognizer:pinch];
    [self.imgview addGestureRecognizer:rotate];
}

-(void) handleRotate:(UIRotationGestureRecognizer *)gest
{
    gest.view.transform = CGAffineTransformRotate(gesture.view.transform, gest.rotation);
    gest.rotation = 0;
}


-(void) handleMove:(UIGestureRecognizer *)gest
{
    CGPoint location = [gest locationInView:self.view];
    gest.view.center = location;
}

-(void) handlePinch:(UIPinchGestureRecognizer *)gesture
{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
   
}

-(void) handleTap:(UISwipeGestureRecognizer *)gest
{
    [UIView animateWithDuration:1 animations:^{
        gest.view.center = self.view.center;
    }];
}


@end
