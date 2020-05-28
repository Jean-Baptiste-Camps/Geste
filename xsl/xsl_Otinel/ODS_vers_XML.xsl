<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    exclude-result-prefixes="office table text" version="1.0">
    <!-- Simple stylesheet to export Open Document Spreadsheets into XML with first row 
        (column names) used as tag names -->
    <!-- N.B. that the column names (in the first row) have to be valid XML names… -->
    <xsl:output indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <ooo_calc_export scriptVersion="0.1" scriptUpdate="2016-01-17" scriptAuthor="jbc">
            <!-- treat only tables that have one row of content (colnames excepted) -->
            <xsl:apply-templates select="descendant::table:table[table:table-row[2]]"/>
        </ooo_calc_export>
    </xsl:template>

    <xsl:template match="table:table">
        <xsl:element name="{@table:name}">
            <!-- process all rows except the first -->
            <xsl:apply-templates select="table:table-row[preceding-sibling::table:table-row]"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table:table-row">
        <xsl:element name="row">
            <xsl:attribute name="n">
                <xsl:value-of select="position()"/>
            </xsl:attribute>
            <xsl:apply-templates select="table:table-cell"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table:table-cell">
        <!-- retrieve the name from the first row containing column names -->
        <!-- it is not as straightforward as it should be, because, to gain space, sequential indentical columns 
            are  kept under one single element in the source file with a @table:number-columns-repeated attribute,
        so, we have to iterate.
        -->
        <!-- Do not iterate over an empty cell -->
        <xsl:choose>
            <xsl:when test=". = ''"/>
            <xsl:otherwise>
                <xsl:call-template name="makeCell">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="iterate" select="@table:number-columns-repeated"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="makeCell">
        <xsl:param name="i"/>
        <xsl:param name="iterate"/>
        <xsl:variable name="position"
            select="position() + sum(preceding-sibling::table:table-cell/@table:number-columns-repeated) - count(preceding-sibling::table:table-cell[@table:number-columns-repeated]) + ($i - 1)"/>
        <xsl:variable name="name"
            select="
                ancestor::table:table/child::table:table-row[1]/child::table:table-cell[
                (
                not(@table:number-columns-repeated)
                and
                (position() + sum(preceding-sibling::table:table-cell/@table:number-columns-repeated) - count(preceding-sibling::table:table-cell[@table:number-columns-repeated])) = $position
                )
                or
                (
                @table:number-columns-repeated and (position() + sum(preceding-sibling::table:table-cell/@table:number-columns-repeated) - count(preceding-sibling::table:table-cell[@table:number-columns-repeated]) + @table:number-columns-repeated - 1) >= $position
                )
                ]"/>
        <xsl:element name="{$name}">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:if test="$iterate and ($i &lt; $iterate)">
            <xsl:call-template name="makeCell">
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="iterate" select="$iterate"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
