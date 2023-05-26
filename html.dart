import 'dart:io';

typedef Attr = Map<String, String>;

String text(String str) {
    Map<String, String> esc = {'&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;'};
    esc.forEach((key, value) {str = str.replaceAll(key, value);});
	return str;
}

String node(String tag, List<String> nodes) {
	return "<" + tag + ">" + nodes.join('') + "</" + tag + ">";
}

String tnode(String tag, String t) {
	return "<" + tag + ">" + text(t) + "</" + tag + ">";
}

String attributes(Attr attr) {
	var a = '';
	for (var key in attr.keys.toList()) {
        if (attr.containsKey(key)) {
            var val = attr[key]!;
            a += " " + key;
            if (val != "") {
                a += "=\"" + text(val) + "\"";
            }
        }
	}
	return a;
}

String anode(String tag, Attr attr, List<String> nodes) {
	var a = attributes(attr);
	var t = nodes.join('');
	return "<" + tag + a + ">" + t + "</" + tag + ">";
}

String inode(String tag, Attr attr) {
	var a = attributes(attr);
	return "<" + tag + a + ">";
}

String nodes(List<String> nodes) {
	return nodes.join('');
}


main(List<String> args) {
    var start = new DateTime.now();
    var html = '';
    for (var i=0; i<100000; i++) {
		html = nodes([
			inode("!doctype", {"html": ""}),
			anode("html", {"lang": "en"}, [
				node("head", [
					inode("meta", {"charset": "utf-8"}),
					tnode("title", "Test"),
                ]),
				node("body", [
					anode("div", {"class": "alert alert-danger"}, [text("Test")]),
					tnode("span", "Abc & def"),
				]),
			]),
		]);
    }
    var end = new DateTime.now();
    print(html);
    print('Dart: ' + (end.difference(start).inMilliseconds).toString() + 'ms');
}