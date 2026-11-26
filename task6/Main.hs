module Main where

import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy as BL
import qualified Codec.Text.IConv as IConv
import Text.Regex.PCRE

main :: IO ()
main = do
    filePath <- getLine
    text <- B.readFile filePath
    let pattern = B.pack "(?is)<h3[^>]*>.*?</h3>"

    if text =~ pattern
        then putStrLn "Заголовки найдены!"
        else putStrLn "Заголовки не найдены."

    let headers = getAllTextMatches (text =~ pattern) :: [B.ByteString]
    let utf8Strict = B.unlines headers
    let utf8Lazy = BL.fromStrict utf8Strict

    let cp1251Lazy = IConv.convert "UTF-8" "CP1251" utf8Lazy
    let koi8rLazy  = IConv.convert "UTF-8" "KOI8-R"  utf8Lazy

    BL.writeFile "output6_cp1251.txt" cp1251Lazy
    BL.writeFile "output6_koi8r.txt"  koi8rLazy

    putStrLn "Файлы успешно перекодированы в CP1251 и KOI8-R"
