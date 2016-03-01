//
//  DCScrollView.h
//  图片轮播器
//
//  Created by ma c on 15/12/11.
//  Copyright © 2015年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  因为实际app上滚动轮播器的图片都是有点击事件的，所有在这里设置该自定义控件
 *  的代理方法来实现这个功能
 */
@protocol PostForInfoDelegate <NSObject>

- (void)postForInfoWithImageid:(NSString *)imageid;

@end

@interface DCScrollView : UIView

@property (nonatomic,weak) id<PostForInfoDelegate> delegate;

//自定义初始化方法，指定scrollView大小和图片轮播的对象
/**
 *  此方法传入的数组是网络加载的图片url的数组
 */
- (instancetype)initWithFrame:(CGRect)frame andImageUrls:(NSArray *)urls;
/**
 *  此方法传入的数组是本地的image图片数组
 */
- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images;


@end
