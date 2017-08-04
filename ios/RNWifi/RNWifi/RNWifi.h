//
//  RNWifi.h
//  RNWifi
//
//  Created by Michele Mola on 04/08/17.
//  Copyright © 2017 Michele Mola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RNWifi : NSObject <RCTBridgeModule>

- (void) wifiConnect:(NSString *)text;

@end
