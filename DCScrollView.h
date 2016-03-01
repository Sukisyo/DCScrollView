//
//  DCScrollView.h
//  图片轮播器
//
//  Created by ma c on 15/12/11.
//  Copyright © 2015年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCScrollView : UIView


//自定义初始化方法，指定scrollView大小和图片轮播的对象
- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray*)images;




@end
