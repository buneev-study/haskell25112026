module Main where
import qualified Data.ByteString.Char8 as B
import Text.Regex.PCRE
import System.IO


main :: IO ()
main = do
    filePath <- getLine
    text <- B.readFile filePath
    let pattern = B.pack "(?is)<h3[^>]*>.*?</h3>"

    if text =~ pattern
        then putStrLn "Заголовки найдены!"
        else putStrLn "Заголовки не найдены."

    let links = getAllTextMatches (text =~ pattern) :: [B.ByteString]
    B.writeFile "pre_output5.txt" (B.unlines links)
    enc
enc :: IO ()
enc = do
    openhandle <- openFile "pre_output5.txt" ReadMode
    cp <- mkTextEncoding "cp866"
    writehandle <- openFile "output5.txt" WriteMode
    hSetEncoding writehandle cp
    contents <- hGetContents openhandle
    hPutStr writehandle (contents)
    hFlush writehandle
    putStrLn "Файл перекодирован в CP866"
    hClose openhandle
    hClose writehandle






