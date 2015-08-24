//
//  MapViewController.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/17/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "MapViewController.h"
#import "Reachability.h"
#import "CustomAnnotation.h"
#import "Database.h"
#import "DetalhesViewController.h"
#import "EstatisticaViewController.h"



@interface MapViewController ()

@end

#define SERVICEURL @"http://54.149.41.128/AguaAzulWS/praia/listar"

@implementation MapViewController{
    CustomAnnotation *CA;
;
}

@synthesize mapView;
@synthesize praiasLista, annotationArray;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self visualizarMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)carregarJson{
    // Prepare the link that is going to be used on the GET request
    NSURL * url = [[NSURL alloc] initWithString:@"http://env-4818724.jelasticlw.com.br/banhobom2/rest/cliente/estacoesMobile"];
    
    // Prepare the request object
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    // Prepare the variables for the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a Array around the Data from the response
    NSArray* object = [NSJSONSerialization
                       JSONObjectWithData:urlData
                       options:0
                       error:&error];
    
    Database *db =[[Database alloc] init];
    
    [db createDataBase];
    
    // Iterate through the object and print desired results
    for (int i=0; i < [object count]; i++) {
        
        NSString *codEstacao = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"codigo"], nil];
        NSLog(@"Codigo Estacao: %@", codEstacao);
        
        NSString *nomePraia = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"praia"], nil];
        NSLog(@"Nome Praia: %@", nomePraia);
        
        NSString *latitude = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"latitude"], nil];
        NSLog(@"Latitude: %@", latitude);
        
        NSString *longitude = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"longitude"], nil];
        NSLog(@"Longitude: %@", longitude);
        
        NSString *status = [NSString stringWithFormat:@"%@", [object[i] objectForKey:@"status"], nil];
        NSLog(@"Status: %@", status);

        [db saveData:nomePraia addLat:latitude addLong:longitude addBaln:status addCodPraia:codEstacao];
        
        NSLog(@"------");
    }
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    praiasLista = [db findData];
    
    [self mapWithAnnotation];

}



- (IBAction)refresh:(id)sender {
    [self visualizarMap];
}

- (IBAction)historico:(id)sender {
    EstatisticaViewController *estatisticaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EstatisticaViewController"];
    [self presentViewController:estatisticaViewController animated:YES completion:nil];
}

-(void)visualizarMap{
    
    //self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.delegate = self;
    
    self.mapView.delegate = self;
    [self.mapView setMapType:MKMapTypeHybrid];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    
    
    int x = [self checkForNetwork];
    if(x == 1){
        NSLog(@"There's no internet connection at all. Display error message now.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                        message:@"There's no internet connection at all!"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
        [alert show];
        
    }else{
        [self carregarJson];
    }
}

-(void)mapWithAnnotation{
    
    annotationArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row in praiasLista) {
        NSString *latitude = [row objectForKey:@"lat"];
        double latitudeDouble = [latitude doubleValue];
        
        NSString *longitude = [row objectForKey:@"lon"];
        double longitudeDouble = [longitude doubleValue];
        
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = latitudeDouble;
        region.center.longitude = longitudeDouble;
        
        NSString *nomePraia = [row objectForKey:@"nomePraia"];
        NSString *status = [row objectForKey:@"status"];
        NSString *codEstacao = [row objectForKey:@"codEstacao"];
        
        CA = [[CustomAnnotation alloc] init];
        
        /*
         CA.descricaoPraia = descricao;
         */
        CA.title = codEstacao;
        CA.idEstacao = codEstacao;
        CA.nomePraia = nomePraia;
        CA.statusEstacao = status;
        CA.coordinate = region.center;
        
        if ([status  isEqual: @"1"]) {
            CA.statusEstacao = @"Praia Própria para Banho";
            CA.subtitle = @"Praia Própria para Banho";
        }else{
            CA.statusEstacao = @"Praia Imprópria para Banho";
            CA.subtitle = @"Praia Imprópria para Banho";
        }
        [annotationArray addObject:CA];
        
        
    }

    // Add to map
    [self.mapView addAnnotations:annotationArray];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.canShowCallout = YES;
    MyPin.animatesDrop = YES;
    MyPin.selected = YES;
    MyPin.userInteractionEnabled = YES;

    
    if ([annotation.subtitle isEqualToString:@"Praia Própria para Banho"]) {
        MyPin.pinColor = MKPinAnnotationColorGreen;
    }else if ([annotation.subtitle isEqualToString:@"Praia Imprópria para Banho"]){
        MyPin.pinColor = MKPinAnnotationColorRed;
    }else{
        MyPin.pinColor = MKPinAnnotationColorPurple;
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    MyPin.rightCalloutAccessoryView = rightButton;
    MyPin.rightCalloutAccessoryView.tag = 1;

    
    return MyPin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    DetalhesViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    detailsViewController.coordinateMap = &(coordinate);
    detailsViewController.title = view.annotation.title;        //NAO
    detailsViewController.subtitulo = view.annotation.subtitle; //NAO
    
    for (NSDictionary *row in praiasLista) {
        if ([row objectForKey:@"codEstacao"] == view.annotation.title) {
            detailsViewController.nomePraia = [row objectForKey:@"nomePraia"];
            detailsViewController.idEstacao = [row objectForKey:@"codEstacao"];
            detailsViewController.statusEstacao = [row objectForKey:@"status"];
            

        }
    }
    
        //detailsViewController.descricaoPraia = view.annotation.descricaoPraia;
        //detailsViewController.coordinateMap = &(coordinate);
        [self presentViewController:detailsViewController animated:YES completion:nil];
}

-(int)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    switch (myStatus) {
        case NotReachable:
        {
            return 1;
        }break;
            
        case ReachableViaWWAN:
        {
            NSLog(@"We have a 3G connection");
        }break;
            
        case ReachableViaWiFi:
        {
            NSLog(@"We have WiFi.");
        }break;
            
        default:
            break;
    }
    return 0;
}


@end
