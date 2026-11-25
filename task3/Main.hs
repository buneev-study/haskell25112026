module Main where
import qualified Data.ByteString.Char8 as B
import Text.Regex.PCRE

main :: IO ()
main = do
    filePath <- getLine
    text <- B.readFile filePath
    let pattern = B.pack "(?s)<a href=\"https://[^\"]+\"[^>]*>.*?</a>"

    if text =~ pattern
        then putStrLn "Ссылки найдены!"
        else putStrLn "Ссылки не найдены."

    let links = getAllTextMatches (text =~ pattern) :: [B.ByteString]
    B.writeFile "output3.txt" (B.unlines links)
