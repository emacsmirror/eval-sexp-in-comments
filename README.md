# eval-last-sexp-in-comments

`eval-last-sexp-in-comments` attempts to evaluate the last sexp using
`eval-last-sexp` (the latter usually being on C-x C-e). If that raises
an error, however, `eval-last-sexp-in-comments` will try to uncomment
the last sexp in a temporary buffer and evaluate `eval-last-sexp`
there.

This is usefull when you have commented debugging code in you elisp
files, which you want to use. Instead of uncommenting the region,
hitting C-x C-e, and commenting the stuff again when you are done,
just redefine C-x C-e, such that `eval-last-sexp-in-comments` is
called instead of `eval-last-sexp`.
