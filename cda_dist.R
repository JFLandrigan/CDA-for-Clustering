cda_clustering_dist <- function(dat, colinds, thresh = NA,  sensitivity = .001, type = "euclidean"){
  
  #Load the igraph package.
  require(igraph)
  
  #Caluclate the distances. Note by default distance uses euclidean distances.
  distmat <- dist(dat[,c(colinds)], method = type)
  #Convert the distance matrix object into a matrix
  distmat <- as.matrix(distmat)
  
  #If no threshold is provided calculate the threshold based on the no isolate rule
  if(is.na(thresh)){
    #First set the threshold to be the max of the distance matrix.
    thresh <- max(distmat)
    #Set the boolean flag to FALSE. When it becomes TRUE this means that a threshold has been found. 
    check <- FALSE
    
    while(check == FALSE){
      #Generate the adjacency matrix at the given threshold
      adjmat <- ifelse(distmat <= thresh, 1, 0)
      #Since each column contains the link information for a single node 
      #(i.e. 1 means linked, 0 not linked), if the minimum of the colum sums is less then 1 
      #this means there is an isolated node. Therefore stop iterating, increase the threshold to 
      #the value before there was an isolated node and redefine the adjacency matrix.
      if(min(colSums(adjmat)) < 1){
        check = TRUE
        thresh <- thresh + sensitivity
        adjmat <- ifelse(distmat <= thresh, 1, 0)
        #if the minimum of the adjacency matrix is 1 this means that a node only has one 
        #link so simply set the boolean flag to true and keep the adjacency matrix as is.
      }else if(min(colSums(adjmat)) == 1){
        check = TRUE
        #If neither of the previous two conditions were met decrease the threshold 
        #(i.e. make it so that nodes have to be closer togther to be linked)
      }else{
        thresh <- thresh - sensitivity
      }
    }
    
    #Construct the network from the adjacency matrix
    g <- graph_from_adjacency_matrix(adjmat, mode = c("undirected"))
    #Remove loops from the network (i.e. make sure nodes don't connect to themselves)
    g <- simplify(g, remove.loops = TRUE) 
    #Run the edge betweenness community detection algorithm
    ebc <- cluster_edge_betweenness(g)
    
  #if threshold provided to the function then apply that threshold  
  }else{
    #Generate the adjacency matrix at the given threshold
    adjmat <- ifelse(distmat <= thresh, 1, 0)
    #Construct the graph from the adjacency matrix
    g <- graph_from_adjacency_matrix(adjmat, mode = c("undirected"))
    #Remove loops from the network (i.e. make sure nodes don't connect to themselves)
    g <- simplify(g, remove.loops = TRUE) 
    #Run the edge betweenness clustering algorhithm
    ebc <- cluster_edge_betweenness(g)
  }
  
  #Return threshold value used, the cluster membership, the network,
  return(list(Threshold = thresh, Cluster_Assignments = as.character(membership(ebc)), Network = g, 
              Distance_Matrix = distmat, Adjacency_Matrix = adjmat))
  
}
