//
//  MLVAdView.m
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

#import "MLVAdView.h"
#import "MLVAdCell.h"

static const NSInteger MLVAdViewSectionNumbers = 1000;

NSNotificationName const MLVAdViewSelectionDidChangeNotification = @"MLVAdViewSelectionDidChangeNotification";

@interface MLVAdView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) NSInteger index;   // index of last visible cell

@property (nonatomic, strong) NSArray *installedConstraints;
@end

@implementation MLVAdView

- (void)dealloc {
    self.collectionView.delegate = nil;
    
    NSLog(@"dealloc ");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.collectionView];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:MLVAdCell.class forCellWithReuseIdentifier:@"MLVAdCell"];
    
    self.interval = 5.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.pagingEnable = YES;
    self.automaticScrollEnable = YES;
    self.index = 0;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [layout invalidateLayout];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)updateConstraints {
    
    if (self.installedConstraints) [NSLayoutConstraint deactivateConstraints:self.installedConstraints];
    
    NSString *visualFormat;
    NSDictionary *views;
    NSDictionary *metrics;
    NSMutableArray *installedConstraints = NSMutableArray.new;
    NSArray *constraints;
    
    if (self.adViewHeader) {
        visualFormat = @"V:|[_adViewHeader(==h1)][_collectionView]";
        views = NSDictionaryOfVariableBindings(_adViewHeader, _collectionView);
        

        if (self.adViewFooter) {
            visualFormat = @"V:|[_adViewHeader(==h1)][_collectionView][_adViewFooter(==h2)]|";
            views = NSDictionaryOfVariableBindings(_adViewHeader, _collectionView, _adViewFooter);
            metrics = @{@"h1" : @(self.adViewHeader.bounds.size.height), @"h2" : @(self.adViewFooter.bounds.size.height)};
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adViewFooter]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_adViewFooter)];
            
            [NSLayoutConstraint activateConstraints:constraints];
            
            [installedConstraints addObjectsFromArray:constraints];
            
        } else {
            visualFormat = @"V:|[_adViewHeader(==h1)][_collectionView]|";
            views = NSDictionaryOfVariableBindings(_adViewHeader, _collectionView);
            metrics = @{@"h1" : @(self.adViewHeader.bounds.size.height)};
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
            
            [NSLayoutConstraint activateConstraints:constraints];
            
            [installedConstraints addObjectsFromArray:constraints];
        }

        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adViewHeader]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_adViewHeader)];
        
        [NSLayoutConstraint activateConstraints:constraints];
        
        [installedConstraints addObjectsFromArray:constraints];
    } else {
        
        if (self.adViewFooter) {
            visualFormat = @"V:|[_collectionView][_adViewFooter(==h2)]|";
            views = NSDictionaryOfVariableBindings(_collectionView, _adViewFooter);
            metrics = @{@"h2" : @(self.adViewFooter.bounds.size.height)};
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adViewFooter]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_adViewFooter)];
            
            [NSLayoutConstraint activateConstraints:constraints];
            
            [installedConstraints addObjectsFromArray:constraints];

        } else {
            visualFormat = @"V:|[_collectionView]|";
            views = NSDictionaryOfVariableBindings(_collectionView);
        }
    }

    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [installedConstraints addObjectsFromArray:constraints];
    
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [installedConstraints addObjectsFromArray:constraints];
    
    self.installedConstraints = [NSArray arrayWithArray:installedConstraints];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
    
    [super updateConstraints];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self stopTimer];
}

#pragma mark - Properties
- (void)setDataSource:(id<MLVAdViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (void)setDelegate:(id<MLVAdViewDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if (_delegate) {
            [self reloadData];
        }
    }
}

- (void)setScrollDirection:(MLVAdViewScrollDirection)scrollDirection {
    
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.scrollDirection = _scrollDirection == MLVAdViewScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        [layout invalidateLayout];

        [self reloadData];
    }
}

- (void)setPagingEnable:(BOOL)pagingEnable {
    
    if (_pagingEnable != pagingEnable) {
        _pagingEnable = pagingEnable;
        
        self.collectionView.pagingEnabled = _pagingEnable;
    }
}

- (void)setAutomaticScrollEnable:(BOOL)automaticScrollEnable {
    
    if (_automaticScrollEnable != automaticScrollEnable) {
        _automaticScrollEnable = automaticScrollEnable;
        
        if (_automaticScrollEnable) {
            [self stopTimer];
            [self startTimer];
        } else {
            [self stopTimer];
        }
    }
}

- (void)setInterval:(NSTimeInterval)interval {
    
    if (_interval != interval) {
        _interval = interval;
        
        if (self.automaticScrollEnable) {
            [self stopTimer];
            [self startTimer];
        }
    }
}

- (void)setAdViewHeader:(UIView *)adViewHeader {
    if (![_adViewHeader isEqual:adViewHeader]) {
        
        if (_adViewHeader) {
            [_adViewHeader removeFromSuperview];
        }
        
        _adViewHeader = adViewHeader;
        
        if (_adViewHeader) {
            
            _adViewHeader.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:_adViewHeader];
        }
        
        [self setNeedsUpdateConstraints];
    }
}

- (void)setAdViewFooter:(UIView *)adViewFooter {
    if (![_adViewFooter isEqual:adViewFooter]) {
        
        if (_adViewFooter) {
            [_adViewFooter removeFromSuperview];
        }
        
        _adViewFooter = adViewFooter;
        
        if (_adViewFooter) {
            
            _adViewFooter.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:_adViewFooter];
        }
        
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - Methods
- (void)reloadData {
    
    self.collectionView.scrollEnabled = YES;
    
    if ([self.dataSource numberOfItemsInAdView:self] < 2) {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:MLVAdViewSectionNumbers / 2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    if (self.automaticScrollEnable) {
        [self stopTimer];
        [self startTimer];
    }
}

#pragma mark - Private methods
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(displayNextAd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)displayNextAd {
    
    if ([self.dataSource numberOfItemsInAdView:self]) {
        
        NSIndexPath *itemIdx = [self.collectionView indexPathsForVisibleItems].lastObject;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIdx.item inSection:MLVAdViewSectionNumbers / 2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        NSInteger idx = itemIdx.item + 1;
        NSInteger section = MLVAdViewSectionNumbers / 2;
        
        if (idx == [self.dataSource numberOfItemsInAdView:self]) {
            idx = 0;
            section++;
        }
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark - UICollection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MLVAdViewSectionNumbers;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX(1, [self.dataSource numberOfItemsInAdView:self]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLVAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLVAdCell" forIndexPath:indexPath];
    
    cell.adView = [self.dataSource adView:self viewForItemAtIndex:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLVAdCell *ad = (MLVAdCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:willDisplayAd:forItemAtIndex:)]) {
        
        if (indexPath.item != self.index) {
            [self.delegate adView:self willDisplayAd:ad.adView forItemAtIndex:indexPath.item];
            self.index = indexPath.item;
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:shouldSelectItemAtIndex:)]) {
        return [self.delegate adView:self shouldSelectItemAtIndex:indexPath.item];
    }
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didSelectedViewAtIndex:)]) {
        [self.delegate adView:self didSelectedViewAtIndex:indexPath.item];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MLVAdViewSelectionDidChangeNotification object:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    collectionView.contentInset = UIEdgeInsetsZero;
    return collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - UIScroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

@end
