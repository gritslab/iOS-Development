//
//  EmitterTemplate.h
//  GLParticles1
//
//  Created by GRITS on 3/14/14.
//  Copyright (c) 2014 GRITS. All rights reserved.
//

#ifndef GLParticles1_EmitterTemplate_h
#define GLParticles1_EmitterTemplate_h

#define NUM_HORIZONTAL 200
#define NUM_VERTICAL 200
#define NUM_PARTICLES (NUM_HORIZONTAL*NUM_VERTICAL)

typedef struct Particle
{
    float x;
    float y;
}
Particle;

typedef struct Emitter
{
    Particle particles[NUM_PARTICLES];
    float uX, uY;
    float uCorrelation;
    float uStdX, uStdY;
}
Emitter;

Emitter emitter = {0.0f};

#endif
