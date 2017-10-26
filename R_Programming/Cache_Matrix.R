## =================================================================================
## makeCacheMatrix() and solveCache() calculate and cache the inverse of a matrix. 
## These functions take a square matrix as input. If inverse of matrix was not
## previously calculated, solve() will be used to find inverse. If inverse was 
## previously calculated, the functions will print its cached value. 
## =================================================================================

## The makeCacheMatrix() function returns a list of functions that are used by the
## cacheSolve() function to set the value of the matrix, get the value of the matrix, 
## set the value of the inverse, and get the value of the inverse.
makeCacheMatrix <- function(x = matrix()) {
     # sets matrix inverse (inv) to NULL, resets each time 
     inv <- NULL
     # function that takes input, saves input matrix, and resets inverse to NULL 
     set <- function(y) {
          x <<- y
          inv <<- NULL
     }
     # function that returns original matrix 
     get <- function() x
     # function that caches inverse value if not already calculated
     setinv <- function(solve) inv <<- solve
     # function to return cached value to cacheSolve() matrix
     getinv <- function() inv
     # returns list of functions to be accessed outside of function
     list(set = set, get = get,
          setinv = setinv,
          getinv = getinv)
}

## The cacheSolve() function will determine if the matrix inverse has already been 
## calculated and will return the matrix inverse. If previously calculated, it will 
## return the cached value. If not previously calculated, it will solve for the 
## inverse of the matrix using the solve() function
cacheSolve <- function(x, ...) {
     # gets value of inverse from makeCacheMatrix() function 
     inv <- x$getinv()
     # if inverse already calculated, then return cached inverse value 
     if(!is.null(inv)) {
          # print to console 
          message("getting cached data...")
          # return cached inverse, exists cacheSolve function 
          return(inv)
     }
     # if inverse not already calculated (inv = NULL)
     data <- x$get()
     # solve for the inverse of the matrix
     inv <- solve(data, ...)
     # store the inverse value in x, used by makeCacheMatrix() function 
     x$setinv(inv)
     ## Return a matrix that is the inverse of 'x'
     inv
}