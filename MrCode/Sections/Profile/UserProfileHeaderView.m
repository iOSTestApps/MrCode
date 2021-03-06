//
//  UserProfileHeaderView.m
//  MrCode
//
//  Created by hao on 7/19/15.
//  Copyright (c) 2015 hao. All rights reserved.
//

#import "UserProfileHeaderView.h"
#import "GITUser.h"

#import "Masonry.h"
#import "UIImage+MRC_Octicons.h"
#import "NSDate+DateTools.h"
#import "UIImageView+WebCache.h"
#import <ChameleonFramework/Chameleon.h>

#define kAvatarSize CGSizeMake(60, 60)

@interface UserProfileHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *bioLabel;
@property (nonatomic, strong) UIButton    *followersButton;
@property (nonatomic, strong) UIButton    *repositoriesButton;
@property (nonatomic, strong) UIButton    *followingButton;

@end

@implementation UserProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = [UIImage octicon_imageWithIdentifier:@"Person" size:kAvatarSize];
    [self addSubview:_avatarImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    _titleLabel.textColor = [UIColor flatPurpleColor];
    [self addSubview:_titleLabel];

    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    _nameLabel.textColor = [UIColor grayColor];
    [self addSubview:_nameLabel];
    
    _bioLabel = [UILabel new];
    _bioLabel.font = [UIFont systemFontOfSize:12.f];
    _bioLabel.textColor = [UIColor lightGrayColor];
    _bioLabel.numberOfLines = 1;
    [self addSubview:_bioLabel];
    
    // Buttons
    _followersButton = [UIButton new];
    [self setupButton:_followersButton withTag:101];
    
    _repositoriesButton = [UIButton new];
    [self setupButton:_repositoriesButton withTag:102];
    
    _followingButton = [UIButton new];
    [self setupButton:_followingButton withTag:103];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kAvatarSize);
        make.left.equalTo(@5);
        make.top.equalTo(@10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(@18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.baseline.equalTo(self.titleLabel);
    }];
    
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    self.bioLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 15 * 2;
    
    // Buttons
    CGFloat horizontalPadding = 15;
    [self.followersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.mas_equalTo(horizontalPadding);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
    }];
    [self.repositoriesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.followersButton);
        make.left.equalTo(self.followersButton.mas_right).offset(horizontalPadding);
        make.top.equalTo(self.followersButton);
    }];
    [self.followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.repositoriesButton);
        make.left.equalTo(self.repositoriesButton.mas_right).offset(horizontalPadding);
        make.top.equalTo(self.repositoriesButton);
        make.right.mas_equalTo(-horizontalPadding);
    }];
}

#pragma mark - Private

- (void)setupButton:(UIButton *)button withTag:(NSUInteger)tag
{
    button.tag = tag;

    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 0.2;
    button.layer.borderColor = [[UIColor flatSkyBlueColorDark] CGColor];
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    button.enabled = YES;
    [button setUserInteractionEnabled:YES];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)tapButton:(UIButton *)button
{
    NSLog(@"%@", @(button.tag));
    
    [self.delegate tapUserProfileHeaderViewButton:button];
}

- (void)setUser:(GITUser *)user
{
    _user = user;
    self.titleLabel.text = user.login;
    self.nameLabel.text = user.name ? : @"";
    self.bioLabel.text   = user.bio ? : [NSString stringWithFormat:@"Updated %@", user.updatedAt.timeAgoSinceNow];
    
    [self.avatarImageView sd_setImageWithURL:user.avatarURL];
    
    [self.followingButton setTitle:[NSString stringWithFormat:@"%@\nFollowing", @(user.following)] forState:UIControlStateNormal];
    [self.repositoriesButton setTitle:[NSString stringWithFormat:@"%@\nRepositories", @(user.publicRepos)] forState:UIControlStateNormal];
    [self.followersButton setTitle:[NSString stringWithFormat:@"%@\nFollowers", @(user.followers)] forState:UIControlStateNormal];
}

@end
