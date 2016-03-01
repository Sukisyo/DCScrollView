//
//  DCScrollView.m
//  图片轮播器
//
//  Created by ma c on 15/12/11.
//  Copyright © 2015年 bjsxt. All rights reserved.
//

#import "DCScrollView.h"

#import "DCScrollView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "PKReadModel.h"  /////实际情况导入实际的model

#define SCREENHEIGHT self.frame.size.height
#define SCREENWIDTH self.frame.size.width
#define PAGECONTROLLERTAG 201
#define IMAGEBUTTONTAG 7777

@interface DCScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;//底部用于滚动的scrollView
@property (nonatomic,assign) NSUInteger index;//当前图片的索引
@property (nonatomic,strong) NSTimer *timer;//计时器用于控制图片自动滚动
@property (nonatomic,assign) NSInteger count;//用于记录外部传入图片的数量
/**
 *  创建一个数组来接收每个图片按钮带的imageid
 */
@property (nonatomic,strong) NSArray *images;

@end

@implementation DCScrollView

/**
 *  此方法传入的数组是网络加载的图片url的数组
 */
- (instancetype)initWithFrame:(CGRect)frame andImageUrls:(NSArray *)urls {
    self = [super initWithFrame:frame];
    if (self) {
        //记录图片的总数方面后面使用
        self.count = urls.count;
        self.images = urls;
        
        //创建一个底部view，用于承载scrollView和pagecontroller
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [self addSubview:backView];
        //打开响应者链
        backView.userInteractionEnabled = YES;
        
        //创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [backView addSubview:_scrollView];
        _scrollView.delegate = self;
        
        /**
         *  在传进来的图片数组前后分别加入一张图片,最前面加原先的最后一张图，最后面加
         *  原先的第一张图
         */
        NSMutableArray *imageArr = [NSMutableArray arrayWithArray:urls];
        [imageArr insertObject:[urls firstObject] atIndex:urls.count];
        [imageArr insertObject:[urls lastObject] atIndex:0];
        
        for (NSUInteger i = 0; i < imageArr.count; i++) {
            //创建图片按钮
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.tag = IMAGEBUTTONTAG + i;
            [imageButton setFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT)];
            //调用SDWebImage加载图片   //////数组获取图片url的get方法实际情况用实际参数
            [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[imageArr[i] img]] forState:UIControlStateNormal];
            //设置imageButton的点击方法
            [imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:imageButton];
            
        }
        
        //设置scrollView的contentSize为（原先图片数量 + 2） * width
        [_scrollView setContentSize:CGSizeMake((self.count+2) * SCREENWIDTH, SCREENHEIGHT)];
        [_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
        //设置scrollView相关的一些属性
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        
        
        
        //加载pageController
        CGFloat pageH = 20;
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - pageH, SCREENWIDTH,pageH)];
        pageController.tag = PAGECONTROLLERTAG;
        [backView addSubview:pageController];
        //设置背景色
        [pageController setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]];
        //设置圆点个数
        [pageController setNumberOfPages:self.count];
        
        
        //初始化一个计时器，执行过一段时间滚动轮播器的操作
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        //消息循环
        //        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        //        [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.index = 1;
        
        
    }
    
    return self;
}
/**
 *  此方法传入的数组是本地的image图片数组
 */
- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        //记录图片的总数方面后面使用
        self.count = images.count;
        self.images = images;
        
        //创建一个底部view，用于承载scrollView和pagecontroller
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [self addSubview:backView];
        //打开响应者链
        backView.userInteractionEnabled = YES;
        
        //创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [backView addSubview:_scrollView];
        _scrollView.delegate = self;
        
        /**
         *  在传进来的图片数组前后分别加入一张图片,最前面加原先的最后一张图，最后面加
         *  原先的第一张图
         */
        NSMutableArray *imageArr = [NSMutableArray arrayWithArray:images];
        [imageArr insertObject:[images firstObject] atIndex:images.count];
        [imageArr insertObject:[images lastObject] atIndex:0];
        
        for (NSUInteger i = 0; i < imageArr.count; i++) {
            //创建图片按钮
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.tag = IMAGEBUTTONTAG + i;
            [imageButton setFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT)];
            //加载图片
            [imageButton setImage:images[i] forState:UIControlStateNormal];
            //设置imageButton的点击方法
            [imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imageButton];
            
        }
        
        //设置scrollView的contentSize为（原先图片数量 + 2） * width
        [_scrollView setContentSize:CGSizeMake((self.count+2) * SCREENWIDTH, SCREENHEIGHT)];
        [_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
        //设置scrollView相关的一些属性
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        
        
        
        //加载pageController
        CGFloat pageH = 20;
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - pageH, SCREENWIDTH,pageH)];
        pageController.tag = PAGECONTROLLERTAG;
        [backView addSubview:pageController];
        //设置背景色
        [pageController setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]];
        //设置圆点个数
        [pageController setNumberOfPages:self.count];
        
        
        //初始化一个计时器，执行过一段时间滚动轮播器的操作
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        //消息循环
        //        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        //        [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.index = 1;
        
        
    }
    
    return self;
    
}


//自动滚动轮播器的操作
- (void)nextPage {
    
    //设置本次scrollView应该滚动到的位置
    CGPoint offset = CGPointMake(self.scrollView.frame.size.width * self.index, 0);
    //获得pagecontroller对象
    UIPageControl *pageControl = (UIPageControl *)[self.scrollView.superview viewWithTag:PAGECONTROLLERTAG];
    /**
     *  为保证最后一张图能连贯地滚动到第一张图，在图片数组后加的那张图片在
     *  此起作用。当滚动到倒数第二张图时，让之滚动到第一张图的替代（最后一张
     *  图）上，并在滚动结束的那一刻将图片直接切换到第一张图上。其他滚动操作
     *  无什么特别之处
     */
    if (self.index == self.count + 1) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:offset];
            pageControl.currentPage = 0;
        }completion:^(BOOL finished) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:offset];
            pageControl.currentPage = self.index - 1;
        }];
    }
    //当图片滚动到最后一张图的时候需要让索引指向第二张，以保证轮播连贯进行
    if (self.index == self.count + 1) {
        self.index = 2;
    }else {
        self.index ++;
    }
    
}
//imageButton的点击方法
- (void)imageButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(postForInfoWithImageid:)]) {
        ////////数组获取图片url的get方法实际情况用实际参数
        [self.delegate postForInfoWithImageid:[self.images[sender.tag - IMAGEBUTTONTAG - 1] urlid]];
    }
}


//scrollView的代理方法
#pragma mark - UIScrollViewDelegate
//当对scrollView进行拖动的时候终止计时器的计时操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}
//当对scrollView的拖动停止时，重新开始对计时器的计时操作
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate distantPast]];
}
/**
 *  滚动轮播器不仅支持自动滚动，还应支持手动滑动
 *  因此设置此代理方法。之所以用这个方法而不是上一方法是因为这一方法能精准判
 *  断scrollView停止滑动的那一刻，而上一方法会造成一瞬间的卡屏
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //获取结束滑动时的偏移量
    CGPoint offest = scrollView.contentOffset;
    //获取pagecontroller控件
    UIPageControl *pageControl = (UIPageControl *)[scrollView.superview viewWithTag:PAGECONTROLLERTAG];
    //当滑动到最后一张图（数组的第一张图的替代）时
    if (offest.x == self.frame.size.width * (self.count + 1)) {
        //将图片滑动到数组的第一张图上
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        pageControl.currentPage = 0;
        //当滑动到第一张图（数组的最后一张图的替代）时
    }else if (offest.x == 0){
        //将图片滑动到数组的最后一张图上
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * (self.count), 0)];
        pageControl.currentPage = self.count - 1;
    }else {
        pageControl.currentPage = (offest.x - self.frame.size.width) / self.frame.size.width;
    }
    //通过pagecontroller当前显示的页数获得当前页数的索引
    self.index = pageControl.currentPage + 1;
}

@end
