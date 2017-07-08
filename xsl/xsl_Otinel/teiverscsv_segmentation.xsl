<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:result-document href="{$filename}_segmentation.csv">
        <xsl:text>ID</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>typeCas</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lemmeMotPreced</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posMotPreced</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posSimplMotPreced</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lemmeMotCour</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posMotCour</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posSimplMotCour</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lemmeMotSuiv</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posMotSuiv</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>posSimplMotSuiv</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>typeCasMotSuiv</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates select="descendant::tei:text/descendant::tei:w[not(ancestor::corr) and not(ancestor::note)]"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:value-of select="@xml:id"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test="@rend">
                <xsl:value-of select="@rend"/>
            </xsl:when>
            <!-- JBC: et testons à présent si une espace fine sépare ce mot de celui qui le suit -->
            <xsl:when test=". is following::tei:space[@quantity='0.5' and not(ancestor::tei:w)][1]/preceding::tei:w[1]">
                <xsl:text>sepFine</xsl:text>
            </xsl:when>
            <xsl:when test="tei:space">
                <xsl:text>degl</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>segm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[1]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="preceding::tei:w[1]/@lemma"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[1]"><xsl:text>NA</xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="substring-after(tokenize(preceding::tei:w[1]/@ana, ' ')[1], '#')"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[1]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="substring(tokenize(preceding::tei:w[1]/@ana, ' ')[1], 2, 3)"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@lemma"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="substring-after(tokenize(@ana, ' ')[1], '#')"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="substring(tokenize(@ana, ' ')[1], 2, 3)"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[last()]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="following::tei:w[1]/@lemma"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[last()]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="substring-after(tokenize(following::tei:w[1]/@ana, ' ')[1], '#')"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[last()]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="substring(tokenize(following::tei:w[1]/@ana, ' ')[1], 2, 3)"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#9;</xsl:text>
        <!-- Cas du mot suivant -->
        <xsl:choose>
            <xsl:when test=". is ancestor::tei:l/descendant::tei:w[last()]"><xsl:text>NA</xsl:text></xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="following::tei:w[1]/@rend">
                        <xsl:value-of select="following::tei:w[1]/@rend"/>
                    </xsl:when>
                    <!-- JBC: et testons à présent si une espace fine sépare ce mot de celui qui le suit -->
                    <xsl:when test="following::tei:w[1] is following::tei:w[1]/following::tei:space[@quantity='0.5' and not(ancestor::tei:w)][1]/preceding::tei:w[1]">
                        <xsl:text>sepFine</xsl:text>
                    </xsl:when>
                    <xsl:when test="following::tei:w[1]/tei:space">
                        <xsl:text>degl</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>segm</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
               </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>