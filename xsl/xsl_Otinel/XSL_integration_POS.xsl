<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:variable name="POS_file" select="
        concat(string-join(tokenize(base-uri(), '/')[position() != last()], '/'),
        '/POS-tags/', 
        substring-before(tokenize(base-uri(), '/')[last()], '_'), 
        '_pos.xml')"/>
    
    <xsl:variable name="POS" select="document($POS_file)"/>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:variable name="monID" select="@xml:id"/>
        <xsl:variable name="mesPOS" select="$POS//row[ID = $monID]"/>
        <xsl:variable name="monAna">
            <xsl:for-each select="$mesPOS/(PPOS|MODE|TEMPS|PERS.|NOMB.|GENRE|CAS|DEGRÉ)[. != '']">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$mesPOS/(NOMB.-M|CAS-M|flect_M)">
                <xsl:text> </xsl:text>
                <xsl:text>#M:</xsl:text>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="lemma" select="$mesPOS/PLEMMA"/><!-- TODO: il faudrait utiliser
            ici normalize-unicode() en 'NFC', mais la feuille de création de tableaux ne la gère pas encore
            -->
            <xsl:attribute name="ana" select="$monAna"/>
            <xsl:apply-templates select=" node() |  @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>