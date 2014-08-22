//
//  EmitterShader.m
//  GLParticles1
//
//  Created by GRITS on 3/14/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#import "EmitterShader.h"
#import "ShaderProcessor.h"

// Shaders
#define STRINGIFY(A) #A
#include "Emitter.vsh"
#include "Emitter.fsh"

@implementation EmitterShader

- (void)loadShader
{
    // Program
    ShaderProcessor* shaderProcessor = [[ShaderProcessor alloc] init];
    self.program = [shaderProcessor BuildProgram:EmitterVS with:EmitterFS];
    
    // Attributes
    self.aX = glGetAttribLocation(self.program, "aX");
    self.aY = glGetAttribLocation(self.program, "aY");
    
    // Uniforms
    self.uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
    
    self.uX = glGetUniformLocation(self.program, "uX");
    self.uY = glGetUniformLocation(self.program, "uY");
    self.uCorrelation = glGetUniformLocation(self.program, "uCorrelation");
    self.uStdX = glGetUniformLocation(self.program, "uStdX");
    self.uStdY = glGetUniformLocation(self.program, "uStdY");
}

@end