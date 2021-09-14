<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="POS_file" select="
        concat('../tag/', 
        substring-before(tokenize(base-uri(), '/')[last()], '.xml'), '.tsv')"/>
    
    <xsl:variable name="myTSV" select="unparsed-text($POS_file)"/>
    
    <xsl:variable name="myDoc">
        <!-- Turn it into xml -->
        <xsl:call-template name="XMLify">
            <xsl:with-param name="tsv" select="$myTSV"></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
    
<!--    <xsl:template match="/">
        <xsl:apply-templates/>        
    </xsl:template>-->
    
    
    <xsl:template name="XMLify">
        <xsl:param name="tsv"/>
        
        <xsl:variable name="myLines" select="tokenize($tsv, '\n')"/>
        <doc>
            <xsl:for-each select="$myLines">
                <xsl:if test="normalize-space(.) != '' ">
                    <xsl:variable name="myVals" select="tokenize(., '\t')"/>
                    <token>
                        <lemma><xsl:copy-of select="$myVals[2]"/></lemma>
                        <pos><xsl:copy-of select="$myVals[3]"/></pos>
                        <morph><xsl:copy-of select="$myVals[4]"/></morph>
                    </token>
                </xsl:if>
            </xsl:for-each>
        </doc>
    </xsl:template>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:w | tei:pc">
        <xsl:variable name="w_position">
            <xsl:number count="tei:w | tei:pc" from="tei:body" level="any"/>
        </xsl:variable>
        <!--<xsl:variable name="w_count" select="preceding::tei:w | preceding::tei:pc"/>-->
        
        <xsl:copy>
            <xsl:attribute name="lemma" select="$myDoc/doc/token[position() = $w_position]/lemma"/>
            <xsl:attribute name="pos" select="$myDoc/doc/token[position() = $w_position]/pos"/>
            <xsl:attribute name="msd" select="$myDoc/doc/token[position() = $w_position]/morph"/>
            
            <xsl:apply-templates select="@*[local-name() != ('lemma', 'pos', 'msd')] | node()"/>
        </xsl:copy>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>