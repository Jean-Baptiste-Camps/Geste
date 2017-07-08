<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Retraiter aussi pour que les mots soit unis ou non en fonction de @rend et pas 
    de l'espacement du fichier @xml. 
    -->
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
        <xsl:value-of select="replace(translate(translate(translate(.,'&#xA;&#xD;', '  '), '&amp;', '\&amp;'), '$', ''), '\s+', ' ')"/>
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
    
<!--    <xsl:template match="l">
        <xsl:apply-templates/><xsl:choose>
            <xsl:when test="following-sibling::l">&amp;</xsl:when>
            <xsl:otherwise>\&amp;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
<!--    Modifier ce template, et intégrer \pend dans le template lg
    pour pouvoir gérer les paragraphes vides.-->
    <xsl:template match="l">
        <xsl:if test="@sameAs">\skipnumbering </xsl:if>
        <xsl:apply-templates/>
            <xsl:if test="following-sibling::l">\\ </xsl:if>
    </xsl:template>
    

    
<!--  Facsimilar output  -->
    <!--<xsl:template match="choice">
        <xsl:apply-templates select="abbr|orig"/>
    </xsl:template>-->
    
    <!-- Et comme certains reg ne sont pas dans des choices -->
    <xsl:template match="reg" mode="#all"/>
    <xsl:template match="expan" mode="#all"/>
    
    
    <xsl:template match="pc">
        <xsl:if test="@type != 'supplied' "><xsl:apply-templates/></xsl:if>
    </xsl:template>
    
<!--  short space  -->
    <xsl:template match="space">
        <xsl:choose>
            <xsl:when test="@quantity='0.5'"><xsl:text>\,</xsl:text></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="
                    for $i in 1 to @quantity
                    return '~'
                    "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
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
    <xsl:template match="del" mode="#default lemme">\sout{<xsl:apply-templates/>}</xsl:template>
    <xsl:template match="add" mode="#default lemme">\uline{<xsl:apply-templates/>}</xsl:template>
    
<!--    Corrections et erreurs du copise-->
<!--    Ne pas oublier à terme de traiter les cas où la corr. porte sur un nom propre-->
    <xsl:template match="w[descendant::sic|descendant::corr|descendant::unclear|descendant::note|descendant::gap]">
        <xsl:choose>
            <xsl:when test="descendant::hi[matches(@rend, 'initiale filigr')]">
                <xsl:apply-templates/>
                <xsl:text>\edtext{}{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\edtext{</xsl:text><xsl:apply-templates/><xsl:text>}{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>\lemma{</xsl:text>
        <xsl:apply-templates mode="lemme"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="descendant::sic | descendant::corr|descendant-or-self::unclear | descendant::gap">
            <xsl:text>\Afootnote{</xsl:text>
            <xsl:if test="descendant::sic | descendant::corr">
                <xsl:text> \textit{lire} </xsl:text> <xsl:apply-templates mode="note"/>
            </xsl:if>
            <xsl:if test="descendant-or-self::unclear">
                <xsl:text> \textit{lecture difficile}</xsl:text>
                <xsl:choose>
                    <xsl:when test="descendant-or-self::unclear/@reason ='damage' ">
                        <xsl:text> \textit{(dégât matér.)}</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="descendant-or-self::unclear/@xml:id">
                    <xsl:variable name="monID" select="concat('#', descendant-or-self::unclear/@xml:id)"/>
                    <xsl:if test="/descendant::note[@corresp = $monID]">
                        <xsl:text>, \textit{</xsl:text>
                        <xsl:apply-templates select="/descendant::note[@corresp = $monID]/node()"/>
                        <xsl:text>} </xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:if test="descendant::gap">
                <xsl:text> </xsl:text>
                <xsl:value-of select="sum(descendant::gap/@quantity)"/>
                <xsl:text> </xsl:text>
                    <xsl:if test="descendant::gap/@unit='char'">\textit{car. non transcrits}</xsl:if>
                <xsl:choose>
                    <xsl:when test="descendant::gap/@reason='illegible'"> (\textit{illisibles})</xsl:when>
                    <xsl:when test="descendant::gap/@reason='damage'"> (\textit{dégât matériel})</xsl:when>
                    <xsl:when test="descendant::gap/@reason='lacuna'"> (\textit{lacune matérielle})</xsl:when>
                </xsl:choose>
                <xsl:if test="descendant::gap/@xml:id">
                    <xsl:variable name="monID" select="concat('#', @xml:id)"/>
                    <xsl:if test="/descendant::note[@corresp = $monID]">
                        <xsl:text>, \textit{</xsl:text>
                        <xsl:apply-templates select="/descendant::note[@corresp = $monID]/node()"/>
                        <xsl:text>} </xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="descendant::note[@type = 'palaeographic' and not(@corresp)]" mode="commentaire"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="not(@rend='aggl') and not(@rend='elision')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w">
        <xsl:apply-templates/>
        <xsl:if test="not(@rend='aggl') and not(@rend='elision')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="hi[matches(@rend, 'initiale filigr')]">
        <xsl:text>\lettrine[lines = </xsl:text>
        <xsl:value-of select="substring-before(tokenize(@rend, ' ')[matches(., '\dl')], 'l')"/>
        <xsl:text>, lraise = 0.3]{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}{}</xsl:text>
    </xsl:template>
    <xsl:template match="hi[matches(@rend, 'initiale filigr')]" mode="lemme">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="note" mode = "lemme"/>
    
    <xsl:template match="corr" mode="#default lemme"/>
    <!-- Mode note peut-être à revoir (du point de vue éditorial) -->
    <xsl:template match="corr" mode="note"><xsl:apply-templates/></xsl:template>
    <xsl:template match="sic" mode="note"/>
    <xsl:template match="del" mode="note">
        <xsl:if test="matches(@ana, '#restaure')">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="add" mode="note">
        <xsl:if test="not(@type='redundant')"><xsl:apply-templates/></xsl:if>
    </xsl:template>
    <xsl:template match="gap" mode="note"/>
    
    <xsl:template match="w" mode="lemme">
        <xsl:apply-templates mode="lemme"/>
        <xsl:if test="not(@rend='aggl') and not(@rend='elision')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="note[not(ancestor::w)]">
        <xsl:choose>
            <xsl:when test="@type = 'palaeographic' and not(@corresp)">
                <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
                <xsl:apply-templates select="preceding::w[1]" mode="lemme"/>
                <xsl:text>}\Bfootnote{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}} </xsl:text>  
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <!-- TODO: pour l'instant, redéfinition locale de ces deux là (base, feuille tei vers latex communs), pour ne pas avoir le sigle M dans les transcriptions individuelles -->
    <xsl:template match="gap[not(ancestor::w)]">
        <xsl:choose>
            <xsl:when test="@unit='fol'">
                <!--<xsl:text>\skipnumbering \dots \dots \dots \dots</xsl:text>-->
            </xsl:when>
            <xsl:when test="@unit='char'">
                    <xsl:variable name="quantite">
                        <xsl:choose>
                            <xsl:when test="@min and @max">
                                <xsl:value-of select="(@min + @max) div 2 "/>
                            </xsl:when>
                            <xsl:when test="@quantity">
                                <xsl:value-of select="@quantity"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                <xsl:value-of select="for $i in 1 to $quantite
                    return '.'
                    "/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>\edtext{}{\lemma{</xsl:text>
        <xsl:apply-templates mode="lemme" select="preceding::w[1]"/>
        <xsl:text> \dots </xsl:text>
        <xsl:apply-templates mode="lemme" select="following::w[1]"/>
        <xsl:if test="ancestor::l/@n != following::w[1]/ancestor::l/@n">
            <xsl:text> \textit{(v.~</xsl:text>
            <xsl:value-of select="following::w[1]/ancestor::l/@n"/>
            <xsl:text>)} </xsl:text>
        </xsl:if>
        <!--<xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>-->
        <xsl:text>}\Afootnote{</xsl:text>
        <xsl:choose>
            <xsl:when test="@quantity">
                <xsl:value-of select="@quantity"/>
            </xsl:when>
            <xsl:when test="@min and @max">
                <xsl:text> \textit{entre} </xsl:text> <xsl:value-of select="@min"/>
                <xsl:text> \textit{et} </xsl:text> <xsl:value-of select="@max"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="@unit='char'"><xsl:text>\textit{car. non transcrit</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>}</xsl:text></xsl:when>
            <xsl:when test="@unit='fol'"><xsl:text>\textit{fol. manquant</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>}</xsl:text></xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@reason='illegible'"><xsl:text> (\textit{illisibles</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>})</xsl:text></xsl:when>
            <xsl:when test="@reason='damage'"> (\textit{dégât matériel})</xsl:when>
            <xsl:when test="@reason='lacuna'"> (\textit{lacune matérielle})</xsl:when>
        </xsl:choose>
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="unclear[not(ancestor::w)]">
        <xsl:apply-templates select="node()[not(local-name(.) = 'note') and not(@type = 'palaeographic') ]"/><!-- sauf les notes, que l'on veut intégrer à celle que l'on est en train de créer -->
        <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::w">
                <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
                <xsl:choose>
                    <xsl:when test="count(descendant::w) = 2">
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
                    </xsl:when>
                    <xsl:when test="count(descendant::w) > 2">
                        <xsl:text> \dots{} </xsl:text>
                        <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="descendant::pc[@type='orig']">
                <xsl:apply-templates select="descendant::pc[@type='orig']"/>
            </xsl:when>
        </xsl:choose>
        <!--<xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>-->
        <xsl:text>}\Afootnote{</xsl:text>
        <xsl:text> \textit{lecture difficile}</xsl:text>
        <xsl:choose>
            <xsl:when test="@reason ='damage' ">
                <xsl:text> \textit{(dégât matér.)}</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="child::note[@type='palaeographic']">
            <xsl:text>, \textit{</xsl:text>
            <xsl:apply-templates select="note[@type='palaeographic']/node()"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:text>}} </xsl:text>
    </xsl:template>
    
    
<!--    Index?-->
    
</xsl:stylesheet>