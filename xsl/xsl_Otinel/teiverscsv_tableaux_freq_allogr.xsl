<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    
    <xsl:import href="teiverstxt_orig.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="text"/>
    <xsl:include href="teiverscsv_fonctions.xsl"/>
    <!-- Cette feuille a été programmée relativement rapidement, et on pourrait la rendre plus élégante -->
    
    <!-- TODO: 27 août 2016 => feuille cassée, patchée pour éviter les integer division by zero, mais ne remplit peut-être plus son but initial -->
    
    <xsl:param name="regex1"
        select="
        (  'a|ɑ', 
        'b|B',
        'd|ꝺ|D',
        'e|E',
        'g|G',
        'ı|J|ȷ',
        'l|L',
        'm|M',
        'n|N',
        'r|R|ꝛ',
        's|S|ſ||',
        'u|v|V'
        )"/>
    
    <xsl:param name="regex2"
        select="
        (  'a|ɑ|A|Λ', 
        'b|B',
        'ꝺ|D',
        'e|E|EE|&#61975;',
        'f|ff|F',
        'g|G',
        'ı|J',
        'k|K',
        'l|L',
        'm|M',
        'n|N',
        'p|ꝑ|P',
        'q|Q',
        'r|R',
        's|S',
        't|T',
        'u|v|V'
        )"/>
    
    <!-- On redéfinit les templates concernant tei:hi, pour différencier l'emploi en ligne -->
    <xsl:template match="tei:hi[matches(@rend, 'initiale')]" mode="#default"/>
    <xsl:template match="tei:hi[matches(@rend, 'initiale')]" mode="notabilior">
        <xsl:apply-templates mode="#default"/>
    </xsl:template>
    
    
    <xsl:template match="/">
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:variable name="tree" select="/"/>
        <!-- 1er tableau, fréquence des allographes employés en ligne -->
        <xsl:choose>
            <!-- On va différencier les traitements, au cas où il y ait un handshift.  -->
            <xsl:when test="descendant::tei:handShift">
                <xsl:variable name="mains" select="descendant::tei:handShift/@new"/>
                <xsl:variable name="textes" as="node()+">
                    <xsl:for-each select="descendant::tei:handShift">
                        <xsl:variable name="monId" select="generate-id(.)"/>
                        <texte>
                            <xsl:apply-templates
                                select =
                                "$tree/descendant::tei:l[(generate-id(preceding::tei:handShift[1]) = $monId and not(descendant::tei:handShift)) or generate-id(descendant::tei:handShift) = $monId]"
                            />
                        </texte>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="tokenisés" as="node()+">
                    <xsl:for-each select="$textes">
                        <texte>
                            <xsl:call-template name="_tokenize-characters">
                                <xsl:with-param name="string" select="."/>
                            </xsl:call-template>
                        </texte>
                    </xsl:for-each>
                </xsl:variable>
                <!-- Et on est bon pour partir -->
                    <xsl:result-document href="{$filename}_freq_enligne.csv">
                     <xsl:text>,</xsl:text>
                     <xsl:for-each select="$regex1"><xsl:value-of select="translate(., '|', ',')"/><xsl:text>,</xsl:text></xsl:for-each>
                        <xsl:text>Indice allographétique global</xsl:text>
                        <xsl:text>,</xsl:text>
                      <xsl:text>&#xA;</xsl:text>
                        <xsl:for-each select="$tokenisés">
                            <xsl:variable name="position" select="position()"/>
                            <xsl:variable name="texte" select="."/>
                            <xsl:value-of select="concat('Main', $position)"/>
                            <xsl:for-each select="$regex1">
                                <xsl:variable name="regex_en_cours" select="."/>
                                <xsl:variable name="lettres" select="tokenize(.,'\|')"/>
                                <xsl:if test="count($texte/descendant::node()[matches(., $regex_en_cours)]) > 0">
                                    <xsl:for-each select="$lettres">
                                        <xsl:text>,</xsl:text>
                                        <xsl:variable name="lettre" select="."/>
                                        <xsl:choose>
                                            <xsl:when test="count($texte/descendant::node()[. = $lettre]) > 0">
                                                <xsl:value-of select="round-half-to-even(count($texte/descendant::node()[. = $lettre]) div count($texte/descendant::node()[matches(., $regex_en_cours)]),4)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>0</xsl:text>
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                        
                                        
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text>,</xsl:text>
                            <!-- Traitements très spécifiques à nos trois manuscrits, car la définition d'allographe minoritaire varie -->
                            <xsl:choose>
                                <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'M'">
                                    <xsl:value-of select="round-half-to-even(
                                        count($texte/descendant::node()[matches(., 'a|B|ꝺ|D|E|G|ȷ|J|L|M|N|ꝛ|R|s|||v' )])
                                        div count($texte/descendant::node()[not(. = '')])
                                        , 4)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="round-half-to-even(
                                        count($texte/descendant::node()[matches(., 'ɑ|B|d|D|E|G|ȷ|J|L|M|N|ꝛ|R|s|||v' )])
                                        div count($texte/descendant::node()[not(. = '')])
                                        , 4)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>&#xA;</xsl:text>
                        </xsl:for-each>
                    </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <!-- et on retourne sur nos autres traitements -->
                <xsl:variable name="texte">
                    <xsl:apply-templates select="descendant::tei:l"/>
                </xsl:variable>
                <xsl:variable name="tokenisé">
                    <xsl:call-template name="_tokenize-characters">
                        <xsl:with-param name="string" select="$texte"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:result-document href="{$filename}_freq_enligne.csv">
                    <xsl:text>,</xsl:text>
                    <xsl:for-each select="$regex1"><xsl:value-of select="translate(., '|', ',')"/><xsl:text>,</xsl:text></xsl:for-each>
                    <xsl:text>Indice allographétique global</xsl:text>
                    <xsl:text>,</xsl:text>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:variable name="texte" select="$tokenisé"/>
                        <xsl:for-each select="$regex1">
                            <xsl:variable name="regex_en_cours" select="."/>
                            <xsl:variable name="lettres" select="tokenize(.,'\|')"/>
                            <xsl:if test=" count($texte/descendant::node()[matches(., $regex_en_cours)]) > 0">
                                <xsl:for-each select="$lettres">
                                <xsl:text>,</xsl:text>
                                <xsl:variable name="lettre" select="."/>
                                    <xsl:choose>
                                        <xsl:when test="count($texte/descendant::node()[. = $lettre]) > 0">
                                            <xsl:value-of select="round-half-to-even(count($texte/descendant::node()[. = $lettre]) div count($texte/descendant::node()[matches(., $regex_en_cours)]),4)"/>
                                        </xsl:when>
                                        <xsl:otherwise><xsl:text>0</xsl:text></xsl:otherwise>
                                    </xsl:choose>
                            </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    <!-- Traitements très spécifiques à nos trois manuscrits, car la définition d'allographe minoritaire varie -->
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'M'">
                            <xsl:value-of select="round-half-to-even(
                                count($texte/descendant::node()[matches(., 'a|B|ꝺ|D|E|G|ȷ|J|L|M|N|ꝛ|R|s|||v' )])
                                div count($texte/descendant::node()[not(. = '')])
                                , 4)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="round-half-to-even(
                                count($texte/descendant::node()[matches(., 'ɑ|B|d|D|E|G|ȷ|J|L|M|N|ꝛ|R|s|||v' )])
                                div count($texte/descendant::node()[not(. = '')])
                                , 4)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
       
        <!-- Et maintenant, 2e tableau, pour faire la même chose pour les litterae notabiliores -->
        <xsl:choose>
            <!-- On va différencier les traitements, au cas où il y ait un handshift.  -->
            <xsl:when test="descendant::tei:handShift">
                <xsl:variable name="mains" select="descendant::tei:handShift/@new"/>
                <xsl:variable name="textes" as="node()+">
                    <xsl:for-each select="descendant::tei:handShift">
                        <xsl:variable name="monId" select="generate-id(.)"/>
                        <texte>
                            <xsl:for-each select =
                                "$tree/descendant::tei:hi[matches(@rend, 'initiale') and
                                ((generate-id(preceding::tei:handShift[1]) = $monId and not(descendant::tei:handShift)) or generate-id(descendant::tei:handShift) = $monId)]">
                                <node>
                                <xsl:apply-templates mode="notabilior" select="."/>
                                </node>
                            </xsl:for-each>
                        </texte>
                    </xsl:for-each>
                </xsl:variable>
                <!-- Et on est bon pour partir -->
                <xsl:result-document href="{$filename}_freq_initiale.csv">
                    <xsl:text>,</xsl:text>
                    <xsl:for-each select="$regex2"><xsl:value-of select="translate(., '|', ',')"/><xsl:text>,</xsl:text></xsl:for-each>
                    <xsl:text>Indice allographétique global</xsl:text>
                    <xsl:text>,</xsl:text>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:for-each select="$textes">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="texte" select="."/>
                        <xsl:value-of select="concat('Main', $position)"/>
                        <xsl:for-each select="$regex2">
                            <xsl:variable name="regex_en_cours" select="."/>
                            <xsl:variable name="lettres" select="tokenize(.,'\|')"/>
                            <xsl:for-each select="$lettres">
                                <xsl:text>,</xsl:text>
                                <xsl:variable name="lettre" select="."/>
                                <xsl:value-of select="round-half-to-even(count($texte/descendant::node()[. = $lettre]) div count($texte/descendant::node()[matches(., $regex_en_cours)]),4)"/>
                            </xsl:for-each>
                        </xsl:for-each>
                        <xsl:text>,</xsl:text>
                        <!-- Traitements très spécifiques à nos trois manuscrits, car la définition d'allographe minoritaire varie -->
                        <xsl:choose>
                            <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'A' and $position = 1">
                                <xsl:value-of select="round-half-to-even(
                                    count($texte/descendant::node()[matches(., 'a|A|b|ꝺ|E|[^f]f[^f]|F|l|N|V' )])
                                    div count($texte/descendant::node()[not(. = '')])
                                    , 4)"/>
                            </xsl:when>
                            <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'A' and $position = 2">
                                <xsl:value-of select="round-half-to-even(
                                    count($texte/descendant::node()[matches(., 'A|F|m|N|P|v' )])
                                    div count($texte/descendant::node()[not(. = '')])
                                    , 4)"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:for-each>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
                <!-- et on retourne sur nos autres traitements -->
                <xsl:variable name="texte">
                    <xsl:for-each select="descendant::tei:hi[matches(@rend, 'initiale')]">
                        <node>
                            <xsl:apply-templates  mode="notabilior" select="." />
                        </node>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:result-document href="{$filename}_freq_initiale.csv">
                    <xsl:text>,</xsl:text>
                    <xsl:for-each select="$regex2"><xsl:value-of select="translate(., '|', ',')"/><xsl:text>,</xsl:text></xsl:for-each>
                    <xsl:text>Indice allographétique global</xsl:text>
                    <xsl:text>,</xsl:text>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:variable name="texte" select="$texte"/>
                    <xsl:for-each select="$regex2">
                        <xsl:variable name="regex_en_cours" select="."/>
                        <xsl:variable name="lettres" select="tokenize(.,'\|')"/>
                        <xsl:for-each select="$lettres">
                            <xsl:text>,</xsl:text>
                            <xsl:variable name="lettre" select="."/>
                            <xsl:value-of select="round-half-to-even(count($texte/descendant::node()[. = $lettre]) div count($texte/descendant::node()[matches(., $regex_en_cours)]),4)"/>
                        </xsl:for-each>
                    </xsl:for-each>
                    <!-- Traitements très spécifiques à nos trois manuscrits, car la définition d'allographe minoritaire varie -->
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'M'">
                            <xsl:value-of select="round-half-to-even(
                                count($texte/descendant::node()[matches(., 'ɑ|ꝺ|E|F|g|m|N|P' )])
                                div count($texte/descendant::node()[not(. = '')])
                                , 4)"/>
                        </xsl:when>
                        <xsl:when test="$tree/descendant::tei:msDesc/@xml:id = 'B'">
                            <xsl:value-of select="round-half-to-even(
                                count($texte/descendant::node()[matches(., 'a|b|&#61975;|f|K|l|n|P|q|T|u' )])
                                div count($texte/descendant::node()[not(. = '')])
                                , 4)"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>