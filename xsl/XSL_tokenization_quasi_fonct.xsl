<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <!-- 
        XSL de tokenization à peaufiner,
        notamment pour la gestion des niveaux de 
        profondeur au sein des TEI:l,
        mais qui donne des résultats corrects.
    -->
    <!-- Tenir compte des ' pour créer des mots avec rend="elision" -->

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()[parent::tei:l]" mode="addAnchors">
        <xsl:analyze-string select="." regex="(\s+|&apos;)">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="matches(., '\s+')">
                        <anchor type="wordBoundary"/>
                    </xsl:when>
                    <xsl:when test='matches(., "&apos;")'>
                        <anchor type="wordBoundary" subtype="elision"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ERROR</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="copyWithAnchors">
            <xsl:apply-templates mode="addAnchors"/>
        </xsl:variable>
        <xsl:apply-templates select="$copyWithAnchors" mode="tokenize"/>
    </xsl:template>

    <xsl:template match="tei:l" mode="tokenize">
        <xsl:copy>
            <xsl:apply-templates select="attribute::*"/>
            <xsl:apply-templates select="descendant::tei:anchor" mode="tokenize"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:anchor[@type = 'wordBoundary']" mode="tokenize">
        <xsl:choose>
            <xsl:when 
                test="preceding-sibling::tei:anchor[@type = 'wordBoundary']">
                <xsl:variable name="precedingAnchor"
                    select="preceding-sibling::tei:anchor[@type = 'wordBoundary'][1]"/>
                <w>
                    <xsl:if test="@subtype = 'elision'">
                        <xsl:attribute name="rend">elision</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates
                        select="preceding-sibling::node()[preceding-sibling::tei:anchor[1] is $precedingAnchor]"
                        mode="#default"/>
                </w>
                <xsl:if test="not(@subtype = 'elision')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when
                test="not(preceding-sibling::tei:anchor[@type = 'wordBoundary']) and parent::tei:l">
                <w>
                    <xsl:apply-templates 
                        select="preceding-sibling::node()" 
                        mode="#default"/>
                </w>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>ERROR</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Et les derniers mots de la ligne -->
        <xsl:if test="not(following-sibling::tei:anchor[@type = 'wordBoundary']) and parent::tei:l">
            <w>
                <xsl:apply-templates 
                    select="following-sibling::node()" 
                    mode="#default"/>
            </w>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
