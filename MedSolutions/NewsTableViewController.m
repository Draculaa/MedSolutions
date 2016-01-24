//
//  NewsTableViewController.m
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "News.h"
#import "HTTPManager.h"
#import <UIImageView+AFNetworking.h>
#import "NewsDetailViewController.h"


@interface NewsTableViewController ()

@property (nonatomic, strong) NSMutableArray * objects;

@end

static NSString * const newsCellIdentifier = @"NewsTableCell";

@implementation NewsTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.objects = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (NewsDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self configureView];
}

- (void)configureView{
    __weak typeof(self) wSelf = self;
    [[HTTPManager sharedManager] getFeedOnSuccess:^(NSArray * news) {
        [wSelf.objects addObjectsFromArray:news];
        [wSelf.tableView reloadData];

    } onFailure:^(NSError *error, NSInteger *statusCode) {
        NSLog(@"ERROR: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"
                                                                 forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"BasicCell"];
        }
        return cell;
    }
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier
                                                              forIndexPath:indexPath];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier: newsCellIdentifier];
    }
    
    News * news = (News *)[self.objects objectAtIndex:indexPath.row];
    cell.titleLabel.text = news.title;
    cell.dateLabel.text = news.createdAt;
    [cell.newsImageView setImageWithURL:[NSURL URLWithString:news.imageUrlString]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.objects.count) {
        [self configureView];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    NewsDetailViewController * controller = ( NewsDetailViewController *)[[segue destinationViewController] topViewController];
    News * news = [self.objects objectAtIndex:indexPath.row];
    controller.currentNews = news;
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
    controller.navigationItem.title = news.title;
    [controller configureView];
}


@end
