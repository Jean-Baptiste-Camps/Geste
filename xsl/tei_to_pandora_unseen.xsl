<?xml version="1.0" encoding="UTF-8"?>
<!-- Problème pour la normalisation unicode, 
que les accents se trouvent dans des balises séparées;
il faut donc faire un premier passage pour récupérer le contenu 
avant de le normaliser
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
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <!--<xsl:value-of select="@xml:id"/>-->
        <!--<xsl:text>&#9;</xsl:text>-->
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-unicode(translate(normalize-space($contenu),' ', '_'), 'NFC')"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:orig"/>
    <xsl:template match="tei:abbr"/>
    <xsl:template match="tei:note"/>
    <!--<xsl:template match="tei:sic"/>--><!-- voir ce qu'il faut faire pour les sic -->
    <!-- TODO: traitement des tei:del ? Conserver celui-ci ? Et que faire des del de niveau supérieur?-->
    <xsl:template match="tei:del[ancestor::tei:w]"/>
    
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- Normalisation des majuscules -->
    <xsl:template match="text()[. is ancestor::tei:w/descendant::text()[1] and (ancestor::tei:name|ancestor::tei:forename|ancestor::tei:placeName)]">
        <xsl:value-of select="upper-case(substring(., 1, 1))"/>
        <xsl:value-of select="substring(.,2)"/>
    </xsl:template>
    
</xsl:stylesheet>