#!/bin/sh
go run html.go
go run builder/html2.go
v run html.v
v run html2.v
dart html.dart
dart html2.dart
nim compile --run html.nim 
nim compile --run html2.nim 
php html.php
