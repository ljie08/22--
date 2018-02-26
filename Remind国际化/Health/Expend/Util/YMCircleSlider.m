//
//  YMCircleSlider.m
//  DottedLineVIew
//
//  Created by 金朗泰晟 on 17/3/20.
//  Copyright © 2017年 QQ. All rights reserved.
//

#import "YMCircleSlider.h"
#import "NSTimer+timerBlock.h"

//角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
//255进制颜色转换
#define CircleRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//宽高定义
#define CircleSelfWidth  self.frame.size.width
#define CircleSelfHeight self.frame.size.height

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface YMCircleSlider(){
    
    CAShapeLayer * trackLayer;
}


@property (nonatomic, assign) CGFloat fakeProgress;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YMCircleSlider

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame pathBackColor:(UIColor *)pathBackColor pathFillColor:(UIColor *)pathFillColor startAngle:(CGFloat)startAngle strokeWidth:(CGFloat)strokeWidth{
    
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        
        if (pathBackColor) {
            _pathBackColor = pathBackColor;
        }
        if (pathFillColor) {
            _pathFillColor = pathFillColor;
        }
        _startAngle = startAngle;
        _strokeWidth = strokeWidth;
        [self initLayers];
    }
    return self;
}

//初始化数据
- (void)initialization{
    
    self.backgroundColor = [UIColor clearColor];
//    _pathBackColor = CircleRGB(204, 204, 204);
//    _pathFillColor = CircleRGB(219, 184, 102);
//    _strokeWidth = 10;//线宽
//    _startAngle = -CircleDegreeToRadian(90);//起始角度
//    _reduceValue = CircleDegreeToRadian(0);//每次减少的角度
//    _animationModel = kCircleIncreaseByProgress;//动画速度，根据进度
 //   _showPoint = YES;//小圆点
//    _forceRefresh = YES;//刷新动画
//    
//    _fakeProgress = 0.f;//用来逐渐增加，直到等于progress的值
//    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
//    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ZZCircleProgress" ofType:@"bundle"]];
//    _pointImage = [UIImage imageNamed:@"circle_point1" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
    
}

#pragma mark - setters

- (void)setStartAngle:(CGFloat)startAngle{
    
    if (_startAngle != CircleDegreeToRadian(startAngle)) {
        _startAngle = CircleDegreeToRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setReduceValue:(CGFloat)reduceValue{
    
    if (_reduceValue != CircleDegreeToRadian(reduceValue)) {
        if (_reduceValue >= 360) {
            return;
        }
        _reduceValue = CircleDegreeToRadian(reduceValue);
        [self setNeedsDisplay];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth{
    
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        trackLayer.lineWidth = strokeWidth;
        [self setNeedsDisplay];
//        [self addPath:0];
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor{
    
    if (_pathBackColor != pathBackColor) {
        
        _pathBackColor = pathBackColor;
        [self setNeedsDisplay];
//        [self addPath:0];
    }
}

- (void)setPathFillColor:(UIColor *)pathFillColor{
    
    if (_pathFillColor != pathFillColor) {
        
        _pathFillColor = pathFillColor;
        [self setNeedsDisplay];
//        [self addPath:0];
    }
}

- (void)setShowPoint:(BOOL)showPoint{
    
    if (_showPoint != showPoint) {
        _showPoint = showPoint;
        [self setNeedsDisplay];
//        [self addPath:0];
    }
}

- (void)setShowProgressText:(BOOL)showProgressText{
    
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}

- (void)setSliderModel:(kCircleSliderModel)sliderModel{
        _sliderModel = sliderModel;
    
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    //    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0 - 1 - 3;//留出一像素，防止与边界相切的地方被切平
    CGFloat valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue) * _fakeProgress;
        if (sliderModel == kCircleSliderScale) {
                CGFloat space = 0;
                NSArray *arr = [NSArray arrayWithObjects:@"0",@"15",@"30",@"45", nil];
                for (NSInteger i = 0; i<40; i++) {
                    UIImage *img = IMGNAME(@"autoDot");
                    if (i % 10 == 0) {
                        NSInteger index = i / 10;
        
                        CGPoint point1 = center;
                        CGPoint origin = CGPointZero;
                        if (index == 0 || index == 2) {
                            
                            origin.x = point1.x;
                            origin.y = point1.y - radius + _strokeWidth + space;
                            if (index == 2) {
                                origin.y = point1.y + radius - _strokeWidth - space;
                            }
                        }else if (index ==1){
                            origin.x = point1.x + radius - _strokeWidth - space;
                            origin.y = point1.y;
                            
                        }else if (index == 3){
                            origin.x = point1.x - radius + _strokeWidth + space;
                            origin.y = point1.y;
                        }
                        
                        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
                        imgView.center = origin;
                        [self addSubview:imgView];
                        
                        CGRect frame = CGRectMake(0, 0, 25, 25);
//                        frame.origin = origin1;
                        UILabel *label = [[UILabel alloc] initWithFrame:frame];
                        label.text = arr[index];
                        label.font = [UIFont systemFontOfSize:18];
                        label.textColor = [UIColor whiteColor];
                        label.textAlignment = NSTextAlignmentCenter;
                        if (index == 0 || index == 2) {
                            label.centerX = imgView.centerX;
                            if (index == 0) {
                                label.top = imgView.bottom + space;
                            }else{
                            
                                label.bottom = imgView.top - space;

                            }
                        }else{
                            
                            if (index == 1) {
                                label.right = imgView.left - space;
                            }else{
                                
                                label.left = imgView.right + space;
                                
                            }
                            label.centerY = imgView.centerY;
                        }
                        [self addSubview:label];
                        
                    }
                }
        }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:_pointImage];
    imgView.center = [self calculateImgPositionWithCenter:center Angle:valueEndA Radius:radius];
    imgView.tag = 101;
    [self addSubview:imgView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    //    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0 - 1 - 3;//留出一像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (CircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA;
    if (self.angle > 0) {
        valueEndA = ToRad(self.angle);
    }else{
        valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue) * _fakeProgress;  //数值终点位置
    }
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(context, _strokeWidth);
    //线条顶端
    CGContextSetLineCap(context, kCGLineCapRound);
    //线条颜色
    [_pathBackColor setStroke];
    //添加路径到上下文
    CGContextAddPath(context, basePath.CGPath);
    //渲染背景色
    CGContextStrokePath(context);
    
    //路径线
//    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
//    CGContextSetLineCap(context, kCGLineCapRound);
//    [_pathFillColor setStroke];
//    CGContextAddPath(context, valuePath.CGPath);
//    CGContextStrokePath(context);
    
    //显示小圆点
//    if (_showPoint) {
//        CGFloat width = _pointImage.size.width;
//        CGRect frame = CGRectMake(CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-width)/2.f-1)*cosf(valueEndA)-width/2.0 - 2, CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-width)/2.f-1)*sinf(valueEndA)-width/2.0 - 2,width, width);
//        
//        CGContextDrawImage(context, frame, _pointImage.CGImage);
//    }
    
    //显示文字
    if (_showProgressText) {
        NSInteger minute = (int)(ToRad(self.angle)*10) >= 60 ?60:(int)(ToRad(self.angle)*10);
        NSString *currentText = [NSString stringWithFormat:@"%ld分钟",minute];
        //段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;
        //字体
        UIFont *font = [UIFont systemFontOfSize:30];
        //构架属性合集
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
        //获得size
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        //垂直居中
        CGRect rect = CGRectMake((CircleSelfWidth-stringSize.width)/2.0, (CircleSelfHeight - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:rect withAttributes:attributes];
    }
    
}

- (CGPoint)calculateTextPositionWithCenter:(CGPoint)center Angle:(CGFloat)angle Radius:(CGFloat)radius{
    
    CGFloat calRadius = radius;
    CGFloat x = calRadius * cosf(angle);
    CGFloat y = calRadius * sinf(angle);
    return CGPointMake(x + center.x, y + center.y);
    
}

- (void)setProgress:(CGFloat)progress{
    
    if ((_progress == progress && !_forceRefresh)|| progress > 1.0 || progress < 0.0) {
        return;
    }
    
    _fakeProgress = _increaseFromLast == YES?_progress:0.0;//从上次进度开始还是从起点开始
    BOOL isReverse = progress < _fakeProgress ? YES:NO; //是否是反方向
    _progress = progress;
    
    //先暂停计时器
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_progress == 0.0 || _notAnimated) {
        _fakeProgress = _progress;
        [self setNeedsDisplay];
        [self addPath:0];
        return;
    }
    
    //设置每次增加的数值
    CGFloat sameTimeIncreaseValue = _increaseFromLast == YES ? fabs(_fakeProgress - _progress):_progress;
    CGFloat defaultIncreaseValue = isReverse == YES ? -0.01 : 0.01;
    __weak typeof(self) weakSelf = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.005 block:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //反方向动画
        if (isReverse ) {
            if (_fakeProgress <= _progress || _fakeProgress <= 0.0) {
                [strongSelf dealWithLast];
                [strongSelf addPath:0];
                return ;
            }else{
                //进度条动画
                [strongSelf setNeedsDisplay];
                [strongSelf addPath:0];
            }
        }else{
            
            if (_fakeProgress >= _progress || _fakeProgress >=1.0f) {
                [strongSelf dealWithLast];
                [strongSelf addPath:0];
                return;
            }else{
                
                //进度条动画
                [strongSelf setNeedsDisplay];
                [strongSelf addPath:0];
            }
            
        }
        
        //数值增加或者减少
        if (_animationModel == kCircleIncreaseSameTime) {
            _fakeProgress += defaultIncreaseValue*sameTimeIncreaseValue;//不同进度动画时间基本相同
        }else{
            
            _fakeProgress += defaultIncreaseValue;//进度越大动画时间越长
        }
        [strongSelf addPath:0];
    } repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealWithLast{
    
    //最后一次赋值
    _fakeProgress = _progress;
    [self setNeedsDisplay];
    [self addPath:0];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
    //获得中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    
    if (_sliderModel == kCircleSliderProgress) {
        CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
        CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
        CGFloat ra = (lastPoint.x - centerPoint.x) * (lastPoint.x - centerPoint.x) + (lastPoint.y - centerPoint.y) * (lastPoint.y - centerPoint.y);
        if (!(SQR(maxWidth + 20) >= ra && ra >= SQR(radius-15))) {
            return YES;
        }
    }
    
    
    [self movehandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)movehandle:(CGPoint)lastPoint{
    
    //获得中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    
    //计算中心点到任意点的角度
    float currentAngle = AngleFromNorth(centerPoint,
                                        lastPoint,
                                        NO);
    int angleInt = floor(currentAngle);
    
    //保存新角度
    self.angle = angleInt;

    [self addPath:angleInt];
    NSLog(@"angle == %d",angleInt);
    //重新绘制
    [self setNeedsDisplay];
}

-(void)changeAngle:(int)angle{
    _angle = angle;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
//    [self addPath:angle];
    
}

//从苹果是示例代码clockControl中拿来的函数
//计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

- (void)initLayers{

    trackLayer = [ CAShapeLayer  layer];
    
    trackLayer. frame = self. bounds;
    
    [self.layer  addSublayer:trackLayer];
    
    trackLayer. fillColor = [[ UIColor  clearColor]  CGColor];//填充颜色
    
    trackLayer. strokeColor = [[ UIColor  redColor]  CGColor];//边框颜色
    
    trackLayer. opacity =  0.8;
    
    trackLayer.lineCap  = kCALineCapRound ;
    
    trackLayer. lineWidth = _strokeWidth;  // 红色的边框宽度
    
    
    CALayer * gradinetLayer = [ CALayer  layer];
    
    CAGradientLayer  * gradLayer1 = [CAGradientLayer  layer ];
    
    gradLayer1. frame =  CGRectMake( 0,  0,self.frame. size. width, self. frame. size. height);
    
    [gradLayer1 setColors :[ NSArray  arrayWithObjects :( id )[Tools hexStringToColor:@"183b7b"].CGColor,( id )_pathFillColor.CGColor,  nil ]];
    
    [gradLayer1 setLocations: @[@0.1, @0.3, @1  ]];
    
    [gradLayer1 setStartPoint :CGPointMake ( 1 , 0.5 )];
    
    [gradLayer1 setEndPoint: CGPointMake( 0.5,  0)];
    
    [gradinetLayer addSublayer:gradLayer1];
    [gradinetLayer setMask:trackLayer];
    [self.layer  addSublayer:gradinetLayer];
    
//    [self addPath:0];

}


- (void)addPath:(CGFloat)angle{

    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
    CGFloat valueEndA;
    if (angle != 0) {
        CGFloat angle0 = angle >=270 ? angle - 360 : angle;
        valueEndA = ToRad(angle0) ;
    }else{
        valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue) * _fakeProgress;  //数值终点位置
    }
    
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    trackLayer. path = [valuePath  CGPath];
    
    for (UIView *sub in self.subviews) {
        if (sub.tag == 101) {
            [sub removeFromSuperview];
        }
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:_pointImage];
    CGPoint point = [self calculateImgPositionWithCenter:center Angle:valueEndA Radius:radius];
    
    imgView.center = point;
    imgView.tag = 101;
    [self addSubview:imgView];
}

- (CGPoint)calculateImgPositionWithCenter:(CGPoint)center Angle:(CGFloat)angle Radius:(CGFloat)radius{
    
    CGFloat calRadius = radius;
    CGFloat x = calRadius * cosf(angle);
    CGFloat y = calRadius * sinf(angle);
    return CGPointMake(x + center.x, y + center.y);
    
}

@end














