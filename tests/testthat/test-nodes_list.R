# Data for tests ----

nodes <- c("S01", "S02", "S11", "S21")
edges <- edges_list(nodes)[ , -c(1:2)]

edges_from <- edges[ , -1, drop = FALSE]
edges_to   <- edges[ , -2, drop = FALSE]

nodes_num  <- 1:8
nodes_fac  <- as.factor(letters)
nodes_na   <- c(NA, "S02", "S11", "S21")
nodes_one  <- c("S21", "S21", "S21", "S21")
nodes_mat  <- matrix(nodes, ncol = 2)


# Test for errors ----

test_that("nodes_list() - Tests for wrong inputs", {
  
  expect_error(nodes_list(), 
               "Argument 'x' is required", 
               fixed = TRUE)
  
  expect_error(nodes_list(nodes_num), 
               paste0("Argument 'x' must be either a data.frame (edges list) ", 
               "or a character (vector of nodes)"), 
               fixed = TRUE)
  
  expect_error(nodes_list(nodes_fac), 
               paste0("Argument 'x' must be either a data.frame (edges list) ", 
                      "or a character (vector of nodes)"), 
               fixed = TRUE)
  
  expect_error(nodes_list(nodes_mat), 
               paste0("Argument 'x' must be either a data.frame (edges list) ", 
                      "or a character (vector of nodes)"), 
               fixed = TRUE)
  
  expect_error(nodes_list(edges_from), 
               "The column 'from' is absent from the edges data.frame", 
               fixed = TRUE)
  
  expect_error(nodes_list(edges_to), 
               "The column 'to' is absent from the edges data.frame", 
               fixed = TRUE)
  
  expect_error(nodes_list(nodes_na), 
               "Argument 'x' cannot contain NA (unidentified nodes)", 
               fixed = TRUE)
  
  expect_error(nodes_list(nodes_one), 
               "The data contain less than two nodes", 
               fixed = TRUE)
})


# Test for success ----

test_that("nodes_list() - Tests for good outputs", {
  
  ## Test on edges list ----
  
  expect_silent({
    nodes <- nodes_list(edges)
  })
  
  expect_equal(class(nodes), "character")
  expect_equal(length(nodes), 4L)
  expect_equal(nodes[1], "S01")
  expect_equal(nodes[3], "S11")
  
  
  ## Test of nodes vector ----
  
  expect_silent({
    nodes <- nodes_list(c("S01", "S02", "S11", "S21"))
  })
  
  expect_equal(class(nodes), "character")
  expect_equal(length(nodes), 4L)
  expect_equal(nodes[1], "S01")
  expect_equal(nodes[3], "S11")
})
