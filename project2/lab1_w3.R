A <- matrix(c(1, 2, 3, 4), nrow = 2)

cache <- makeCacheMatrix(A)
A_inv_cached <- cacheSolve(cache)от

A_inv <- solve(A)

identical(A_inv, A_inv_cached())