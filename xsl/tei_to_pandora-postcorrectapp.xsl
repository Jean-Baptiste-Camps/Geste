<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- FEUILLE À FINIR -->
    
    <xsl:import href="tei_to_pandora_train.xsl"/>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates select="descendant::tei:w"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    
</xsl:stylesheet>