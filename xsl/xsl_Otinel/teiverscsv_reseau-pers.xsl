<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- Transformation des persName
    en des données pour un réseau
    -->
    
    <xsl:template match="/">
        
        <xsl:text>pers1,pers2&#xA;</xsl:text>
        
        <xsl:apply-templates select="descendant::tei:lg[count(descendant::tei:persName) > 2]"/>
        
    </xsl:template>
    
    
    <xsl:template match="tei:lg">
        
       <xsl:variable name="mesNoms"
       select="distinct-values(descendant::tei:persName/tei:forename/tei:w/@lemma)"
       />
        
        <xsl:for-each select="$mesNoms">
            <xsl:variable name="maPos" select="position()"/>
            <xsl:for-each select="$mesNoms[position() > $maPos]">
                
                <xsl:value-of select="$mesNoms[$maPos]"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            
        </xsl:for-each>
        
        
    </xsl:template>
    
    <!-- Éventuellement, modifier pour calculer plutôt des poids globaux aux relations.
    Faisable en une deuxième étape, avec un for-each-group
    Mais peut se faire au moment du traitement plutôt.
    Sinon, on pourrait inclure le numéro de laisse dans une colonne supplémentaire,
    pour voir l'évolution dans le temps.
    Renommer Source et Target les colonnes?
      -->
    
    
    
</xsl:stylesheet>
