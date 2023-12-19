cacheSolve <- function(cacheMatrix, ...) 
{
  # Перевіряємо, чи існує об'єкт кешування та чи він не порожній
  if (!is.null(cacheMatrix$cache)) 
  {
    message("Cached matrix inversion is used")
    return(cacheMatrix$cache)
  } 
  else 
  {
    message("Calculation of matrix inversion")
    
    # Якщо інверсія відсутня в кеші, обчислюємо її
    inv <- solve(cacheMatrix$get(), ...)
    
    # Зберігаємо інверсію в об'єкті кешування
    cacheMatrix$cache <- inv
    return(inv)
  }
}