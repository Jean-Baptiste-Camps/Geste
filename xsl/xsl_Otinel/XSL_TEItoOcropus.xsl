<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Version originale -->
    <xsl:import href="teiverstxt_orig.xsl"/>
    <!-- Conservation des accents, abréviations, ponctuation -->
    <xsl:import href="teiverstxt_orig_tous_caracteres.xsl"/>
    <!-- Et la feuille -->
    <xsl:output method="text"/>
    <!-- import à refaire plus proprement 
        si on veut rendre la feuille plus généraliste -->
    <xsl:variable name="facsimile" select="document('../Transcriptions_diplomatiques/facsimile/facsimile_bodmer.xml')"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:cb"/>
    </xsl:template>
    
    <xsl:template match="tei:cb">
        <xsl:variable name="currentColumn" select="."/>
        <xsl:variable name="positionColonne" select="count(preceding::tei:cb) + 1"/>
        <!-- on récupère la colonne de même position dans le fichier facsimile -->
        <xsl:value-of select="$positionColonne"/>
        <xsl:variable name="colonneFS" select="$facsimile/facsimile/column[position() = $positionColonne]" />
        
        <xsl:for-each 
            select="following::tei:l[preceding::tei:cb[1] is $currentColumn]">
            <!-- et idem pour les lignes -->
            <xsl:variable name="positionLigne" select="position()"/>
            <xsl:variable name="filename" select="substring-before($colonneFS/line[position() = $positionLigne], '.')"/>
            <xsl:result-document href="{$filename}.gt.txt">
                <xsl:apply-templates/>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>
    
</xsl:stylesheet>