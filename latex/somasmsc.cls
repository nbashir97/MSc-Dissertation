%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Most students will not need to edit this file.
% Only edit if you are sure you know what you are doing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{somasmsc}[2020/03/30 SoMaS MSc Dissertations]

\LoadClass[12pt, a4paper, twoside]{book}

\RequirePackage[sort]{natbib}
\RequirePackage{url}
\RequirePackage[pdftex]{graphicx}
\RequirePackage{float}
\RequirePackage{parskip}
\RequirePackage[svgnames, fixpdftex]{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage[T1]{fontenc}
\RequirePackage{verbatim}
\RequirePackage{setspace}
\RequirePackage{mathtools}
\RequirePackage{amssymb}
\RequirePackage[left=37mm, right=30mm, top=35mm, bottom=30mm]{geometry}
\RequirePackage[amsmath, thmmarks]{ntheorem}
\RequirePackage[colorlinks=true, linkcolor=black, urlcolor=black, citecolor=black, anchorcolor=black]{hyperref}
\RequirePackage{todonotes}

% Additional packages
\RequirePackage{rotating}
\RequirePackage[justification = centering]{caption}
\RequirePackage{afterpage}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{bm}
\RequirePackage{pdflscape}
\RequirePackage{multirow}
\RequirePackage{makecell}

% Additional commands
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}

\renewcommand{\bibname}{References}

% Additional command to increase table row height
\setlength\extrarowheight{5pt}

\setlength{\theorempreskipamount}{3.0ex plus 1ex minus 0.75ex}
\setlength{\theorempostskipamount}{3.0ex plus 1ex minus 0.75ex}

\theorembodyfont{\normalfont}
\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{exa}{Example}[section]
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}

\newtheorem{definition}[theorem]{Definition}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{notation}[theorem]{Notation}
\newtheorem{assumption}[theorem]{Assumption}
\newtheorem{conjecture}[theorem]{Conjecture}

\DeclareMathOperator{\E}{E}
\DeclareMathOperator{\Prob}{P}
