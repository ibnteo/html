function text(str) {
    str = str.replace('&', '&amp;');
    str = str.replace('<', '&lt;');
    str = str.replace('>', '&gt;');
    str = str.replace('"', '&quot;');
	return str;
}

function tnode(tag, t) {
	return '<' + tag + '>' + text(t) + '</' + tag + '>';
}

function node(tag, ...nodes) {
	const t = nodes.join('');
	return '<' + tag + '>' + t + '</' + tag + '>';
}

function attributes(attr) {
	let a = '';
	for (const [key, val] of Object.entries(attr)) {
		a += ' ' + key + (val != '' ? '="' + text(val) + '"' : '');
	}
	return a;
}

function anode(tag, attr, ...nodes) {
	const a = attributes(attr);
	const t = nodes.join('');
	return '<' + tag + a + '>' + t + '</' + tag + '>';
}

function inode(tag, attr) {
	const a = attributes(attr);
	return '<' + tag + a + '>';
}

function nodes(...nodes) {
	return nodes.join('');
}

const start = new Date();
let html = '';
for (let i=0; i<100_000; i++) {
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
const end = new Date();
console.log(html);
console.log('JavaScript: '+(end-start)+'ms');