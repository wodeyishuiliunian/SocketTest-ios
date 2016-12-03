//
//  ViewController.m
//  SocketTestKeHu
//
//  Created by 三米 on 16/12/2.
//  Copyright © 2016年 pang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 和服务器进行链接
- (IBAction)connect:(UIButton *)sender
{

    
    
    // 1. 创建socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 与服务器的socket链接起来
    NSError *error = nil;
    BOOL result = [self.socket connectToHost:self.IPText.text onPort:self.portText.text.integerValue error:&error];
    
    // 3. 判断链接是否成功
    if (result) {
        [self addText:@"客户端链接服务器成功"];
    } else {
        [self addText:@"客户端链接服务器失败"];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
// 发送消息
- (IBAction)sendMassage:(UIButton *)sender
{
    [self.socket writeData:[self.sendMsgText.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [self.socket readDataWithTimeout:-1 tag:0];
}
// 客户端链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self addText:[NSString stringWithFormat:@"链接服务器%@", host]];
    [self.socket readDataWithTimeout:-1 tag:0];
    
   
}
-(IBAction)clearMsg:(id)sender
{
    self.readMsgText.text = @"";
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
//    [_socket readDataWithTimeout:-1 tag:tag];
}
// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.socket readDataWithTimeout:-1 tag:0];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:content];
    [self.socket readDataWithTimeout:-1 tag:0];
    
}
-(IBAction)disconnect:(id)sender
{
    [self.socket disconnect];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"%@",err);
}
// textView填写内容
- (void)addText:(NSString *)text
{
    self.readMsgText.text = [self.readMsgText.text stringByAppendingFormat:@"%@\n", text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
