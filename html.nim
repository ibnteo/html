import tables
import strutils
import times

# type attr = table[string, string]

proc text(str: string): string =
    result = str.multiReplace(("&", "&amp;"), ("<", "&lt;"), (">", "&gt;"), ("\"", "&quot;"))


proc node(tag: string, nodes: varargs[string]): string =
    result = "<" & tag & ">" & join(nodes, "") & "</" & tag & ">"

proc tnode(tag: string, t: string): string =
    result = "<" & tag & ">" & text(t) & "</" & tag & ">"

proc attributes(attr: Table[string, string]): string =
    result = ""
    for key, val in attr:
        result = result & " " & key
        if val != "":
            result = result & "=\"" & text(val) & "\""

proc anode(tag: string, attr: Table[string, string], nodes: varargs[string]): string =
    result = "<" & tag & attributes(attr) & ">"
    for node in nodes:
        result = result & node
    result = result & "</" & tag & ">"

proc inode(tag: string, attr: Table[string, string]): string =
    result = "<" & tag & attributes(attr) & ">"

proc nodes(nodes: varargs[string]): string =
    result = ""
    for node in nodes:
        result = result & node

var tstart = cpuTime()
var html = ""
for i in countup(0, 100_000):
    html = nodes(
        inode("!doctype", {"html": ""}.toTable),
        anode("html", {"lang": "en"}.toTable,
            node("head",
                inode("meta", {"charset": "utf-8"}.toTable),
                tnode("title", "Test"),
            ),
            node("body",
                anode("div", {"class": "alert alert-danger"}.toTable, text("Test")),
                tnode("span", "Abc & def"),
            ),
        ),
    )
var tend = cpuTime()
echo html, "\n"
echo "Nim: ", tend - tstart, "\n"
