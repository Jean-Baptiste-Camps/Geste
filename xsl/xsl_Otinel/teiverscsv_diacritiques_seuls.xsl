<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:text>ID</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lettre précéd.</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lettre cour.</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>accentuee</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lettre suiv.</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>valeurPhon</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>étiquette morpho-syntaxique</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lemme</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>agglutination</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates select="descendant::tei:orig[. = '&#769;' and not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w]"/>
        <!--distinct-values(//text()[following::text()[1][. = '&#769;'] ])-->
    </xsl:template>
    
    <!-- Champs à rajouter: lettre précédente accentuée ou non, etc. -->
    
    <xsl:template match="tei:orig[. = '&#769;']">
        <xsl:value-of select="ancestor::tei:w/@xml:id"/>
        <xsl:text>&#9;</xsl:text>
        <!-- Lettre précédente -->
        <!-- On teste d'abord si on est en début de mot -->
        <xsl:choose>
            <!-- on teste que c'est le même mot, et qu'il n'y ait pas d'agglutination -->
            <xsl:when test="not(ancestor::tei:w is preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]/ancestor::tei:w)
                and not(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]/ancestor::tei:w[@rend='aggl' or @rend='elision']) 
                ">
                <xsl:text>_</xsl:text>
            </xsl:when>
        <xsl:otherwise>
        <xsl:choose>
            <xsl:when test="
                string-length(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]) = 1">
                <xsl:value-of select="substring(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][2], string-length(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][2]))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="index" select="string-length(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]) - 1"/>
                <xsl:value-of select="substring(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1], $index, 1)"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="substring(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1], string-length(preceding::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]))"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <!-- on teste que c'est le même mot, et qu'il n'y ait pas d'agglutination -->
            <xsl:when test="not(ancestor::tei:w is following::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1]/ancestor::tei:w)
                and not(ancestor::tei:w[@rend='aggl' or @rend='elision']) 
                ">
                <xsl:text>_</xsl:text>
            </xsl:when>
            <xsl:otherwise>
        <xsl:value-of select="substring(following::text()[not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w][1], 1, 1)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <!-- Voyelle ou consonne -->
        <xsl:choose>
            <xsl:when
                test="
                preceding::text()[
                not(ancestor::tei:corr) 
                and not(ancestor::tei:reg) 
                and not(ancestor::tei:expan) 
                and not(ancestor::tei:note) 
                and ancestor::tei:w][1][parent::tei:orig[parent::tei:choice[tei:reg = 'j' or tei:reg = 'v']]]
                ">
                <xsl:text>consonne</xsl:text>
            </xsl:when>
            <xsl:otherwise>voyelle</xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="substring-after(tokenize(ancestor::tei:w/@ana, ' ')[1], '#')"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="ancestor::tei:w/@lemma"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test="ancestor::tei:w/@rend">
                <xsl:value-of select="ancestor::tei:w/@rend"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>segmenté</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>