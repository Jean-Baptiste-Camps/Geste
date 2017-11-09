<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:variable name="mesDocs" select="collection('../xml/?select=*_pos.xml')"/>
    
    
    <xsl:template match="/">
        <!-- Lemmes concaténés -->
        <!--<xsl:result-document>
        <xsl:for-each-group select="$mesDocs//tei:w[contains(@lemma, '+')]" group-by="@lemma">
            <xsl:sort select="@lemma" order="ascending" data-type="text"/>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="count(current-group())"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each-group>
        </xsl:result-document>-->
        <!-- Noms propres -->
        <xsl:result-document>
            <xsl:for-each-group select="$mesDocs//tei:w[starts-with(@type, 'POS=NOMpro')]" group-by="@lemma">
                <xsl:sort select="@lemma" order="ascending" data-type="text"/>
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text>&#9;</xsl:text>
                <xsl:value-of select="count(current-group())"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>