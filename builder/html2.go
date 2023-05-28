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
	b := strings.Builder{}
	b.WriteString("<")
	b.WriteString(tag)
	b.WriteString(">")
	for _, node := range nodes {
		b.WriteString(node)
	}
	b.WriteString("</")
	b.WriteString(tag)
	b.WriteString(">")
	return b.String()
}

func tnode(tag string, t string) string {
	b := strings.Builder{}
	b.WriteString("<")
	b.WriteString(tag)
	b.WriteString(">")
	b.WriteString(text(t))
	b.WriteString("</")
	b.WriteString(tag)
	b.WriteString(">")
	return b.String()
}

func attributes(attr attr) string {
	b := strings.Builder{}
	for key, val := range attr {
		b.WriteString(" ")
		b.WriteString(key)
		if val != "" {
			b.WriteString("=\"")
			b.WriteString(text(val))
			b.WriteString("\"")
		}
	}
	return b.String()
}

func anode(tag string, attr attr, nodes ...string) string {
	b := strings.Builder{}
	b.WriteString("<")
	b.WriteString(tag)
	b.WriteString(attributes(attr))
	b.WriteString(">")
	for _, node := range nodes {
		b.WriteString(node)
	}
	b.WriteString("</")
	b.WriteString(tag)
	b.WriteString(">")
	return b.String()
}

func inode(tag string, attr attr) string {
	b := strings.Builder{}
	b.WriteString("<")
	b.WriteString(tag)
	b.WriteString(attributes(attr))
	b.WriteString(">")
	return b.String()
}

func nodes(nodes ...string) string {
	b := strings.Builder{}
	for _, node := range nodes {
		b.WriteString(node)
	}
	return b.String()
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
	fmt.Printf("Go2: %vms\n", end-start)
}
