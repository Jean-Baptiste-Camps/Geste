<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        
        <xsl:apply-templates select="descendant::pb"/>
        
    </xsl:template>
    
    <xsl:template match="pb">
        <xsl:value-of select="@n"/>
        <xsl:variable name="monPb" select=".">
        </xsl:variable>
        <xsl:text>: </xsl:text>
      
        <xsl:value-of 
            select="
            count(following::l[preceding::pb[1] is $monPb and not(ancestor::rdg)])
            +
            count(following::lg[preceding::pb[1] is $monPb and not(preceding::element()[1] is $monPb) and not(ancestor::rdg)])
            "/><!-- Modification pour prendre en compte que, lorsqu'une laisse débute une page, il n'y a pas de saut de ligne -->
        <xsl:text>vers &#xA;</xsl:text>
        
    </xsl:template>
    
    
    
    
</xsl:stylesheet>