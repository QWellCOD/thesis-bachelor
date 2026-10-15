% Bachelor thesis class (Hochschule Reutlingen, Fakultät Informatik).
% Layout follows the Exposé; typesetting with pdfLaTeX, two-sided print with binding.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hsrt-thesis}[2026/10/15 v1.0 Bachelor thesis HSRT]

\LoadClass[
  fontsize=11pt,
  twoside=true,
  open=right,
  BCOR=8mm,
  cleardoublepage=empty,
  captions=tableheading,
  listof=totoc,
  numbers=noenddot,
  chapterprefix=false,
]{scrbook}

% Logos and the declaration form are PDF 1.6/1.7
\pdfminorversion=7
% Harmless: two logos with transparency groups on the title page
\pdfsuppresswarningpagegroup=1

% --- Language and fonts ---
\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman]{babel}
\RequirePackage[osf,p]{libertineRoman}
% Scale factors match the x-heights to Libertine (\fontdimen5 ratios)
\RequirePackage[scaled=0.80]{noto-sans}
\RequirePackage[scaled=0.94,varqu,varl]{inconsolata}
\RequirePackage[libertine]{newtxmath}
% newtxmath takes math digits from the text font; use lining figures there
\DeclareSymbolFont{operators}{OT1}{LinuxLibertineT-TLF}{m}{n}
\SetSymbolFont{operators}{bold}{OT1}{LinuxLibertineT-TLF}{\bold@wt}{n}
% Type area calculated after the fonts are loaded
\KOMAoptions{DIV=calc}

% Lining tabular figures in tables, old-style figures in running text
\AddToHook{env/tabular/begin}{\figureversion{lining,tabular}}
\AddToHook{env/tabularx/begin}{\figureversion{lining,tabular}}

% --- Page layout ---
% pass: geometry keeps the typearea layout, it is only used for the title page
\RequirePackage[pass]{geometry}
\RequirePackage{scrlayer-scrpage}
\clearpairofpagestyles
\cfoot*{\pagemark}
\setkomafont{pageheadfoot}{\normalfont\sffamily}
\setkomafont{pagenumber}{\normalfont\sffamily}
\pagestyle{scrheadings}

\setcounter{secnumdepth}{\subsectionnumdepth}
\setcounter{tocdepth}{\subsectiontocdepth}

% --- General packages ---
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tabularx}
\RequirePackage{enumitem}
\setlist{noitemsep}
\RequirePackage{pdfpages}
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}

% --- Code listings (minted must be loaded before csquotes) ---
% float instead of newfloat: with newfloat, KOMA and the listings package of latexdiff
% both register the .lol file and the diff build fails
\RequirePackage[chapter]{minted}
% KOMA float style: caption above, formatted and spaced like table captions
\floatstyle{komaabove}
\restylefloat{listing}
\setminted{
  style=bw,
  fontsize=\footnotesize,
  linenos,
  numbersep=5pt,
  xleftmargin=15pt,
  frame=lines,
  breaklines,
  tabsize=4,
}

% Colors of the Exposé listings, applied on top of the Pygments style "bw"
\definecolor{hsrtKeyword}{rgb}{0.37,0.08,0.25}
\definecolor{hsrtComment}{rgb}{0.133,0.545,0.133}
\definecolor{hsrtString}{rgb}{0,0.126,0.941}
\def\hsrt@pyg@keyword{\let\PYG@bf=\textbf\def\PYG@tc##1{\textcolor{hsrtKeyword}{##1}}}
\def\hsrt@pyg@comment{\def\PYG@tc##1{\textcolor{hsrtComment}{##1}}}
\def\hsrt@pyg@string{\def\PYG@tc##1{\textcolor{hsrtString}{##1}}}
\newcommand*\hsrt@pyg@set[2]{%
  \@for\hsrt@tmp:=#2\do{\expandafter\let\csname PYG@tok@\hsrt@tmp\endcsname#1}}
% minted calls this hook every time it (re)loads a highlighting style
\appto\minted@patch@PygmentsStyledef{%
  \hsrt@pyg@set\hsrt@pyg@keyword{k,kc,kd,kn,kp,kr,kt,ow}%
  \hsrt@pyg@set\hsrt@pyg@comment{c,ch,cm,c1,cs,cpf}%
  \hsrt@pyg@set\hsrt@pyg@string{s,sa,sb,sc,dl,sd,s2,se,sh,si,sx,sr,s1,ss}%
  \hsrt@pyg@set\relax{nc,nn,ne,ni,nt}}

\RequirePackage[autostyle=true]{csquotes}
\RequirePackage{microtype}

% --- Bibliography ---
\RequirePackage[backend=biber, style=apa]{biblatex}

% --- Links, abbreviations, cross-references (cleveref last) ---
\RequirePackage[hidelinks, bookmarksnumbered, pdfdisplaydoctitle]{hyperref}
\RequirePackage[acronym, nomain, toc, nonumberlist, style=long]{glossaries-extra}
\setabbreviationstyle[acronym]{long-short}
\makeglossaries
\RequirePackage[ngerman]{cleveref}
\crefname{listing}{Listing}{Listings}

% --- Title page data ---
\newcommand*\academicdegree[1]{\def\hsrt@academicdegree{#1}}
\newcommand*\studyprogram[1]{\def\hsrt@studyprogram{#1}}
\newcommand*\faculty[1]{\def\hsrt@faculty{#1}}
\newcommand*\university[1]{\def\hsrt@university{#1}}
\newcommand*\matriculationnumber[1]{\def\hsrt@matriculationnumber{#1}}
% Rows of a two-column table: Role: & Name \\ ...
\newcommand\examiners[1]{\def\hsrt@examiners{#1}}
\academicdegree{}
\studyprogram{}
\faculty{}
\university{}
\matriculationnumber{}
\examiners{}

\AtBeginDocument{%
  \hypersetup{
    pdftitle={\@title},
    pdfauthor={\@author},
    pdfsubject={Bachelorarbeit},
  }%
}

\renewcommand*{\maketitle}{%
  \cleardoublepage
  \newgeometry{top=4cm, bottom=3cm, inner=3cm, outer=3cm, bindingoffset=8mm}%
  \begin{titlepage}
    \centering\sffamily
    \includegraphics[width=7cm]{assets/Logos/HSRT}\par
    \vspace{0.5cm}
    \vfill
    Bachelorarbeit\par
    \vspace{0.8cm}
    {\Huge\bfseries\@title\par}
    \vspace{2cm}
    {\Large\@author\par}
    \vspace{0.2cm}
    Matrikelnummer: \hsrt@matriculationnumber\par
    \vspace{0.8cm}
    zur Erlangung des akademischen Grades\\
    \hsrt@academicdegree\\
    im Studiengang \hsrt@studyprogram\\
    an der \hsrt@faculty\ der \hsrt@university\par
    \vspace{0.8cm}
    {\large Abgabedatum: \@date\par}
    \vspace{0.8cm}
    \begin{tabular}{@{}r@{\quad}l@{}}
      \hsrt@examiners
    \end{tabular}\par
    \vfill
    \begin{minipage}[c][3cm][c]{\textwidth}
      \centering
      \includegraphics[height=2.4cm]{assets/Logos/Bosch/Bosch_symbol_logo_black}%
      \hspace{1.5cm}%
      \includegraphics[height=2.2cm]{assets/Logos/INF/Simple_BW}%
    \end{minipage}\par
    \vspace{1cm}
  \end{titlepage}
  \restoregeometry
}

\endinput
