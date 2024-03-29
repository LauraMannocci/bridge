#' Create a spatial weights matrix
#' 
#' @description
#' Creates a spatial weights matrix by multiplying an adjacency (connectivity)
#' matrix (see [adjacency_matrix()]) and an edges weight matrix (see 
#' [edges_weight_matrix()]). Resulting spatial weights equal to 0 will be 
#' replaced by `4 x max(w)`, where `max(w)` is the maximal weight in the 
#' matrix.
#'
#' @param x an adjacency `matrix` of dimensions `n x n`, where `n` is the 
#'   number of nodes (sites). The output of [adjacency_matrix()].
#'   
#' @param y an edges weight `matrix` of dimensions `n x n`, where `n` is the 
#'   number of nodes (sites). The output of [edges_weight_matrix()].
#'
#' @return A spatial weights `matrix` of dimensions `n x n`, where `n` is the 
#'   number of nodes (sites).
#' 
#' @export
#'
#' @examples
#' # Import Adour sites ----
#' path_to_file <- system.file("extdata", "adour_sites_coords.csv", 
#'                             package = "bridge")
#' adour_sites  <- read.csv(path_to_file)
#' 
#' # Convert sites to sf object (POINTS) ----
#' adour_sites_sf <- sf::st_as_sf(adour_sites, coords = 2:3, crs = "epsg:2154")
#' 
#' # Retrieve nodes (from nodes vector) ----
#' adour_nodes <- nodes_list(adour_sites$"site")
#' 
#' # Find edges with 1 degree of neighborhood (undirected) ----
#' adour_edges <- edges_list(adour_nodes)
#' 
#' # Get adjacency matrix ----
#' adour_adjacency <- adjacency_matrix(adour_edges)
#' adour_adjacency
#' 
#' # Compute distances between pairs of sites along the Adour river ----
#' adour_dists <- distance_euclidean(adour_sites_sf)
#' 
#' # Create Edges weight matrix ----
#' adour_weights <- edges_weight_matrix(adour_dists)
#' adour_weights
#' 
#' # Create Spatial weight matrix ----
#' spatial_weights_matrix(adour_adjacency, adour_weights)

spatial_weights_matrix <- function(x, y) {
  
  ## Check 'x' argument ----
  
  if (missing(x)) {
    stop("Argument 'x' is required", call. = FALSE)
  }
  
  if (!is.matrix(x)) {
    stop("Argument 'x' must be a matrix (adjacency matrix)", call. = FALSE)
  }
  
  if (!is.numeric(x)) {
    stop("Argument 'x' must be a numeric matrix (adjacency matrix)", 
         call. = FALSE)
  }
  
  if (nrow(x) != ncol(x)) {
    stop("Number of rows of 'x' must be equal to number of columns ", 
         "(adjacency matrix)", call. = FALSE)
  }
  
  if (is.null(rownames(x))) {
    stop("Row names of 'x' must contain nodes labels", call. = FALSE)
  }
  
  if (any(!(rownames(x) %in% colnames(x)))) {
    stop("Row names and column names of 'x' must be equal", call. = FALSE)
  }
  
  if (sum(!is.na(x) & x != 0) == 0) {
    stop("Argument 'x' contains no edge", call. = FALSE)
  }
  
  
  ## Check 'y' argument ----
  
  if (missing(y)) {
    stop("Argument 'y' is required", call. = FALSE)
  }
  
  if (!is.matrix(y)) {
    stop("Argument 'y' must be a matrix (edges weight matrix)", call. = FALSE)
  }
  
  if (!is.numeric(y)) {
    stop("Argument 'y' must be a numeric matrix (edges weight matrix)", 
         call. = FALSE)
  }
  
  if (nrow(y) != ncol(y)) {
    stop("Number of rows of 'y' must be equal to number of columns ", 
         "(edges weight matrix)", call. = FALSE)
  }
  
  if (is.null(rownames(y))) {
    stop("Row names of 'y' must contain nodes labels", call. = FALSE)
  }
  
  if (any(!(rownames(y) %in% colnames(y)))) {
    stop("Row names and column names of 'y' must be equal", call. = FALSE)
  }
  
  if (sum(!is.na(y) & y != 0) == 0) {
    stop("Argument 'y' contains no weight", call. = FALSE)
  }
  
  
  ## Check 'x' and 'y' arguments ----
  
  if (nrow(x) != nrow(y)) {
    stop("Number of nodes is not equal between 'x' (adjacency matrix) and ", 
         "'y' (edges weight matrix)", call. = FALSE)
  }
  
  if (any(!(rownames(y) %in% rownames(x)))) {
    stop("Nodes names do not match between 'x' (adjacency matrix) and ", 
         "'y' (edges weight matrix)", call. = FALSE)
  }
  
  if (sum(rownames(y) == rownames(x)) != nrow(x)) {
    stop("Nodes names are not in the same order in 'x' (adjacency matrix) ", 
         "and 'y' (edges weight matrix)", call. = FALSE)
  }
  
  if (sum(colnames(y) == colnames(x)) != ncol(x)) {
    stop("Nodes names are not in the same order in 'x' (adjacency matrix) ", 
         "and 'y' (edges weight matrix)", call. = FALSE)
  }
  
  
  ## Create spatial weight matrix ----
  
  mat <- x * y
  
  mat[which(is.na(mat) | mat == 0)] <- 4 * max(mat, na.rm = TRUE)
  
  mat
}
