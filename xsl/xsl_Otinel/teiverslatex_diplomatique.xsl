<?xml version="1.0" encoding="UTF-8"?>
<!-- TODO: il faut se décider sur le traitement de sic:
        - est-ce qu'on l'affiche avec <> ?
        - auquel cas, il faut traiter les cas ou sic au dessus du niveau du mot
        - il faut corriger dans le code, les mots qui ne se résument qu'à un sic… (éviter les lemmes vides).
        - Définir une règle pour les corr substantives qui se retrouvent au dessus du niveau mot… ou pour les sic non substantives qui s'y trouvent également
   -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- TODO: modifier cette feuille pour avoir les numéros de vers de M (en les récupérant dans le fichier XML et utilisant ledrightnote -->
    
    <!-- Feuille à reprendre de fond en comble en:
        - définissant des règles pour chacun des éléments présents dans les transcriptions;
        - améliorant la gestion des notes;
        - améliorant la gestion de l'espacement;
        - songeant à échapper les caractères (&, sign abrév., déjà traité) de la source;
    -->
   <xsl:import href="teiverslatex_communs.xsl"/> 
    <xsl:output encoding="UTF-8" omit-xml-declaration="yes" method="text" indent="no"/>
   
   
    <!--    Space normalisation-->
    <xsl:strip-space elements="*"/>
    <!--<xsl:preserve-space elements="l"/>-->
<!--    vérifier que cette dernière commande fasse bien ce que l'on souhaite-->
    
    <xsl:template match="text()">
        <!-- On normalise l'espace et on échappe les caractères actifs de LaTeX-->
        <!--<xsl:value-of select="translate(translate(.,'&#xA;&#xD;', '  '), '&amp;', '\&amp;')"/>-->
        <xsl:value-of select="
            normalize-unicode(
                replace(
                    translate(
                        translate(
                       replace(
                        replace(., '_', '\\char`_'),
                        '&amp;', '\\char`&amp;'),
                   '&#xA;&#xD;', '  '), '$', ''),
                '\s+', ' '),
            'NFC')"/>
    </xsl:template>
    
    <!-- Normalisation des majuscules -->
    <xsl:template match="text()[
        (ancestor::w and . is preceding::pc[@type = 'supplied' 
            and (
                . = '.' or 
                . = '!' or
                .  = '?'
                )][1]/following::w[1]/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1]
            )
            or
            (. is (ancestor::placeName[1])/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))]) and not(ancestor::addName)][1][not(ancestor::nameLink)])
            or
            (. is (ancestor::forename[1])/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1][not(ancestor::nameLink)])
            or
            (. is (ancestor::surname[1])/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1][not(ancestor::nameLink)])
            or
            (. is (ancestor::name[1])/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1][not(ancestor::nameLink)])
            or (. is ancestor::q[@who]/descendant::w[1]/descendant::text()[ not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1])
         ] "><!-- TODO : faudra songer à encoder les nameLinks ; aussi, simplifier quand on aura réglé la question de surname, forename, persName-->
        <xsl:variable name="gaps">
            <xsl:for-each select="ancestor::l/descendant::gap/following::w[1]/descendant::text()[not(ancestor::del) and not(ancestor::note) and not(ancestor::sic[not(matches(@ana, '#substantive'))])][1]">
                <ID>
                <xsl:copy-of select="generate-id(.)"/>
                </ID>
            </xsl:for-each>
        </xsl:variable>
        <!--<xsl:value-of select="$gaps"></xsl:value-of> : 
        <xsl:value-of select="generate-id(.)"></xsl:value-of>-->
        <xsl:choose>
            <xsl:when test="generate-id(.) = $gaps/ID and not(ancestor::forename|ancestor::surname|ancestor::placeName)">
                <xsl:value-of select="normalize-unicode(.,'NFC')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-unicode(upper-case(substring(., 1, 1)), 'NFC')"/>
                <xsl:value-of select="normalize-unicode(substring(., 2),'NFC')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Ponctuation du discours direct -->
    <xsl:template match="q">
        <xsl:text> \og{}</xsl:text>
        <xsl:variable name="monL" select="ancestor::l"/>
        <xsl:if test="preceding::l[1]/child::q and not(preceding::w[ancestor::l is $monL]) and @who"><!-- 
        c'est un raccourci, car,  a partir du moment où on mettera des @who partout , il faudra plutôt tester
        s'ils diffèrent.
        -->
            <xsl:text>-- </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>\fg{} </xsl:text>
    </xsl:template>
    
    <xsl:template match="/">
<!--        \documentclass[12pt]{book}
        \usepackage[french]{babel}
        \usepackage{fontspec}
        \usepackage{xltxtra}
        \setmainfont{Junicode}-->
        <!-- alternative: Palemonas MUFI       -->
        <!--\usepackage{eledmac}-->
<!--        Follows very specific command for removing ]
        in commentary notes-->
        <!--\nolemmaseparator[B]-->
<!--        Strikethrough text-->
        <!--\usepackage{ulem}-->
        <!-- Very specific thesis requirements-->
<!--       % \usepackage[top=2.5cm, bottom=2.5cm]{geometry}
        %\usepackage{setspace}
        %\onehalfspacing
        %NB: la quantité de pages est équivalente avec les marges LaTeX et l'espacement simple, ou les marges 2.5 et l'espacement 1.5
        \begin{document}-->
        <xsl:apply-templates/>
        <!--\end{document}-->
    </xsl:template>
    
    
<!--    Pour l'instant, on ne veut pas le teiHeader-->
    <xsl:template match="teiHeader"/>
    
<!--    La structure de l'édition-->
    <xsl:template match="body">
        \beginnumbering
        <xsl:apply-templates/>
        \endnumbering
    </xsl:template>
    
<!--    <xsl:template match="lg">
        \stanza <xsl:apply-templates/>
    </xsl:template>-->
    <xsl:template match="lg">
        \subsection*{<xsl:value-of select="@n"/>}
        \pstart \noindent <xsl:apply-templates/>
        <xsl:text>\pend&#xA;</xsl:text>
    </xsl:template>
    
<!--    <xsl:template match="l">
        <xsl:apply-templates/><xsl:choose>
            <xsl:when test="following-sibling::l">&amp;</xsl:when>
            <xsl:otherwise>\&amp;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
<!--    Modifier ce template, et intégrer \pend dans le template lg
    pour pouvoir gérer les paragraphes vides.-->
    <xsl:template match="l">
        <xsl:if test="@real">
            <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
            <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
                    <xsl:text> \dots{} </xsl:text>
                    <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            <xsl:if test="tokenize(@xml:id, '_')[1] = 'M'">
                <xsl:text> \textit{M}</xsl:text>
            </xsl:if>
            <xsl:text>}\Afootnote{\textbf{</xsl:text>
            <xsl:value-of select="@real"/>
            <xsl:text>}}}</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
            <xsl:if test="following-sibling::l">\\ </xsl:if>
    </xsl:template>
    
<!--  Facsimilar output  -->
    <xsl:template match="choice">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    
    <xsl:template match="ex">
        <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="am"/>
    
   <!-- <xsl:template match="pc">
        <xsl:if test="@type != 'supplied' "><xsl:apply-templates/></xsl:if>
    </xsl:template>-->
    <xsl:template match="pc">
        <xsl:choose>
            <xsl:when test="@type='orig'"/>
            <xsl:when test="@type='supplied'">
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
<!--  short space  -->
    <xsl:template match="space"/>
    
<!--    À raffiner selon le modèle-->
<!--    <xsl:template match="del">
        \edtext{\sout{<xsl:apply-templates/>}}{
        \lemma{<xsl:apply-templates/>}
        \Afootnote{Texte gratté par le copiste.}
<!-\-        Différencier les types (grattage, ...)-\->
        }
    </xsl:template>
    <xsl:template match="add">
        \edtext{\textsuperscript{<xsl:apply-templates/>}}{
        \lemma{<xsl:apply-templates/>}
        \Afootnote{Texte ajouté par le copiste.}
        <!-\-        Différencier les types (grattage, ...)-\->
        }
    </xsl:template>-->
    <xsl:template match="subst[not(ancestor::w)]">
            <xsl:apply-templates/>
        <!-- TODO: il faudrait sans doute mettre ce qui suit, que l'on répète plusieurs fois, dans un template nommé -->
            <xsl:text>\edtext{</xsl:text>
            <xsl:text>}{%
                      \lemma{</xsl:text>
            <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
        <xsl:choose>
            <xsl:when test="count(descendant::w) = 2">
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
            <xsl:when test="count(descendant::w) > 2">
                <xsl:text> \dots{} </xsl:text>
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>
            <xsl:text>}\Afootnote{</xsl:text>
        <xsl:choose>
            <xsl:when test="del[@rend='repassé'] and add[@place='inplace']">
                <xsl:text> \textit{le scribe a repassé} </xsl:text>
                <xsl:apply-templates select="del" mode="note"/>
                <xsl:text> \textit{en} </xsl:text>
                <xsl:apply-templates select="add" mode="note"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="del" mode="note"/>
                <xsl:text> \textit{a été} </xsl:text>
                <xsl:choose>
                    <xsl:when test="del/@rend ='barré' ">
                        <xsl:text> \textit{barré} </xsl:text>
                    </xsl:when>
                    <xsl:when test="del/@rend ='exponctué' ">
                        <xsl:text> \textit{exponctué} </xsl:text>
                    </xsl:when>
                    <xsl:when test="del/@rend ='gratté' ">
                        <xsl:text> \textit{gratté} </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> \textit{suppr.} </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> \textit{et}  </xsl:text>
                <xsl:apply-templates select="add" mode="note"/>
                <xsl:text> \textit{a été aj.} </xsl:text>
                <xsl:choose>
                    <xsl:when test="add/@place ='above' ">
                        <xsl:text> \textit{en interl.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="add/@place ='end' ">
                        <xsl:text> \textit{à la fin de la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="add/@place ='inline' ">
                        <xsl:text> \textit{à la suite dans la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="add/@place ='inplace' ">
                        <xsl:text> \textit{dans la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="add/@place ='margin' ">
                        <xsl:text> \textit{en marge} </xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <!-- À modifier si on veut signaler systématiquement la main -->
        <xsl:if test="add/@hand"> \textit{(main différ. de la principale)} </xsl:if>
            <xsl:text>}} </xsl:text>
    </xsl:template>
    
    <xsl:template match="del"/>
    <xsl:template match="del[not(ancestor::subst) and not(ancestor::w)]">
        <xsl:choose>
            <xsl:when test="matches(@ana, '#restaure')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
                <xsl:apply-templates select="preceding::w[1]" mode="lemme"/>
                <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
                    <xsl:text> \textit{M}</xsl:text>
                </xsl:if>
                <xsl:text>}\Afootnote{</xsl:text>
                <xsl:text> \textit{à la suite de ce mot} </xsl:text>
                <xsl:apply-templates mode="note"/>
                <xsl:text> \textit{a été suppr.} </xsl:text>
                <xsl:choose>
                    <xsl:when test="@rend ='barré' ">
                        <xsl:text> \textit{par rature} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@rend ='exponctué' ">
                        <xsl:text> \textit{par exponct.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@rend ='gratté' ">
                        <xsl:text> \textit{par grattage} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@rend ='repassé' ">
                        <xsl:text> \textit{par repassement} </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@place ='above' ">
                        <xsl:text> \textit{en interl.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@place ='end' ">
                        <xsl:text> \textit{à la fin de la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@place ='inline' ">
                        <xsl:text> \textit{à la suite dans la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@place ='inplace' ">
                        <xsl:text> \textit{dans la l.} </xsl:text>
                    </xsl:when>
                    <xsl:when test="@place ='margin' ">
                        <xsl:text> \textit{en marge} </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <!-- À modifier si on veut signaler systématiquement la main -->
                <xsl:if test="@hand"> \textit{(main différ. de la principale)} </xsl:if>
                <xsl:text>}} </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="add">
        <xsl:if test="not(@type='redundant')"><xsl:apply-templates/></xsl:if>
    </xsl:template>
    <xsl:template match="add[not(ancestor::subst) and not(ancestor::w)]">
        <xsl:if test="not(@type='redundant')"><xsl:apply-templates/></xsl:if>
                <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
                <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
        <xsl:choose>
            <xsl:when test="count(descendant::w) = 2">
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
            <xsl:when test="count(descendant::w) > 2">
                <xsl:text> \dots{} </xsl:text>
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>
                <xsl:text>}\Afootnote{</xsl:text>
            <xsl:text> \textit{aj.} </xsl:text>
                    <xsl:choose>
                        <xsl:when test="@place ='above' ">
                            <xsl:text> \textit{en interl.} </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place ='end' ">
                            <xsl:text> \textit{à la fin de la l.} </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place ='inline' ">
                            <xsl:text> \textit{à la suite dans la l.} </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place ='inplace' ">
                            <xsl:text> \textit{dans la l.} </xsl:text>
                        </xsl:when>
                        <xsl:when test="@place ='margin' ">
                            <xsl:text> \textit{en marge} </xsl:text>
                        </xsl:when>
                    </xsl:choose>
        <!-- À modifier si on veut signaler systématiquement la main -->
        <xsl:if test="@hand"> \textit{(main différ. de la principale)} </xsl:if>
            <xsl:text>}} </xsl:text>
    </xsl:template>
    
    
<!--    Corrections et erreurs du copiste-->
<!--    Ne pas oublier à terme de traiter les cas où la corr. porte sur un nom propre-->
    <xsl:template match="w[descendant::sic|descendant::corr|descendant::unclear|descendant::note|descendant::subst|descendant::del|descendant::add|descendant::gap]">
        <xsl:text>\edtext{</xsl:text><xsl:apply-templates/><xsl:text>}{\lemma{</xsl:text>
        <!-- À revoir, mais pour l'instant, je redéfinis systématiquement le lemme, pour éviter les crochets en lemme dans les corrections: 
            à simplifier en agissant plutôt au niveau des templates -->
        <xsl:apply-templates mode="lemme"/>
        <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
        <xsl:if test="descendant::sic[not(matches(@ana, '#substantive'))]|descendant::corr|descendant::unclear|descendant::gap | descendant::subst | descendant::del | descendant::add">
            <xsl:text>\Afootnote{</xsl:text>
            <xsl:if test="descendant::sic[not(matches(@ana, '#substantive'))] | descendant::corr | descendant::subst | descendant::del | descendant::add">
                <xsl:if test="descendant::sic[not(matches(@ana, '#substantive'))] | descendant::corr[not(matches(@ana, '#substantive'))] | descendant::subst | descendant::del | descendant::add">
                <xsl:text> \textit{ms.} </xsl:text> <!-- TODO: est-ce bien nécessaire, sachant que les crochets suffisent à reconstruire la leçon du ms. ? -->
            <xsl:apply-templates mode="note"/>
            </xsl:if>
                <xsl:if test="descendant::corr[matches(@ana, '#substantive')]">
                    <xsl:text> \textit{lire} </xsl:text>
                    <xsl:apply-templates mode="noteCorr"/>
                </xsl:if>
        </xsl:if>
            <xsl:apply-templates 
                select="descendant::subst 
                            | descendant::del[not(ancestor::subst)] 
                            | descendant::add[not(ancestor::subst)]" 
                            mode="commentaire"/>
        <xsl:if test="descendant::unclear">
            <xsl:text> \textit{lecture difficile}</xsl:text>
            <xsl:choose>
                <xsl:when test="descendant-or-self::unclear/@reason ='damage' ">
                    <xsl:text> \textit{(dégât matér.)} </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="descendant::gap">
                <xsl:value-of select="sum(descendant::gap/@quantity)"/>
                <xsl:text> </xsl:text>
                <xsl:if test="descendant::gap/@unit='char'"><xsl:text>\textit{car. non transcrit</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>}</xsl:text></xsl:if>
                <xsl:choose>
                    <xsl:when test="descendant::gap/@reason='illegible'"><xsl:text> (\textit{illisible</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>})</xsl:text></xsl:when>
                    <xsl:when test="descendant::gap/@reason='damage'"> (\textit{dégât matériel})</xsl:when>
                    <xsl:when test="descendant::gap/@reason='lacuna'"> (\textit{lacune matérielle})</xsl:when>
                </xsl:choose>
        </xsl:if>
      <xsl:text>}</xsl:text>
        </xsl:if>
       <xsl:apply-templates select="descendant::note" mode="commentaire"/>
      <xsl:text>}</xsl:text>
        <xsl:choose>
            <xsl:when test="@rend='elision' or @rend = 'elision-sans-aggl'"><xsl:text>'</xsl:text></xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(. is following::pc[@type='supplied'][1]/preceding::w[1])">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="@rend='elision'  or @rend = 'elision-sans-aggl'"><xsl:text>'</xsl:text></xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(. is following::pc[@type='supplied'][1]/preceding::w[1])">
                <xsl:text> </xsl:text>
            </xsl:if></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="sic">
        <xsl:choose>
            <xsl:when test="matches(@ana, '#substantive')">
                <xsl:text>\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&lt;</xsl:text><xsl:apply-templates/><xsl:text>&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="corr">
        <xsl:choose>
            <xsl:when test="descendant::w or matches(@ana, '#substantive')">
                <xsl:text> \textbf{ø} </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="abbr"/>
    
    <xsl:template match="note[@type='palaeographic']"/>
    
    <xsl:template match="note[not(@type = 'palaeographic')]">
        <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
        <xsl:apply-templates select="preceding::w[1]" mode="lemme"/>
        <xsl:text>}\Bfootnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}} </xsl:text>  
    </xsl:template>
    
    
    <!-- Mode note peut-être à revoir (du point de vue éditorial) -->
    <xsl:template match="corr" mode="note"/>
    <xsl:template match="corr" mode="noteCorr">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="orig" mode="note"/>
    <xsl:template match="abbr" mode="note"/>
    <xsl:template match="sic" mode="note"><xsl:apply-templates/></xsl:template>
    <xsl:template match="del" mode="note">\sout{<xsl:apply-templates/>}</xsl:template>
    <xsl:template match="add" mode="note">\uline{<xsl:apply-templates/>}</xsl:template>
    
    <!-- Mode LEMME -->
    <xsl:template mode="lemme" match="abbr"/>
    <xsl:template mode="lemme" match="sic">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template mode="lemme" match="orig"/>
    <xsl:template mode="lemme" match="note"/>
    <xsl:template mode="lemme" match="del"/>
    <xsl:template mode="lemme" match="add">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template mode="lemme" match="sic[not(matches(@ana, '#substantive'))]"/>
    <xsl:template mode="lemme" match="corr[matches(@ana, '#substantive')]"/>
    
    <!-- Et comme certains orig ne sont pas dans des choices -->
    <xsl:template match="orig"/>

    <xsl:template match="w" mode="lemme">
        <!--<xsl:apply-templates select="text() | corr | choice/expan | choice/reg | expan | reg | hi | unclear" mode="lemme"/>-->
        <!-- Plus nécessaire, car on a redéfini le comportement du mode lemme -->
        <xsl:apply-templates mode="lemme"/>
    </xsl:template>
    
    <!-- Mode Commentaire -->
    <xsl:template match="subst" mode="commentaire">
        <xsl:choose>
            <xsl:when test="del[@rend='repassé'] and add[@place='inplace']">
                <xsl:text> \textit{le scribe a repassé} </xsl:text>
                <xsl:apply-templates select="del" mode="note"/>
                <xsl:text> \textit{en} </xsl:text>
                <xsl:apply-templates select="add" mode="note"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="del" mode="note"/>
                <xsl:text> \textit{a été} </xsl:text>
                <xsl:choose>
                    <xsl:when test="del/@rend ='barré' ">
                        <xsl:text> \textit{barré} </xsl:text>
                    </xsl:when>
                    <xsl:when test="del/@rend ='exponctué' ">
                        <xsl:text> \textit{exponctué} </xsl:text>
                    </xsl:when>
                    <xsl:when test="del/@rend ='gratté' ">
                        <xsl:text> \textit{gratté} </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> \textit{suppr.} </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> \textit{et}  </xsl:text>
        <xsl:apply-templates select="add" mode="note"/>
        <xsl:text> \textit{a été aj.} </xsl:text>
        <xsl:choose>
            <xsl:when test="add/@place ='above' ">
                <xsl:text> \textit{en interl.} </xsl:text>
            </xsl:when>
            <xsl:when test="add/@place ='end' ">
                <xsl:text> \textit{à la fin de la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="add/@place ='inline' ">
                <xsl:text> \textit{à la suite dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="add/@place ='inplace' ">
                <xsl:text> \textit{dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="add/@place ='margin' ">
                <xsl:text> \textit{en marge} </xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- À modifier si on veut signaler systématiquement la main -->
        <xsl:if test="add/@hand"> \textit{(main différ. de la principale)} </xsl:if>
    </xsl:template>
    
    <xsl:template match="del[not(ancestor::subst)]" mode="commentaire">
        <xsl:text>, </xsl:text> 
        <xsl:apply-templates select="." mode="note"/>
        <xsl:text> \textit{suppr.} </xsl:text>
        <xsl:choose>
            <xsl:when test="@rend ='barré' ">
                <xsl:text> \textit{par rature} </xsl:text>
            </xsl:when>
            <xsl:when test="@rend ='exponctué' ">
                <xsl:text> \textit{par exponct.} </xsl:text>
            </xsl:when>
            <xsl:when test="@rend ='gratté' ">
                <xsl:text> \textit{par grattage} </xsl:text>
            </xsl:when>
            <xsl:when test="@rend ='repassé' ">
                <xsl:text> \textit{par repassement} </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@place ='above' ">
                <xsl:text> \textit{en interl.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='end' ">
                <xsl:text> \textit{à la fin de la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='inline' ">
                <xsl:text> \textit{à la suite dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='inplace' ">
                <xsl:text> \textit{dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='margin' ">
                <xsl:text> \textit{en marge} </xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- À modifier si on veut signaler systématiquement la main -->
        <xsl:if test="@hand"> \textit{(main différ. de la principale)} </xsl:if>
    </xsl:template>
    
    <xsl:template match="add[not(ancestor::subst)]" mode="commentaire">
        <xsl:text>, </xsl:text> 
        <xsl:apply-templates select="." mode="note"/>
        <xsl:text> \textit{aj.} </xsl:text>
        <xsl:choose>
            <xsl:when test="@place ='above' ">
                <xsl:text> \textit{en interl.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='end' ">
                <xsl:text> \textit{à la fin de la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='inline' ">
                <xsl:text> \textit{à la suite dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='inplace' ">
                <xsl:text> \textit{dans la l.} </xsl:text>
            </xsl:when>
            <xsl:when test="@place ='margin' ">
                <xsl:text> \textit{en marge} </xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- À modifier si on veut signaler systématiquement la main -->
        <xsl:if test="@hand"> \textit{(main différ. de la principale)} </xsl:if>
    </xsl:template>
    
    
    
<!--    Index?-->
    
</xsl:stylesheet>