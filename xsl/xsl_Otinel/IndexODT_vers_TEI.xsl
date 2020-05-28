<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs text"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
        <xsl:strip-space elements="*"/>
        
        <xsl:template match="/">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Title</title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Publication Information</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <div type="index">
                            <listPerson>
                                <xsl:apply-templates/>
                            </listPerson>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:template>
    
    
    <xsl:template match="text:p[@text:style-name='P1' and child::text:span[@text:style-name='T1'] ]">
        <person>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="text:span[@text:style-name='T1']"/>
            </xsl:attribute>
            <persName>
                <xsl:apply-templates select="text:span[@text:style-name='T1']"/>
            </persName>
            <desc>
                <xsl:apply-templates/>
            </desc>
        </person>
    </xsl:template>
    
    <xsl:template match="text:p[@text:style-name='P1' and not(child::text:span[@text:style-name='T1']) ]">
        
            <xsl:choose>
                <xsl:when test="matches(., '^\w+\s+(A|V|M|P)`s+')">
                    <xsl:variable name="sigle">
                        <xsl:analyze-string select="." regex="^\w+\s+(A|V|M|P)`s+">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <witDetail>
                        <xsl:apply-templates/>
                    </witDetail>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                    <xsl:apply-templates/>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>