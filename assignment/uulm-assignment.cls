\def\@clsname{uulm-assignment}
\ProvidesClass{\@clsname}[2025/03/30 v3.0 Assignment document class]
\LoadClass[11pt]{article}

\def\@clswrn{\ClassWarning{\@clsname}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Includes                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[sfdefault,lining]{FiraSans}
\RequirePackage[scaled=0.9]{FiraMono}
\RequirePackage{fouriernc}

\RequirePackage{tikz}
\usetikzlibrary{tikzmark}
\def\m#1{\tikzmark{#1}}

\RequirePackage{sansmath}
\RequirePackage{microtype}
\RequirePackage[utf8]{inputenc}
\RequirePackage[inline]{enumitem}
\RequirePackage{ifthen}
\RequirePackage{lastpage}
\RequirePackage{afterpage}
\RequirePackage[ngerman,english]{babel}
\RequirePackage{graphicx}
\RequirePackage{titlesec}
\RequirePackage{comment}
\RequirePackage[hidelinks]{hyperref}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Options                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newboolean{nocolor}
\newboolean{solution}
\DeclareOption{nocolor}{\setboolean{nocolor}{true}}
\DeclareOption{solution}{\setboolean{solution}{true}}
\ProcessOptions*

\input{config/utils.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Layout                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newlength{\@xmargin}\setlength{\@xmargin}{2.25cm}
\newlength{\@ymargin}\setlength{\@ymargin}{2cm}
\RequirePackage[hmargin=\@xmargin,vmargin=\@ymargin,a4paper,includeheadfoot,headsep=1.2cm]{geometry}

\renewcommand{\baselinestretch}{1.15}
\setlength{\parindent}{0pt}
\setlength{\parskip}{1em}

\titleformat*{\section}{\normalfont\large\bfseries}
\titlespacing*{\section}{0pt}{2.5ex plus 1ex minus 0.5ex}{0ex plus 0.2ex}
\titleformat*{\paragraph}{\normalfont\itshape\scshape}

\RequirePackage{scrlayer-scrpage}
\KOMAoptions{headsepline=true}
\renewcommand\headfont{\normalfont}
\ihead{\@shortcourse{} \textbar{} \@shortsemester}
\chead{\@title}
\ohead{\@date}
\ifoot{\itshape\@shortsupervisor}
\ofoot{\def\@linkcolor{.}\itshape Seite \thepage{} / \pageref{LastPage}}

\defpairofpagestyles[scrheadings]{title}{
	\KOMAoptions{headsepline=false}
	\ihead{}\chead{}\ohead{}
}

\pagestyle{scrheadings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Colors                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% currently not used
% \definecolor{uulm}{RGB}{125,154,170}
\definecolor{uulm-akzent}{rgb}{.663,.635,.553}
\definecolor{uulm-in}{RGB}{163,38,56}
\colorlet{uulm-in-link}{uulm-in!30!black}
\colorlet{uulm-akzent-blend}{black!70!uulm-akzent}

\ifthenelse{\boolean{nocolor}}{\colorlet{uulm-in-link}{black}\colorlet{uulm-akzent-blend}{black}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Create info macros                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ensureinfocommand{faculty}
\ensureinfocommand{course}
\ensureinfocommand{semester}
\ensureinfocommand{supervisor}
\ensureinfocommand{assignmenttype}
\ensureinfocommand{assignmentdeadline}
\ensureinfocommand{assignmentno}
\def\deadline{\@assignmentdeadline} % macros for user land :)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Title page                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\maketitle}{%
	\thispagestyle{title}%
	\vspace*{-\dimexpr\headheight+\headsep+.5\@xmargin\relax}%
	\uulmlogo{uulm-akzent-blend}%
	\\[.5\@ymargin]%
	\noindent\hspace*{-\@xmargin}%
	\begin{tikzpicture}
		\ifthenelse{\boolean{nocolor}}
			{\colorlet{b1}{white}  \colorlet{b2}{white}}
			{\colorlet{b1}{uulm-in}\colorlet{b2}{uulm-akzent!50}}
		\ifthenelse{\boolean{nocolor}}
			{\colorlet{f1}{black}\colorlet{f2}{black}}
			{\colorlet{f1}{white}\colorlet{f2}{uulm-akzent-blend}}

		\node[rectangle,draw=b1,fill=b1,minimum width=\paperwidth,minimum height=1.2cm](B1){};
		\node[anchor=east,xshift=-\@xmargin,align=right,text width=\dimexpr\paperwidth-2\@xmargin\relax,
		font=\Large,f1,inner sep=0] at (B1.east){\@course};

		\node[anchor=north,rectangle,draw=b2,fill=b2,minimum width=\paperwidth,minimum height=2.4cm] at (B1.south) (B2){};
		\node[anchor=east,xshift=-\@xmargin,align=right,text width=\dimexpr\paperwidth-2\@xmargin\relax,
		font=\normalsize,f2,inner sep=0] at (B2.east){\@faculty{}\par\@supervisor\\[1ex]\@semester};
	\end{tikzpicture}%
	\\[.5\@ymargin]%
	{\large\bfseries\@assignmenttype~\@assignmentno: \@title}\hfill%
	{\small Besprechung: \@assignmentdeadline}%
	\par\vskip0.5em minus 0.5em\relax%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Tasks and subtasks                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{task}
\newcommand\task{\@ifstar{\@tasks}{\@task}}
\def\@task#1{% starred version
	\refstepcounter{task}%
	\def\intocline{}%
	\addcontentsline{toc}{section}{\arabic{task} - #1}%
	\let\intocline\undefined%
	\section*{Aufgabe \arabic{task}\quad\normalfont\normalsize#1}%
}
\def\@tasks#1{\section*{#1}}

\newcommand\opttask{\@ifstar{\@otasks}{\@otask}}
\def\@otask#1{\@task{\bgroup\normalsize\normalfont\makeopt\egroup#1}}
\def\@otasks#1{\@tasks{\bgroup\normalsize\normalfont\makeopt\egroup#1}}

\newlist{subtasks}{enumerate}{1}
\setlist[subtasks,1]{label=\itshape\alph*)~,beginpenalty=-1000,midpenalty=-100,endpenalty=100,topsep=0pt}
\setlist[itemize,1]{label=$\bullet$}

\newcounter{optitem}
\def\makeopt{\@ifundefined{intocline}{\stepcounter{optitem}\m{opt\arabic{optitem}}%
	\begin{tikzpicture}[o]%
		\coordinate (helper) at (pic cs:opt\arabic{optitem});%
		\node[anchor=west,shift={(1em,1.1mm)}] at (helper-|current page.west) {\color{gray}Optional};%
	\end{tikzpicture}%
}{}}

\def\optitem{\item\makeopt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Solution                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\onsolution#1{\ifthenelse{\boolean{solution}}{#1}{}}
\def\inlinesolution#1{\onsolution{%
	\rotatebox[origin=c]{0}{\@pen}~#1~\rotatebox[origin=c]{180}{\@pen}%
}}

\def\changemargin{\list{}{\leftmargin\sol@leftmargin}\item[]}
\let\endchangemargin=\endlist
\newsavebox{\@solutioncontent}
\ifthenelse{\boolean{solution}}{\def\sol@leftmargin{1em}
	\newenvironment{solution}{\setlist{leftmargin=\sol@leftmargin}%
		\hfill\break\@ifundefined{beforesolution}{}{\beforesolution}%
		\begin{samepage}%
		\rotatebox[origin=c]{-45}{\@pen}\par%
		\begin{changemargin}\vspace{-.4\baselineskip}%
	}{
		\end{changemargin}\vspace{-.5\baselineskip}%
		\rotatebox[origin=c]{225}{\reflectbox{\@pen}}
		\end{samepage}\@ifundefined{aftersolution}{}{\aftersolution}\par%
	}
}{\excludecomment{solution}}

\input{config/uulm-logo.tex}
\input{config/compat.tex}
