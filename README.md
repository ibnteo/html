# HTML Template Benchmark

```
$ ./benchmark.sh
```

## Result

```
Go: 2538ms
Go2: 2597ms

V: 772.060ms
V2: 549.858ms

Dart: 1995ms
Dart2: 1350ms

Nim: 312ms
Nim2: 422ms

Python: 1361ms
JS: 896ms
PHP: 399ms
```

When the string size increases, if you collect all 100_000 templates in one line, the Go, V, Dart languages cannot assemble a string through string concatenation, they work only through StringBuilder, and even faster.

V when compiled into v html.v -prod gives a much better result.