<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates/>
            <change who="#JBC" when="2019">Automated character level tokenization and simplification for allographetic analysis</change>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:del | tei:corr | tei:note | tei:expan | tei:pc[@type='supplied']"/>
   
   <!-- Character level tokenization -->

<xsl:template match="text()[ancestor::tei:w]"><!-- On pourrait rajouter and not(normalize-space(.) = '') mais la regex doit le traiter -->
    <xsl:analyze-string select="." regex="\S">
        <xsl:matching-substring>
            <c>
                <xsl:value-of select="." />
            </c>
        </xsl:matching-substring>
    </xsl:analyze-string>
</xsl:template>
    
    <!-- But, we keep original diacritics -->
    <xsl:template match="tei:orig[not(parent::tei:choice)]">
        <pc type='diacritic'>
        <xsl:apply-templates/>
        </pc>
    </xsl:template>
    
    <!-- We remove editorial diacritics -->
    <xsl:template match="tei:reg[not(parent::tei:choice)]"/>
    
    <!-- Hardcode all spaces -->
    <xsl:template match="tei:w">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:if test="not(@rend) and not(. is ancestor::tei:l[1]/descendant::tei:w[last()])">
            <space/>
        </xsl:if>
    </xsl:template>
    

</xsl:stylesheet>
