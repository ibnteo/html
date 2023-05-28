#!/usr/bin/env python3
#coding: utf-8

import datetime

def text(str):
    r = {"&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;"}
    for key in r:
        str = str.replace(key, r[key])
    return str

def tnode(tag, t=""):
    return "<" + tag + ">" + text(t) + "</" + tag + ">"

def node(tag, n=[]):
    return "<" + tag + ">" + nodes(n) + "</" + tag + ">"

def attributes(attr):
    a = ""
    for key in attr:
        val = attr[key]
        a = " " + key
        if val != "":
            a += "=\"" + text(val) + "\""
    return a

def anode(tag, attr, n=[]):
    return "<" + tag + attributes(attr) + ">" + nodes(n) + "</" + tag + ">"

def inode(tag, attr):
    return "<" + tag + attributes(attr) + ">"

def nodes(n):
    return ''.join(n)

start = datetime.datetime.now()
html = ""
for i in range(0, 100_000):
    html = nodes([
        inode("!doctype", {"html":""}),
        anode("html", {"lang":"en"}, [
            node("head", [
                inode("meta", {"charset":"utf-8"}),
                tnode("title", "Test"),
            ]),
            node("body", [
                anode("div", {"class": "alert alert-danger"}, [text("Test")]),
                tnode("span", "Abc & def"),
            ])
        ]),
    ])
end = datetime.datetime.now()
print(html)
print("Python: "+str(end-start))
