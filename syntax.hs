-- 定义数据
name = "James Bond"
age :: Int
age = 50

-- 定义函数
nextInt :: Int -> Int
nextInt x = x + 1

equal x y = x == y
isEven x = equal (mod x 2) 0

-- 函数也是数据
isEven' :: Int -> Bool
isEven' = \x -> mod x 2 == 0

-- 递归函数
fact 0 = 1
fact n = n * fact (n - 1)
-- 定义 List    
list = 1:2:3:4:5:[]
list' = [1,2,3,4,5]
list'' = fromTo 1 6
-- 模式匹配 + 汉编
fromTo :: Int -> Int -> [Int]
fromTo 开始 结束
    | 开始 == 结束 = []
    | 开始 < 结束 = 开始 : (fromTo (开始 + 1) 结束)
    | 开始 > 结束 = 开始 : (fromTo (开始 - 1) 结束)
-- Curry
fromZero = fromTo 0
toZero = \x -> fromTo x 0
-- Compose
isOdd :: Int -> Bool
isOdd = isEven . nextInt


