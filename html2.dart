import 'dart:io';

typedef Attr = Map<String, String>;

String text(String str) {
    Map<String, String> esc = {'&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;'};
    esc.forEach((key, value) {str = str.replaceAll(key, value);});
	return str;
}

String node(String tag, List<String> nodes) {
    final buffer = StringBuffer();
    buffer
        ..write("<")
        ..write(tag)
        ..write(">");
    for (var node in nodes) {
        buffer.write(node);
    }
    buffer
        ..write("</")
        ..write(tag)
        ..write(">");
	return buffer.toString();
}

String tnode(String tag, String t) {
    final buffer = StringBuffer();
    buffer
        ..write("<")
        ..write(tag)
        ..write(">")
        ..write(text(t))
        ..write("</")
        ..write(tag)
        ..write(">");
	return buffer.toString();
}

String attributes(Attr attr) {
    final buffer = StringBuffer();
	for (var key in attr.keys.toList()) {
        if (attr.containsKey(key)) {
            var val = attr[key]!;
            buffer
                ..write(" ")
                ..write(key);
            if (val != "") {
            buffer
                ..write('="')
                ..write(text(val))
                ..write('\"');
            }
        }
	}
	return buffer.toString();
}

String anode(String tag, Attr attr, List<String> nodes) {
    final buffer = StringBuffer();
    buffer
        ..write("<")
        ..write(tag)
        ..write(attributes(attr))
        ..write(">");
    for (var node in nodes) {
        buffer.write(node);
    }
    buffer
        ..write("</")
        ..write(tag)
        ..write("<");
	return buffer.toString();
}

String inode(String tag, Attr attr) {
    final buffer = StringBuffer();
    buffer
        ..write("<")
        ..write(tag)
        ..write(attributes(attr))
        ..write(">");
	return buffer.toString();
}

String nodes(List<String> nodes) {
    final buffer = StringBuffer();
    for (var node in nodes) {
        buffer.write(node);
    }
	return buffer.toString();
}


main(List<String> args) {
    var start = new DateTime.now();
    final buffer = StringBuffer();
    for (var i=0; i<100000; i++) {
        buffer.clear();
		buffer.write(nodes([
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
		]));
    }
    var end = new DateTime.now();
    print(buffer.toString());
    print('Dart2: ' + (end.difference(start).inMilliseconds).toString() + 'ms');
}