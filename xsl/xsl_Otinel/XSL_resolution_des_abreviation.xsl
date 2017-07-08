<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    version="2.0">
    <!--<xsl:output method="text"/>-->
    <xsl:output omit-xml-declaration="yes"/>
    <!-- Pour l'instant, la feuille envoie des matériaux assez bruts.
    Pour la raffiner, il faudrait différencier selon la flexion, pour les noms, pronoms, verbes, …
    -->
    
    <xsl:template match="/">
        <xsl:variable name="arborescenceAbbr">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="arborescenceExpan">
            <xsl:apply-templates mode="resolution"/>
        </xsl:variable>
        <!-- Ici, las, on va devoir faire du style monotemplatesque avec des for-each-group (tris) -->
        <xsl:for-each-group select="$arborescenceAbbr/descendant::tei:w" group-by="@lemma">
            <xsl:sort select="lower-case(current-grouping-key())"/>
            <!-- Le lemme est-il abrégé -->
            <xsl:if test="current-group()[descendant::tei:abbr]">
            <xsl:variable name="monGroupe" select="current-group()"/>
                <!--<xsl:value-of select="current-grouping-key()"/>-->
                <!--<xsl:copy-of select="$monGroupe"></xsl:copy-of>-->
            <xsl:choose>
                <!-- Est-il jamais résolu? -->
                <xsl:when test="not(current-group()[not(descendant::tei:abbr)])">
                    <xsl:text>\dag{}\textbf{</xsl:text>
                    <xsl:value-of select="current-grouping-key()"/>
                    <xsl:text>} : </xsl:text>
                    <xsl:call-template name="tableauFormes">
                        <xsl:with-param name="groupe" select="current-group()"/>
                        <xsl:with-param name="arborescenceExpan" select="$arborescenceExpan"/>
                    </xsl:call-template>
                    <!-- Call template affichant les formes et leurs vers -->
                    <xsl:text>&#xA;&#xA;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!-- N'y a-t-il qu'une seule forme résolue? -->
                    <xsl:choose>
                        <xsl:when test="count(distinct-values(current-group()[not(descendant::tei:abbr)])) = 1">
                            <!-- Si oui, correspond-elle à la résolution proposée? -->
                            <xsl:variable name="resolutionFautive">
                                <xsl:call-template name="findErrors">
                                    <xsl:with-param name="arborescenceExpan" select="$arborescenceExpan"/>
                                    <xsl:with-param name="groupe" select="$monGroupe"/>
                                    <xsl:with-param name="referenceForm" select="distinct-values($monGroupe[not(descendant::tei:abbr)])"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="count($resolutionFautive/erreur) > 0">
                                <xsl:text>\textbf{</xsl:text>
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text>}: </xsl:text>
                                <xsl:text> RÉSOLUTIONS FAUTIVES : </xsl:text>
                                <xsl:value-of select="$resolutionFautive/erreur" separator=", "/>
                                <xsl:call-template name="tableauFormes">
                                    <xsl:with-param name="groupe" select="$monGroupe"/>
                                    <xsl:with-param name="arborescenceExpan" select="$arborescenceExpan"/>
                                </xsl:call-template>
                                <xsl:text>&#xA;&#xA;</xsl:text>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- S'il y en a plusieurs, l'une est-elle majoritaire? -->
                            <xsl:variable name="resolutionsConcurrentes">
                            <xsl:for-each-group select="current-group()[not(descendant::tei:abbr)]" group-by=".">
                                <groupeResol>
                                <xsl:copy-of select="current-group()"/>
                                </groupeResol>
                            </xsl:for-each-group>
                            </xsl:variable>
                            <!--<xsl:text>max(count($resolutionsConcurrentes/groupeResol)) : </xsl:text>
                            <xsl:value-of select="max($resolutionsConcurrentes/groupeResol/count(child::tei:w))"/>
                            <xsl:text> $resolutionsConcurrentes/groupeResol/count(child::element()) : </xsl:text>
                            <xsl:value-of select="$resolutionsConcurrentes/groupeResol/count(child::tei:w)"/>-->
                            <!--<xsl:text>FORME de REF: </xsl:text>
                            <xsl:value-of select="distinct-values($resolutionsConcurrentes/groupeResol[count(child::tei:w) = max($resolutionsConcurrentes/groupeResol/count(child::tei:w)) ]/tei:w)"/>-->
                            <xsl:choose>
                                <!-- Si oui, 
                                    les résolutions correspondent-elles à la forme majoritaire ?-->
                                <xsl:when test="
                                    count($resolutionsConcurrentes/groupeResol[count(child::tei:w) = max($resolutionsConcurrentes/groupeResol/count(child::tei:w) ) ])  
                                    = 1
                                    ">
                                   <xsl:text>*\textbf{</xsl:text>
                                   <xsl:value-of select="current-grouping-key()"/>
                                   <xsl:text>} : </xsl:text>
                                    <xsl:variable name="resolutionFautive">
                                        <xsl:call-template name="findErrors">
                                            <xsl:with-param name="referenceForm" select="distinct-values($resolutionsConcurrentes/groupeResol[count(child::tei:w) = max($resolutionsConcurrentes/groupeResol/count(child::tei:w)) ]/tei:w)"/>
                                            <xsl:with-param name="groupe" select="$monGroupe"/>
                                            <xsl:with-param name="arborescenceExpan" select="$arborescenceExpan"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:if test="count($resolutionFautive/erreur) > 0">
                                        <xsl:text> RÉSOLUTIONS FAUTIVES : </xsl:text>
                                        <xsl:value-of select="$resolutionFautive/erreur" separator=", "/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Si non, on regarde ça-->
                                    <xsl:text>**\textbf{</xsl:text>
                                    <xsl:value-of select="current-grouping-key()"/>
                                    <xsl:text>} : </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:call-template name="tableauFormes">
                                <xsl:with-param name="arborescenceExpan" select="$arborescenceExpan"/>
                                <xsl:with-param name="groupe" select="$monGroupe"/>
                            </xsl:call-template>
                            <xsl:text>&#xA;&#xA;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:if>
        </xsl:for-each-group>
    
    </xsl:template>
    
    <xsl:template name="tableauFormes">
        <xsl:param name="groupe"/>
        <xsl:param name="arborescenceExpan"/>
        <xsl:text>\textit{formes résolues}  </xsl:text>
        <xsl:choose>
            <xsl:when test="$groupe[not(descendant::tei:abbr)]">
                <xsl:call-template name="comptageFormesParCat">
                    <xsl:with-param name="groupe" select="$groupe[not(descendant::tei:abbr)]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> ø.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> -- \textit{formes abrégées} </xsl:text>
        <xsl:call-template name="comptageFormesParCat">
            <xsl:with-param name="groupe" select="$groupe[descendant::tei:abbr]"/>
        </xsl:call-template>
        <xsl:text> --  \textit{résol.} </xsl:text>
        <xsl:for-each select="$groupe[descendant::tei:abbr]">
            <xsl:variable name="monId" select="@xml:id"/>
            <xsl:value-of select="$arborescenceExpan/descendant::tei:w[@xml:id = $monId]"/>
            <xsl:text>, </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="comptageFormesParCat">
        <xsl:param name="groupe"/>
        <!-- TODO: il ne faut pas utiliser un choose, car un lemme peut avoir plusieurs
        catégories différentes
        -->
        <!--<xsl:choose>-->
            <xsl:if test="$groupe[matches(@ana, '#VER')]">
                <xsl:call-template name="comptageVerbes">
                    <xsl:with-param name="groupe" select="$groupe"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$groupe[
                matches(@ana, '(#NOM|PRO(per|pos|dem|ind|car|ord|rel|int|com)|ADJ|DET)') 
                ]">
                <xsl:call-template name="comptageNom">
                    <xsl:with-param name="groupe" select="$groupe"/>
                </xsl:call-template>
            </xsl:if>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$groupe[not(matches(@ana, '#VER'))
                        and not(matches(@ana, '(#NOM|PRO(per|pos|dem|ind|car|ord|rel|int|com)|ADJ|DET)'))
                        ]"/>
                </xsl:call-template>
        <!--</xsl:choose>-->
    </xsl:template>
    
    <xsl:template name="comptageNom">
        <xsl:param name="groupe"/>
            <xsl:if test="$groupe[matches(@ana, '#s\s+#(m|f|n)\s+#n')]">
                <xsl:text>CSS, </xsl:text>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#s\s+#(m|f|n)\s+#n')]"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$groupe[matches(@ana, '#s\s+#(m|f|n)\s+#r')]">
                <xsl:text>CRS, </xsl:text>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#s\s+#(m|f|n)\s+#r')]"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$groupe[matches(@ana, '#p\s+#(m|f|n)\s+#n')]">
                <xsl:text>CSP, </xsl:text>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#p\s+#(m|f|n)\s+#n')]"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$groupe[matches(@ana, '#p\s+#(m|f|n)\s+#r')]">
                <xsl:text>CRP, </xsl:text>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#p\s+#(m|f|n)\s+#r')]"/>
                </xsl:call-template>
            </xsl:if>
    </xsl:template>
    
    <xsl:template name="comptageVerbes">
        <xsl:param name="groupe"/>
        <xsl:if test="$groupe[matches(@ana, '#VERinf')]">
            <xsl:text>Inf. </xsl:text>
            <xsl:call-template name="comptageFormes">
                <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#VERinf')]"/>
            </xsl:call-template>
        </xsl:if>
        <!-- ana="#VERcjg #ind #pst #3 #s " -->
        <xsl:for-each-group select="$groupe" group-by="tokenize(@ana, ' ')[2]">
            <xsl:choose>
                <xsl:when test="current-grouping-key() = '#ind'">
                    <xsl:text>Ind.,</xsl:text>
                </xsl:when>
                <xsl:when test="current-grouping-key() = '#imp'">
                    <xsl:text>Imp., </xsl:text>
                </xsl:when>
                <xsl:when test="current-grouping-key() = '#con'">
                    <xsl:text>Cond., </xsl:text>
                </xsl:when>
                <xsl:when test="current-grouping-key() = '#sub'">
                    <xsl:text>Subj., </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <!-- On traite d'abord les modes qui se subdivisent en temps -->
                <xsl:when test="current-grouping-key() = '#ind' or current-grouping-key() = '#sub'">
                    <xsl:for-each-group select="current-group()" group-by="tokenize(@ana, ' ')[3]">
                        <xsl:choose>
                            <xsl:when test="current-grouping-key() = '#pst'">
                                <xsl:text> prés. </xsl:text>
                            </xsl:when>
                            <xsl:when test="current-grouping-key() = '#ipf'">
                                <xsl:text> imparf. </xsl:text>
                            </xsl:when>
                            <xsl:when test="current-grouping-key() = '#fut'">
                                <xsl:text> fut. </xsl:text>
                            </xsl:when>
                            <xsl:when test="current-grouping-key() = '#psp'">
                                <xsl:text> parf. </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:call-template name="makeVerbalTable">
                            <xsl:with-param name="groupe" select="current-group()"/>
                            <xsl:with-param name="personne" select="4"/>
                            <xsl:with-param name="nombre" select="5"/>
                        </xsl:call-template>
                    </xsl:for-each-group>
                </xsl:when>
                <!-- puis les autres -->
                <xsl:when test="current-grouping-key() = '#imp' or current-grouping-key() = '#con' ">
                    <xsl:call-template name="makeVerbalTable">
                        <xsl:with-param name="groupe" select="current-group()"/>
                        <xsl:with-param name="personne" select="3"/>
                        <xsl:with-param name="nombre" select="4"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each-group>
        <xsl:if test="$groupe[matches(@ana, '#VERppe')]">
            <xsl:text>Part. p. </xsl:text>
            <xsl:call-template name="comptageNom">
                <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#VERppe')]"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[matches(@ana, '#VERppa[^x]+')]">
            <xsl:text>Part. p. </xsl:text>
            <xsl:call-template name="comptageNom">
                <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#VERppa[^x]')]"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[matches(@ana, '#VERppa.*#x')]">
            <xsl:text> forme inv. </xsl:text>
            <xsl:call-template name="comptageFormes">
                <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#VERppa.*#x')]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="makeVerbalTable">
        <xsl:param name="groupe"/>
        <xsl:param name="personne" as="xs:integer"/>
        <xsl:param name="nombre" as="xs:integer"/>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#s']">
            <xsl:text>P1, </xsl:text>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
                    </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#s']">
        <xsl:text>P2, </xsl:text>
        <xsl:call-template name="comptageFormes">
            <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
        </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#s']">
        <xsl:text>P3, </xsl:text>
        <xsl:call-template name="comptageFormes">
            <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
        </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#p']">
        <xsl:text>P4, </xsl:text>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#p']"/>                        
                    </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#p']">
        <xsl:text>P5, </xsl:text>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#p']"/>
                    </xsl:call-template>
        </xsl:if>
        <xsl:if test="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#p']">
        <xsl:text>P6, </xsl:text>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#p']"/>
                    </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="comptageFormes">
        <xsl:param name="groupe"/>
        <xsl:for-each-group select="$groupe" group-by=".">
            <xsl:sort select="count(current-group())" order="descending"/>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text> (</xsl:text>
            <xsl:if test="count(current-group()) > 10">
                <xsl:value-of select="count(current-group())"/>
                <xsl:text> occurr.: </xsl:text>
            </xsl:if>
            <xsl:value-of select="current-group()/ancestor::tei:l/@n" separator=", "/>
            <xsl:text>)</xsl:text>
            <xsl:choose>
                <xsl:when test="position() = last()"><xsl:text>; </xsl:text></xsl:when>
                <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="findErrors">
        <xsl:param name="groupe"/>
        <xsl:param name="arborescenceExpan"/>
        <xsl:param name="referenceForm"/>
        <xsl:for-each-group select="$groupe[descendant::tei:abbr]" group-by=".">
            <xsl:variable name="monId" select="@xml:id"/>
            <xsl:if test=" $arborescenceExpan/descendant::tei:w[@xml:id = $monId]
                != $referenceForm">
                <erreur>
                    <xsl:value-of select="current-grouping-key()"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="count(current-group())"/>
                    <xsl:text>) </xsl:text>
                </erreur>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    
    <!-- Normalisations (TODO: à mettre en facteur commun avec feuille XSL_tableaux-verbaux) -->
    <!-- Normalisations  avec abréviations -->
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:choice" mode="#all">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <!--<xsl:template match="tei:abbr"/>-->
    <xsl:template match="tei:orig" mode="#all"/>
    <xsl:template match="tei:corr" mode="#all"/>
    <!--<xsl:template match="tei:expan | tei:ex | tei:reg | tei:hi">-->
    <xsl:template match="tei:ex | tei:reg | tei:hi" mode="#all">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template match="tei:note" mode="#all"/>
    <xsl:template match="tei:del" mode="#all"/>
    
    
    <xsl:template match="tei:expan" mode="#default"/>
    <!-- Normalisations  avec résolution -->
    <xsl:template match="tei:abbr" mode="resolution"/>
    
    <xsl:template match="tei:expan" mode="resolution">
        <xsl:apply-templates mode="resolution"/>
    </xsl:template>
    
    
</xsl:stylesheet>