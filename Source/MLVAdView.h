//
//  MLVAdView.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Enum that specifies the scroll direction of the adView
 */
typedef NS_ENUM(NSInteger, MLVAdViewScrollDirection) {
    MLVAdViewScrollDirectionVertical,
    MLVAdViewScrollDirectionHorizontal
};

@protocol MLVAdViewDataSource, MLVAdViewDelegate;

UIKIT_EXTERN NSNotificationName const MLVAdViewSelectionDidChangeNotification;

@interface MLVAdView : UIView

/**
 *  AdView data source default nil. weak reference
 */
@property (nonatomic, weak, nullable) id<MLVAdViewDataSource> dataSource;

/**
 *  AdView delegate default nil. weak reference
 */
@property (nonatomic, weak, nullable) id<MLVAdViewDelegate> delegate;

/**
 *  Accessory view for above ad content. default is nil. not to be confused with adView, the size of header will automatically adjust to adViewHeader's height and adView's container width
 */
@property (nonatomic, strong, nullable) UIView *adViewHeader;

/**
 *  Accessory view for below ad content. default is nil. not to be confused with adView, the size of header will automatically adjust to adViewHeader's height and adView's container width
 */
@property (nonatomic, strong, nullable) UIView *adViewFooter;

/**
 *  AdView automatic scroll time interval, default is 5.
 */
@property (nonatomic) NSTimeInterval interval;

/**
 *  AdView scroll direction, default is MLVAdViewScrollDirectionHorizontal
 */
@property (nonatomic) MLVAdViewScrollDirection scrollDirection;

/**
 *  Default NO. if YES, stop on multiples of view bounds
 */
@property (nonatomic) BOOL pagingEnable;

/**
 *  AdView automatic scroll enable, default is YES. if NO, adView will stop and never scroll automatically
 */
@property (nonatomic) BOOL automaticScrollEnable;

/**
 *  Discard the dataSource and delegate data and requery as necessary
 */
- (void)reloadData;

@end


@protocol MLVAdViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemsInAdView:(MLVAdView *)adView;

/**
 *  The view that display in adView, the size of view will automatically adjust to adView's container
 */
- (UIView *)adView:(MLVAdView *)adView viewForItemAtIndex:(NSUInteger)index;
@end


@protocol MLVAdViewDelegate <NSObject>

@optional

/**
 *  Methods for notification of selection/deslection events.
 *  The sequence of calls leading to selection from a user touch is:
 *
 *  (when the touch lifts)
 *  1. -adView:shouldSelectItemAtIndex:
 *  2. -adView:didSelectItemAtIndex:
 */
- (BOOL)adView:(MLVAdView *)adView shouldSelectItemAtIndex:(NSUInteger)index;

- (void)adView:(MLVAdView *)adView didSelectedViewAtIndex:(NSUInteger)index;


- (void)adView:(MLVAdView *)adView willDisplayAd:(UIView *)ad forItemAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
