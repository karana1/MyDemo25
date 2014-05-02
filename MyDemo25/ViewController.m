//
//  ViewController.m
//  MyDemo25
//
//  Created by karan chopra on 18/04/14.
//  Copyright (c) 2014 karan chopra. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_share:(id)sender
{
    FBShareDialogParams *fbshare = [[FBShareDialogParams alloc]init];
    fbshare.link = [NSURL URLWithString:@"https://in.yahoo.com/?p=us"];
    fbshare.name = @"Yahoo";
    fbshare.caption = @"Yahoo is a great website";
    fbshare.picture = [NSURL URLWithString:@"http://siliconangle.com/files/2014/03/Yahoo-logo.jpg"];
    fbshare.description = @"Yahoo is a complete website for latest news and weather and your email, etc";
    
    if ([FBDialogs canPresentShareDialogWithParams:fbshare])
    {
        [FBDialogs presentShareDialogWithLink:fbshare.link name:fbshare.name caption:fbshare.caption description:fbshare.description picture:fbshare.picture clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error)
         {
             if(error)
             {
                 // An error occurred, we need to handle the error
                 // See: https://developers.facebook.com/docs/ios/errors
                 NSLog(@"Error publishing story: %@", error.description);
             } else
             {
                 // Success
                 NSLog(@"result %@", results);
             }
         }];

    }
    else
    {
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end

