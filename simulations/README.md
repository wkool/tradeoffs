#Simulations

This directory contains MATLAB code to recreate the simulations and figures reported in Kool, Cushman, & Gershman (2016).

The main function is wrapper.m (USAGE: data = wrapper(nriterations)). You will answer a few questions in order to determine which two-step task you would like to simulate. Next, it will compute the surfaces of standardized regression coefficients for the relationship between model-based control and reward rate. You can view the results of this simulation with the function plot_grid(data).

With the number of iterations that are used in the paper (1000), wrapper.m will take a long time to finish. This process can be sped up by breaking up these analyses and running them in parallel jobs on your institution's computing cluster.
