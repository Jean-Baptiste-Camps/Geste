<?xml version="1.0" encoding="UTF-8"?>

<!-- 
    Un moyen largement meilleur d'avoir une feuille plus propre serait sans doute d'utiliser un langage xml de transition, 
    permettant d'éviter des bidouilles intermédiaires (du genre ajout de %), en créeant des 
    <consonne></consonne> et <voyelle></voyelle>, etc.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="teiverstxt_orig.xsl"/>
    <xsl:include href="teiverscsv_fonctions.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="text"/>

    <xsl:param name="regex"
        select="
        (  'a|ɑ|A|Λ', 
            'b|B',
            'd|δ|D',
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
    
    <!-- TODO: il faudrait simplifier le code, en évitant la redondance entre les templates nommés,
    ce qu'il est assez aisé de faire en ajoutant un paramètre ($main), et en testant systématiquement s'il est présent
    (if $main, alors, on rajoute la colonne main)
    -->
    
    <xsl:template match="/">
        <!-- Changer cette variable pour changer le préfixe des fichiers de sortie -->
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:choose>
            <!-- 
            On va différencier les traitements, au cas où il y ait un handshift. 
            Dans ce cas, on veut faire de la main un critère également -->
            <xsl:when test="descendant::tei:handShift">
                <xsl:variable name="tree" select="/"/>
                <xsl:variable name="mains" select="descendant::tei:handShift/@new"/>
                <!-- Bon, tout le passage qui suit est un peu moche, mais il est nécessaire, car nous voulons
                    1. créer une séquence ($textes), contenant un nœud texte correspondant a la partie copiée par une même main
                    2. donc, nous devons utiliser le type item()+
                    3. mais nous ne voulons pas un nœud par "apply-templates", mais un par texte
                -->
                <xsl:variable name="textes" as="node()+">
                    <xsl:for-each select="descendant::tei:handShift">
                        <xsl:variable name="monId" select="generate-id(.)"/>
                        <texte>
                            <!-- comme, malheureusement, on ne peut mettre l'handShift entre deux vers (contrairement à l'exemple
                            des Guidelines), mais seulement à l'intérieur, il faut légèrement compliquer le code-->
                            <!-- L'autre solution serait d'agir au niveau des w -->
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
                <xsl:for-each select="$regex">
                    <xsl:variable name="regex" select="."/>
                    <xsl:variable name="letter">
                        <xsl:value-of select="substring(.,1,1)"/>
                    </xsl:variable>
                    <xsl:result-document href="{$filename}_{$letter}.csv">
                        <xsl:text>preceding,allograph,following,hand&#xA;</xsl:text>
                        <xsl:for-each select="$tokenisés">
                            <xsl:variable name="position" select="position()"/>
                            <xsl:call-template name="csv_sans_pos">
                                <xsl:with-param name="tokenisé" select="."/>
                                <xsl:with-param name="regex" select="$regex"/>
                                <xsl:with-param name="main" select="$mains[$position]"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:result-document>
                    <xsl:result-document href="{$filename}_{$letter}_pos.csv">
                        <xsl:choose><!-- On teste pour voir quel entête faire -->
                            <xsl:when test="starts-with($regex, 'ı') or starts-with($regex, 'u')">
                                <xsl:text>preceding,allograph,following,position,val,hand&#xA;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>preceding,allograph,following,position,hand&#xA;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="$tokenisés">
                            <xsl:variable name="position" select="position()"/>
                            <xsl:call-template name="csv_avec_pos">
                                <xsl:with-param name="tokenisé" select="."/>
                                <xsl:with-param name="regex" select="$regex"/>
                                <xsl:with-param name="main" select="$mains[$position]"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:result-document>
                </xsl:for-each>
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
                <xsl:for-each select="$regex">
                    <xsl:variable name="letter">
                        <xsl:value-of select="substring(.,1,1)"/>
                    </xsl:variable>
                    <xsl:result-document href="{$filename}_{$letter}.csv">
                        <xsl:text>preceding,allograph,following&#xA;</xsl:text>
                        <xsl:call-template name="csv_sans_pos">
                            <xsl:with-param name="tokenisé" select="$tokenisé"/>
                            <xsl:with-param name="regex" select="."/>
                        </xsl:call-template>
                    </xsl:result-document>
                    <xsl:result-document href="{$filename}_{$letter}_pos.csv">
                        <xsl:choose><!-- On teste pour voir quel entête faire -->
                            <xsl:when test="starts-with(., 'ı') or starts-with(., 'u')">
                                <xsl:text>preceding,allograph,following,position,val&#xA;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>preceding,allograph,following,position&#xA;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="csv_avec_pos">
                            <xsl:with-param name="tokenisé" select="$tokenisé"/>
                            <xsl:with-param name="regex" select="."/>
                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Règles modèles complémentaires servant à traiter les cas de u/v et i/j -->
    <!-- On triche, en insérant un symbole pourcentage après les lettres employées différemment de l'usage moderne -->
    <!-- C'est-à-dire, pas pour:
            tei:reg[. = 'j' and (following-sibling::tei:orig = 'ȷ')]
            tei:reg[. = 'j' and (following-sibling::tei:orig = 'J')] 
    -->
    <xsl:template
        match="
        tei:orig[. = 'u' and (preceding-sibling::tei:reg = 'v')] |
        tei:orig[. = 'v' and (preceding-sibling::tei:reg = 'u')] |
        tei:orig[. = 'V' and (preceding-sibling::tei:reg = 'u')] |
        tei:orig[. = 'ı' and (preceding-sibling::tei:reg = 'j')] |
        tei:orig[. = 'ȷ' and (preceding-sibling::tei:reg = 'i')] |
        tei:orig[. = 'J' and (preceding-sibling::tei:reg = 'i')]
        ">
        <xsl:value-of select="."/>
        <xsl:text>%</xsl:text>
    </xsl:template>
    

    <!-- Règles modèles nommées servant à produire les csv et à la tokénisation de niveau caractère -->
    <xsl:template name="csv_sans_pos">
        <xsl:param name="tokenisé"/>
        <xsl:param name="regex"/>
        <xsl:param name="main"/>
        <!-- On commence par retirer les % indésirables ici -->
        <xsl:variable name="tokenisé">
            <xsl:sequence select="$tokenisé/*[not(. = '%')]"/>
        </xsl:variable>
        <!-- et on continue sans rougir après ce hack odieux -->
        <xsl:for-each select="$tokenisé/*[matches(., $regex)]">
            <xsl:value-of select="preceding::text()[1]"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="following::text()[1]"/>
            <xsl:if test="$main">
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$main"/>
            </xsl:if>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="csv_avec_pos">
        <xsl:param name="tokenisé"/>
        <xsl:param name="regex"/>
        <xsl:param name="main"></xsl:param>
        <!-- Les affaires commencent -->
        <!-- Pour bien faire, il faudrait reverser tout le code redondant dans un autre template-->
        <xsl:choose>
            <xsl:when test="starts-with($regex, 'ı') or starts-with($regex, 'u')">
                <xsl:for-each select="$tokenisé/*[matches(., $regex)]">
                    <!-- On créé tout d'abord une variable qui va nous indiquer où trouver le caractère suivant -->
                    <xsl:variable name="posCaracSuiv" select="if (matches(following::text()[1], '%')) then 2 else 1"/>
                    <xsl:choose>
                        <xsl:when test="matches(preceding::text()[1], '%')">
                            <xsl:value-of select="preceding::text()[2]"/>
                        </xsl:when>
                        <xsl:when test="matches(preceding::text()[1], '§|\s')"/>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding::text()[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="matches(following::text()[$posCaracSuiv], '§|\s')"/>
                        <xsl:otherwise>
                            <xsl:value-of select="following::text()[$posCaracSuiv]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="preceding::text()[1] = '§' ">
                            <xsl:text>InitVers</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(preceding::text()[1], '\s') and matches(following::text()[$posCaracSuiv], '\s')">
                            <xsl:text>Seul</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(preceding::text()[1], '\s')">
                            <xsl:text>InitMot</xsl:text>
                        </xsl:when>
                        <xsl:when test="following::text()[$posCaracSuiv] = '§' ">
                            <xsl:text>FinVers</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(following::text()[$posCaracSuiv], '\s')">
                            <xsl:text>FinMot</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Med</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="matches(following::text()[1], '%')">
                            <xsl:choose>
                                <xsl:when test=". = 'u' ">
                                    <xsl:text>consonne</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'v'">voyelle</xsl:when>
                                <xsl:when test=". = 'V'">voyelle</xsl:when>
                                <xsl:when test=". = 'ı'">consonne</xsl:when>
                                <xsl:when test=". = 'ȷ'">voyelle</xsl:when>
                                <xsl:when test=". = 'J'">voyelle</xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test=". = 'u' ">
                                    <xsl:text>voyelle</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'v'">consonne</xsl:when>
                                <xsl:when test=". = 'V'">consonne</xsl:when>
                                <xsl:when test=". = 'ı'">voyelle</xsl:when>
                                <xsl:when test=". = 'ȷ'">consonne</xsl:when>
                                <xsl:when test=". = 'J'">consonne</xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$main">
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="$main"/>
                    </xsl:if>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- Sinon, on retire tous les pourcents indésirables -->
                <xsl:variable name="tokenisé">
                    <xsl:sequence select="$tokenisé/*[not(. = '%')]"/>
                </xsl:variable>
                <!-- Et on continue -->
                <xsl:for-each select="$tokenisé/*[matches(., $regex)]">
                    <xsl:if test="not(matches(preceding::text()[1], '§|\s'))">
                        <xsl:value-of select="preceding::text()[1]"/>
                    </xsl:if>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>,</xsl:text>
                    <xsl:if test="not(matches(following::text()[1], '§|\s'))">
                        <xsl:value-of select="following::text()[1]"/>
                    </xsl:if>
                    <xsl:text>,</xsl:text>
                    <xsl:choose>
                        <xsl:when test="preceding::text()[1] = '§' ">
                            <xsl:text>InitVers</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(preceding::text()[1], '\s') and matches(following::text()[1], '\s')">
                            <xsl:text>Seul</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(preceding::text()[1], '\s')">
                            <xsl:text>InitMot</xsl:text>
                        </xsl:when>
                        <xsl:when test="following::text()[1] = '§' ">
                            <xsl:text>FinVers</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(following::text()[1], '\s')">
                            <xsl:text>FinMot</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Med</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$main">
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="$main"/>
                    </xsl:if>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
