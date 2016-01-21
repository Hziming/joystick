//
//  ViewController.h
//  socket-client
//
//  Created by 邹应天 on 15/12/27.
//  Copyright © 2015年 yingtian zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncUdpSocket.h>
#import <GCDAsyncUdpSocket.h>
@interface ViewController : UIViewController<NSStreamDelegate,AsyncUdpSocketDelegate>{
    NSInputStream *_inputStream;//对应输入流
    NSOutputStream *_outputStream;
    
    
}
@property (strong)GCDAsyncUdpSocket *udpSocket;

@end

