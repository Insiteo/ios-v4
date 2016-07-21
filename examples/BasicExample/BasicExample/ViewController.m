//
//  ViewController.m
//  BasicExample
//
//  Created by Lionel Rossignol on 18/07/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import "ViewController.h"

#import <InsiteoSDKCore/InsiteoSDKCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)onSendAnalyticsButtonTap:(id)sender {
    NSError *error;
    if (![INSAnalytics trackCustomEvent:@"sample_anayltics_button_tap"
                               metadata:@{ @"my_custom_data": @"my_id" }
                                  debug:YES // or NO
                                  error:&error]) {
        NSLog(@"Analytics custom tracking failed: %@", error.localizedDescription);
    }
}

@end
