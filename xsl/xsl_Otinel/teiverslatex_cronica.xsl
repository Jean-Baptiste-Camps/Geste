<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- TODO:
        - une fois qu'on aura segmenté, adapter les commandes pour raccourcir les lemmes très longs, et faire apparaître, dans le cas des additions, 
        le mot précédent.
        - faut-il séparer comme plusieurs notes les lieux variants imbriqués, comme on fait pour l'instant, ou utiliser les parenthèses?
        - signaler ce qui est rubrique, etc. Traiter les additions, leurs mains, etc.
    -->
    
    <!--<xsl:import href="/home/jbc/Oxygen XML Editor 16/frameworks/tei/xml/tei/stylesheet/latex/latex.xsl"/>-->
    
    <xsl:output encoding="UTF-8" omit-xml-declaration="yes" method="text" indent="no"/>
    
    <!--    Space normalisation-->
    <!--<xsl:strip-space elements="*"/>-->
    <!--<xsl:preserve-space elements="tei:p"/>-->
    <!-- (Vérifications à faire sur la sortie) -->
    
    <xsl:template match="text()" mode="#all">
        <!-- On normalise l'espace et on échappe les caractères actifs de LaTeX-->
        <xsl:value-of select="replace(translate(translate(translate(.,'&#xA;&#xD;', '  '), '&amp;', '\&amp;'), '$', ''), '\s\s+', ' ')"/>
    </xsl:template>
    
    <xsl:template match="/">
        \documentclass[12pt]{article}
        \usepackage[latin, french]{babel}
        \usepackage{fontspec}
        \usepackage{xltxtra}
        \setmainfont{Junicode}
        \usepackage[noreledmac]{eledmac}
        <!-- Configuration des notes -->
        <!--\footparagraph{A}-->
        \footparagraph{B}
        \footparagraph{C}
        <!--\footparagraph{D}-->
        <!--        Strikethrough text-->
        \usepackage{ulem}
        \author{Ébauche d'édition par <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor"/>}
        \title{\textsc{<xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>} -- 
        <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>}
        \begin{document}
        \maketitle
        <xsl:apply-templates/>
        %\tableofcontents
        \end{document}
    </xsl:template>
   
   <!-- TRAITEMENT DE L'ÉDITION -->
    
    <!--    La structure de l'édition-->
    <xsl:template match="tei:body">
        <xsl:text>&#xA;</xsl:text>
        \section*{Édition}
        <xsl:text>&#xA;</xsl:text>
        \beginnumbering
        <xsl:apply-templates/>
        \endnumbering
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:head[ancestor::tei:body]">
        <xsl:text>\ledsubsection*{</xsl:text><xsl:apply-templates/><xsl:text>}&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:div[ancestor::tei:body]">
        <xsl:text>&#xA;\pstart&#xA;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA;\pend&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="ab">
        \pausenumbering
        <xsl:apply-templates/>
        \resumenumbering
    </xsl:template>
    
    <xsl:template match="tei:app">
        <xsl:text>\edtext{</xsl:text>
        <!-- Ne pas réafficher plusieurs fois le lemme dans le corps de l'édition -->
        <xsl:if test="not(ancestor::tei:app)"><xsl:apply-templates select="tei:lem" mode="lemme"/></xsl:if>
        <xsl:text>}{</xsl:text>
        <!-- mais l'afficher toujours en lemme -->
        <xsl:if test="ancestor::tei:app"><xsl:text>\lemma{</xsl:text><xsl:apply-templates select="tei:lem" mode="lemme"/><xsl:text>}</xsl:text></xsl:if>
        <xsl:if test="tei:rdg"><xsl:choose>
            <xsl:when test="@type = 'orthographic' or @type= 'paleographic'">
                <xsl:text>\Cfootnote{</xsl:text>
                <xsl:apply-templates select="tei:rdg"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- On isole les leçons uniques à MT sur un étage -->
                    <xsl:when test="count(tei:rdg) = 1 and tei:rdg/@wit ='#MT' ">
                        <xsl:text>\Bfootnote{</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\Afootnote{</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- On affiche les manuscrits du lemme si l'app est lui-même dans un app, et ne concerne qu'une partie de la famille -->
                <xsl:if test="ancestor::tei:app"><xsl:text>\textit{</xsl:text><xsl:value-of select="translate(tei:lem/@wit, '#', '')"/><xsl:text>} </xsl:text></xsl:if>
                <xsl:apply-templates select="tei:rdg"/>
                <xsl:text>}</xsl:text>
            </xsl:otherwise>
        </xsl:choose></xsl:if>
        <xsl:if test="tei:witDetail">
         <xsl:apply-templates select="tei:witDetail"/>
        </xsl:if>
        <xsl:text>}</xsl:text>
        <xsl:variable name="monId" select="generate-id(.)"/>
        <xsl:apply-templates select="descendant::tei:app[generate-id(ancestor::tei:app[1]) = $monId]"/>
        <!-- à modifier pour que les descendants ne soient pas traités à chaque fois quand il y a plusieurs niveaux d'imbrication -->
    </xsl:template>
    
    <xsl:template match="tei:app" mode="lemme">
        <xsl:apply-templates select="tei:lem" mode="lemme"/>
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <xsl:choose>
            <xsl:when test=". = '' ">\textit{om.}</xsl:when>
            <xsl:otherwise><xsl:apply-templates mode="lemme"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:text>\textit{</xsl:text><xsl:value-of select="translate(@wit, '#', '')"/><xsl:text>} </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:witDetail">
    <xsl:if test="not(ancestor::tei:app)"><xsl:text>\edtext{}{</xsl:text></xsl:if>
    <xsl:text>\Dfootnote{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text> \textit{</xsl:text>
    <xsl:value-of select="translate(@wit, '#', '')"/>
    <xsl:text>}} </xsl:text>
    <xsl:if test="not(ancestor::tei:app)"><xsl:text>}</xsl:text></xsl:if>
    </xsl:template>
   
    
    <xsl:template match="tei:pb">
        <xsl:text>Déb. du fol.~</xsl:text>
        <xsl:value-of select="@n"/>
    </xsl:template>
    <xsl:template match="tei:cb[not(preceding-sibling::tei:pb)]">
        <xsl:text>Déb. de la col.~</xsl:text>
        <xsl:value-of select="@n"/>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="#all">\sout{<xsl:apply-templates/>}</xsl:template>
    <xsl:template match="tei:add" mode="#all">\uline{<xsl:apply-templates/>}</xsl:template>
    <xsl:template match="tei:lb[ancestor::tei:rdg]"><xsl:text>\,/\,</xsl:text></xsl:template>
    
    <!--Notes de commentaire-->
    <!--    Pour l'instant, un seul étage géré-->
    <!--    Not the more elegant way, but needed if we want
    a line-number-->
    <!-- Ajouter une règle qui aille chercher, comme lemme, le mot vers l'@xml:id duquel pointe la référence contenue dans la note -->
    <xsl:template match="tei:note">
        <xsl:text>\footnoteA{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <!--    Index?-->
    
    <!-- Un peu de mise en forme -->
        <xsl:template match="tei:q | tei:seg[@type='q']">
            <xsl:text>\og{}</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>\fg{}</xsl:text>
        </xsl:template>
        
    <!-- Traitement du header et du front -->
    
    <xsl:template match="tei:teiHeader"/>
        
    <xsl:template match="tei:listWit[ancestor::tei:front]">
        <!-- On récupère et met en forme l'xml:id  -->
        <xsl:variable name="sigle" select="concat(
            upper-case(substring(translate(@xml:id, '_', ' '),1,1)),
            substring(translate(@xml:id, '_', ' '), 2))
            "/>
        
        <xsl:choose>
            <xsl:when test="count(ancestor::tei:listWit) = 0">
                <!--<xsl:text>\section*{</xsl:text>-->
                <!--<xsl:text>}</xsl:text>-->
            </xsl:when>
            <xsl:when test="count(ancestor::tei:listWit) = 1">
                <xsl:text>\subsection*{</xsl:text>
                <!--<xsl:apply-templates select="tei:head"/>-->
                <xsl:value-of select="$sigle"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::tei:listWit) = 2">
                <xsl:text>\subsubsection*{</xsl:text>
                <!--<xsl:apply-templates select="tei:head"/>-->
                <xsl:value-of select="$sigle"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::tei:listWit) > 2">
                <xsl:text>\paragraph*{</xsl:text>
                <xsl:value-of select="$sigle"/>
                <!--<xsl:apply-templates select="tei:head"/>-->
                <xsl:text>}</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:witness">
        <xsl:text>&#xA;</xsl:text>
        \textbf{<xsl:value-of select="@xml:id"/>}\\
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
   <xsl:template match="tei:head[ancestor::tei:front and not(ancestor::tei:listWit)]">
       <xsl:text>&#xA;</xsl:text>
       <xsl:choose>
           <xsl:when test="count(ancestor::tei:div) = 1">
               <xsl:text>\section*{</xsl:text>
               <xsl:apply-templates/>
               <xsl:text>}</xsl:text>
           </xsl:when>
           <xsl:when test="count(ancestor::tei:div) = 2">
               <xsl:text>\subsection*{</xsl:text>
               <xsl:apply-templates/>
               <xsl:text>}</xsl:text>
           </xsl:when>
           <xsl:when test="count(ancestor::tei:div) = 3">
               <xsl:text>\subsubsection*{</xsl:text>
               <xsl:apply-templates/>
               <xsl:text>}</xsl:text>
           </xsl:when>
       </xsl:choose>
       <xsl:text>&#xA;</xsl:text>
   </xsl:template>
   
   <!-- Reprise ponctuelle de templates des feuilles du Consortium -->
    
    <xsl:template match="tei:listBibl">
        <xsl:text>\begin{description}&#xA;</xsl:text>
        <xsl:apply-templates select="tei:biblStruct"/>
        <xsl:text>\end{description}&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:biblStruct">
        <xsl:text>\item[</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>]</xsl:text>
        <xsl:for-each select="descendant::node()">
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:p[not(ancestor::tei:body)]">
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <xsl:text>\begin{itemize}&#xA;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{itemize}&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <xsl:text>\item </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
