<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- TODO: add rules to transform the emplacement of @facs elements, paragraphs as cb or pb, etc.
    and their numerotation
    -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()[ancestor::tei:l and not(ancestor::tei:note)]">
        <xsl:analyze-string select="." regex="([^&apos;\-\s]+)($|[&apos;\-\s]+|^)">
            <xsl:matching-substring>
                <xsl:element name="w">
                    <xsl:choose>
                        <xsl:when test='regex-group(2) = "&apos;"'>
                            <xsl:attribute name="rend">elision</xsl:attribute>
                        </xsl:when>
                        <xsl:when test='regex-group(2) = "-"'>
                            <xsl:attribute name="rend">aggl</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:copy-of select="regex-group(1)"></xsl:copy-of>
                </xsl:element>
            </xsl:matching-substring>
            
            <xsl:non-matching-substring>
                <xsl:if test="normalize-space(.) != ''">
                    <xsl:comment>ERROR? Non matched text on this line:
                <xsl:value-of select="."/>
                </xsl:comment>
                </xsl:if>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
</xsl:stylesheet>