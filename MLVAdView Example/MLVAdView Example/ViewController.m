//
//  ViewController.m
//
//  Copyright (c) 2016 NEET. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ViewController.h"
#import <MLVAdView/MLVAdView.h>
#import "AdView.h"

@interface ViewController () <MLVAdViewDataSource, MLVAdViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MLVAdView *adView = [[MLVAdView alloc] initWithFrame:CGRectZero];
    adView.translatesAutoresizingMaskIntoConstraints = NO;
    adView.delegate = self;
    adView.dataSource = self;
    [self.view addSubview:adView];
    
    UIView *header = UIView.new;
    header.frame = CGRectMake(0, 0, 0, 44.);
    header.backgroundColor = UIColor.redColor;
    UILabel *headerTitleLabel = UILabel.new;
    headerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerTitleLabel.text = @"This is adView header";
    [header addSubview:headerTitleLabel];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerTitleLabel(==20.)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerTitleLabel)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerTitleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerTitleLabel)]];
    
    adView.adViewHeader = header;
    
    UIView *footer = UIView.new;
    footer.frame = CGRectMake(0, 0, 0, 44.);
    footer.backgroundColor = UIColor.redColor;
    UILabel *footerTitleLabel = UILabel.new;
    footerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    footerTitleLabel.text = @"This is adView header";
    [footer addSubview:footerTitleLabel];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[footerTitleLabel(==20.)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footerTitleLabel)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footerTitleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footerTitleLabel)]];

    adView.adViewFooter = footer;
    
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[adView(==300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(adView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[adView(==200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(adView)]];
    [NSLayoutConstraint constraintWithItem:adView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.].active = YES;
    [NSLayoutConstraint constraintWithItem:adView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.].active = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        adView.adViewFooter = nil;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        adView.adViewHeader = nil;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        adView.adViewHeader = header;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        adView.adViewFooter = footer;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInAdView:(MLVAdView *)adView {
    return 3;
}

- (UIView *)adView:(MLVAdView *)adView viewForItemAtIndex:(NSUInteger)index {
    
    AdView *ad = [[AdView alloc] init];
    ad.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad_%ld.jpg", (long)index]];
    ad.titleLabel.text = [NSString stringWithFormat:@"ad_%ld", (long)index];

    return ad;
}

- (void)adView:(MLVAdView *)adView willDisplayAd:(UIView *)ad forItemAtIndex:(NSUInteger)index {
    NSLog(@"%ld", index);
}

@end
