<?xml version="1.0" encoding="UTF-8"?>
<!-- TODO: utiliser la fonction 'normalize-unicode(), et la mettre en  œuvre dans les autres feuilles de style -->
<!-- Sur la normalisation, voir
        https://www.w3.org/TR/2005/WD-charmod-norm-20051027/#sec-NormalizationMotivation
        En gros,
        The Unicode Consortium provides four standard normalization forms 
        (see Unicode Normalization Forms [UTR #15]). These forms differ in 1) 
        whether they normalize towards decomposed characters (NFD, NFKD)  ** i.e., ç devient c+cédille **
        or precomposed characters (NFC, NFKC) **l'inverse** 
        and 2) whether the normalization 
        process erases compatibility distinctions (NFKD, NFKC) ** ſ devient s ** 
        or not (NFD, NFC).
        
        Roughly speaking, NFC is defined such that each combining character sequence
        (a base character followed by one or more combining characters) is replaced, 
        as far as possible, by a canonically equivalent precomposed character. 
        Text in a Unicode encoding form is said to be in NFC if it doesn't contain
        any combining sequence that could be replaced and if any remaining 
        combining sequence is in canonical order.
        
        => NFC me paraît également le meilleur choix.
-->
<!-- Problème pour la normalisation unicode, 
que les accents se trouvent dans des balises séparées;
il faut donc faire un premier passage pour récupérer le contenu 
avant de le normaliser
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:l"/><!-- Ajouter un test pour éviter de récupérer les vers vides -->
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:apply-templates select="descendant::tei:w[
            not(@lemma = '' and not(contains(@type,'POS=OUT'))) 
            and not(ancestor::tei:del)
            and not(descendant::tei:gap)
            ]"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-unicode(translate(normalize-space($contenu),' ', '_'), 'NFC')"/>
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
        
        <!--<xsl:text>)</xsl:text>-->
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del"/>
    <xsl:template match="tei:add">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- Créer une XSL standard forme  normalisée-->
    <xsl:template match="tei:orig"/>
    <xsl:template match="tei:abbr"/>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:sic"/><!-- TODO: faire très attention avec ça -->
    
</xsl:stylesheet>
