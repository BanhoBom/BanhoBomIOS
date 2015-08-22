//
//  EstatisticaViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/22/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "EstatisticaViewController.h"

@interface EstatisticaViewController ()

@end

@implementation EstatisticaViewController

@synthesize title;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = title;
    NSLog(@"Title = %@", title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@""];
    
    cell.textLabel.text = [NSString stringWithFormat:@"ROW %ld" , (long)indexPath.row + 1];
    cell.imageView.image = [UIImage imageNamed:@"estatistica.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


@end
