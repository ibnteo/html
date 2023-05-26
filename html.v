module main

import time

type Attr = map[string]string

pub fn text(str string) string {
	return str.replace_each(['<', '&lt;', '>', '&gt;', '&', '&amp;', '"', '&quot;'])
}

fn tnode(tag string, t string) string {
	return '<$tag>${text(t)}</$tag>'
}

pub fn node(tag string, nodes ...string) string {
	t := nodes.join('')
	return '<$tag>$t</$tag>'
}

fn attributes(attr Attr) string {
	mut a := ''
	for key, val in attr {
		a += ' ' + key + if val != '' { '="' + text(val) + '"' } else { '' }
	}
	return a
}

pub fn anode(tag string, attr Attr, nodes ...string) string {
	a := attributes(attr)
	t := nodes.join('')
	return '<$tag$a>$t</$tag>'
}

pub fn inode(tag string, attr Attr) string {
	a := attributes(attr)
	return '<$tag$a>'
}

pub fn nodes(nodes ...string) string {
	return nodes.join('')
}

fn main() {
	start := time.now()
	mut html := ''
	for i:=0; i<100_000; i++ {
		html = nodes(
			inode('!doctype', {'html':''}),
			anode('html', {'lang':'en'},
				node('head',
					inode('meta', {'charset':'utf-8'}),
					tnode('title', 'Test'),
				),
				node("body",
					anode('div', {'class': 'alert alert-danger'}, text('Test')),
					tnode('span', 'Abc & def'),
				),
			),
		)
	}
	end := time.now()
	println(html)
	println('V: ${end-start}')
}
