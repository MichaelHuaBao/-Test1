//
//  ViewController.m
//  无限轮播器Test1
//
//  Created by apple on 15/5/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//添加定时器
@property(nonatomic,weak)NSTimer *timer ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //先定义图片的高度及宽度
    CGFloat  h = self.scrollView.frame.size.height;
    CGFloat  w = self.scrollView.frame.size.width;
    
    //图片的张数
    int  count = 5;
    //for循环添加图片
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //拼接图片的名字
        NSString *name = [NSString stringWithFormat:@"img_0%d",i+1];
        imageView.image = [UIImage imageNamed:name];
        imageView.frame = CGRectMake(i * w, 0, w, h);
        [self.scrollView addSubview:imageView];
    }
    
    //设置滚动的内容
    self.scrollView.contentSize = CGSizeMake(count * w, 0);
    //设置分页
    self.scrollView.pagingEnabled = YES;
    
    //设置总页数
    self.pageControl.numberOfPages = count;
    
    //这有一页的时候进行隐藏
    self.pageControl.hidesForSinglePage = YES;
    // 设置页码图片ios8.0之后没有了
//    [self.pageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
//    [self.pageControl setValue:[UIImage imageNamed:@"other"] forKeyPath:@"_pageImage"];
//
   
    //开启定时器
    [self startTimer];
}

#pragma mark----<UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5 );
    self.pageControl.currentPage = page ;
    
}

#pragma mark---设置定时器
//开始定时器
-(void)startTimer{
   //加上一个定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPage:) userInfo:@"123" repeats:YES];
  
    // 修改NSTimer在NSRunLoop中的模式：NSRunLoopCommonModes
    // 主线程不管在处理什么操作，都会抽时间处理NSTimer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
-(void)nextPage:(NSTimer *)timer{
    //计算出下一页
    NSInteger page = self.pageControl.currentPage + 1 ;
    if (page == 5) {
        page = 0;
    }
    //让scrollView滚动到下一页
    CGPoint offset = CGPointMake(page * self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
}

//结束定时器
-(void)stopTimer{
    
    [self.timer invalidate];
}

//当用户即将开始拖拽scrollView时,停止定时器
//
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
    
}

//当拖拽结束的时候开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
    
    
}

@end
