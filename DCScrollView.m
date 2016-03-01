//
//  DCScrollView.m
//  图片轮播器
//
//  Created by ma c on 15/12/11.
//  Copyright © 2015年 bjsxt. All rights reserved.
//

#import "DCScrollView.h"

#define SCREENHEIGHT frame.size.height
#define SCREENWIDTH frame.size.width
#define PAGECONTROLLERTAG 201

@interface DCScrollView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *images;

@end

@implementation DCScrollView

- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.images = images;
        //对自定义控件的外观进行设置
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT)];
        [self addSubview:backView];
        backView.userInteractionEnabled = YES;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [backView addSubview:scrollView];
        scrollView.delegate = self;
        self.scrollView = scrollView;
        
        for (NSUInteger i = 0; i < images.count; i++) {

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT)];
            imageView.image = images[i];
            [scrollView addSubview:imageView];
        }
        
        
        /***************在最后加一张图片******************/

        
        UIImageView *preView = [[UIImageView alloc] initWithFrame:CGRectMake(images.count * frame.size.width, 0, frame.size.width, frame.size.height)];
        preView.image = images[0];
        [scrollView addSubview:preView];
        
        
        /**********************************************/

        
        [scrollView setContentSize:CGSizeMake((images.count+1) * SCREENWIDTH, SCREENHEIGHT)];
        [scrollView setContentOffset:CGPointZero];
        
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        
        [scrollView setPagingEnabled:YES];
        [scrollView setBounces:NO];
        
        
        
        //加载pageController
        CGFloat pageH = SCREENHEIGHT / images.count;
        pageH = pageH > 20 ? pageH : 20;
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - pageH, SCREENWIDTH,pageH)];
        pageController.tag = PAGECONTROLLERTAG;
        [backView addSubview:pageController];
        //设置背景色
        [pageController setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]];
        //设置圆点个数
        [pageController setNumberOfPages:images.count];
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        self.index = 0;
}

    return self;
}

- (void)nextPage {
    if (self.index == self.images.count) {
        self.index = 0;
    }else {
        self.index ++;
    }
    CGPoint offset = CGPointMake(self.scrollView.frame.size.width * self.index, 0);
    UIPageControl *pageControl = (UIPageControl *)[self.scrollView.superview viewWithTag:PAGECONTROLLERTAG];
    
    if (self.index == self.images.count ) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:offset];
            self.index = 0;
            pageControl.currentPage = self.index;
        }completion:^(BOOL finished) {
            [self.scrollView setContentOffset:CGPointZero];
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:offset];
            pageControl.currentPage = self.index;
        }];
    }
    

    
    
    
    
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    UIPageControl *pageControl = (UIPageControl *)[scrollView.superview viewWithTag:PAGECONTROLLERTAG];
    pageControl.currentPage = offset.x / scrollView.frame.size.width;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate distantPast]];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
