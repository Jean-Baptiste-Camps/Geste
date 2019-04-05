<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <!-- Serait possible de conserver certaines entités avec xsl:character-map -->
    
    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="sigle">
        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc[1]/child::element()[1]/@xml:id"/>
    </xsl:variable>
    
    <xsl:template match="node()|@*" mode="numerotation">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:l" mode="numerotation">
        <xsl:variable name="number" select="count(preceding::tei:l[not(@n)]) + 1">
            <!-- Removed because weird behavirou -->
            <!--<xsl:number format="1" level="single" from="tei:text" count="tei:l[not(@n)]"/>--><!-- On compte ceux qui ne sont pas numérotés, car une numérotation manuelle signifie qu'il y a un vers répété -->
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@n">
                <xsl:copy>
                    <xsl:attribute name="xml:id" select="concat($sigle, '_l_', @n)"/>
                    <xsl:apply-templates select="@*|node()" mode="numerotation"/>
                </xsl:copy>
            </xsl:when>
           <xsl:otherwise>
               <xsl:copy>
                   <xsl:attribute name="n" select="$number"/>
                   <xsl:attribute name="xml:id" select="concat($sigle, '_l_', $number)"/>
                   <xsl:apply-templates select="@*|node()" mode="numerotation"/>
               </xsl:copy>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- NB: je pense que, pour les éditions, l'option not rdg est nécessaire et not
    sic, sauf que ça dépend pour lesquelles: pas harmonisé. 
    À voir en détail.
    -->
    <!--<xsl:template match="tei:w[not(ancestor::tei:rdg or ancestor::tei:sic)]" mode="numerotation">-->
    <xsl:template match="tei:w" mode="numerotation">
        <xsl:variable name="number">
            <xsl:number format="000001" level="any" from="tei:text"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id" select="concat($sigle, '_w_',$number)"/>
            <xsl:apply-templates select="@*|node()" mode="numerotation"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="numerotation">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:choose>
                    <xsl:when test="preceding::tei:cb"><xsl:number count="tei:lb" from="tei:cb" level="any"/></xsl:when>
                    <xsl:otherwise><xsl:number count="tei:lb" from="tei:pb" level="any"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>