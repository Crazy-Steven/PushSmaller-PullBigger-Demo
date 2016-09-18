//
//  ViewController.m
//  PushSmaller&PullBigger-Demo
//
//  Created by 郭艾超 on 16/7/17.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "ViewController.h"
#define headRect CGRectMake(0,0,self.view.bounds.size.width,280)
#define VCWidth self.view.bounds.size.width
#define VCHeight self.view.bounds.size.height
#define navHeight 44 //上推留下的高度

@interface HeadView:UIView
@property (weak, nonatomic) UIImageView * backgroundView;
@property (weak, nonatomic) UIImageView * headView;
@property (weak, nonatomic) UILabel * signLabel;

@end

@implementation HeadView
- (instancetype)initWithFrame:(CGRect)frame backgroundView:(NSString *)name headView:(NSString *)headImgName headViewWidth:(CGFloat)width signLabel:(NSString *)signature
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -navHeight, frame.size.width, frame.size.height)];
        UIImage * image = [UIImage imageNamed:name];
        UIImage * newImg = [self image:image byScalingToSize:self.bounds.size];
        backgroundView.image = newImg;
        backgroundView.clipsToBounds = YES;
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;

        UIImageView * headView = [[UIImageView alloc]initWithFrame:(CGRect){(frame.size.width - width) * 0.5,0.5 * (frame.size.height - width) - navHeight,width,width}];
        headView.layer.cornerRadius = width*0.5;
        headView.layer.masksToBounds = YES;
        headView.image = [UIImage imageNamed:headImgName];
        [self addSubview:headView];
        _headView = headView;
        
        UILabel * signLabel = [[UILabel alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(headView.frame) ,self.bounds.size.width,40}];
        signLabel.text = signature;
        signLabel.textAlignment = NSTextAlignmentCenter;
        signLabel.textColor = [UIColor whiteColor];
        [self addSubview:signLabel];
        _signLabel = signLabel;
        
    }
    return self;
}

- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}
@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) HeadView * myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initUI];
}

- (void)initUI {
    
    UITableView * myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHeight, VCWidth, VCHeight - navHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.contentInset = UIEdgeInsetsMake(headRect.size.height-navHeight-navHeight, 0, 0, 0);
    _myTableView = myTableView;
    //myTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:myTableView];
    
    HeadView * vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"background.jpg" headView:@"headImg.jpg" headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"Crazy Steven 原创"];
    
    _myView = vc;
    _myView.backgroundColor = [UIColor clearColor];
    _myView.userInteractionEnabled = NO;
    [self.view addSubview:vc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

#pragma mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"StevenCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell---%ld",indexPath.row + 1];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset_Y = scrollView.contentOffset.y + headRect.size.height-navHeight-navHeight;

    if  (offset_Y < 0) {
        
        _myView.backgroundView.contentMode = UIViewContentModeScaleToFill;

        _myView.backgroundView.frame = CGRectMake(offset_Y*0.5 , -navHeight, VCWidth - offset_Y, headRect.size.height - offset_Y);
    }else if (offset_Y > 0 && offset_Y <= (headRect.size.height-navHeight-navHeight)) {
        
        _myView.backgroundView.contentMode = UIViewContentModeTop;
        
        CGFloat y = navHeight* offset_Y/(headRect.size.height-navHeight-navHeight)-navHeight;
        
        _myView.backgroundView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - offset_Y);
        
        
        CGFloat width = offset_Y*(40-(VCWidth / 4))/(headRect.size.height-navHeight-navHeight)+(VCWidth / 4);
        _myView.headView.frame =CGRectMake(0, 0, width,width);
        _myView.headView.layer.cornerRadius =width*0.5;
        _myView.headView.center = _myView.backgroundView.center;
        
        _myView.signLabel.frame =CGRectMake(0, CGRectGetMaxY(_myView.headView.frame), VCWidth, 40);
        
        _myView.signLabel.alpha = 1 - (offset_Y*3 / (headRect.size.height-navHeight-navHeight) /2);
    }else if(offset_Y > (headRect.size.height-navHeight-navHeight)) {
        _myView.backgroundView.contentMode = UIViewContentModeTop;
        
        CGFloat y = navHeight* (headRect.size.height-navHeight-navHeight)/(headRect.size.height-navHeight-navHeight)-navHeight;
        
        _myView.backgroundView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - (headRect.size.height-navHeight-navHeight));
        
        
        CGFloat width = (headRect.size.height-navHeight-navHeight)*(40-(VCWidth / 4))/(headRect.size.height-navHeight-navHeight)+(VCWidth / 4);
        _myView.headView.frame =CGRectMake(0, 0, width,width);
        _myView.headView.layer.cornerRadius =width*0.5;
        _myView.headView.center = _myView.backgroundView.center;
        
        _myView.signLabel.frame =CGRectMake(0, CGRectGetMaxY(_myView.headView.frame), VCWidth, 40);
        
        _myView.signLabel.alpha = 1 - ((headRect.size.height-navHeight-navHeight)*3 / (headRect.size.height-navHeight-navHeight) /2);
    }
}

@end
