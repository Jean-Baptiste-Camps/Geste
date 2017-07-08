<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:result-document href="{$filename}_corrections.csv">
            <xsl:text>typeCorr</xsl:text>
            <xsl:text>&#9;</xsl:text>
            <xsl:text>niveau</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body/(descendant::tei:del |descendant::tei:add)"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="tei:del | tei:add">
       <xsl:choose>
           <xsl:when test="@rend">
               <xsl:value-of select="@rend"/>
           </xsl:when>
           <xsl:when test="@place">
               <xsl:value-of select="@place"/>
           </xsl:when>
       </xsl:choose> 
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test="ancestor::tei:w">
                <xsl:text>infMot</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::tei:w">
                <xsl:text>supEqMot</xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- NB: à terme, il faudrait aussi comparer avec la longueur de la séquence en nombre de chars -->
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    
</xsl:stylesheet>