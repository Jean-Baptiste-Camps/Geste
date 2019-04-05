<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:ti="http://chs.harvard.edu/xmlns/cts" exclude-result-prefixes="xs tei ti" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="myURI">
        <xsl:value-of select="tokenize(base-uri(), '/')[position() != last()]" separator="/"/>
        <xsl:text>/?select=*.xml</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="myCollection" select="collection($myURI)"/>
    
    
    <xsl:template match="/">
        <!-- Do not forget the textgroup description ! -->
        
        <xsl:result-document href="../nemo-data/geste/__cts__.xml">
            <!-- 
                The urn of the textgroup node must contains only the urn up to the textgroup component
            -->
            <ti:textgroup xmlns:ti="http://chs.harvard.edu/xmlns/cts" urn="urn:cts:froLit:geste">
                <!-- 
                    Groupname is the name of the textgroup. 
                    There needs to be at least one groupname node, with a clear lang declaration. 
                    One groupname at least is required.
                -->
                <ti:groupname xml:lang="fr">Geste</ti:groupname>
                <!--<ti:groupname xml:lang="lat">Marcus Valerius Martialis</ti:groupname>-->
            </ti:textgroup>
        </xsl:result-document>
        
        
        
        <xsl:for-each-group select="$myCollection" group-by="/tei:TEI/@corresp">
            
            <!-- Create the work descriptor -->
            <xsl:result-document href="../nemo-data/geste/{current-grouping-key()}/__cts__.xml">
                
                <ti:work xmlns:ti="http://chs.harvard.edu/xmlns/cts" groupUrn="urn:cts:froLit:geste"
                    urn="urn:cts:froLit:geste.{current-grouping-key()}" xml:lang="fro">
                    <!-- To supply a title, we take the first main title of the first doc.
                        But, would be cleaner to get it from querying Jonas
                    -->
                    <ti:title xml:lang="fre">
                        <xsl:value-of
                            select="current-group()[1]/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main']"
                        />
                    </ti:title>
                    <!-- And now a node by document -->
                    <!-- 
                        For each "text", either edition, translation, or commentary, 
                        there should be a ti:edition, ti:translation, or ti:commentary node
                        
                        The edition nodes has two attributes :
                        - The first one, workUrn, contains only the urn up to the work component
                        - The second, urn, contains the full urn
                    -->
                    <xsl:for-each select="current-group()">
                        <ti:edition workUrn="urn:cts:froLit:geste.{current-grouping-key()}"
                            urn="urn:cts:froLit:geste.{current-grouping-key()}.{tei:TEI/@xml:id}">
                            <!-- 
                                Edition, Translation, and Commentary must have at least one label node.
                                Label represents the title of the edition.
                                Label node needs xml:lang declaration, it reflects the language of the title.
                            -->
                            <xsl:apply-templates mode="metadata"
                                select="tei:TEI/tei:teiHeader/tei:fileDesc"/>
                        </ti:edition>
                    </xsl:for-each>
                </ti:work>
            </xsl:result-document>
            
            <!-- And now, treat each document -->
            
            <xsl:for-each select="current-group()">
                <xsl:result-document href="../nemo-data/geste/{current-grouping-key()}/geste.{current-grouping-key()}.{tei:TEI/@xml:id}.xml">
                    <xsl:apply-templates/>
                </xsl:result-document>
            </xsl:for-each>
            
        </xsl:for-each-group>
        
    </xsl:template>
    
    
    <!-- Metadata mode -->
    
    <xsl:template match="tei:fileDesc" mode="metadata">
        <ti:label xml:lang="fre">
            <!-- TODO: improve that -->
            <xsl:apply-templates select="tei:titleStmt" mode="metadata"/>
        </ti:label>
        <!--
            Edition, Translation, and Commentary must have at least one description node.
            Description node needs xml:lang declaration, it reflects the language of the description.
        -->
        <ti:description xml:lang="fre">
            <xsl:apply-templates select="tei:sourceDesc" mode="metadata"/>
        </ti:description>
    </xsl:template>
    
    <xsl:template match="tei:title[@type='main']" mode="metadata">
        <xsl:apply-templates mode="metadata"/>
        <xsl:text>: </xsl:text>
    </xsl:template>
    
    
    
    <xsl:template match="tei:editor" mode="metadata">
        <xsl:if test="not(preceding-sibling::element()[1]/local-name() = 'editor')">
            <xsl:text>, éd. par </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="metadata"/>
        <xsl:text>, </xsl:text>
    </xsl:template>
    
    <!--<xsl:template mode="metadata" match="tei:titleStmt">
        
        
        </xsl:template>
        
        <xsl:template match="tei:sourceDesc"></xsl:template>-->
    
    
    <!-- Default mode -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:copy>
            <xsl:apply-templates select="@* | tei:fileDesc"/>
            <encodingDesc>
                <refsDecl n="CTS">
                    <!-- JBC: removing word level indexing with CapiTainS for performance -->
                    <!--<cRefPattern 
                        n="mot"
                        matchPattern="(\w+)(\w+)"
                        replacementPattern="#xpath(/tei:TEI/tei:text/tei:body//tei:l[@n='$1']//tei:w[@xml:id='$2'])">
                        <p>Ce pointeur extrait les mots</p>
                        </cRefPattern>-->
                    <cRefPattern 
                        n="vers"
                        matchPattern="(\w+)"
                        replacementPattern="#xpath(/tei:TEI/tei:text/tei:body//tei:l[@n='$1'])">
                        <p>Ce pointeur extrait les vers</p>
                    </cRefPattern>
                </refsDecl>
            </encodingDesc>
            <!-- TODO: improve that from ODD model -->
            <xsl:apply-templates select="tei:profileDesc | tei:revisionDesc"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:text">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:base" select="
                concat('urn:cts:froLit:geste.', 
                ancestor::tei:TEI/@corresp,
                '.',
                ancestor::tei:TEI/@xml:id)
                "></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>
