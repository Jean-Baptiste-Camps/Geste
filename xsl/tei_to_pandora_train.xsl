<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="NoPonctMod" select="not(/descendant::tei:pc[@type='supplied'])"/>
    
    <xsl:template match="/">
        <xsl:text>form</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>lemma</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>POS</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>morph</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates select="descendant::tei:l"/>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <!-- JBC: traitement des sic et corr.
        Si on voulait être rigoureux, il faudrait peut-être
        virer les corrections de l'éditeur, garder les sic,
        et ne garder que les lemmes, pas les variantes rdg.
        
        Pour le moment: je garde les variantes rdg, qui font des 
        données en plus.
        -->
        <xsl:apply-templates select="descendant::tei:w[
            not(@lemma = '' or @pos ='OUT'
            or ancestor::tei:del
            or descendant::tei:gap)
            ]
            | descendant::tei:pc[@type='supplied']
            "
        />
        <xsl:if test="$NoPonctMod">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:w | tei:pc">
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-unicode(translate(normalize-space($contenu),' ', '_'), 'NFC')"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="normalize-unicode(translate(normalize-space(@lemma), ' ', '_'), 'NFC')"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="translate(normalize-space(@pos), ' ', '')"/>
        <!--<xsl:text>(</xsl:text>-->
        <xsl:text>&#9;</xsl:text>
        <xsl:variable name="morph">
            <!--<xsl:for-each select="tokenize(@ana, ' ')[matches(., 'CATTEX2009_MS_(MODE|TEMPS|PERS.|NOMB.|GENRE|CAS|DEGRE)')]">
                <xsl:value-of select="substring-after(., '#CATTEX2009_MS_')"/>
                <xsl:if test="position() != last()"><xsl:text>|</xsl:text></xsl:if>
            </xsl:for-each>-->
            <xsl:value-of select="translate(normalize-space(@msd), ' ', '')"/>
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
    
    <!-- JBC: ici, on va garder les sic, et virer les 
    corr éditoriales (à reréfléchir si besoin).
    Ou plutôt l'inverse - ah oui, mais en fait, ça va varier selon les docs.
    Zut.
    Une approche qui peut marcher:
    -->
    <xsl:template match="tei:choice[tei:corr]">
        <xsl:apply-templates select="tei:corr"/>
    </xsl:template>
    <!-- SEUL PROBLÈME: pour les éditions qui normalisent trop la langue, on aura la version normalisée. Cf. par ex.
    Aebischer sur FlorenceA et Macaire.
    -->
    <!--<xsl:template match="tei:sic"/>-->
    <!--<xsl:template match="tei:corr[@type='editorial']"/>-->
    
</xsl:stylesheet>
