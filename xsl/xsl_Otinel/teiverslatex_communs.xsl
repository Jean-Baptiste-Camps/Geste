<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Règles modèles communes de la transformation TEI vers LaTeX -->
    <!-- TODO: template lacunaStart? -->
    
    <xsl:template match="ab">
        \pausenumbering
        <xsl:apply-templates/>
        \resumenumbering
    </xsl:template>
    
    <xsl:template match="lg">
        \pstart[ \subsection*{<xsl:value-of select="@n"/>}]
        \noindent <xsl:apply-templates/>
        <xsl:text>\pend&#xA;</xsl:text>
    </xsl:template>
    
    <!-- Structuration physique -->
    
    <!--    TO DO: ne marche pas (flottant)-->
    <xsl:template match="gb">
        <xsl:text>\ledrightnote{[cah.\,</xsl:text><xsl:value-of select="@n"/>
        <xsl:text>, </xsl:text>
        <xsl:choose>
            <xsl:when test="following::cb"><xsl:value-of select="following::cb[1]/@n"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="following::pb[1]/@n"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text>]}</xsl:text>
    </xsl:template>
    <xsl:template match="pb">
        <xsl:if test="not(following::cb) and not(. is preceding::gb[1]/following::pb[1])">
        <xsl:text>\ledrightnote{[</xsl:text><xsl:value-of select="@n"/><xsl:text>]}</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="cb">
        <xsl:if test="not(. is preceding::gb[1]/following::cb[1])">
                <xsl:text>\ledrightnote{[</xsl:text><xsl:value-of select="@n"/><xsl:text>]}</xsl:text>
            </xsl:if>
    </xsl:template>
    <xsl:template match="lb">
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
   
   <!-- APPARAT ET NOTES --> 
    <!-- Représentation de la source -->
    <xsl:template match="gap[ancestor::w]" mode="#default lemme">
        <xsl:if test="@unit='char'">
            <xsl:value-of select="for $i in 1 to @quantity
                return '.'
                "/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="gap[not(ancestor::w)]">
        <xsl:choose>
            <xsl:when test="@unit='fol'">
                <!--<xsl:text>\skipnumbering \dots \dots \dots \dots</xsl:text>-->
            </xsl:when>
            <xsl:when test="@unit='char'">
                <xsl:variable name="quantite">
                    <xsl:choose>
                        <xsl:when test="@min and @max">
                            <xsl:value-of select="(@min + @max) div 2 "/>
                        </xsl:when>
                        <xsl:when test="@quantity">
                            <xsl:value-of select="@quantity"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="for $i in 1 to $quantite
                    return '.'
                    "/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>\edtext{}{\lemma{</xsl:text>
        <xsl:apply-templates mode="lemme" select="preceding::w[1]"/>
        <xsl:text> \dots </xsl:text>
        <xsl:apply-templates mode="lemme" select="following::w[1]"/>
        <xsl:if test="ancestor::l/@n != following::w[1]/ancestor::l/@n">
            <xsl:text> \textit{(v.~</xsl:text>
            <xsl:value-of select="following::w[1]/ancestor::l/@n"/>
            <xsl:text>)} </xsl:text>
        </xsl:if>
        <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>
        <xsl:text>}\Afootnote{</xsl:text>
        <xsl:choose>
            <xsl:when test="@quantity">
                <xsl:value-of select="@quantity"/>
            </xsl:when>
            <xsl:when test="@min and @max">
                <xsl:text> \textit{entre} </xsl:text> <xsl:value-of select="@min"/>
                <xsl:text> \textit{et} </xsl:text> <xsl:value-of select="@max"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="@unit='char'"><xsl:text>\textit{car. non transcrit</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>}</xsl:text></xsl:when>
            <xsl:when test="@unit='fol'"><xsl:text>\textit{fol. manquant</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>}</xsl:text></xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@reason='illegible'"><xsl:text> (\textit{illisibles</xsl:text><xsl:if  test="@quantity > 1"><xsl:text>s</xsl:text></xsl:if><xsl:text>})</xsl:text></xsl:when>
            <xsl:when test="@reason='damage'"> (\textit{dégât matériel})</xsl:when>
            <xsl:when test="@reason='lacuna'"> (\textit{lacune matérielle})</xsl:when>
        </xsl:choose>
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="gap" mode="note">
        <xsl:value-of select="for $i in 1 to @quantity
            return '.'
            "/>
    </xsl:template>
    
    <xsl:template match="handShift">
        <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
        <xsl:apply-templates select="following::w[1]" mode="lemme"/>
        <xsl:text>}\Bfootnote{</xsl:text>
        <xsl:text>début de la copie d'</xsl:text>
        <xsl:value-of select="substring-after(@new, '#')"/>
        <xsl:text>}} </xsl:text>
    </xsl:template>
    
    <!--Notes de commentaire-->
    <!--    Pour l'instant, un seul étage géré-->
    <!--    Not the more elegant way, but needed if we want
    a line-number-->
    <!-- À terme, ajouter une règle qui aille chercher, comme lemme, le mot vers l'@xml:id duquel pointe la référence contenue dans la note -->
        <xsl:template match="note">
                    <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
                    <xsl:apply-templates select="preceding::w[1]" mode="lemme"/>
                    <xsl:text>}\Bfootnote{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}} </xsl:text>  
    </xsl:template>
    <!-- Règles différentes pour les notes contenues dans des mots, pour ne pas imbriquer des notes -->
    <xsl:template match="note[ancestor::w]"/>
    <xsl:template match="note[ancestor::w]" mode="note"/>
    <xsl:template match="note[ancestor::w]" mode="commentaire">
        <xsl:text>\Bfootnote{</xsl:text>
        <xsl:apply-templates mode="#default"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="unclear[not(ancestor::w) and descendant::w]">
        <xsl:apply-templates select="node()[not(local-name(.) = 'note') and not(@type = 'palaeographic') ]"/><!-- sauf les notes, que l'on veut intégrer à celle que l'on est en train de créer -->
        <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
        <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
        <xsl:choose>
            <xsl:when test="count(descendant::w) = 2">
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
            <xsl:when test="count(descendant::w) > 2">
                <xsl:text> \dots{} </xsl:text>
                <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="tokenize(ancestor::l/@xml:id, '_')[1] = 'M'">
            <xsl:text> \textit{M}</xsl:text>
        </xsl:if>
        <xsl:text>}\Afootnote{</xsl:text>
        <xsl:text> \textit{lecture difficile}</xsl:text>
        <xsl:choose>
            <xsl:when test="@reason ='damage' ">
                <xsl:text> \textit{(dégât matér.)}</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="child::note[@type='palaeographic']">
            <xsl:text>, \textit{</xsl:text>
            <xsl:apply-templates select="note[@type='palaeographic']/node()"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:text>}} </xsl:text>
    </xsl:template>
    
   <xsl:template match="emph|title">
       <xsl:text>\textit{</xsl:text>
       <xsl:apply-templates/>
       <xsl:text>}</xsl:text>
   </xsl:template>
    <xsl:template match="mentioned">
        <xsl:text>\emph{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="ref">
        <xsl:text>\ref{</xsl:text>
        <xsl:value-of select="@target"/>
        <xsl:text>}, p.~\pageref{</xsl:text>
        <xsl:value-of select="@target"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    
</xsl:stylesheet>