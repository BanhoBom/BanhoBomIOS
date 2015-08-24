//
//  ClimaViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/22/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "ClimaViewController.h"

@interface ClimaViewController ()

@end

@implementation ClimaViewController

@synthesize title;
@synthesize nomePraia, tempPraia, humiPraia, seTePraia, iconWeatherPraia, detailPraia, velVentoPraia, dataEHoraDaColeta;
@synthesize coordinateMap;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.nomePraia.text = [NSString stringWithFormat:@"%@", title];
    
    [self carregarInformacoesDeTempo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) carregarInformacoesDeTempo{
    double lat = coordinateMap->latitude;
    double lon = coordinateMap->longitude;
    
    NSLog(@"Praia: %@, latitude: %f, longitude: %f", title, lat, lon);
    
    
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/b6ba45d5b5f16bf1/conditions/lang:BR/q/%+f,%+f.json", lat, lon];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *weatherData = [NSData dataWithContentsOfURL:url];
    
    // parse the JSON results
    
    NSError *error;
    id weatherResults = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    NSDictionary *currentObservation = weatherResults[@"current_observation"];
    
    NSString *temperatura = currentObservation[@"temp_c"];
    NSString *temp = [NSString stringWithFormat:@"%@ºC", temperatura];
    NSLog(@"Temperatura: %@", temperatura);
    self.tempPraia.text = temp;
    
    NSString *humidade = currentObservation[@"relative_humidity"];
    NSString *hum = [NSString stringWithFormat:@"Humidade: %@", humidade];
    NSLog(@"Humidade: %@", humidade);
    self.humiPraia.text = hum;
    
    NSString *sensacaoTermica = currentObservation[@"feelslike_c"];
    NSString *sen = [NSString stringWithFormat:@"Sensação Térmica: %@ºC", sensacaoTermica];
    NSLog(@"sensacaoTermica: %@", sensacaoTermica);
    self.seTePraia.text = sen;
    
    NSString *tempo = currentObservation[@"weather"];
    NSLog(@"Tempo: %@", tempo);
    self.detailPraia.text = tempo;
    
    NSString *velocidadeVento = currentObservation[@"wind_kph"];
    NSString *vel = [NSString stringWithFormat:@"Velocidade do Vento: %@ Km/h", velocidadeVento];
    NSLog(@"velocidadeVento: %@", velocidadeVento);
    self.velVentoPraia.text = vel;
    
    NSString *icon = currentObservation[@"icon_url"];
    NSData *iconPraia = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:icon]];
    iconWeatherPraia.image = [UIImage imageWithData:iconPraia];
    
    NSString *dataEHora = currentObservation[@"observation_time_rfc822"];
    self.dataEHoraDaColeta.text = dataEHora;
}


@end
