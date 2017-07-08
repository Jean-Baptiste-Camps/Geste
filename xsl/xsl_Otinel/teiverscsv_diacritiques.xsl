<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text"/>

    <xsl:include href="teiverscsv_fonctions.xsl"/>

    <!--<xsl:param name="lettresAChercher" select="'ı|e'"/>-->

    <xsl:template match="/">
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:result-document href="{$filename}_accents.csv">
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
        <!-- On commence par tokeniser tout le texte -->
        <xsl:variable name="tokenisé">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- Petite touche de chic: on calcule automatiquement quelles sont les lettres qui portent l'accent -->
        <xsl:variable name="lettresAChercher">
            <xsl:value-of select="distinct-values($tokenisé//token[following::token[1] = '&#769;'])" separator="|"/>
        </xsl:variable>
        <xsl:apply-templates 
            mode="creationCSV"
            select="$tokenisé/descendant::token[matches(., $lettresAChercher)]"/>
        <!--descendant::tei:orig[. = '&#769;' ]"/>-->
        <!--distinct-values(//text()[following::text()[1][. = '&#769;'] ])-->
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="text()[ancestor::tei:body and not(ancestor::tei:corr) and not(ancestor::tei:reg) and not(ancestor::tei:expan) and not(ancestor::tei:note) and ancestor::tei:w]">
        <xsl:call-template name="_tokenize-characters">
            <xsl:with-param name="string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Champs à rajouter: lettre précédente accentuée ou non, etc. -->
    <xsl:template match="token" mode="creationCSV">
        <xsl:value-of select="ancestor::tei:w/@xml:id"/>
        <xsl:text>&#9;</xsl:text>
        <!-- Lettre précédente ou début de mot -->
        <xsl:choose>
            <xsl:when
                test="
                    not(ancestor::tei:w is preceding::token[1]/ancestor::tei:w)
                    and not(preceding::token[1]/ancestor::tei:w[@rend = 'aggl' or @rend = 'elision'])
                    ">
                <xsl:text>_</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="preceding::token[1]"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#9;</xsl:text>
        <!-- Accentué ou non -->
        <xsl:choose>
            <xsl:when test="following::token[1][. = '&#769;']">
                <xsl:text>accentue</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:choose>
                    <!-- Et on récupère le caractère suivant -->
                    <xsl:when
                        test="
                            not(ancestor::tei:w is following::token[2]/ancestor::tei:w)
                            and not(ancestor::tei:w[@rend = 'aggl' or @rend = 'elision'])
                            ">
                        <xsl:text>_</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="following::token[2]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>nonAccent</xsl:text>
                <xsl:text>&#9;</xsl:text>
                <xsl:choose>
                    <!-- Et on récupère le caractère suivant -->
                    <xsl:when
                        test="
                            not(ancestor::tei:w is following::token[2]/ancestor::tei:w)
                            and not(ancestor::tei:w[@rend = 'aggl' or @rend = 'elision'])
                            ">
                        <xsl:text>_</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="following::token[2]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <!-- Voyelle ou consonne -->
        <xsl:choose>
            <xsl:when
                test="
                    .[parent::tei:orig[parent::tei:choice[tei:reg = 'j' or tei:reg = 'v']]]
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
            <!-- Ou le mot précédent -->
            <xsl:when test="ancestor::tei:w/preceding::tei:w[1]/@rend">
                <xsl:value-of select="ancestor::tei:w/preceding::tei:w[1]/@rend"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>segmenté</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

    <!--<xsl:template match="tei:orig[. = '&#769;']">
        <xsl:value-of select="ancestor::tei:w/@xml:id"/>
        <xsl:text>&#9;</xsl:text>
        <!-\- Lettre précédente -\->
        <!-\- On teste d'abord si on est en début de mot -\->
        <xsl:choose>
            <!-\- on teste que c'est le même mot, et qu'il n'y ait pas d'agglutination -\->
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
            <!-\- on teste que c'est le même mot, et qu'il n'y ait pas d'agglutination -\->
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
        <!-\- Voyelle ou consonne -\->
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
    </xsl:template>-->

</xsl:stylesheet>
