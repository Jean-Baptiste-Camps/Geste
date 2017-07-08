<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xhtml tei"
    version="2.0">
    
    <xsl:output encoding="UTF-8" omit-xml-declaration="yes" indent="no" method="xhtml"         doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html;charset=UTF8"/>
            </head>
            <body style="font-family:'Junicode'">
                <xsl:apply-templates/>
            </body>
        </html>
        
    </xsl:template>
    

    <xsl:template match="tei:lg">
        <br/><b><xsl:value-of select="@n"/></b>
        <!--<table>-->
        <xsl:apply-templates/>
        <!--</table>-->
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
<!--    <xsl:template match="tei:l">
        <tr>
            <td>
                <b><xsl:call-template name="lb"/></b>
            </td>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>-->

<!-- Sans numéros de page-->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:cb">
        <b>[<xsl:value-of select="@n"/>]</b>
    </xsl:template>
    
<!--Avec numéros de page -->
  <!--  <xsl:template name="lb">
        <xsl:variable name="ndepage">
            <xsl:number count="tei:lb" level="any"/>
        </xsl:variable>
        <xsl:if test="$ndepage mod 4 = 0">
            <xsl:value-of select="$ndepage"/>
        </xsl:if>
    </xsl:template>-->
    
    <xsl:template match="tei:unclear">
        <a style="text-decoration:underline">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:note">
        [[<xsl:apply-templates/>]]
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:text>[...]</xsl:text>
    </xsl:template>
    
    <xsl:template match="/tei:TEI/tei:teiHeader"/>
    
    <xsl:template match="//tei:choice/tei:reg"/>
    
    <xsl:template match="//tei:choice/tei:expan"/>
    
<!-- Pour obtenir le contraire   -->
    
<!--    <xsl:template match="//tei:choice/tei:orig"/>
    
    <xsl:template match="//tei:choice/tei:abbr"/>-->
    
    <xsl:template match="tei:corr">
        [<xsl:apply-templates/>]
    </xsl:template>
    
    <xsl:template match="tei:sic">
        &lt;<xsl:apply-templates/>&gt;
    </xsl:template>
    
    <xsl:template match="//tei:ex">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="//tei:add[@place='above']">
        <sup><xsl:apply-templates/></sup>
    </xsl:template>
    
    <xsl:template match="//tei:add[@place='margin']">
       <xsl:text>**</xsl:text><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:pc[@type='supplied']"/>
    
</xsl:stylesheet>