module main

import time
import strings

type Attr = map[string]string

pub fn text(str string) string {
	return str.replace_each(['<', '&lt;', '>', '&gt;', '&', '&amp;', '"', '&quot;'])
}

fn tnode(tag string, t string) string {
	tt := text(t)
	mut n := strings.new_builder(tag.len*2+5+tt.len)
	n.write_string('<')
	n.write_string(tag)
	n.write_string('>')
	n.write_string(tt)
	n.write_string('</')
	n.write_string(tag)
	n.write_string('>')
	return n.str()
}

pub fn node(tag string, nodes ...string) string {
	mut l := 0
	for node in nodes {
		l += node.len
	}
	mut n := strings.new_builder(l+tag.len*2+5)
	n.write_string('<')
	n.write_string(tag)
	n.write_string('>')
	for node in nodes {
		n.write_string(node)
	}
	n.write_string('</')
	n.write_string(tag)
	n.write_string('>')
	return n.str()
}

fn attributes(attr Attr) string {
	mut a := strings.new_builder(attr.len*20)
	for key, val in attr {
		a.write_string(' ')
		a.write_string(key)
		if val != '' {
			a.write_string('="')
			a.write_string(text(val))
			a.write_string('"')
		}
	}
	return a.str()
}

pub fn anode(tag string, attr Attr, nodes ...string) string {
	mut l := 0
	for node in nodes {
		l += node.len
	}
	a := attributes(attr)
	mut n := strings.new_builder(l+a.len+tag.len*2+5)
	n.write_string('<')
	n.write_string(tag)
	n.write_string(a)
	n.write_string('>')
	for node in nodes {
		n.write_string(node)
	}
	n.write_string('</')
	n.write_string(tag)
	n.write_string('>')
	return n.str()
}

pub fn inode(tag string, attr Attr) string {
	a := attributes(attr)
	mut n := strings.new_builder(a.len+tag.len*2+2)
	n.write_string('<')
	n.write_string(tag)
	n.write_string(a)
	n.write_string('>')
	return n.str()
}

pub fn nodes(nodes ...string) string {
	mut l := 0
	for node in nodes {
		l += node.len
	}
	mut n := strings.new_builder(l)
	for node in nodes {
		n.write_string(node)
	}
	return n.str()
}

fn main() {
	start := time.now()
	//mut html := ''
	mut html := strings.new_builder(0)
	for i:=0; i<100_000; i++ {
		html.clear()
		//html = nodes(
		html.write_string(nodes(
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
		))
	}
	end := time.now()
	println(html.str())
	println('V2: ${end-start}')
}
