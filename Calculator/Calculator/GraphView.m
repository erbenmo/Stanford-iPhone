//
//  GraphView.m
//  Calculator
//
//  Created by MoErben on 6/9/12.
//  Copyright (c) 2012 MoErben. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end

@implementation GraphView
@synthesize dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    [self setNeedsDisplay];
}

- (void)setup
{
    _scale = 40;
    _origin.x = self.bounds.origin.x + self.bounds.size.width/2;
    _origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

-(void)pinchHandler:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

-(void)panHandler:(UIPanGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

-(void)tripleTapHandler:(UITapGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        self.origin = [gesture locationInView:self];
    }
}

- (void)drawRect:(CGRect)rect {

    [[AxesDrawer class] drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    for(CGFloat w=self.bounds.origin.x; w<=self.bounds.origin.x + self.bounds.size.width; w++) {
        double dw = w - self.origin.x;
        
        double x = dw / self.scale;
        
        double y = [self.dataSource getValue:x];
        double dh = y * self.scale;
        double h = self.origin.y - dh;
        
        //double width = self.bounds.size.width;
        //double height = self.bounds.size.height;
        if(!CGRectContainsPoint(self.bounds, CGPointMake(w, h))) continue;
        
        CGContextMoveToPoint(context, w-0.1, h-0.1);
        CGContextAddLineToPoint(context, w+0.1, h+0.1);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}
@end
