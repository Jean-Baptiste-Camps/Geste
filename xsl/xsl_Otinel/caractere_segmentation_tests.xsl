<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:variable name="segmente_par_char" as="xs:string+">
            <xsl:for-each select="//tei:w/text() | //tei:orig">
                <!-- Avec un peu de FLOWR pour le style (on tokenise caractère par caractère la chaîne en entrée) -->
                <xsl:sequence select=" 
                    for $index in 1 to string-length(.)
                    return substring(., $index, 1)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:text>Ratio ɑ/a: </xsl:text>
        <!-- On évite la division par 0 -->
        <xsl:if test="count($segmente_par_char[. = 'a']) > 0">
            <xsl:value-of select="count($segmente_par_char[. = 'ɑ']) div (count($segmente_par_char[. = 'ɑ']) + count($segmente_par_char[. = 'a'])) * 100"/>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>