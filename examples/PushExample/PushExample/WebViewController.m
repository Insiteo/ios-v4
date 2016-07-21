//
//  WebViewController.m
//  PushExample
//
//  Created by Lionel Rossignol on 18/07/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

// Used to keep aspect ratio 16:9 for web view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *portraitConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *landscapeConstraint;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add tap gesture recognizer on main view to close the web view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onCloseButtonTap:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Constraints

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Update content view constraint for web view ratio
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        self.portraitConstraint.active = YES;
        self.landscapeConstraint.active = NO;
    } else {
        self.landscapeConstraint.active = YES;
        self.portraitConstraint.active = NO;
    }
}

#pragma mark - URL loading

- (void)loadURL:(NSURL *)url {
    // Load URL in web view
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - IBActions

- (IBAction)onCloseButtonTap:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        self.webView.delegate = nil;
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIScrollView *scroll = [webView scrollView];
    float zoom = webView.bounds.size.width / scroll.contentSize.width;
    scroll.zoomScale = MIN(MAX(zoom, scroll.minimumZoomScale), scroll.maximumZoomScale);
    [scroll setZoomScale:zoom animated:YES];
}

@end
