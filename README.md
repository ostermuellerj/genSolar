# Generating optimum-efficiency digital solar arrays using genetic algorithms, inspired by plant phyllotaxy. 

This program defines a few basic characteristics of digital "plants" which are controlled using a genetic algorithm. Fitness of individual plants are evaluated by a unique parallel ray-casting algorithm that represents sun exposed area over time. Won 4th Place in Bioinformatics/Computational Biology at Intel ISEF 2018.

<img src="images/plant.png" width="600">

There are three possible leaf functions, whose basic shape are described by the below functions:

<img src="images/leaf_functions.png" width="600">

The following diagram shows how the fitness algorithm simulates the sun's rays crossing the sky: 

<img src="images/fitness.png" width="600">

The fitness is the average number of ray hits across all possible "above-ground" angles.

<img src="images/final.gif" width="600">

The following flowchart shows the genetic algorithm/process of plant selection:

<img src="images/flowchart.png" width="600">
