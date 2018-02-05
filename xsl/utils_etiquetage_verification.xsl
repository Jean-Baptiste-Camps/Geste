<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <!-- XSL pour vérifier la correction de l'étiquetage morphosyntaxique -->
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

<!-- TODO: ajouter un test pour l'accord du sujet et du verbe, au moins quand ils se suivent directement -->
<!-- NOMcom/VERinf, neutre VERinf pour les articles à enlever ; poi PROind pour Fier // les VERcjg, les VERinf précédés de au TOUT 
    en cours FL 14623
    -->
    <xsl:template match="/">
        <!-- Quelques vérifications générales -->
        <xsl:for-each-group select="descendant::tei:w" group-by="@lemma">
            <xsl:sort/>
            <!--<xsl:if
                test="count(distinct-values(current-group()/substring(tokenize(@type, ' ')[1], 20, 6))) > 1">-->
            <xsl:if
                    test="count(distinct-values(current-group()/substring-after(tokenize(@type, '\|')[1], 'POS='))) > 1">
                <xsl:text>Le lemme suivant a plusieurs catégories - </xsl:text>
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text>:</xsl:text>
                <xsl:for-each-group select="current-group()"
                    group-by="substring-after(tokenize(@type, '\|')[1], 'POS=')">
                    <xsl:sort/>
                    <xsl:value-of select="current-grouping-key()"/>
                    <xsl:text> </xsl:text>
                </xsl:for-each-group>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
        </xsl:for-each-group>

        <!-- Vérifications individuelles -->
        <xsl:apply-templates select="descendant::tei:w[@lemma != '']"/>
    </xsl:template>

    <xsl:template match="tei:w">
        <!-- Modifications pour aligner sur nouvel usage des @type. Si on réécrit la feuille pour fonctionner proprement
        avec les étiquettes préfixées, on pourra alléger.
        -->
        <!-- EDIT 18 octobre 2017: on passe à type maintenant -->
        <!--<xsl:variable name="anaBrut" select="tokenize(translate(@type, '#', ''), '\s+')"/>-->
        <xsl:variable name="ana" as="xs:string+">
            <xsl:for-each select="tokenize(@type, '\|')">
                <xsl:value-of select="substring-after(.,'=')"/>
            </xsl:for-each>
        </xsl:variable>
        <!--<xsl:variable name="ana" as="xs:string+">
            <xsl:for-each select="$anaBrut">
                <xsl:choose>
                    <xsl:when test="matches(., 'CATTEX2009_MS_')"><!-\- POS et flect. en MS-\->
                        <xsl:value-of select="substring-after(substring-after(., 'CATTEX2009_MS_'), '_')"/>
                    </xsl:when>
                    <xsl:otherwise/><!-\- Morphologie pure exclue -\->
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>-->
        <xsl:variable name="contenu">
            <xsl:apply-templates/>
        </xsl:variable>
        <!--<xsl:value-of select="$ana[1]"/>-->
        <xsl:choose>
            <!-- Je zappe la ponctuation, que je n'étiquette pas linguistiquement -->
            <!-- NB: ce premier test n'est pas obligatoire, vu qu'on va, de fait, tester les catégories ensuite -->
            <!-- <xsl:when test="not(
                $ana[1] = 'VERcjg' or
                $ana[1] = 'VERinf' or
                $ana[1] = 'VERppe' or
                $ana[1] = 'VERppa' or
                $ana[1] = 'NOMcom' or
                $ana[1] = 'NOMpro' or
                $ana[1] = 'ADJqua' or
                $ana[1] = 'ADJind' or
                $ana[1] = 'ADJcar' or
                $ana[1] = 'ADJord' or
                $ana[1] = 'ADJpos' or
                $ana[1] = 'PROper' or
                $ana[1] = 'PROper.PROper' or
                $ana[1] = 'PROimp' or
                $ana[1] = 'PROadv' or
                $ana[1] = 'PROpos' or
                $ana[1] = 'PROdem' or
                $ana[1] = 'PROind' or
                $ana[1] = 'PROcar' or
                $ana[1] = 'PROord' or
                $ana[1] = 'PROrel' or
                $ana[1] = 'PROrel.PROper' or
                $ana[1] = 'PROrel.PROadv' or
                $ana[1] = 'PROint' or
                $ana[1] = 'DETdef' or
                $ana[1] = 'DETndf' or
                $ana[1] = 'DETdem' or
                $ana[1] = 'DETpos' or
                $ana[1] = 'DETind' or
                $ana[1] = 'DETcar' or
                $ana[1] = 'DETrel' or
                $ana[1] = 'DETint' or
                $ana[1] = 'DETcom' or
                $ana[1] = 'ADVgen' or
                $ana[1] = 'ADVgen.PROper' or
                $ana[1] = 'ADVgen.PROadv' or
                $ana[1] = 'ADVneg' or
                $ana[1] = 'ADVneg.PROper' or
                $ana[1] = 'ADVint' or
                $ana[1] = 'ADVsub' or
                $ana[1] = 'PRE' or
                $ana[1] = 'PRE.DETdef' or
                $ana[1] = 'PRE.DETcom' or
                $ana[1] = 'PRE.DETrel' or
                $ana[1] = 'PRE.PROper' or
                $ana[1] = 'PRE.PROrel' or
                $ana[1] = 'CONcoo' or
                $ana[1] = 'CONsub' or
                $ana[1] = 'CONsub.PROper' or
                $ana[1] = 'INJ' or
                $ana[1] = 'RED' or
                $ana[1] = 'OUT'
                )">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: Erreur sur l'étiquette de catégorie/type&#xA;</xsl:text>
            </xsl:when>-->
            <xsl:when test="$ana[1] = 'VERcjg'">
                <!-- [3] – pst/ipf/ fut/psp : présent / imparfait / futur / passé simple
                    (cette catégorie est non pertinente pour les modes impératif et conditionnel, seuls le présent et l’imparfait sont pertinents pour le mode subjonctif) -->
                <xsl:choose>
                    <xsl:when test="$ana[2] = 'ind'">
                        <xsl:if
                            test="
                                not(
                                ($ana[3] = 'pst' or $ana[3] = 'ipf' or $ana[3] = 'fut' or $ana[3] = 'psp') and
                                ($ana[4] = '0' or $ana[4] = '1' or $ana[4] = '2' or $ana[4] = '3') and
                                ($ana[5] = 's' or $ana[5] = 'p')
                                )">
                            <xsl:value-of select="@xml:id"/>
                            <xsl:text>: Erreur sur la morphologie (</xsl:text>
                            <xsl:value-of select="@lemma"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="$ana[1]"/>
                            <xsl:text>) &#xA;</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$ana[2] = 'imp'">
                        <xsl:if
                            test="
                                not(
                                ($ana[3] = '1' or $ana[3] = '2') and
                                ($ana[4] = 's' or $ana[4] = 'p')
                                )">
                            <xsl:value-of select="@xml:id"/>
                            <xsl:text>: Erreur sur la morphologie (</xsl:text>
                            <xsl:value-of select="@lemma"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="$ana[1]"/>
                            <xsl:text>) &#xA;</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$ana[2] = 'con'">
                        <xsl:if
                            test="
                                not(
                                ($ana[3] = '0' or $ana[3] = '1' or $ana[3] = '2' or $ana[3] = '3') and
                                ($ana[4] = 's' or $ana[4] = 'p')
                                )">
                            <xsl:value-of select="@xml:id"/>
                            <xsl:text>: Erreur sur la morphologie (</xsl:text>
                            <xsl:value-of select="@lemma"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="$ana[1]"/>
                            <xsl:text>) &#xA;</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$ana[2] = 'sub'">
                        <xsl:if
                            test="
                                not(
                                ($ana[3] = 'pst' or $ana[3] = 'ipf') and
                                ($ana[4] = '0' or $ana[4] = '1' or $ana[4] = '2' or $ana[4] = '3') and
                                ($ana[5] = 's' or $ana[5] = 'p')
                                )">
                            <xsl:value-of select="@xml:id"/>
                            <xsl:text>: Erreur sur la morphologie (</xsl:text>
                            <xsl:value-of select="@lemma"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="$ana[1]"/>
                            <xsl:text>) &#xA;</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@xml:id"/>
                        <xsl:text>: Erreur sur la morphologie (</xsl:text>
                        <xsl:value-of select="@lemma"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="$ana[1]"/>
                        <xsl:text>) &#xA;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- s/p, n/r/- -->
            <!-- /!\ Je m'éloigne de Cattex2009 ici, en proposant de ne pas étiqueter les infinitifs (s'ils sont fléchis, c'est qu'ils sont substantivés… 
                donc pas de flexion en MS) -->
            <xsl:when test="$ana[1] = 'VERinf'">
                <!--<xsl:if test="not(
                    ($ana[2] = 's'  or $ana[2] = 'p' ) and
                    ($ana[3] = 'n'  or $ana[3] = 'r' or $ana[3] = '-')
                    )">-->
                <xsl:if test="$ana[2]">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- nombre, genre sans neutre, et cas -->
            <xsl:when
                test="
                    $ana[1] = 'VERppe' or
                    $ana[1] = 'NOMcom' or
                    $ana[1] = 'NOMpro' or
                    $ana[1] = 'DETdef' or
                    $ana[1] = 'PRE.DETdef' or
                    $ana[1] = 'DETndf' or
                    $ana[1] = 'DETdem' or
                    $ana[1] = 'DETind' or
                    $ana[1] = 'DETcar' or
                    $ana[1] = 'DETrel' or
                    $ana[1] = 'PRE.DETrel' or
                    $ana[1] = 'DETint' or
                    $ana[1] = 'DETcom' or
                    $ana[1] = 'PRE.DETcom'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p') and
                        ($ana[3] = 'm' or $ana[3] = 'f') and
                        ($ana[4] = 'n' or $ana[4] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- les mêmes, mais avec xxx pour les gérondifs -->
            <xsl:when test="
                    $ana[1] = 'VERppa'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = ('s', 'p', 'x')) and
                        ($ana[3] = ('m', 'f', 'x')) and
                        ($ana[4] = ('n', 'r', 'x'))
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>

            <!-- s/p, m/f/n, n/r -->
            <xsl:when
                test="
                    $ana[1] = 'ADJind' or
                    $ana[1] = 'ADJord'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p') and
                        ($ana[3] = 'm' or $ana[3] = 'f' or $ana[3] = 'n') and
                        ($ana[4] = 'n' or $ana[4] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- ADJqua: s/p, m/f/n, n/r, p/c/s -->
            <xsl:when test="$ana[1] = 'ADJqua'">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p') and
                        ($ana[3] = 'm' or $ana[3] = 'f' or $ana[3] = 'n') and
                        ($ana[4] = 'n' or $ana[4] = 'r') and
                        ($ana[5] = 'p' or $ana[5] = 'c' or $ana[5] = 's')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- s/p, m/f/n/-, n/r -->
            <xsl:when
                test="
                    $ana[1] = 'ADJcar' or
                    $ana[1] = 'PROdem' or
                    $ana[1] = 'PROind' or
                    $ana[1] = 'PROcar' or
                    $ana[1] = 'PROord'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p') and
                        ($ana[3] = 'm' or $ana[3] = 'f' or $ana[3] = 'n' or $ana[3] = '-') and
                        ($ana[4] = 'n' or $ana[4] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- 1/2/3, s/p, m/f/n, n/r -->
            <xsl:when test="$ana[1] = 'ADJpos'">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = '1' or $ana[2] = '2' or $ana[2] = '3') and
                        ($ana[3] = 's' or $ana[3] = 'p') and
                        ($ana[4] = 'm' or $ana[4] = 'f' or $ana[4] = 'n') and
                        ($ana[5] = 'n' or $ana[5] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- 1/2/3, s/p, m/f/n/-, n/r/i -->
            <xsl:when
                test="
                    $ana[1] = 'PROper' or
                    $ana[1] = 'PROper.PROper' or
                    $ana[1] = 'ADVgen.PROper' or
                    $ana[1] = 'ADVneg.PROper' or
                    $ana[1] = 'PRE.PROper' or
                    $ana[1] = 'CONsub.PROper'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = '1' or $ana[2] = '2' or $ana[2] = '3') and
                        ($ana[3] = 's' or $ana[3] = 'p') and
                        ($ana[4] = 'm' or $ana[4] = 'f' or $ana[4] = 'n' or $ana[4] = '-') and
                        ($ana[5] = 'n' or $ana[5] = 'r' or $ana[5] = 'i')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- PROimp: 0, S, N, n/r -->
            <xsl:when test="$ana[1] = 'PROimp'">
                <!-- modification : à l'origine $ana[3]= 'S' / enlèvement cap (LI) -->
                <xsl:if
                    test="
                        not(
                        ($ana[2] = '0') and
                        ($ana[3] = 's') and
                        ($ana[4] = 'n' or $ana[4] = 'r' or $ana[4] = 'i')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- Ø -->
            <xsl:when
                test="
                    $ana[1] = 'PROadv' or
                    $ana[1] = 'ADVgen.PROadv' or
                    $ana[1] = 'ADVneg' or
                    $ana[1] = 'ADVint' or
                    $ana[1] = 'ADVsub' or
                    $ana[1] = 'PRE' or
                    $ana[1] = 'CONcoo' or
                    $ana[1] = 'CONsub' or
                    $ana[1] = 'INJ' or
                    $ana[1] = 'RED' or
                    $ana[1] = 'OUT'
                    ">
                <xsl:if test="$ana[2]">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur un type sans morphologie attendue &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- 1/2/3, s/p, m/f/n/-, n/r -->
            <xsl:when test="$ana[1] = 'PROpos'">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = '1' or $ana[2] = '2' or $ana[2] = '3') and
                        ($ana[3] = 's' or $ana[3] = 'p') and
                        ($ana[4] = 'm' or $ana[4] = 'f' or $ana[4] = 'n' or $ana[4] = '-') and
                        ($ana[5] = 'n' or $ana[5] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- s/p/-, m/f/n/-, n/r/i/- -->
            <xsl:when
                test="
                    $ana[1] = 'PROrel' or
                    $ana[1] = 'PROrel.PROper' or
                    $ana[1] = 'PROrel.PROadv' or
                    $ana[1] = 'PRE.PROrel'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p' or $ana[2] = '-') and
                        ($ana[3] = 'm' or $ana[3] = 'f' or $ana[3] = 'n' or $ana[3] = '-') and
                        ($ana[4] = 'n' or $ana[4] = 'r' or $ana[4] = 'i')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- s/p/-, m/f/n/-, n/r/-  -->
            <xsl:when
                test="
                    $ana[1] = 'PROint' or
                    $ana[1] = 'PROcom'
                    ">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 's' or $ana[2] = 'p' or $ana[2] = '-') and
                        ($ana[3] = 'm' or $ana[3] = 'f' or $ana[3] = 'n' or $ana[3] = '-') and
                        ($ana[4] = 'n' or $ana[4] = 'r' or $ana[4] = '-')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- 1/2/3, s/p, m/f, n/r -->
            <xsl:when test="$ana[1] = 'DETpos'">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = '1' or $ana[2] = '2' or $ana[2] = '3') and
                        ($ana[3] = 's' or $ana[3] = 'p') and
                        ($ana[4] = 'm' or $ana[4] = 'f') and
                        ($ana[5] = 'n' or $ana[5] = 'r')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- p/c/s/- -->
            <xsl:when test="$ana[1] = 'ADVgen'">
                <xsl:if
                    test="
                        not(
                        ($ana[2] = 'p' or $ana[2] = 'c' or $ana[2] = 's' or $ana[2] = '-')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: Erreur sur la morphologie (</xsl:text>
                    <xsl:value-of select="@lemma"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$ana[1]"/>
                    <xsl:text>) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: Erreur sur l'étiquette de catégorie/type, </xsl:text>
                <xsl:value-of select="$ana"/>
                <xsl:text> &#xA;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Et j'insère ici une suite de tests plus spécifiques,
        qui ne vérifient pas que l'orthodoxie Cattex,
        mais testent également quelques erreurs courantes
        (liste non exhaustive)
        -->
        <xsl:choose>
            <!-- ajout PROimp ici (LI) -->
            <xsl:when test="@lemma = 'il'">
                <xsl:if test="not($ana[1] = 'PROper' or $ana[1] = 'PROimp')">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: 'il' est un pronom&#xA;</xsl:text>
                </xsl:if>
                <xsl:if
                    test="matches(
                        following::tei:w[1]/@type,'NOMcom')
                        ">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: 'il' devant un subst. (?)&#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@lemma = 'le'">
                <xsl:if test="$ana[1] != 'DETdef'">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: 'le' est un déterminant&#xA;</xsl:text>
                </xsl:if>
                <xsl:if
                    test="
                    not(matches(following::tei:w[1]/@type, 'NOM(com|pro)'))
                        and not(matches(following::tei:w[1]/@type, 'ADJ'))
                        and not(matches(following::tei:w[1]/@type, 'VERppe'))
                        and not(matches(following::tei:w[1]/@type, 'VERppa'))
                        and not(matches(following::tei:w[1]/@type, 'PRO(ind|car|pos|ord)'))
                        and not(following::tei:w[1]/@lemma = 'plus')
                        ">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: 'le' ne précède pas une forme nominale (ne serait-ce pas plutôt 'il' ?) &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@lemma = 'ne1' and $ana[1] != 'ADVneg'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'ne1' est ADVneg&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'ne2' and $ana[1] != 'CONcoo'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'ne2' est CONcoo&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'se' and $ana[1] != 'CONsub'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'se' est CONsub&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'si' and $ana[1] != 'ADVgen'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'si' est ADVgen&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'en1' and $ana[1] != 'PRE'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'en1' est PRE&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'en2' and $ana[1] != 'PROadv'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'en2' est PROadv&#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="@lemma = 'cant1' and not($ana[1] = ('ADVint', 'ADVsub', 'CONsub', 'ADVgen'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'cant1' (QUANDO) ou 'cant2' (QUANTUM) ?&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'cant2' and not(matches(@type, 'ind'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'cant1' (QUANDO) ou 'cant2' (QUANTUM) ?&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'que1|que4' and not($ana[1] = ('CONsub', 'ADVgen', 'RED'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'que1|que4' est CONsub (ou ADVgen dans dans la négation restrictive, ou RED)&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'que2|que3' and not($ana[1] = ('PROrel', 'PROint'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'que2|que3' est PROrel ou int&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'qui' and not($ana[1] = ('PROrel', 'PROint'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'qui' est PROrel ou int&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="matches(@type, 'VER') and not(matches(@lemma, 're?\d?$'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: lemme verbal bizarre, </xsl:text>
                <xsl:value-of select="@lemma"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="matches(@type, 'VERinf') and not(matches($contenu, 're?$'))">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: infinitif sans terminaison d'infinitif, </xsl:text>
                <xsl:value-of select="$contenu"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <!-- pronoms -->
            <xsl:when
                test="
                    @lemma = ('je', 'tu', 'il', 'soi1', 'nos1', 'vos1')
                    and
                    $ana[1] != 'PROper'
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: lemme de pronom et étiquette contradictoire&#xA;</xsl:text>
            </xsl:when>
            <!-- possessifs -->
            <xsl:when
                test="
                    @lemma = ('mon1', 'ton4', 'son4', 'mien', 'tuen', 'suen', 'nostre', 'vostre', 'lor2')
                    ">
                <xsl:if test="not(matches(@type, 'pos'))">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: lemme de possessif et étiquette contradictoire&#xA;</xsl:text>
                </xsl:if>
                <xsl:if test="@lemma = ('mon1', 'ton4', 'son4') and $ana[1] != 'DETpos'">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: article possessif qui n'est pas DETpos&#xA;</xsl:text>
                </xsl:if>
                <xsl:if
                    test="@lemma = ('mien', 'tuen', 'suen') and not($ana[1] = ('PROpos', 'ADJpos'))">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: adjectif possessif qui n'est pas ADJpos ou PROpos&#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when
                test="
                    @lemma = 'mais1' and
                    $ana[1] = 'CONcoo'
                    and not(. is preceding::tei:pc[@type = 'supplied'][1]/following::tei:w[1]
                    or . is ancestor::tei:q/descendant::tei:w[1]
                    or . is ancestor::tei:l/descendant::tei:w[1]
                    )
                    ">
                <!-- TODO: étendre à toutes les CONsub ? À affiner quand on aura l'analyse de la syntaxe -->
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'mais1' CONcoo qui n'est pas en tête de proposition &#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="
                    @lemma = 'qui' and (tokenize(preceding::tei:w[1]/@type, ' ')[1] = '#PRE'
                    or $ana[3] = ('r', 'i')
                    )
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'qui' pour 'cui' ? &#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="
                    @lemma = 'que2|que3' and
                    $ana[4] = ('m', 'f')
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'que' pour 'qui' ? &#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'on' and $ana[1] != 'PROind'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'on' qui n'est pas PROind (?) &#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="@lemma = 'ome' and $ana[1] != 'NOMcom'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'ome' qui n'est pas NOMcom (?) &#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="
                    @lemma = ('tot', 'trestot') and matches(following::tei:w[1]/@type, 'DET')
                    and $ana[1] != 'DETind'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: 'tot' prédéterminant qui n'est pas étiqueté comme tel (?)&#xA;</xsl:text>
            </xsl:when>

        </xsl:choose>
        <!-- Tests fondés sur les catégories, toujours pour traquer des erreurs fréquentes -->
        <xsl:choose>
            <xsl:when
                test="
                    $ana[1] = 'PRE' and
                    (matches(following::tei:w[1]/@type, 'VERcjg')
                    or
                    matches(following::tei:w[1]/@type, 'CON')
                    or
                    matches(following::tei:w[1]/@type, 'PRE')
                    )
                    ">
                <!-- Je retire
                    or 
                matches(following::tei:w[1]/@type, 'ADV') 
                => préposition devant un adverbe ne me paraît pas un problème (souplesse des prépositions/adverbes en AF)
                -->
                <xsl:if
                    test="
                        not(
                        @lemma = ('tresque1', 'desque', 'jesque')
                        and matches(following::tei:w[1]/@lemma, '(a3|en1)')
                        )">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: PRE devant un </xsl:text>
                    <xsl:value-of select="tokenize(following::tei:w[1]/@type, ' ')[1]"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when
                test="
                    $ana[1] = 'PROadv' and
                    not(matches(following::tei:w[1]/@type, 'VER'))
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: PROadv devant un </xsl:text>
                <xsl:value-of select="tokenize(following::tei:w[1]/@type, ' ')[1]"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="
                    matches(@type, 'DET') and (not(@lemma = ('tot', 'trestot'))) and
                    $ana[1] != 'DETcar'
                    and matches(following::tei:w[1]/@type, 'DET')
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: deux déterminants qui se suivent &#xA;</xsl:text>
            </xsl:when>
            <xsl:when
                test="
                    matches(@type, 'PRO') and matches(following::tei:w[1]/@type, 'NOM(com|pro)') and ./ancestor::tei:l is following::tei:w[1]/ancestor::tei:l
                    and not($ana[1] = 'PROrel')
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: PRO devant un substantif (?) &#xA;</xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- Et maintenant quelques tests sur la flexion, pour terminer (à développer) -->
        <xsl:choose>
            <!-- PRONOMS -->
            <xsl:when
                test="
                    (($ana[1] = 'PROper' and not($ana[5] = 'i')) or ($ana[1] = 'PROrel' and not($ana[4] = 'i')))
                    and matches(preceding::tei:w[1]/@type, 'PRE')
                    ">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$ana[1]"/>
                <xsl:text> à droite d'une préposition qui n'est pas au CRI (?) &#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="matches($ana[1], 'PROper')">
                <xsl:if
                    test="
                        ($ana[2] = '1' and $ana[3] = 's' and not(@lemma = 'je')) or
                        ($ana[2] = '2' and $ana[3] = 's' and not(@lemma = 'tu')) or
                        ($ana[2] = '1' and $ana[3] = 'p' and not(@lemma = 'nos1')) or
                        ($ana[2] = '2' and $ana[3] = 'p' and not(@lemma = 'vos1')) or
                        ($ana[2] = '3' and not(@lemma = 'soi1' or matches(@lemma, 'il')))
                        ">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: contradiction entre personne et lemme &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- POSSESSIFS -->
            <xsl:when test="matches($ana[1], 'pos')">
                <xsl:if
                    test="
                        ($ana[2] = '1' and not(@lemma = ('mon1', 'mien', 'nostre'))) or
                        ($ana[2] = '2' and not(@lemma = ('ton4', 'tuen', 'vostre'))) or
                        ($ana[2] = '3' and not(@lemma = ('son4', 'suen', 'lor2')))
                        ">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: contradiction entre personne et lemme &#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- ACCORD DU GROUPE NOMINAL -->
            <xsl:when
                test="
                    (matches($ana[1], 'DET') and matches(following::tei:w[1]/@type, '(DET|ADJ|NOM|VERppe)')
                    or matches($ana[1], 'ADJ') and matches(following::tei:w[1]/@type, 'NOM(com|pro)')
                    or matches($ana[1], 'DET|NOM') and matches(following::tei:w[1]/@type, 'ADJ')
                    or matches($ana[1], 'DET|NOM') and matches(following::tei:w[1]/@type, 'VERppa') and not(matches(following::tei:w[1]/@type, '_x\s'))
                    )
                    and ./ancestor::tei:l is following::tei:w[1]/ancestor::tei:l">
                <!-- JBC: todo, maintenant qu'on étiquette ça plus proprement avec
                le nom de chaque étiquette morphologique
                -->
                <xsl:variable name="followingWanaBrut"
                    select="
                        if (matches(following::tei:w[1]/@type, '(ADJ|PRO|DET)pos'))
                        then
                            tokenize(following::tei:w[1]/@type, '\|')[position() != 2]
                        else
                            tokenize(following::tei:w[1]/@type, '\|')
                        "/>
                <xsl:variable name="followingWana" as="xs:string+">
                    <xsl:for-each select="$followingWanaBrut">
                        <!--<xsl:choose>
                            <xsl:when test="matches(., 'CATTEX2009_MS_')"><!-\- POS et flect. en MS-\->
                                <xsl:value-of select="substring-after(substring-after(., 'CATTEX2009_MS_'), '_')"/>
                            </xsl:when>
                            <xsl:otherwise/><!-\- Morphologie pure exclue -\->
                        </xsl:choose>-->
                        <xsl:value-of select="substring-after(., '=')"/>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:if
                    test="not(deep-equal($ana[position() > 1 and position() &lt; 5], $followingWana[position() > 1 and position() &lt; 5]))">
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: problème d'accord dans un groupe nominal, </xsl:text>
                    <xsl:copy-of select="$ana[position() > 1 and position() &lt; 5]"/>
                    <xsl:text>: </xsl:text>
                    <xsl:copy-of select="$followingWana[position() > 1 and position() &lt; 5]"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- ACCORD DU VERBE -->
            <xsl:when
                test="$ana[1] = 'VERppa' and preceding::tei:w[1]/@lemma = 'en1' and not($ana[position() > 1 and position() &lt; 5] = 'x')">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>: les gérondifs ne sont pas fléchis &#xA;</xsl:text>
            </xsl:when>
            <!-- TODO: je désactive pour l'instant ce test qu'il faudra refaire quand on aura les q, et, encore mieux, quand on aura la syntaxe -->
            <!--<xsl:when test="$ana[1] = 'VERcjg'">
                <xsl:variable name="monContexte" select="if (ancestor::tei:q) then ancestor::tei:q else ancestor::tei:l"/>
                <xsl:variable name="maPonctSuiv" select="following::tei:pc[@type='supplied'][1]"/><!-\- TODO: à améliorer, quand on aura la syntaxe -\->
                <xsl:variable name="maPonctPréc" select="preceding::tei:pc[@type='supplied'][1]"/>
                <xsl:variable name="monMot" select="."/>
                <xsl:variable name="nombreEtPers" select="if ($ana[2] = ('imp', 'con') ) then $ana[position() > 2] else $ana[position() > 3]"/>
                <xsl:variable name="sujets" select="
                    preceding::tei:w[matches(@type, '(NOM|PROper).*#(f|m|n)\s+#n') 
                    and (ancestor::tei:q is $monContexte or ancestor::tei:l is $monContexte)  
                    and following::tei:w[matches(@type, 'VERcjg')][1] is $monMot
                    and following::tei:pc[@type='supplied'][1] is $maPonctSuiv
                    ][1]
                    | 
                    following::tei:w[matches(@type, '(NOM|PROper).*#(f|m|n)\s+#n') 
                    and (ancestor::tei:q is $monContexte or ancestor::tei:l is $monContexte)
                    and preceding::tei:w[matches(@type, 'VERcjg')][1] is $monMot 
                    and preceding::tei:pc[@type='supplied'][1] is $maPonctPréc
                    ][1]
                    "/>
                <xsl:for-each select="$sujets"><!-\- un nom appelle la plupart du temps une troisième personne… (va créer du bruit en raison de l'apostrophe) -\->
                    <xsl:variable name="followingWana" select="
                        if (matches(@type, 'PRO')) 
                        then tokenize(translate(@type, '#', ''), '\s+')[position() > 1]
                        else ('3', tokenize(translate(@type, '#', ''), '\s+')[position() > 1])
                        "/>
                    <xsl:if test="not( deep-equal($nombreEtPers, $followingWana[position() &lt; 3]))">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:text>: problème d'accord d'un verbe (?), </xsl:text>
                        <xsl:copy-of select="$nombreEtPers"/><xsl:text>, </xsl:text> <xsl:apply-templates select="$monMot/child::node()"/>
                        <xsl:text>: </xsl:text>
                        <xsl:copy-of select="$followingWana[ position() &lt; 3]"/><xsl:text>, </xsl:text> <xsl:apply-templates select="./child::node()"/>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:if>
                    
                </xsl:for-each>
                
            </xsl:when>-->
        </xsl:choose>

    </xsl:template>
    <!-- 
                
                
                
                $ana[1] = 'PROint' or
                $ana[1] = 'PROcom' or -->

    <!-- Message d'erreur type
     <xsl:value-of select="@xml:id"/>
     <xsl:text>: Erreur sur … &#xA;</xsl:text>
    -->

    <xsl:template match="tei:abbr"/>
    <xsl:template match="tei:expan">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:orig"/>
    <xsl:template match="tei:corr"/>
    <!--<xsl:template match="tei:expan | tei:ex | tei:reg | tei:hi">-->
    <xsl:template match="tei:ex | tei:reg | tei:hi">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:note"/>

</xsl:stylesheet>
