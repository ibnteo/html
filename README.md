# HTML Template Benchmark

```
$ ./benchmark.sh
```

## Result

```
Go: 3744ms
Go2 (strings.Builder): 4497ms
V: 2.221s
V (-prod): 659.877ms
V2 (strings.Builder): 1.779s
V2 (-prod): 574.895ms
Dart: 1725ms
Nim: 3.417453707
Nim2 (stringbuilder.nim): 4.751443744
PHP: 399ms
```

When the string size increases, if you collect all 100_000 templates in one line, the Go, V, Dart languages cannot assemble a string through string concatenation, they work only through StringBuilder, and even faster.

V when compiled into v html.v -prod gives a much better result.