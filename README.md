# Generating optimum-efficiency digital solar arrays using genetic algorithms, inspired by plant phyllotaxy. 

This program defines a few basic characteristics of digital "plants" which are controlled using a genetic algorithm. Fitness of individual plants are evaluated by a unique parallel ray-casting algorithm that represents sun exposed area over time. 

<img src="images/plant.png" width="400">

There are three possible leaf functions, whose basic shape are described by the below functions:

<img src="images/leaf_functions.png" width="400">

The following diagram shows how the fitness algorithm simulates the sun's rays crossing the sky: 

<img src="images/fitness.png" width="400">

The fitness is the average number of ray hits across all possible "above-ground" angles.

<img src="images/final.gif" width="400">

<img src="images/flowchart.png" width="400">
