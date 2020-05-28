<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:import href="workflow_numerotation.xsl"/>
    
    <!-- TODO: intégrer les remarques faites dans la feuille d'annotation
    sous une forme <note type="annotation"> ?
    -->
    
    <!-- Je modifie pour utiliser @pos et @msd (MàJ de la TEI) - TODO: à tester -->
    
    <xsl:variable name="POS_file" select="
        concat('../tag/', 
        tokenize(base-uri(), '/')[last()])"/>
    
    <xsl:variable name="POS" select="document($POS_file)"/>
    
    <!-- Modification pour numéroter 
        et intégrer les
        pos en une seule compilation
    -->
    <xsl:template match="/">
        <xsl:variable name="docNum">
            <xsl:apply-templates mode="numerotation"/>
        </xsl:variable>
        <xsl:apply-templates select="$docNum/node()"/>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:w">
        <xsl:variable name="monID" select="@xml:id"/>
        <xsl:variable name="mesPOS" select="$POS//row[ID = $monID]"/>
        <xsl:variable name="maPOS" select="$mesPOS/PPOS"/>
        <xsl:variable name="maMorph">
            <xsl:for-each select="$mesPOS/(MODE|TEMPS|PERS.|NOMB.|GENRE|CAS|DEGRÉ)[. != '']">
                <!--<xsl:text>#</xsl:text>
                <xsl:text>CATTEX2009_MS_</xsl:text>-->
                <xsl:choose>
                    <xsl:when test="local-name(.) ='DEGRÉ'">
                        <xsl:text>DEGRE=</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="local-name()"/>
                        <xsl:text>=</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                <xsl:text>|</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="monAna">
            <xsl:if test="$mesPOS/PPOSM[. != '']">
                <xsl:text>#</xsl:text>
                <xsl:text>CATTEX2009_M_</xsl:text>
                <xsl:value-of select="$mesPOS/PPOSM"/>
            </xsl:if>
            <xsl:if test="$mesPOS/flectM[. != '']"><!-- Passons à la flexion en morphologie. On ne l'intègre que si elle diffère de celle en MS. -->
                <xsl:variable name="mesFlectMS" select="$mesPOS/(MODE|TEMPS|PERS.|NOMB.|GENRE|CAS|DEGRÉ)[. != '']"/>
                <xsl:variable name="mesFlectM" select="tokenize($mesPOS/flectM, '\|')"/>
                <xsl:for-each select="$mesFlectM">
                    <xsl:variable name="maPosition" select="position()"/>
                    <xsl:if test=". != $mesFlectMS[$maPosition]">
                        <xsl:text> #</xsl:text>
                        <xsl:text>CATTEX2009_M_</xsl:text>
                        <xsl:value-of select="$mesFlectMS[$maPosition]/local-name()"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <!-- TODO: insérer traitement pour les cas où étiquette M plus longue que MS
                TODO: [BUG] le code suivant ne fonctionnera pas pour les cas où l'étiquette pos M diffère trop 
                nettement de la pos MS (adj employé comme adverbe, etc.) => il faut compléter de manière systématique
                -->
                <xsl:if test="count($mesFlectM) > count($mesFlectMS)">
                    <xsl:choose>
                        <xsl:when test="$mesPOS/PPOSM = 'ADJqua' and $mesPOS/PPOS != 'ADJqua'">
                            <xsl:text> #</xsl:text>
                            <xsl:text>CATTEX2009_M_</xsl:text>
                            <xsl:text>DEGRE</xsl:text>
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="$mesFlectM[last()]"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
            <!--<xsl:for-each select="$mesPOS/(NOMB.-M|CAS-M|flect_M)">
                <xsl:text> </xsl:text>
                <xsl:text>#M:</xsl:text>
                <xsl:value-of select="."/>
            </xsl:for-each>-->
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="lemma" select="normalize-space(normalize-unicode($mesPOS/PLEMMA, 'NFC'))"/>
            <xsl:attribute name="pos" select="normalize-space(normalize-unicode($maPOS, 'NFC'))"/>
            <xsl:attribute name="msd" select="normalize-space(normalize-unicode($maMorph, 'NFC'))"/>
            <xsl:if test="$monAna != ''">
                <xsl:attribute name="ana" select="normalize-space(normalize-unicode($monAna, 'NFC'))"/>
            </xsl:if>
            <xsl:apply-templates select=" node() |  @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>