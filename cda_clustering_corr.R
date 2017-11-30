cda_clustering_corr <- function(dat, colinds, thresh = NA, sensitivity = .001, type = "pearson"){
  
  #Load the igraph package
  require(igraph) 
  
  #Calculate all the pairwise correlations across the selected columns. 
  #Note the function expects rows to be individual observations and the columns to be the features.
  cormat <- cor(t(dat[,c(colinds)]), method = type) 
  #Set all correlations below 0 to 0 since only care about positive correlations
  cormat <- ifelse(cormat <= 0, 0, cormat)
  #Set the diagonal of the correlation matrix to zeros to ensure that nodes do not loop on themselves. 
  diag(cormat) <- 0 
  
  #If no prespecified threshold then calculate the threshold based on no isolates rule
  if(is.na(thresh)){
    #Since this is a correlation matrix the threshold will initially be set to zero 
    #and incremented up to find pairs with strong positive correlations. 
    thresh <- 0
    check <- FALSE
    
    while(check == FALSE){
      #Define the adjacency matrix
      adjmat <- ifelse(cormat >= thresh, 1, 0)
      #If the minimum number of conncections for a single node is below 1 (i.e. 0) 
      #then set the boolean flag to TRUE, lower the trheshold to the value just before there were 
      #isolated nodes and and redefine the adjacency matrix.
      if(min(colSums(adjmat)) < 1){
        check <- TRUE
        thresh <- thresh - sensitivity
        adjmat <- ifelse(cormat >= thresh, 1, 0)
        #If the minimum number of connections is 1 then set the boolean flag to TRUE and stop incrementing
      }else if(min(colSums(adjmat)) == 1){
        check = TRUE
        #If the threshold goes above 1 then just exit the loop because all the observations are 
        #perfectly correlated and there will not be any identifiable clusters as the network will be fully connected.
      }else if(thresh > 1){
        check <- TRUE
        print("***The network is fully connected and the algorithm will not work***")
        #If none of the above conditions were met then simly increment the threshold upwards. 
      }else{
        thresh <- thresh + sensitivity
      }
    }
    
    #Construct the graph from the adjacency matrix
    g <- graph_from_adjacency_matrix(adjmat, mode = c("undirected"))
    #Run the edge betweenness clustering algorhithm
    ebc <- cluster_edge_betweenness(g)
    
  #if threshold provided to the function then apply that threshold
  }else{
    #Define the adjacency matrix
    adjmat <- ifelse(cormat >= thresh, 1, 0)
    #Construct the graph from the adjacency matrix
    g <- graph_from_adjacency_matrix(adjmat, mode = c("undirected"))
    #Run the edge betweenness clustering algorhithm
    ebc <- cluster_edge_betweenness(g)
  }
  #Return threshold value used, the cluster membership, the network,
  return(list(Threshold = thresh, Cluster_Assignments = as.character(membership(ebc)), Network = g, 
              Correlation_Matrix = cormat, Adjacency_Matrix = adjmat))
  
}
