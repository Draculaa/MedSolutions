//
//  NewsTableViewCell.h
//  MedSolutions
//
//  Created by Евгений on 23.01.16.
//  Copyright © 2016 Eugene Kirtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *newsImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
