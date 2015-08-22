//
//  DetalhesViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/19/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "DetalhesViewController.h"
#import "ClimaViewController.h"
#import "EstatisticaViewController.h"

@interface DetalhesViewController ()

@end

@implementation DetalhesViewController

@synthesize coordinateMap;
@synthesize imagePraia, imageOpcao;
@synthesize estacaoLabel, praiaLabel, mensLabel;
@synthesize title, subtitulo;
@synthesize latitude, longitude;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    latitude = coordinateMap->latitude;
    longitude= coordinateMap->longitude;
    
    NSLog(@" lat %f, long %f", latitude, longitude);
    
    self.praiaLabel.text = title;
    [self status];
    
    
}

-(void)status{
    if ([subtitulo isEqualToString:@"Praia Própria para Banho"]) {
        self.mensLabel.text = @"Água Boa";
        imageOpcao.image = [UIImage imageNamed:@"positive.jpg"];
    } else {
        self.mensLabel.text = @"Água Não Boa";
        imageOpcao.image = [UIImage imageNamed:@"negative.jpg"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)estaticaButton:(id)sender {
    EstatisticaViewController *estatisticaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EstatisticaViewController"];
    estatisticaViewController.title = title;
    [self presentViewController:estatisticaViewController animated:YES completion:nil];
}

- (IBAction)tempoButton:(id)sender {
    CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    ClimaViewController *climaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClimaViewController"];
    climaVC.coordinateMap = &(coodinate);
    climaVC.title = title;
    
    [self presentViewController:climaVC animated:YES completion:nil];
    
}

- (IBAction)informacaoButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Praia TAL***"
                                                    message:@"Alguma Coisa sobre a Praia"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK!",nil];

    [alert show];
}
@end
