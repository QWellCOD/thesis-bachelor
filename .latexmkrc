# latexmk configuration, used by LaTeX Workshop and by `latexmk` on the command line.

# pdfLaTeX; -shell-escape is required by minted
$pdf_mode = 1;
$pdflatex = 'pdflatex -shell-escape -synctex=1 -file-line-error -interaction=nonstopmode %O %S';

# All generated files (incl. the PDF) go to build/
$out_dir = 'build';
# MiKTeX does not export the output directory itself, but minted v3 needs it
$ENV{'TEXMF_OUTPUT_DIRECTORY'} = $out_dir;

# biblatex/biber is detected automatically; also remove the .bbl on clean
$bibtex_use = 2;

# glossaries: main glossary (glo -> gls) and list of acronyms (acn -> acr)
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
add_cus_dep('acn', 'acr', 0, 'makeglossaries');
$clean_ext .= ' acn acr alg glo gls glg ist';

sub makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    my @args = ('-d', $path, $base_name);
    unshift @args, '-q' if $silent;
    return system('makeglossaries', @args);
}
