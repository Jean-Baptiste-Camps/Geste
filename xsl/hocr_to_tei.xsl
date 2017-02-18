<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xhtml"
    version="2.0">
    <!-- TODO: modifier pour conserver les informations <facsimile/> pour les transcriptions de manuscripts -->
    <!-- Quelques post-traitements qui sont pour l'instant faits par rechercher et remplacer et qu'il conviendrait d'intégrer ici:
    remplacer
    \n(\s*<lb/>\d*\s*GUI DE BOURGOGNE.\s+[\d\-]+)\n 
    par
    \n<! - - $1 - - >\n
    
    (et quelques autres)
    
    Détection des items des sommaires
    
    Détection des lg
    remplacer
    \n<lb/>(« )?([A-ZÉÈÔÀ]{2,})
    par 
    </lg>\n<lg type="laisse" n="">\n<lb/>$1$2
    
    Détection des vers
    remplacer
    \n<lb/>([^\n]*)
    par 
    \n<lb/><l>$1</l>
    -->
    
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="../ODD/out/Modele.rng" 
    type="application/xml"  schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="../ODD/out/Modele.rng" 
    type="application/xml"  schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title></title>
                        <respStmt xml:id="JBC">
                            <resp>sous la direction de</resp>
                            <persName>Jean-Baptiste Camps</persName>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt></publicationStmt>
                    <sourceDesc></sourceDesc>
                </fileDesc>
                <profileDesc>
                    <creation>
                        <origPlace cert="" resp=""></origPlace>
                        <origDate cert="" resp=""></origDate>
                    </creation>
                    <langUsage>
                        <language cert="" resp="" ident="" usage=""></language>
                    </langUsage>
                </profileDesc>
                <revisionDesc>
                    <change who="JBC" when="">Création du gabarit, transformation du fichier hocr en TEI et segmentation.</change>
                </revisionDesc>
            </teiHeader>
            <!-- Je laisse pour l'instant de côté le facsimile, dans la mesure où le système de coordonnées d'ocropus diffère de celui proposé par la TEI -->
            <!--<facsimile>
                <xsl:apply-templates mode="facsimile"/>
            </facsimile>-->
            <text>
                <front></front>
                <body>
                    <xsl:apply-templates
                    select="xhtml:html/xhtml:body"/>
                </body>
                <back></back>
            </text>
        </TEI>
    </xsl:template>
    
    <!--<xsl:template mode="facsimile" match="xhtml:div">
        <surface>
            <graphic>
                <xsl:attribute name="url" select="concat('facsimile', substring-after(@title, ' book/'))"/>
                <xsl:attribute name="xml:id" select="concat('page', substring-before(substring-after(@title, ' book/'), '.bin.png'))"/>
            </graphic>
            <xsl:apply-templates mode="facsimile"/>
        </surface>
    </xsl:template>-->
    <!--<xsl:template mode="facsimile" match="xhtml:span">
        <xsl:variable name="coord" select="tokenize(substring-after(@title, 'bbox '), ' ')"/>
        <zone>
            
        </zone>
    </xsl:template>-->
    
    <xsl:template match="xhtml:div">
        <pb facs="{concat('facsimile', substring-after(@title, ' book/'))}" n="{substring-before(substring-after(@title, ' book/'), '.bin.png')}"/>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xhtml:span">
        <lb/><xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
