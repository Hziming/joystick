//
//  joyStickV.h
//  socket-client
//
//  Created by 邹应天 on 16/1/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Joystick.h"
@class Joystick;
@interface joyStickV : SKScene

@property Joystick *leftJoystick;
@property Joystick *rightJoystick;

-(void)OrientationLeftRotate;
@end
