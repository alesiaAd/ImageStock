//
//  NetworkManager.m
//  Image Stock
//
//  Created by Alesia Adereyko on 19/07/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "NetworkManager.h"

static const NSString *accessKey = @"7870abaa34938ea359c44341421766686e772247d86051c0ed208b866bf87b17";
static const NSString *secretKey = @"6bad3cef0ba374a47fc8b5b53cfca3fe3d34cf96db7f7f66cb1a5d36882090c8";
static NSMutableString *code;

@interface NetworkManager() <WKNavigationDelegate>

@end

@implementation NetworkManager

- (void)authorize {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?client_id=%@&redirect_uri=urn%%3Aietf%%3Awg%%3Aoauth%%3A2.0%%3Aoob&response_type=code&scope=public", accessKey]];
    
    self.webview.navigationDelegate = self;
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
    [self.webview loadRequest:nsrequest];
}

- (BOOL)isLoggedIn {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] != nil;
}

- (void)getAuthorizationResponseSuccess:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure {
    NSURL *urlPost = [NSURL URLWithString:@"https://unsplash.com/oauth/token"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:urlPost] autorelease];
    NSString *postParams = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&redirect_uri=urn%%3Aietf%%3Awg%%3Aoauth%%3A2.0%%3Aoob&code=%@&grant_type=authorization_code", accessKey, secretKey, code];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            failure(error);
        } else {
            NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(json);
        }
    }];
    [dataTask resume];
}

- (void)getAuthirizationResponse {
    [self getAuthorizationResponseSuccess:^(NSDictionary *responseDict) {
        NSString *accessToken = [responseDict valueForKey:@"access_token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"accessToken"];
        [defaults synchronize];
        dispatch_async(dispatch_get_main_queue(), ^(void){            
            [self.delegate loginCompleted:self];
        });
    } failure:^(NSError *error) {
        [self.delegate didFailWithError:error];
    }];
}

- (void)getModelsResponseSuccess:(void (^)(NSArray *responseDict))success failure:(void(^)(NSError* error))failure {
    NSURL *url = [NSURL URLWithString:@"https://api.unsplash.com/photos/random?count=10"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]) {
        [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", accessKey] forHTTPHeaderField:@"Authorization"];
    }
    [urlRequest setValue:[NSString stringWithFormat:@"Client-ID %@", accessKey] forHTTPHeaderField:@"Authorization"];
    
    urlRequest.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            failure(error);
        } else {
            NSError *error = nil;
            NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error == nil) {
                success(json);
            } else {
                [self.delegate didFailWithError:error];
            }
        }
    }];
    [dataTask resume];
}

- (void)loadImageModels {
    [self getModelsResponseSuccess:^(NSArray *responseArray) {
        for (NSDictionary *responseDict in responseArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.model = [self parseModelFromJson:responseDict];
                [self.delegate imageModelLoaded:self.model];
            });
        }
    } failure:^(NSError *error) {
        [self.delegate didFailWithError:error];
    }];
}

- (ImageModel *)parseModelFromJson:(NSDictionary *)json {
    ImageModel *model = [[ImageModel new] autorelease];
    model.url = [[json valueForKey:@"urls"] valueForKey:@"regular"];
    model.fullSize = CGSizeMake([[json valueForKey:@"width"] floatValue], [[json valueForKey:@"height"] floatValue]);
    model.status = LoadingProgressStatusNotLoaded;
    model.image = [UIImage imageNamed:@"noPicture"];
    if ([json valueForKey:@"alt_description"] != (id)[NSNull null]) {
        model.imgDescription = [json valueForKey:@"alt_description"];
    }
    model.userName = [[json valueForKey:@"user"] valueForKey:@"name"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'-'HH:mm"];
    model.creationDate = [dateFormatter dateFromString:[json valueForKey:@"created_at"]];
    [dateFormatter release];
    model.likesAmount = [[json valueForKey:@"likes"] integerValue];
    if ([[json valueForKey:@"location"] valueForKey:@"title"]) {
        model.location = [NSString stringWithFormat:@"%@", [[json valueForKey:@"location"] valueForKey:@"title"]];
    }
    model.imageId = [json valueForKey:@"id"];
    return model;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSURL *url = [webView URL];
    NSString *urlString = url.absoluteString;
    if ([urlString hasPrefix:@"https://unsplash.com/oauth/authorize/native?code="]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        code = [[self valueForKey:@"code"
                   fromQueryItems:queryItems] mutableCopy];
        [self getAuthirizationResponse];
    }
}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (void)dealloc {
    self.model = nil;
    self.webview = nil;
    [super dealloc];
}

@end
