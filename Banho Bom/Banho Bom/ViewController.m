//
//  ViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 7/17/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sobreBB:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BANHO BOM"
                                                    message:@"O Banho Bom é um software com o intuito de prover informações das praias/rios da região à comunidade. O sistema tem um foco nas preocupações ambientais que são comumente de interesse da população, como a Balneabilidade."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK!",nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"logo.png"]];
    
    [alert addSubview:imageView];
    [alert show];
}
@end
