//
//  ChatManager.m
//  Symeetry
//
//  Created by Charles Northup on 4/22/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import "ChatManager.h"
#import "ParseManager.h"


@interface ChatManager()

@property MCPeerID* userBasedPeerID;
//@property ChatManager* chatMang;

@end

@implementation ChatManager

#pragma mark -- Helper Methods

-(void)setPeerID
{
    PFUser* user = [ParseManager currentUser];
    self.devicePeerID = [[MCPeerID alloc] initWithDisplayName:user.username];
    self.mySession = [[MCSession alloc] initWithPeer:self.devicePeerID];
    self.mySession.delegate = self;
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"symeetry-txtchat" discoveryInfo:nil session:self.mySession];
    self.advertiserAssistant.delegate = self;
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.userBasedPeerID serviceType:@"symeetry-txtchat"];
    self.browser.delegate = self;
}

-(instancetype)initWithConnectedblock:(void(^)(void))connected connectingBlock:(void(^)(void))connecting lostConnectionBlock:(void(^)(void))lostConnection gotMessage:(void(^)(void))gotMessage;
{
    self.connected = connected;
    self.connecting = connecting;
    self.lostConnection = lostConnection;
    self.gotMessage = gotMessage;
    return self;
}

-(void)inviteToChat:(MCPeerID*)peer completedBlock:(void(^)(void))completionBlock
{
//    MCNearbyServiceBrowser* browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.userBasedPeerID serviceType:@"symeetry-txtchat"];
//    MCBrowserViewController* browserVC = [[MCBrowserViewController alloc]initWithBrowser:browser session:self.mySession];
//    browserVC.delegate = self;
    [self.browser invitePeer:peer toSession:self.mySession withContext:nil timeout:20];
}

-(void)checkoutChat
{
    [self.advertiserAssistant stop];
    [self.browser stopBrowsingForPeers];
}

-(void)checkinChat
{
    [self.advertiserAssistant start];
    [self.browser startBrowsingForPeers];
}

-(void)sendMessage:(NSString*)message peer:(MCPeerID*)peer error:(NSError*)error sent:(void(^)(void))sent
{
    
    [self.mySession sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peer] withMode:MCSessionSendDataReliable error:&error];
    if (error) {
        //do something Aler view or something that says it didn't send
        NSLog(@"didn't send");
    }
    else {
        sent();
    }
}


#pragma mark -- Browser

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Did not start browsing");
}
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"%@", peerID.displayName);
}
-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lostConnection();
    });
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    
}

#pragma -- Advertiser

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    invitationHandler(YES, self.mySession);
    
}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    
}

#pragma mark -- Session

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.gotMessage();
    });
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected: {
            
            NSLog(@"Connected to %@", peerID.displayName);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.connected();
            });
            break;
            
        } case MCSessionStateConnecting: {
            
            NSLog(@"Connecting to %@", peerID);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.connecting();
            });
            
            break;
        } case MCSessionStateNotConnected: {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lostConnection();
            });
            
            break;
        }
    }
    
}

@end
