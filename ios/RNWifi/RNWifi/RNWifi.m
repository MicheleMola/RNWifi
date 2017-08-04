//
//  RNWifi.m
//  RNWifi
//
//  Created by Michele Mola on 04/08/17.
//  Copyright © 2017 Michele Mola. All rights reserved.
//

#import "RNWifi.h"
#import <React/RCTBridge.h>
#import <React/RCTLog.h>

@implementation RNWifi


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(wifiConnect:(NSString *)text) {
    
    RCTLogInfo("Ciao mondo");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://localhost:8081/start/"]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    _httpServer = [[RoutingHTTPServer alloc] init];
    [_httpServer setPort:8081];                               // TODO: make sure this port isn't already in use
    
    _firstTime = TRUE;
    [_httpServer handleMethod:@"GET" withPath:@"/start" target:self selector:@selector(handleMobileconfigRootRequest:withResponse:)];
    [_httpServer handleMethod:@"GET" withPath:@"/load" target:self selector:@selector(handleMobileconfigLoadRequest:withResponse:)];
    
    NSMutableString* path = [NSMutableString stringWithString:[[NSBundle mainBundle] bundlePath]];
    [path appendString:@"/skipSignProfile.mobileconfig"];
    _mobileconfigData = [NSData dataWithContentsOfFile:path];
    
    [_httpServer start:NULL];
    
    return YES;
}

- (void)handleMobileconfigRootRequest:(RouteRequest *)request withResponse:(RouteResponse *)response {
    NSLog(@"handleMobileconfigRootRequest");
    [response respondWithString:@"<HTML><HEAD><title>Profile Install</title>\
     </HEAD><script> \
     function load() { window.location.href='http://localhost:8000/load/'; } \
     var int=self.setInterval(function(){load()},400); \
     </script><BODY></BODY></HTML>"];
}

- (void)handleMobileconfigLoadRequest:(RouteRequest *)request withResponse:(RouteResponse *)response {
    if( _firstTime ) {
        NSLog(@"handleMobileconfigLoadRequest, first time");
        _firstTime = FALSE;
        
        [response setHeader:@"Content-Type" value:@"application/x-apple-aspen-config"];
        [response respondWithData:_mobileconfigData];
    } else {
        NSLog(@"handleMobileconfigLoadRequest, NOT first time");
        [response setStatusCode:302]; // or 301
        [response setHeader:@"Location" value:@"yourapp://custom/scheme"];
    }
}


@end


