<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="tei_to_pandora_human.xsl"/>
    
    <xsl:template match="tei:w">
        <xsl:value-of select="@xml:id"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:if test="ancestor::tei:del"><xsl:text>&lt;</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:sic[not(@ana)]"><xsl:text>†</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:add"><xsl:text>\</xsl:text></xsl:if>
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-unicode($contenu, 'NFC')"/>
        <xsl:if test="ancestor::tei:del"><xsl:text>&gt;</xsl:text></xsl:if>
        <xsl:if test="ancestor::tei:add"><xsl:text>/</xsl:text></xsl:if>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="normalize-unicode(translate(normalize-space(@lemma), ' ', '_'), 'NFC')"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="translate(normalize-space(substring-after(tokenize(@type, '\|')[1], 'POS=')), ' ', '')"/>
        <!--<xsl:text>(</xsl:text>-->
        <xsl:text>&#9;</xsl:text>
        <xsl:variable name="morph">
            <!--<xsl:for-each select="tokenize(@ana, ' ')[matches(., 'CATTEX2009_MS_(MODE|TEMPS|PERS.|NOMB.|GENRE|CAS|DEGRE)')]">
                <xsl:value-of select="substring-after(., '#CATTEX2009_MS_')"/>
                <xsl:if test="position() != last()"><xsl:text>|</xsl:text></xsl:if>
            </xsl:for-each>-->
            <xsl:value-of select="translate(normalize-space(substring-after(@type, '|')), ' ', '')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$morph != ''"><xsl:value-of select="$morph"/></xsl:when>
            <xsl:otherwise>MORPH=empty</xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>