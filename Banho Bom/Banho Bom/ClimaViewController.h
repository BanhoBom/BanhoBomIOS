//
//  ClimaViewController.h
//  Banho Bom
//
//  Created by Everson Trindade on 8/22/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetalhesViewController.h"

@interface ClimaViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nomePraia;
@property (strong, nonatomic) IBOutlet UILabel *tempPraia;
@property (strong, nonatomic) IBOutlet UILabel *humiPraia;
@property (strong, nonatomic) IBOutlet UILabel *seTePraia;
@property (strong, nonatomic) IBOutlet UIImageView *iconWeatherPraia;
@property (strong, nonatomic) IBOutlet UILabel *detailPraia;
@property (strong, nonatomic) IBOutlet UILabel *velVentoPraia;
@property (strong, nonatomic) IBOutlet UILabel *dataEHoraDaColeta;


@property (nonatomic) CLLocationCoordinate2D *coordinateMap;

@end
