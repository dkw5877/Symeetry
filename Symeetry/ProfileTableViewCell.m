//
//  ProfileTableViewCell.m
//  Symeetry
//
//  Created by user on 4/28/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import "ProfileTableViewCell.h"

@interface ProfileTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
