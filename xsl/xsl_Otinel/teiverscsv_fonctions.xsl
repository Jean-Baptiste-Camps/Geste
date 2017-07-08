<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Bibliothèque de fonction pour la conversion vers csv -->
    <!-- tokenisation -->
    <xsl:template name="_tokenize-characters">
        <xsl:param name="string"/>
        <!-- Ancienne version (exec. sur Mende: 47.8s) -->
        <!--<xsl:param name="len" select="string-length($string)"/>
        <xsl:choose>
            <xsl:when test="$len = 1">
                <token>
                    <xsl:value-of select="$string"/>
                </token>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="_tokenize-characters">
                    <xsl:with-param name="string" select="substring($string, 1, floor($len div 2))"/>
                    <xsl:with-param name="len" select="floor($len div 2)"/>
                </xsl:call-template>
                <xsl:call-template name="_tokenize-characters">
                    <xsl:with-param name="string" select="substring($string, floor($len div 2) + 1)"/>
                    <xsl:with-param name="len" select="ceiling($len div 2)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>-->
        <!-- Tentative d'une version plus efficace en utilisant XQuery ! (merci functx: http://www.xsltfunctions.com/xsl/functx_chars.html)
        exec sur Mende, 32.7 s (!)
        et en outre, plus de bugs du parseur dû à une trop grande récursivité
        -->
        <!--<xsl:variable name="sequence" select="
            for $ch in string-to-codepoints($string)
            return codepoints-to-string($ch)
            "/>-->
        <xsl:for-each select="string-to-codepoints($string)">
            <token><xsl:sequence select="codepoints-to-string(.)"/></token>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>