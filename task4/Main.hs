module Main where
import qualified Data.ByteString.Char8 as B
import Text.Regex.PCRE

main :: IO ()
main = do
    filePath <- getLine
    text <- B.readFile filePath
    let pattern = B.pack "(?is)<h3[^>]*>.*?</h3>"

    if text =~ pattern
        then putStrLn "Заголовки найдены!"
        else putStrLn "Заголовки не найдены."

    let links = getAllTextMatches (text =~ pattern) :: [B.ByteString]
    B.writeFile "output4.txt" (B.unlines links)
