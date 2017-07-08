<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- On importe les règles de conversion de la forme originale (mais on devra redéfinir la suppression des accents et abréviations) -->
    <xsl:import href="teiverstxt_orig.xsl"/>
    <xsl:include href="teiverscsv_fonctions.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="text"/>
    
    <xsl:param name="regex" 
        select="
        (  'q|Q')"/>
    
    <!-- On ne supprime pas les abréviations, mais, pour éviter les bugs avec les caractères combinatoires, 
        on les remplace par des caractères non combinatoires-->
    <xsl:template match="text()">
        <!--<xsl:value-of select="."/>-->
        <xsl:value-of 
            select="
            translate(
            translate(
            translate(
            translate(
            translate(
            translate(., '&#x0363;', '⒜' ),
            '&#x0364;','⒠'),
            '&#x0365;','⒤'),
            '&#x0366;', '⒪'),
            '&#x0367;','⒰'),
            '&#x0303;','~')
            "
        />
        <!--
            a suscrit &#x0363; > ⒜
            e sucrit &#x0364; > ⒠
            i suscrit &#x0365; > ⒤
            o sucrit &#x0366; > ⒪
            u suscrit &#x0367; > ⒰
            tilde &#x0303; > ~ 
        -->
    </xsl:template>
    
    <!-- On supprime aussi l'espace après les initiales, pour pouvoir analyser les signes abréviatifs qui suivent
        (à voir si on conserve, où si on traite ça comme un bug à corriger) -->
    <xsl:template match="tei:hi[matches(@rend, 'detach')]">
        <xsl:apply-templates/>
        <!--<xsl:text> </xsl:text>-->
        <!-- Ajout d'un espace après les initiales détachées: paraît se justifier car souvent, le copiste traite la seconde lettre de la ligne comme une lettre de début de mot -->
    </xsl:template>
    
    <xsl:template match="/">
        <!-- Changer cette variable pour changer le préfixe des fichiers de sortie -->
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:variable name="texte">
            <xsl:apply-templates select="descendant::tei:l"/>
        </xsl:variable>
        <xsl:variable name="tokenisé">
            <xsl:call-template name="_tokenize-characters">
                <xsl:with-param name="string" select="$texte"/>
            </xsl:call-template>
        </xsl:variable>
        <!--<xsl:value-of select="$texte"></xsl:value-of>-->
        
        <xsl:for-each select="$regex">
            <xsl:variable name="letter"><xsl:value-of select="substring(.,1,1)"/></xsl:variable>
            <xsl:result-document href="{$filename}_{$letter}_abbr_init.csv">
                <xsl:call-template name="csv_sans_pos_avec_abbrev_en_initiale">
                    <xsl:with-param name="tokenisé" select="$tokenisé"/>
                    <xsl:with-param name="regex" select="."/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template name="csv_sans_pos_avec_abbrev_en_initiale">
        <xsl:param name="tokenisé"/>
        <xsl:param name="regex"/>
        <xsl:text>allograph,following&#xA;</xsl:text>
        <xsl:for-each select="$tokenisé/*[matches(., $regex)]">
            <xsl:if test="preceding::text()[1] = '§'">
                <xsl:value-of select="."></xsl:value-of>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="following::text()[1]"/>
                <xsl:text></xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>