//
//  NewsTableViewController.h
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDetailViewController.h"

@interface NewsTableViewController : UITableViewController

@property (strong, nonatomic) NewsDetailViewController *detailViewController;

@end
