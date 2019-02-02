//
//  Contato.m
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato

-(NSString *)description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@, Endereço: %@, Site: %@", self.nome, self.telefone, self.endereco, self.site];
}

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *)title{
    return self.nome;
}

-(NSString *)subtitle{
    return self.site;
}

@dynamic nome, telefone, endereco, site, latitude, longitude, foto;

@end
