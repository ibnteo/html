#!/bin/sh

go run html.go
go run builder/html2.go

v html.v -prod && ./html && rm html
v html2.v -prod && ./html2 && rm html2

dart html.dart
dart html2.dart

nim compile --run html.nim
nim compile --run html2.nim

python3 html.py
node html.js
php html.php
