\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kththesis}

\newif\ifinswedish
\DeclareOption{english}{}
\DeclareOption{swedish}{\inswedishtrue}

%% Send any unknown option to the report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions\relax

\LoadClass[12pt]{report}

% Make it possible to conditionally depend on the TeX-engine used
\RequirePackage{ifxetex}
\RequirePackage{ifluatex}
\newif\ifxeorlua
\ifxetex\xeorluatrue\fi
\ifluatex\xeorluatrue\fi

%% Load other packages

\ifxeorlua
  \RequirePackage{polyglossia}
  \ifinswedish
    \setmainlanguage{swedish}
    \setotherlanguage{english}
  \else
    \setmainlanguage{english}
    \setotherlanguage{swedish}
  \fi
\else
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[swedish,english]{babel}
\fi

\RequirePackage[a4paper,
  top=37mm,bottom=50mm,inner=35mm,outer=35mm,
  headsep=15mm,headheight=5mm,footskip=25mm]{geometry} % Set paper and contents dimensions
  
\RequirePackage{fancyhdr} % Take control of headers and footers
\RequirePackage{emptypage} % Supress page numbers on otherwise empty pages

\RequirePackage{titlesec} % Redefine the appearance of headers
% === Patch to circumvent a bug in the titlesec package version 2.10.1
\@ifpackagelater{titlesec}{2016/03/21}{%
 % Package titlesec is on version 2.10.2 or higher, nothing to do %
}{%
 % Check if package titlesec is on version 2.10.1 %
 \@ifpackagelater{titlesec}{2016/03/15}{%
  % Package titlesec on version 2.10.1, patch accordingly %
  \RequirePackage{etoolbox}%
  \patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}%
  \patchcmd{\ttlh@hang}{\noindent}{}{}{}%
 }{%
  % Package titlsecon is on version 2.10.0 or lower, nothing to do %
 }%
}
% === End ot titlesec patch
\setcounter{secnumdepth}{3}
\ifxeorlua
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures={TeX}} % This enables TeX style ligatures such as ---, '', ``, and so on
  \setmainfont{TeX Gyre Pagella} % Palatino from the TeX Gyre Project
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{palatino}
\fi

% Set up the header and footer
\fancyhead{}
\fancyhead[R]{\sffamily\small\leftmark\qquad}
%\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}

% Add 5% extra linespacing
\linespread{1.05}

% Set the proper format for the headers
\titleformat{\chapter}%[display]
  {\normalfont\sffamily\huge\bfseries}
  {\thechapter\ \ \ \rule[-1.5pt]{2pt}{21pt}}{20pt}{\Huge}
\titleformat{\section}
  {\normalfont\sffamily\Large\bfseries}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\sffamily\large\bfseries}
  {\thesubsection}{1em}{}
\titleformat{\subsubsection}
  {\normalfont\sffamily\large\bfseries}
  {\thesubsubsection}{1em}{}

\renewenvironment{abstract}{\section*{\abstractname}}{\clearpage}


\newenvironment{sweabstract} {\section*{Referat}}{\clearpage}

% Define commands for setting the user definable parts of the title page
\newcommand{\supervisor}[1]{\def\@supervisor{#1}}
\newcommand{\examiner}[1]{\def\@examiner{#1}}
\let\@secondauthor\@empty
\newcommand{\secondauthor}[1]{\def\@secondauthor{#1}}
\let\@subtitle\@empty
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\let\@alttitle\@empty
\newcommand{\alttitle}[1]{\def\@alttitle{#1}}
\let\@principal\@empty
\newcommand{\principal}[1]{\def\@principal{#1}}
\let\@email\@empty
\newcommand{\email}[1]{\def\@email{#1}}
\let\@school\@empty
\newcommand{\school}[1]{\def\@school{#1}}
\let\@programme\@empty
\newcommand{\programme}[1]{\def\@programme{#1}}

% Command to print out the standardized title page
\renewcommand{\titlepage}{
\newgeometry{top=65mm,bottom=30mm,left=50mm,right=35mm}
\thispagestyle{empty}
\ifinswedish\selectlanguage{swedish}\fi
\begin{huge}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@title \par
  \end{flushleft}
\end{huge}
\ifx\@subtitle\@empty\relax
\else
\begin{Large}
  \vspace{1ex}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@subtitle \par
  \end{flushleft}
\end{Large}
\fi

\vspace{10mm}
\begin{large}
  \begin{flushleft}
    \sffamily
    \expandafter\MakeUppercase\expandafter\@author \par
    \ifx\@secondauthor\@empty\relax
    \else\vspace{1ex}\expandafter\MakeUppercase\expandafter\@secondauthor \par
    \fi
  \end{flushleft}
\end{large}

\vfill

\begin{flushleft}
  \sffamily
  \ifinswedish
    \@programme\\
    \ifx\@date\@empty\relax\else Datum: \@date\\\fi
    Handledare: \@supervisor\\
    Examinator: \@examiner\\
    \ifx\@principal\@empty\relax\else Uppdragsgivare: \@principal\\\fi
    \ifx\@alttitle\empty\relax\else Engelsk titel: %
    \begin{otherlanguage}{english}\@alttitle\end{otherlanguage}\\\fi
    \@school\\
  \else
    \@programme\\
    \ifx\@date\@empty\relax\else Date: \@date\\\fi
    Supervisor: \@supervisor\\
    Examiner: \@examiner\\
    \ifx\@principal\@empty\relax\else Principal: \@principal\\\fi
    \ifx\@alttitle\empty\relax\else Swedish title: %
    \begin{otherlanguage}{swedish}\@alttitle\end{otherlanguage}\\\fi
    \@school\\
  \fi
\end{flushleft}
\restoregeometry
\cleardoublepage
}

\newcommand{\frontmatter}{
    \pagenumbering{roman}
    \setcounter{page}{1}
}

\newcommand{\mainmatter}{
  \cleardoublepage
  \pagenumbering{arabic}
}

\endinput
