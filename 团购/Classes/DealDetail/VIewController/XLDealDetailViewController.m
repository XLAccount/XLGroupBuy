//
//  XLDealDetailViewController.m
//  团购
//
//  Created by 徐理 on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLDealDetailViewController.h"
#import "XLBiasLineLabel.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "XLCRTool.h"
#import "NSDate+comperWithOther.h"
#import "XLSingleParam.h"
#import "XLDealTool.h"
#import "XLBusinesses.h"
#import "XLMapViewController.h"
#import "XLNavController.h"

@interface XLDealDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancelBtn:(UIButton *)sender;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
// label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet XLBiasLineLabel *listPriceLabel;
// 按钮
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpiresButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountButton;
@property (weak, nonatomic)  UILabel *noticeLable;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTrailing;
- (IBAction)map;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBotton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation XLDealDetailViewController

- (UILabel *)noticeLable
{
    if (_noticeLable == nil){
        UILabel *noticeLable = [[UILabel alloc] init];
        noticeLable.numberOfLines = 0;
        noticeLable.textColor = [UIColor grayColor];
        noticeLable.font = self.refundableExpiresButton.titleLabel.font;
        
        [self.leftView addSubview:noticeLable];
        
        
        [noticeLable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 15, 30, 15) excludingEdge:ALEdgeTop];
        [noticeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.refundableExpiresButton withOffset:30];
        
        _noticeLable = noticeLable;
    }
    return _noticeLable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:230.0/25.05 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    self.webView.backgroundColor = [UIColor colorWithRed:230.0/25.05 green:230.0/255.0 blue:230.0/255.0 alpha:1];;
    
//    储存记录
    [[XLCRTool shareXLCRTool] saveRecentDeal:self.deal];
    
//    判定是否收藏
    NSArray *collectDeals = [XLCRTool shareXLCRTool].collectDeal;
    
    for (XLDeal *deal in collectDeals) {
    
        if ([deal.deal_id isEqualToString:self.deal.deal_id]){
            
            self.collectBtn.selected = YES;
        }
    }
    
    
    
    [self setupLeftContent];
    
    [self setupRightContent];
}

#pragma mark 设置左边内容
- (void)setupLeftContent
{
    [self.iconView setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    [self updateLeftContent];
//    加载详细团购数据
    XLSingleParam *param = [[XLSingleParam alloc] init];
    param.deal_id = self.deal.deal_id;
    
    [XLDealTool singDeal:param success:^(XLSingleResult *result) {
        
             
//        如果返回数据不为空
        if (result.deals.count){
            
            self.deal = [result.deals lastObject];
            
            [self updateLeftContent];
        }else{
            
            self.refundableAnyTimeButton.selected = YES;
            self.refundableExpiresButton.selected = YES;
        }
        
    } failure:^(NSError *error) {
       [MBProgressHUD showError:@"加载团购数据失败"];
    }];
}

/**
 *  更新左边的内容
 */
- (void)updateLeftContent
{
    // 简单信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"💰%0.2f", [self.deal.current_price floatValue]];
    self.listPriceLabel.text = [NSString stringWithFormat:@"门店价💰%0.2f", [self.deal.list_price floatValue]];
    
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpiresButton.selected = self.deal.restrictions.is_refundable;
    
    
    
    NSString *title = [NSString stringWithFormat:@"已售出%ld", self.deal.purchase_count];
    [self.purchaseCountButton setTitle:title forState:UIControlStateNormal];

    
    if (self.deal.notice.length){
        self.noticeLable.text = [NSString stringWithFormat:@"温馨提示： %@",self.deal.notice];
        self.noticeLable.width = self.noticeLable.superview.width - 30;
        self.noticeLable.height = [self.noticeLable.text sizeWithAttributes:@{NSFontAttributeName : self.noticeLable.font}].height;
    }
    
    NSString *title2 = [NSDate dateWithFirstTime:[NSDate date] andOtherTime:self.deal.purchase_deadline];
    
    [self.leftTimeButton setTitle:title2 forState:UIControlStateNormal];
}


- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.deal.deal_h5_url]];
}


- (IBAction)collect {
    
    if (self.collectBtn.selected){
        
        [[XLCRTool shareXLCRTool] unsaveCollectDeal:self.deal];
        
        self.collectBtn.selected = NO;
        [MBProgressHUD showSuccess:@"取消收藏成功"];
    }else{
        [[XLCRTool shareXLCRTool] saveCollectDeal:self.deal];
        
        
        
        self.collectBtn.selected = YES;
        [MBProgressHUD showSuccess:@"收藏成功"];
    }
}

- (IBAction)share {
    
    NSString *text = [NSString stringWithFormat:@"【%@】%@ 详情查看：%@", self.deal.title, self.deal.desc, self.deal.deal_h5_url];
    
    // 需要分享的图片（不分享占位图片）
    UIImage *image = nil;
    if (self.iconView.image != [UIImage imageNamed:@"placeholder_deal"]) {
        image = self.iconView.image;
    }
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"53fb4899fd98c5a4db00a8a0" shareText:text shareImage:image shareToSnsNames:@[UMShareToRenren, UMShareToSina, UMShareToTencent]  delegate:nil];

}

#pragma mark 设置右边webView
- (void)setupRightContent
{
    // 圈圈
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.webView addSubview:loadingView];
    [loadingView startAnimating];
    // 居中
    [loadingView autoCenterInSuperview];
    self.loadingView = loadingView;
    loadingView.color = [UIColor blackColor];
    
    self.webView.scrollView.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:self.deal.deal_h5_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *ID = self.deal.deal_id;
    ID = [ID substringFromIndex:[ID rangeOfString:@"-"].location + 1];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
    
    if ([webView.request.URL.absoluteString isEqualToString:urlStr]){
        
        NSMutableString *js = [NSMutableString string];
        
        [js appendString:@"var bodyHTML = '';"];
        // 拼接link的内容
        [js appendString:@"var link = document.body.getElementsByTagName('link')[0];"];
        [js appendString:@"bodyHTML += link.outerHTML;"];
        // 拼接多个div的内容
        [js appendString:@"var divs = document.getElementsByClassName('detail-info');"];
        [js appendString:@"for (var i = 0; i<=divs.length; i++) {"];
        [js appendString:@"var div = divs[i];"];
        [js appendString:@"if (div) { bodyHTML += div.outerHTML; }"];
        [js appendString:@"}"];
        // 设置body的内容
        [js appendString:@"document.body.innerHTML = bodyHTML;"];
        
        
        
        // 执行JS代码
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        
        
        // 显示网页内容
        webView.scrollView.hidden = NO;
        // 移除圈圈
        [self.loadingView removeFromSuperview];
        
    }else{
        
        //        加载更多图文详情页面
        NSString *js = [NSString stringWithFormat:@"window.open('%@');",urlStr];
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        
    }
}

//永远横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (IBAction)map {
    
//    XLSingleParam *param = [[XLSingleParam alloc] init];
//    param.deal_id = self.deal.deal_id;
//    
//    [XLDealTool singDeal:param success:^(XLSingleResult *result) {
//
    NSMutableArray *mutable = [NSMutableArray array];
    [mutable addObject:self.deal];
    
        
       
        if (self.deal.businesses.count == 0){
            
            [MBProgressHUD showError:@"本次团购暂时没有相关商家的位置信息"];
            
            return;
        }else{
            
            XLMapViewController *mapViewController = [[XLMapViewController alloc] init];
            mapViewController.deals = mutable;
            XLNavController *nav = [[XLNavController alloc] initWithRootViewController:mapViewController];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
    
   }
@end
