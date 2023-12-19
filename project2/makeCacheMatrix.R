makeCacheMatrix <- function(x = matrix()) 
{
  # Ініціалізація початкової матриці
  m <- x
  
  # Зберігання інверсії матриці (початково порожній)
  cache <- NULL
  
  # Функція для встановлення нової матриці
  set <- function(new_matrix) 
  {
    m <<- new_matrix
    
    # При зміні матриці очищуємо кеш
    cache <<- NULL
  }
  
  # Функція для отримання поточної матриці
  get <- function() m
  
  # Функція для обчислення інверсії матриці
  cache_inverse <- function() 
  {
    if (!is.null(cache)) 
    {
      # Якщо інверсія вже є в кеші, повертаємо її
      message("Cached matrix inversion is used")
      return(cache)
    } 
    else 
    {
      # Якщо інверсія відсутня в кеші, обчислюємо її
      message("Calculation of matrix inversion")
      inv <- solve(m)
      
      # Зберігаємо інверсію в кеші
      cache <<- inv
      return(inv)
    }
  }
  
  # Повертаємо список функцій, які можна викликати
  list(set = set, get = get, cache_inverse = cache_inverse)
}
