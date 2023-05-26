module main

import time
import strings

type Attr = map[string]string

pub fn text(str string) string {
	return str.replace_each(['<', '&lt;', '>', '&gt;', '&', '&amp;', '"', '&quot;'])
}

fn tnode(tag string, t string) string {
	mut n := strings.new_builder(100)
	n.write_string('<')
	n.write_string(tag)
	n.write_string('>')
	n.write_string(text(t))
	n.write_string('</')
	n.write_string(tag)
	n.write_string('>')
	return n.str()
}

pub fn node(tag string, nodes ...string) string {
	mut n := strings.new_builder(100)
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
	mut a := strings.new_builder(100)
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
	a := attributes(attr)
	mut n := strings.new_builder(100)
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
	mut n := strings.new_builder(100)
	n.write_string('<')
	n.write_string(tag)
	n.write_string(a)
	n.write_string('>')
	return n.str()
}

pub fn nodes(nodes ...string) string {
	mut n := strings.new_builder(1000)
	for node in nodes {
		n.write_string(node)
	}
	return n.str()
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
