# CDA-for-Clustering

This repository contains functions for using community detection analysis for clustering analyses.

cda_clustering_corr constructs the network based on the correlaitons between observations. Importantly this function expects that the data will be organzied such that the rows are individual observations and the columns are the features. For the types of correlations that can be used see documentation for cor() in R. By default the "type" argument is set to "pearson" and the sensitivity argument which controls the threshold for removing links between nodes in the network is .001. 

cda_clustering_dist operates in a similar fashion to cda_clustering_cor however it constructs the network based on the distance between observations in the dataset. By default the euclidean distance is used to determine the distance between observations (for other types of distances see the documentation for the dist function in R).

Both of the above mentioned functions use the edge betweenness community detection algorithim provided by the igraph package and therefore the igraph package must be installed in order for the functions to work. Further the functions must be passed data in the form of a matrix or dataframe (dat) and the indeces of the columns to compute the correlations or distances (colinds) between observations. You can also set the 'sensitivity' argument (default of .001) to higher or lower values depending on how sensitive you want the function to be when defining links in the network. Note you can also pass the functions predetermined thresholds if desired. Please take note that these functions simply perform the clustering analysis and preprocessing such as scaling should be done before calling the functions.

The functions returns a list containing the following:

Threshold - the threshold used when determining the links between nodes

Cluster_Assignments - a character vector of the cluster assignment labels in the same order as the observations in the dataframe or matrix    passed to the function.

Network - the resultant network from thresholding

Distance/Correlation_Matrix - the distance or correlation matric generated

Adjacency_Matrix - the adjacency matrix generated from thresholding the distance or correlation matrix. This matrix contains the linkng      information for the network in the form of 1 (linked) and 0 (not linked) between the observations in the dataset.

For a companion article on using CDA for clustering see the following RPub: http://rpubs.com/JFLandrigan/CDA_Clustering. 
