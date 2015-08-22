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


@interface MapViewController ()

@end

#define SERVICEURL @"http://54.149.41.128/AguaAzulWS/praia/listar"

@implementation MapViewController

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

-(void)carregarJson
{
    praiasLista = [[NSMutableArray alloc] init];
    
    //show the user that the app is working
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //execute this block of code in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //fetch data from the URL
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:SERVICEURL]
                            ];
        
        //if data was fetched - try to parse it and turn it into an NSDictionary
        NSDictionary* json = nil;
        
        if (kivaData) {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
            
            //NSLog(@" %@", json);
        }
        
        //update the UI - you have to do that on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //code executed on the main queue
            [self updateMapWithDictionary: json];
        });
        
    });
    
}

//Receive and work with json data
- (void)updateMapWithDictionary:(NSDictionary*)json {
    
    Database *db =[[Database alloc] init];
    [db createDataBase];
    
    
    int contador = (unsigned int)[[json objectForKey: @"praiaMobile"] count];
    
    @try {
        //cheap way to fall on the catch block, if there was no data fetched at all
        NSAssert(json, @"No JSON object fetched.");
        
        
        int cont = 0;
        
        
        while (cont < contador) {
            
            NSString *codPraia = [NSString stringWithFormat:@"%@", json[@"praiaMobile"][cont][@"codPraia"], nil];
            NSLog(@"Cod Praia: %@", codPraia);
            
            NSString *nome = [NSString stringWithFormat: @"%@", json[@"praiaMobile"][cont][@"nome"], nil];
            NSLog(@"Nome: %@", nome);
            
            NSString *latitude = [NSString stringWithFormat: @"%@", json[@"praiaMobile"][cont][@"latitude"], nil];
            NSLog(@"Latitude: %@", latitude);
            
            NSString *longitude = [NSString stringWithFormat: @"%@", json[@"praiaMobile"][cont][@"longitude"], nil];
            NSLog(@"Longitude: %@", longitude);
            
            NSString *balneabilidade = [NSString stringWithFormat:@"%@", json[@"praiaMobile"][cont][@"condicaoBalneabilidade"], nil];
            NSLog(@"Balneabiidade: %@", balneabilidade);
            
            [db saveData:nome addLat:latitude addLong:longitude addBaln:balneabilidade addCodPraia:codPraia];
            
            cont++;
        }
        
        praiasLista = [db findData];
        [self mapWithAnnotation];
        
    }
    @catch (NSException *exception) {
        //some of the required keys were missing
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (IBAction)refresh:(id)sender {
    [self visualizarMap];
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
        //[self mapWithAnnotation];
        
    }else{
        [self carregarJson];
    }
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

-(void)mapWithAnnotation{
    
    annotationArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row in praiasLista) {
        NSString *latitude = [row objectForKey:@"lat"];
        double latitudeDouble = [latitude doubleValue];
        
        NSString *longitude = [row objectForKey:@"lon"];
        double longitudeDouble = [longitude doubleValue];
        
        NSString *nome = [row objectForKey:@"nome"];
        NSString *balneabilidade = [row objectForKey:@"baln"];

        
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = latitudeDouble;
        region.center.longitude = longitudeDouble;
        
        CustomAnnotation *CA = [[CustomAnnotation alloc] init];
        
        CA.title = nome;
        CA.coordinate = region.center;
        if ([balneabilidade  isEqual: @"true"]) {
            CA.subtitle = @"Praia Própria para Banho";
        }else{
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
    
    return MyPin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
        DetalhesViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
        detailsViewController.coordinateMap = &(coordinate);
        detailsViewController.title = view.annotation.title;
        detailsViewController.subtitulo = view.annotation.subtitle;
    
        [self presentViewController:detailsViewController animated:YES completion:nil];
}


@end
