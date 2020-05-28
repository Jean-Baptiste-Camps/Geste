<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:param name="monTemoin"><xsl:text>a</xsl:text></xsl:param>
    
    <xsl:template match="/">
        <xsl:apply-templates select="tei:TEI/tei:text/tei:body"/>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- on veut les erreurs du ms. -->
    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="child::tei:corr[@type='errata']">
                <xsl:apply-templates select="tei:corr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:sic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- On sélectionne les variantes que l'on veut
    Ici, il faudrait faire un test, pour savoir si la listWit a plusieurs descendants,
    et, si oui, prendre le premier (ms. de base),
    et, si non, récupérer le lemme.
    -->
    <xsl:template match="tei:app">
        <xsl:apply-templates select="lem[@wit='$monTemoin'] | rdg[@wit='$monTemoin']"/>
    </xsl:template>
    <xsl:template match="tei:head"/>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:pc"/>
    
    
    <!-- gestion espacement -->
    <xsl:template match="tei:w">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    
    
</xsl:stylesheet>