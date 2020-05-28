<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- À retravailler... -->
    <xsl:import href="/home/jbc/Oxygen XML Editor 16/frameworks/tei/xml/tei/stylesheet/html/html.xsl"/>
    <xsl:param name="footnoteBackLink" select="'true'"/>
    
    <xsl:template match="tei:div[ancestor::tei:body]">
        <xsl:variable name="depth">
            <xsl:apply-templates mode="depth" select="."/>
        </xsl:variable>
        <xsl:call-template name="doDivBody">
            <xsl:with-param name="Depth" select="$depth"/>
        </xsl:call-template>
        <h5>Variantes</h5>
        <xsl:apply-templates select="descendant::tei:app[not(@type='orthographic')]" mode="printnotes"/>
        <h5>Variantes graphiques</h5>
        <xsl:apply-templates select="descendant::tei:app[@type='orthographic']" mode="printnotes"/>
        <h5>Notes crit.</h5>
        <xsl:apply-templates select="descendant::tei:note" mode="printnotes"/>
        <h5>Notes test</h5>
        <xsl:apply-templates select="descendant::tei:note" mode="printallnotes"/>
    </xsl:template>
    
</xsl:stylesheet>