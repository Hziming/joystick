//
//  ViewController.m
//  socket-client
//
//  Created by 邹应天 on 15/12/27.
//  Copyright © 2015年 yingtian zou. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>
#import <SpriteKit/SpriteKit.h>
#import "joyStickV.h"
#import "Joystick.h"
#define UDP_PORT 8080
@interface ViewController (){
    joyStickV* hello ;
}

@end

@implementation ViewController

-(void)viewWillLayoutSubviews{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    //注册横屏通知
    //[self loadSocketData];
    //[self UDPsocketDataLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    SKView *spriteView = (SKView *)self.view;
    spriteView.ignoresSiblingOrder = YES;
   // NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    CGSize tempsize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width) ;
    hello = [[joyStickV alloc] initWithSize:tempsize];
    [spriteView presentScene: hello];
    
    
    CADisplayLink *velocityTick = [CADisplayLink displayLinkWithTarget:self selector:@selector(joystickMovement)];
    [velocityTick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];


}

//joystick使用
-(void)joystickMovement;
{   //    if (joystick.velocity.x != 0 || joystick.velocity.y != 0)
//    {
//        NSLog(@"正在操控飞机");
//        //drone.position = CGPointMake(player.position.x + .1 *joystick.velocity.x, player.position.y + .1 * joystick.velocity.y);
//        
//    }
    if (hello.rightJoystick.velocity.x > 0)
    {
        //[drone walkRightAnim];
    }
    else if (hello.rightJoystick.velocity.x < 0)
    {
        //[drone walkLeftAnim];
    }
    if (hello.rightJoystick.velocity.y > 0)
    {
        NSLog(@"0XB1 towards");
        //[drone walkUpAnim];
    }
    else if (hello.rightJoystick.velocity.y < 0)
    {  NSLog(@"0XB2 backwards");
       // [drone walkDownAnim];
    }
    if (hello.rightJoystick.velocity.x == 0 && hello.rightJoystick.velocity.y == 0)
    {
        //[drone idleAnim];
    }
}

#pragma  mark -- 横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
//- (void)statusBarOrientationChange:(NSNotification *)notification
//{
//    //WClassAndFunctionName;
//    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
//    //NSLog(@"orientation is %ld",(long)oriention);
//   // [self adaptUIBaseOnOriention:oriention];//比如改变self.frame
//    switch (oriention) {
//        case 1:
//            break;
//        case 2:
//            break;
//        case 3:[hello OrientationLeftRotate];//left rotate
//            NSLog(@"向左");
//            break;
//        default:
//            break;
//    }
//}
- (BOOL)shouldAutorotate
{
    return YES;
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else {
//        return UIInterfaceOrientationMaskAll;
//    }
//}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)loadSocketData{
    //NSString *host = @"119.29.76.253";
    NSString *host = @"192.168.1.99";//模块ip
    //int port = 5000;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(host), UDP_PORT, &readStream, &writeStream);
    
    _inputStream = (__bridge NSInputStream *)(readStream);
    _outputStream = (__bridge NSOutputStream *)(writeStream);
    
    _inputStream.delegate=self;
    _outputStream.delegate=self;
    
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
    
    NSString *msgStr=@"int 8";
    NSData *data = [msgStr dataUsingEncoding:NSUTF8StringEncoding];
    [_outputStream write:data.bytes maxLength:data.length];
}
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
        switch (eventCode) {
                         case NSStreamEventOpenCompleted:
                             NSLog(@"输入输出流打开完成");
                             break;
                         case NSStreamEventHasBytesAvailable:
                             NSLog(@"有字节可读");
                             [self readData];
                             break;
                         case NSStreamEventHasSpaceAvailable:
                             NSLog(@"可以发送字节");
                             break;
                         case NSStreamEventErrorOccurred:
                                         NSLog(@" 连接出现错误");
                             break;
                         case NSStreamEventEndEncountered:
                             NSLog(@"连接结束");
                             [_inputStream close];
                             [_outputStream close];
    
                  //从主循环中移除
                  [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                  [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
     break;
                 default:
                break;
        }
    //
}
-(void)readData{
    //int (无符号字节)
    uint8_t buf[1024]; //建立一个缓冲区 可以放1024个字节
    NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];  // 返回实际装的字节数
    
     NSData *data = [NSData dataWithBytes:buf length:len];// 把字节数组转化成字符串
     NSString *recStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ \n%@",data,recStr);
    
}

-(void)UDPsocketDataLoad{
    dispatch_queue_t udpSocketQueue=dispatch_queue_create("com.manmanlai.updSocketQueue", DISPATCH_QUEUE_CONCURRENT);
    self.udpSocket= [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:udpSocketQueue];
//    NSString *str = @"data from 192.168.1.101(zyt)";
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//    [self.udpSocket sendData:data
//                      toHost:@"192.168.1.99"
//                        port:UDP_PORT
//                 withTimeout:-1
//                         tag:0];
    
    //self.udpSocket bindToPort:<#(uint16_t)#> error:<#(NSError *__autoreleasing *)#>
    //[self.udpSocket joinMulticastGroup:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>]
    [self startUdpSocket];
    
//    AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc]initWithDelegate:self];
//    NSError *error;
//    [tempSocket bindToPort:4333 error:&error];
//    [tempSocket joinMulticastGroup:@"" error:&error];
//    [tempSocket receiveWithTimeout:-1 tag:0];
    
}

- (void)startUdpSocket
{
    NSError *error = nil;
    
    if (![self.udpSocket bindToPort:UDP_PORT error:&error])
    {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    if (![self.udpSocket beginReceiving:&error])
    {
        [self.udpSocket close];
        
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    
    NSLog(@"Udp Echo server started on port %hu", [self.udpSocket localPort]);
    NSLog(@"localHost %@",[self.udpSocket localHost]);
    NSString *string=[[NSString alloc]initWithData:[self.udpSocket localAddress] encoding:NSUTF8StringEncoding];
    NSLog(@"localAddress %@",string);
}

- (void)stopUdpSocket
{
    [self.udpSocket close];
}
#pragma mark --接受数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
    
}

#pragma mark --发送数据
-(void)sendData:(NSData *)data toAddress:(NSData *)remoteAddr withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    NSString *str = @"data from 192.168.1.101(zyt)";
    data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data
                      toHost:@"192.168.1.99"
                        port:UDP_PORT
                 withTimeout:-1
                         tag:0];
}

#pragma mark the filter
//    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//
//    //imageV.image=[UIImage imageNamed:@"image.jpg"];
//
//
//    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels=15.0;
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:[UIImage imageNamed:@"image.jpg"]];
//    //原生高斯模糊
////    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
////    view.frame=imageV.frame;
//    //view.alpha=;
//
//    imageV.image=blurredImage;
//    //imageV.image=[UIImage imageNamed:@"image.jpg"];
//    //[self.view addSubview:imageV];
//    [self.view addSubview:imageV];
//    //[self loadSocketData];
//
//
//    GPUImageView *imageView=[[GPUImageView alloc]initWithFrame:imageV.frame];
//
//
//    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
//
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//    videoCamera.horizontallyMirrorRearFacingCamera = NO;
//
//    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
//
//
//    [videoCamera addTarget:filter];
//    [filter addTarget:imageView];
//    [videoCamera startCameraCapture];

@end
