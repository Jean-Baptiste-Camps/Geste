<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">

    <!-- Ne pas oublier de commenter le schéma -->
    <xsl:output method="xml" indent="no"/>

    <!-- Serait possible de conserver certaines entités avec xsl:character-map -->

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Tokenizer Vatican et Mende: elisions, agglutinations et déglutinations déjà encodées  -->
    <xsl:template 
        match="tei:l/node()[not(ancestor-or-self::tei:w) and not(ancestor-or-self::tei:note) and not(ancestor-or-self::tei:corr) and not(ancestor-or-self::tei:sic)] ">
        <xsl:choose>
            <xsl:when test='matches(.,"([\wéïüçöëä/]+)")'>
                <w><xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy></w>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    




</xsl:stylesheet>