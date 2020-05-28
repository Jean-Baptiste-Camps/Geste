<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Feuille pour la lecture par l'humain des formes lemmatisées 
    (signalant les manques, ajouts, corrections, etc.).
    N.B.: vérifier l'effet de l'encodage des <sic> dans Otinel sur
    l'ensemble des feuilles de cette chaine.
    
    TODO: centraliser les règles communes avec unseen et train...
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:l"/>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates select="descendant::tei:w"/>
        <!--<xsl:text>&#xA;</xsl:text>-->
    </xsl:template>
    
    <xsl:template match="tei:w">
        <!--<xsl:value-of select="@xml:id"/>-->
        <!--<xsl:text>&#9;</xsl:text>-->
        <xsl:if test="ancestor::tei:del"><xsl:text>&lt;</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:sic[not(@ana)]"><xsl:text>†</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:add"><xsl:text>\</xsl:text></xsl:if>
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-unicode($contenu, 'NFC')"/>
        <xsl:if test="ancestor::tei:del"><xsl:text>&gt;</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:add"><xsl:text>/</xsl:text></xsl:if>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:orig"/>
    <xsl:template match="tei:abbr"/>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:sic"/>
    <!-- TODO: traitement des tei:del ? Conserver celui-ci ? Et que faire des del de niveau supérieur?-->
    <xsl:template match="tei:sic[ancestor::tei:w]">
        <xsl:text>†</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>†</xsl:text>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:w]">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:add">
        <xsl:text>\</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/</xsl:text>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:text>...</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- Normalisation des majuscules -->
    <xsl:template match="text()[. is ancestor::tei:w/descendant::text()[1] and (ancestor::tei:name|ancestor::tei:forename|ancestor::tei:placeName)]">
        <xsl:value-of select="upper-case(substring(., 1, 1))"/>
        <xsl:value-of select="substring(.,2)"/>
    </xsl:template>
    
</xsl:stylesheet>