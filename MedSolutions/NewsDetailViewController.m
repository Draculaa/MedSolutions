//
//  NewsDetailViewController.m
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsTableViewCell.h"
#import "HTTPManager.h"
#import <UIImageView+AFNetworking.h>
@interface NewsDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * spotlight;

@end
static NSString * const newsCellIdentifier = @"NewsTableCell";

@implementation NewsDetailViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.spotlight = [NSMutableArray new];
        //self.currentNews = [News new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.currentNews.title;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)reloadView{
    if (self.currentNews) {
        self.leadLabel.text = self.currentNews.title;
        self.newsTextView.text = self.currentNews.text;
        [self.newsImageView setImageWithURL:[NSURL URLWithString:self.currentNews.imageUrlString]];
    }
    if (self.spotlight.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)configureView{
    if (self.currentNews) {
        __weak typeof(self) wSelf = self;
        [[HTTPManager sharedManager] getDetailNewsWithMediaID:self.currentNews.newsId
                                                    OnSuccess:^(NSDictionary *data) {
                                                        News * detailedNews = data[@"data"];
                                                        wSelf.spotlight = data[@"spotlight"];
                                                        wSelf.currentNews.text =  detailedNews.text;
                                                        wSelf.currentNews.title = detailedNews.title;
                                                        [wSelf reloadView];
                                                    } onFailure:^(NSError *error, NSInteger *statusCode) {
                                                        NSLog(@"ERROR: %@", error);
                                                    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: newsCellIdentifier
                                                               forIndexPath:indexPath];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:newsCellIdentifier];
    }
    News * news = (News *)[self.spotlight objectAtIndex:indexPath.row];
    cell.titleLabel.text = news.title;
    cell.dateLabel.text = news.createdAt;
    [cell.newsImageView setImageWithURL:[NSURL URLWithString:news.imageUrlString]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.spotlight.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section{
    return @"Related news";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    News * news = (News *)[self.spotlight objectAtIndex:indexPath.row];
    self.currentNews = news;
    self.title = self.currentNews.title;
    [self configureView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
