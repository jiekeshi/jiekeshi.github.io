%%
%% Copyright (c) 2018-2019 Weitian LI
%% Copyright (c) 2016 Christophe Roger
%% The LaTeX Project Public License (LPPL) Version 1.3c
%%
%% Resume LaTeX template.
%% Based on
%%     YACC: Another Awesome CV by Christophe Roger
%%     https://github.com/darwiin/yaac-another-awesome-cv
%% which is further based on
%%     Plasmati Graduate CV by Alessandro Plasmati
%%     https://www.latextemplates.com/template/plasmati-graduate-cv
%%

\ProvidesClass{resume}
\LoadClass{article}

%%
%% Class options
%%

\DeclareOption{monochrome}{\def\@monochrome{true}}
\DeclareOption{zh}{\def\@zh{true}}
\ProcessOptions\relax

%%
%% Packages
%%

\RequirePackage[%
  a4paper,%
  margin=2cm,%
]{geometry}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{fontawesome5}
\RequirePackage{parskip}  % auto adjust parskip and items skip
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{setspace}
\RequirePackage{array}
\RequirePackage{url}
\RequirePackage{multirow}
\RequirePackage{fancyhdr}   %设置没有页眉页脚
\fancyhf{} 

\pagestyle{fancy}
\renewcommand\headrulewidth{0pt}
\cfoot{\thepage \ of\ 2}
%\fancyfoot{\thepage\ of \pageref{LastPage}}%当前页 of 总页数
%\pagestyle{plain}      %没有页眉，页脚放在中间
\RequirePackage{makecell}  % multirowcell
\RequirePackage{longtable}
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox}  % required by tikz to make the header
\RequirePackage{csquotes}
\RequirePackage[normalem]{ulem}
\RequirePackage{microtype}
\ifdef{\@zh}{
  \RequirePackage{xeCJK}
}{}

%
% Hyperref
%
% Delay the execution of \hypersetup at \begin{document}.
% NOTE: Should be set before hyperref uses it.
\AtBeginDocument{%
  \hypersetup{%
    pdfborder={0 0 0},% No border around links
    pdfauthor={%
      \ifdef{\@zh}{%
        \@lastname{} \@firstname%
      }{%
        \@firstname{} \@lastname%
      }%
    },%
    pdftitle={%
      \ifdef{\@zh}{%
        简历 | \@lastname{} \@firstname{}
      }{%
        Resume | \@firstname{} \@lastname{}
      }%
    }
  }%
}
\RequirePackage{hyperref}

%%
%% General settings
%%

% Fonts

\defaultfontfeatures{Mapping=tex-text}
%\setmainfont[BoldFont={IBMPlexSerif-Medium.ttf}]{IBMPlexSerif-Text.ttf}
\newfontfamily{\myfont}{LinBiolinum_RB}[Extension = .otf]
\newfontfamily{\otfont}{LinBiolinum_R}[Extension = .otf]
\setmainfont[BoldFont={LinLibertine_RB.otf}]{LinLibertine_R.otf}

\newcommand{\url@courierstyle}{\def\UrlFont{\otfont}}
% Chinese setup
\ifdef{\@zh}{
  \xeCJKsetup{PunctStyle=kaiming}
  \setCJKmainfont{STZHONGS.TTF}
}{}

% Font Awesome icon aliases
\newcommand*{\birthdaySymbol}{\faBirthdayCake}
\newcommand*{\degreeSymbol}{\faGraduationCap}
\newcommand*{\workSymbol}{\faSuitcase}
\newcommand*{\githubSymbol}{\faGithub}
\newcommand*{\homeSymbol}{\faHome}
\newcommand*{\mailSymbol}{\faEnvelope}
\newcommand*{\phoneSymbol}{\faPhoneSquare}
\newcommand*{\linkedinSymbol}{\faLinkedin}
\newcommand*{\locationSymbol}{\faMapMarker}
\newcommand*{\universitySymbol}{\faUniversity}
\newcommand*{\homepageSymbol}{\faInfoCircle }

% Color setup
\ifdef{\@monochrome}%
  {\definecolor{basecolor}{HTML}{000000}}%
  {\definecolor{basecolor}{HTML}{000066}}  % blue
%
\definecolor{darkGrey}{HTML}{989898}
%
\colorlet{linkcolor}{basecolor}
\colorlet{accentcolor}{linkcolor!90}
\colorlet{symbolcolor}{linkcolor!85}

% Date format: yyyy.mm.dd
\newcommand*{\twodigits}[1]{\ifnum#1<10 0\fi\the#1}
\renewcommand*{\today}{%
  \leavevmode\hbox{\the\year.\twodigits\month.\twodigits\day}
}

% Non-numbered pages
%\pagestyle{empty}

% Last-page style
%\def\ps@lastpage{%
 % \def\@oddfoot{\textcolor{gray}{\footnotesize\@fileinfo}\hfil}%
  %\def\@evenfoot{\textcolor{gray}{\footnotesize\@fileinfo}\hfil}%
%}
%\AtEndDocument{\thispagestyle{lastpage}}

% No paragraph indentation
\setlength{\parindent}{0em}

% Line spacing
\ifdef{\@zh}{
  \linespread{1.1}
}{
  \linespread{1.1}
}

% Setup resume sections
\titleformat{\section}{\Large\raggedright\bfseries}{}{0.2em}{}[\titlerule]
\titlespacing{\section}{0em}{1ex}{1ex}  % <left><before><after>

% Configure list via 'enumitem'
\setlist[itemize,1]{label=\faAngleRight, nosep, leftmargin=1em}
\setlist[enumerate,1]{label=[\arabic*], nosep, leftmargin=1.8em}

% Width of the left column for date ranges
\newlength{\leftcolwidth}
\newlength{\rightcolwidth}
\ifdef{\@zh}{%
  \setlength{\leftcolwidth}{6em}
}{
  \setlength{\leftcolwidth}{8.1em}
}
\setlength{\rightcolwidth}{\dimexpr \textwidth - \leftcolwidth - 4\tabcolsep}

%%
%% Generic commands
%%

\newcommand*{\link}[2]{\textcolor{linkcolor}{\href{#1}{#2}}}

\newcommand*{\icon}[1]{%
  \makebox[1em][c]{\textcolor{symbolcolor}{#1}}%
  \hspace{0.2em}%
}

% Test whether the command argument is given and is not empty
% Credit: https://tex.stackexchange.com/a/63233
\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{mmm}{%
  \IfNoValueTF{#1}{#2}{%
    \tl_if_empty:nTF {#1} {#2} {#3}
  }
}
\ExplSyntaxOff

%%
%% Header
%%

% Render a text with its symbol
% Usage; \socialtext{<icon>}{<label>}
\newcommand*{\socialtext}[2]{%
  \mbox{\icon{#1} #2 \hspace{1em}}%
}

% Render a link with its symbol
% Usage; \sociallink{<icon>}{<label>}
\newcommand*{\sociallink}[3]{%
  \mbox{\icon{#1} \link{#2}{#3} \hspace{1em}}%
}

% Name: \name{<firstname>}{<lastname>}
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
% Photo: \photo{<diameter>}{<photo>}
\newcommand{\photo}[2]{\def\@photo{#2}\def\@photodiameter{#1}}
% Address
\newcommand*{\address}[1]{\def\@addressname{#1}}
% Birthday
\newcommand*{\birthday}[1]{\socialtext{\birthdaySymbol}{#1}}
% Place of birth
\newcommand*{\home}[1]{\socialtext{\homeSymbol}{#1}}
% Information
\newcommand*{\info}[1]{\socialtext{\infoSymbol}{#1}}
% Phone
\newcommand*{\phone}[1]{\def\@phonenum{#1}}
% Degree
\newcommand*{\degree}[1]{\socialtext{\degreeSymbol}{#1}}
\newcommand*{\work}[1]{\socialtext{\workSymbol}{#1}}
% University
\newcommand*{\university}[1]{\socialtext{\universitySymbol}{#1}}

\newcommand*{\institution}[1]{\socialtext{\institutionSymbol}{#1}}

\newcommand*{\homepage}[1]{\def\@homepageaddr{#1}}

\newcommand*{\homepageinfo}[1]{%
  \sociallink{\homepageSymbol}{#1}{#1}%
}

% LinkedIn: \linkedin{<username>}
\newcommand*{\linkedin}[1]{%
  \sociallink{\linkedinSymbol}%
    {http://www.linkedin.com/in/#1}%
    {linkedin.com/in/#1}%
}
% GitHub: \github{<username>}
\newcommand*{\github}[1]{%
  \sociallink{\githubSymbol}%
    {https://github.com/#1}%
    {\texttt{github.com/#1}}%
}
% Email address
\newcommand*{\email}[1]{\def\@emailaddr{#1}}

\newcommand*{\emailinfo}[1]{%
  \sociallink{\mailSymbol}{mailto:#1}{#1}
}

% Render the name: \user{<firstanme>}{<lastname>}
\newcommand*{\user}[2]{%
  \color{accentcolor}{%
    \ifdef{\@zh}%
      {{\Huge\bfseries #2 #1}}%
      {{\Huge\bfseries #1 \textsc{#2}}}%
}}

\newcommand*{\phoneinfo}[1]{\color{accentcolor} \socialtext{\phoneSymbol}{#1}}

\newcommand*{\addressinfo}[1]{\color{accentcolor} \socialtext{\locationSymbol}{#1}}

% Render resume header
\newcommand*{\makeheader}{
  \ifdef{\@photodiameter}{
    \begin{minipage}{\@photodiameter}
      \tikz\path[fill overzoom image={\@photo}]
        circle[radius=0.5\linewidth];
    \end{minipage}
    \hspace{1em}
  }{}
  \ifundef{\@photodiameter}{%
    \begin{minipage}{\linewidth}
  }{%
    \begin{minipage}{\dimexpr\linewidth-\@photodiameter-2em}
  }
  \begin{tabular*}{17.5cm}{l@{\extracolsep{\fill}}r}
    \multirow{2}*{\user{\@firstname}{\@lastname}} & \phoneinfo{\@phonenum}\\
     & \emailinfo{\@emailaddr} \\
     \homepageinfo{\@homepageaddr} & \addressinfo{\@addressname}
  \end{tabular*}
    %\centering\user{\@firstname}{\@lastname}
    %\centering\@socialinfo
  \end{minipage}
  %\smallskip
}
%%
%% Sections
%%

% Title
\newcommand*{\sectionTitle}[2]{%
  \section{%
    \texorpdfstring%
      {\color{accentcolor}{\icon{#2} \scshape\textbf{#1}}}%
      {#1}%
  }
}

% Extra array column types
% Credit: https://tex.stackexchange.com/a/12712
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}

% Basic entries listing
\NewDocumentEnvironment{entries}{o}{%
  \IfValueTF{#1}%
    {\begin{tabular}{L{1cm} #1 L{18cm}}}%
    {\begin{tabular}{L{1cm} L{18cm}}}%
}{%
  \end{tabular}
}

\NewDocumentCommand{\entry}{m m}{
  #1 & \begin{minipage}[t]{14.2cm} #2 \end{minipage} \\
}

% Separator (empty space) between two entries
\newcommand*{\separator}[1]{%
  \multicolumn{2}{c}{} \\[\dimexpr #1 - 1em]
}

%%
%% Section: competences
%%

% \begin{competences}[width]
\NewDocumentEnvironment{competences}{o}{%
  \IfValueTF{#1}{%
    \begin{tabular}{R{#1} L{\dimexpr \textwidth - #1 - 4\tabcolsep}}
  }{%
    \begin{tabular}{R{\leftcolwidth} L{\rightcolwidth}}
  }
}{%
  \end{tabular}
}

\NewDocumentCommand{\comptence}{m m}{
  \textbf{#1} & #2 \\
}

%%
%% Section: educations
%%

\NewDocumentEnvironment{educations}{}{%
  \begin{tabular}{|L{\rightcolwidth} R{\leftcolwidth}}
}{%
  \end{tabular}
}

% \education
%   {<start-date>}  % #1
%   [<end-date>]    % #2
%   {<school>}      % #3
%   {<department>}  % #4
%   {<major>}       % #5
%   {<degree>}      % #6
\NewDocumentCommand{\education}{m o m m m m m m}{
  \ifdef{\@zh}{%
    \IfValueTF{#2}{#2}{2020.06} & \textbf{#3} \textbullet #4 \\*
    #1 & #5 \textbullet #6 \\
    & #7 \\
    & #8 \\
  }{%
  \textbf{#3}\textbullet #4 & \IfValueTF{#2}{#2}{\textbf{2020.06}}  \\
  #5  #6 & #1  \\
  #7 &  \\
  #8 &  \\
  }
}

\NewDocumentCommand{\expedu}{m o m m m m m m}{
  \ifdef{\@zh}{%
    \IfValueTF{#2}{#2}{现在} & \textbf{#3} \textbullet #4 \\*
    #1 & #5\textbullet #6  \\
    & #7 \\
  }{%
  \textbf{#3}\textbullet #4 &  \IfValueTF{#2}{#2}{\textbf{Present}}  \\
  #5 & #1  \\
  #7 &  \\
  #8 &  \\
  }
}



%%
%% Section: projects
%%

\NewDocumentEnvironment{projects}{}{%
  \begin{longtable}{R{\leftcolwidth} | L{\rightcolwidth}}
}{%
  \end{longtable}
}

% \project
%   {<start-date>}   % #1
%   [<end-date>]     % #2
%   {<department>}   % #3
%   {<type>}         % #4
%   {<name>}         % #5
%   {<description>}  % #6
%   [<tags>]         % #7
\NewDocumentCommand{\project}{m o m m m m o}{
  \multirowcell{2}[0ex][r]{%
    \IfValueTF{#2}{#2}{\ifdef{\@zh}{现在}{present}} \\ #1%
  }
  & \textbf{#5} \\*
  \ifdef{\@zh}{%
    & #3 \textbullet #4 \\*
  }{%
    & #4, #3 \\*
  }
  & \begin{minipage}[t]{\rightcolwidth} #6 \end{minipage} \\*
  \IfValueT{#7}{%
    & \footnotesize{\tags{#7}} \\
  }
}

%%
%% Section: experiences
%%

\NewDocumentEnvironment{experiences}{}{%
  \begin{longtable}{R{\leftcolwidth} | L{\rightcolwidth}}
}{%
  \end{longtable}
}

% \experience
%   [<start-date>]   % #1
%   {<end-date>}     % #2
%   {<summary>}      % #3
%   [<description>]  % #4
%   [<tags>]         % #5
\NewDocumentCommand{\experience}{o m m o o}{
  #2 & #3 \\*
  \IfValueT{#1}{#1}
  \IfNoValueOrEmptyTF{#4}{}{%
     & \begin{minipage}[t]{\rightcolwidth}
         #4
       \end{minipage} \\*
  }
  \IfValueT{#5}{%
    & \footnotesize{\tags{#5}} \\
  }
}

%%
%% Two-column section
%%

\newcommand*{\twocolumnsection}[2]{
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #1
  \end{minipage}
  \hfill
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #2
  \end{minipage}
}

%%
%% Section: skills
%%

\NewDocumentEnvironment{skills}{}{%
  \begin{tabular}{R{\leftcolwidth} L{\rightcolwidth}}
}{%
  \end{tabular}
}

%%
%% Section: referees
%%

\newenvironment{referees}{%
}{%
  \hfill
  \bigskip
}

\newcommand*{\referee}[5]{%
  \hspace{1em}
  \begin{minipage}[t]{\dimexpr(\linewidth/3) - 3em}
    \begin{tabular}{>{}l >{}l}
      \multicolumn{2}{l}{\textbf{#1}}\\
      \multicolumn{2}{l}{\emph{#2}, \textsc{#3}}\\
      \quad \mailSymbol & \href{mailto:#4}{#4} \\
      \quad \phoneSymbol & #5 \\
    \end{tabular}
  \end{minipage}%
}

\endinput
%% EOF
