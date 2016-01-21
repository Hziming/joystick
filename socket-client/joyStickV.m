//
//  joyStickV.m
//  socket-client
//
//  Created by 邹应天 on 16/1/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "joyStickV.h"
#import "Joystick.h"
@interface joyStickV()
@property (strong,nonatomic) SKSpriteNode *jsThumb;
@property (strong,nonatomic) SKSpriteNode *jsBackdrop;
@property (strong,nonatomic) SKSpriteNode *jsThumb2;
@property (strong,nonatomic) SKSpriteNode *jsBackdrop2;
@end
@implementation joyStickV
-(id)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
        
    self.jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
    self.jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];

    self.leftJoystick = [Joystick joystickWithThumb:self.jsThumb andBackdrop:self.jsBackdrop];
    self.jsThumb2 = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
    self.jsBackdrop2 = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
    
    self.rightJoystick = [Joystick joystickWithThumb:self.jsThumb2 andBackdrop:self.jsBackdrop2];
    [self OrientationLeftRotate];
    return self;
}
-(void)didMoveToView:(SKView *)view{
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
}
//-(void)OrientationProtrait{
//    
//    
//    
//    self.leftJoystick.position = CGPointMake(self.jsBackdrop.size.width, self.jsBackdrop.size.height);
//    self.rightJoystick.position = CGPointMake(self.leftJoystick.position.x*2, self.leftJoystick.position.y);
//    
//    [self addChild:self.leftJoystick];
//    [self addChild:self.rightJoystick];
//}
-(void)OrientationLeftRotate{
    //CGSize tempsize = self.size;
    //NSLog(@"{%f %f}",self.frame.size.height);
    //self.size = CGSizeMake(tempsize.height, tempsize.width);
    self.leftJoystick.position = CGPointMake(self.frame.size.width/2-200,self.frame.size.height/2-100);
    self.rightJoystick.position = CGPointMake(self.frame.size.width/2+200, self.leftJoystick.position.y);
    
    [self addChild:self.leftJoystick];
    [self addChild:self.rightJoystick];
}
@end
