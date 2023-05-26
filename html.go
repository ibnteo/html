package main

import (
	"fmt"
	"strings"
	"time"
)

type attr = map[string]string

func text(str string) string {
	r := strings.NewReplacer("<", "&lt;", ">", "&gt;", "&", "&amp;", "\"", "&quot;")
	return r.Replace(str)
}

func node(tag string, nodes ...string) string {
	t := strings.Join(nodes, "")
	return "<" + tag + ">" + t + "</" + tag + ">"
}

func tnode(tag string, t string) string {
	return "<" + tag + ">" + text(t) + "</" + tag + ">"
}

func attributes(attr attr) string {
	a := ""
	for key, val := range attr {
		a += " " + key
		if val != "" {
			a += "=\"" + text(val) + "\""
		}
	}
	return a
}

func anode(tag string, attr attr, nodes ...string) string {
	a := attributes(attr)
	t := strings.Join(nodes, "")
	return "<" + tag + a + ">" + t + "</" + tag + ">"
}

func inode(tag string, attr attr) string {
	a := attributes(attr)
	return "<" + tag + a + ">"
}

func nodes(nodes ...string) string {
	return strings.Join(nodes, "")
}

func main() {
	start := time.Now().UnixMilli()
	html := ""
	for i := 0; i < 100_000; i++ {
		html = nodes(
			inode("!doctype", attr{"html": ""}),
			anode("html", attr{"lang": "en"},
				node("head",
					inode("meta", attr{"charset": "utf-8"}),
					tnode("title", "Test"),
				),
				node("body",
					anode("div", attr{"class": "alert alert-danger"}, text("Test")),
					tnode("span", "Abc & def"),
				),
			),
		)
	}
	end := time.Now().UnixMilli()
	fmt.Println(html)
	fmt.Printf("Go: %vms\n", end-start)
}
