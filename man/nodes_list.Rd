% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nodes_list.R
\name{nodes_list}
\alias{nodes_list}
\title{Retrieve and order nodes from an edges list}
\usage{
nodes_list(x)
}
\arguments{
\item{x}{either a \code{data.frame} with at least two columns: \code{from}, the label
of one of the two nodes of the edge and \code{to}, label of the other node of
the edge, or a \code{character} vector with nodes labels.}
}
\value{
A \code{character} vector of unique ordered nodes labels.
}
\description{
Retrieves and orders nodes from an edges list or from a vector of nodes.
}
\examples{
# Import Adour sites ----
path_to_file <- system.file("extdata", "adour_sites_coords.csv", 
                            package = "bridge")
adour_sites  <- read.csv(path_to_file)

# Retrieve nodes (from nodes vector) ----
adour_nodes <- nodes_list(adour_sites$"site")
adour_nodes

# Find edges with 1 degree of neighborhood (undirected network) ----
adour_edges <- edges_list(adour_nodes)

# Retrieve nodes (from edges list) ----
nodes_list(adour_edges)
}
