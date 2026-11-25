import System.IO

countTags :: String -> Integer
countTags tags = go 0 tags
    where
        go n [] = n
        go n (tag:tags)
            | tag == '<' = go (n + 1) tags
            | otherwise  = go n tags

main :: IO ()
main = do
    hSetEncoding stdin utf8
    hSetEncoding stdout utf8
    filePath <- getLine
    content <- readFile filePath
    print (countTags content)
