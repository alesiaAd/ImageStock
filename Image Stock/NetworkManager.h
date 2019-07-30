//
//  NetworkManager.h
//  Image Stock
//
//  Created by Alesia Adereyko on 19/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModel.h"
#import <WebKit/WebKit.h>

@class NetworkManager;
@protocol NetworkManagerDelegate <NSObject>

- (void)imageModelLoaded:(ImageModel *)model;
- (void)loginCompleted:(NetworkManager *)manager;
- (void)didFailWithError:(NSError *)error;

@end

@interface NetworkManager : NSObject

@property (nonatomic, retain) ImageModel *model;
@property (nonatomic, retain) WKWebView *webview;

@property (nonatomic, assign) id <NetworkManagerDelegate> delegate;

- (void)loadImageModels;
- (void)authorize;
- (BOOL)isLoggedIn;

@end
