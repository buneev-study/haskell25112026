import System.IO

everyThird :: [String] -> [String]
everyThird list = go 0 list []
    where
        go i [] res = reverse res
        go i (str:l) res
            | i `mod` 3 == 2 = go (i + 1) l (str : res)
            | otherwise = go (i + 1) l res


main :: IO ()
main = do
    hSetEncoding stdin utf8
    hSetEncoding stdout utf8
    filePath <- getLine
    content <- readFile filePath
    let linesList = lines content
    writeFile "output2.txt" (unlines (everyThird linesList))
    putStrLn "Saved to output2.txt"
