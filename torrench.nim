let doc = """
       _           ____              
 _ __ (_)_ __ ___ | __ )  __ _ _   _ 
| '_ \| | '_ ` _ \|  _ \ / _` | | | |
| | | | | | | | | | |_) | (_| | |_| |
|_| |_|_|_| |_| |_|____/ \__,_|\__, |
                               |___/ 


Small tool for searching files online.

Usage:
 nimbay

Options:
 -h --help         Shows this screen
 --version

"""

import os,terminal, fab, xmltree, httpClient, docopt, htmlparser
import strtabs # To access XmlAttributes
import strutils # To use cmpIgnoreCase
import browsers

let args = docopt(doc, version = "nimBay 0.0.1")

var names, links : seq[string]


# info("Getting proxies")

# proc extractProxiesLinks(html: string): seq[string] =
#     var client = newHttpClient()
#     var url = client.getContent(html)
#     let htmlParsed = parseHtml(url)
#     for a in htmlParsed.findAll("td"):
#         if a.attrs.hasKey "data-href":
#             result.add(a.attr("data-href"))

# var proxies = extractProxiesLinks(html = "https://thepiratebay-proxylist.org/")

# info("Fetching " & proxies[1])

info("Downloading list of torrents", fg = fgYellow, sty = {styleBright})

proc listOfTorrents(html: string): (seq[string],seq[string]) =
    var client = newHttpClient()
    var url = client.getContent(html & "/top/all")
    let htmlParsed = parseHtml(url)
    var name, link: seq[string]
    #echo htmlParsed
    for a in htmlParsed.findAll("a"):
        if a.attrs.hasKey "href":
            if a.attr("href").contains("/torrent/"):
                name.add(a.attr("href").splitPath().tail)
            if a.attr("href").contains("magnet:"):
                link.add(a.attr("href"))
    return (name, link)

(names, links) = listOfTorrents(html = "https://thepiratebay.org/top/all")



for i in 0..<len(names):
    echo $i & " - " & $names[i]

que("Pick your file: ", sty = {styleBright}, fg = fgRed)
let result: int = parseInt(readLine(stdin))


openDefaultBrowser(url = links[result])

good("See ya mate!")
