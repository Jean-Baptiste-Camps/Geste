<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Ne pas oublier de commenter le schéma -->
    <xsl:output method="xml" indent="no"/>
    
    <!-- Modifier pour:
        - ajouter le sigle au début de la numérotation des vers, mots, etc.
        du type w_A_45
        - donner un xml:id aux vers
        - donner un numéro aux lb.
        - 
    -->
    
    <!-- Serait possible de conserver certaines entités avec xsl:character-map -->
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:variable name="number">
            <xsl:number format="1" level="any" from="tei:text" count="tei:l[not(@n)]"/><!-- On compte ceux qui ne sont pas numérotés, car une numérotation manuelle signifie qu'il y a un vers répété -->
        </xsl:variable>
        <xsl:variable name="sigle" select="ancestor::tei:TEI/descendant::tei:sourceDesc/tei:msDesc/@xml:id"/>
        <xsl:choose>
            <xsl:when test="@n">
                <xsl:copy>
                    <xsl:attribute name="xml:id" select="concat($sigle, '_l_', @n)"/>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:when>
           <xsl:otherwise>
               <xsl:copy>
                   <xsl:attribute name="n" select="$number"/>
                   <xsl:attribute name="xml:id" select="concat($sigle, '_l_', $number)"/>
                   <xsl:apply-templates select="@*|node()"/>
               </xsl:copy>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:variable name="number">
            <xsl:number format="000001" level="any" from="tei:text"/>
        </xsl:variable>
        <xsl:variable name="sigle" select="ancestor::tei:TEI/descendant::tei:sourceDesc/tei:msDesc/@xml:id"/>
        <xsl:copy>
            <xsl:attribute name="xml:id" select="concat($sigle, '_w_',$number)"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:choose>
                    <xsl:when test="preceding::tei:cb"><xsl:number count="tei:lb" from="tei:cb" level="any"/></xsl:when>
                    <xsl:otherwise><xsl:number count="tei:lb" from="tei:pb" level="any"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>