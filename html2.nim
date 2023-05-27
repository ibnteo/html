import tables
import strutils
import times
import stringbuilder

# type attr = table[string, string]

proc text(str: string): string =
    result = str.multiReplace(("&", "&amp;"), ("<", "&lt;"), (">", "&gt;"), ("\"", "&quot;"))


proc node(tag: string, nodes: varargs[string]): string =
    var b = newStringBuilder(0)
    b.append("<")
    b.append(tag)
    b.append(">")
    for node in nodes:
        b.append(node)
    b.append("</")
    b.append(tag)
    b.append(">")
    result = b.destroy()

proc tnode(tag: string, t: string): string =
    var b = newStringBuilder(0)
    b.append("<")
    b.append(tag)
    b.append(">")
    b.append(text(t))
    b.append("</")
    b.append(tag)
    b.append(">")
    result = b.destroy()

proc attributes(attr: Table[string, string]): string =
    var b = newStringBuilder(0)
    for key, val in attr:
        b.append(" ")
        b.append(key)
        if val != "":
            b.append("=\"")
            b.append(text(val))
            b.append("\"")
    result = b.destroy()

proc anode(tag: string, attr: Table[string, string], nodes: varargs[string]): string =
    var b = newStringBuilder(0)
    b.append("<")
    b.append(tag)
    b.append(attributes(attr))
    b.append(">")
    for node in nodes:
        b.append(node)
    b.append("</")
    b.append(tag)
    b.append(">")
    result = b.destroy()

proc inode(tag: string, attr: Table[string, string]): string =
    var b = newStringBuilder(0)
    b.append("<")
    b.append(tag)
    b.append(attributes(attr))
    b.append(">")
    result = b.destroy()

proc nodes(nodes: varargs[string]): string =
    var b = newStringBuilder(0)
    for node in nodes:
        b.append(node)
    result = b.destroy()

var tstart = cpuTime()
var html = newStringBuilder(0)
for i in countup(0, 100_000):
    html = newStringBuilder(0)
    html.append(nodes(
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
    ))
var tend = cpuTime()
echo html.destroy(), "\n"
echo "Nim2: ", tend - tstart, "\n"
