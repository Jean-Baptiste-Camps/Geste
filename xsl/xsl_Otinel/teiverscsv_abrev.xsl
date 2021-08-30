<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="no" method="text"/>
    <xsl:include href="teiverscsv_fonctions.xsl"/>
    
    <xsl:variable name="aDesCb">
        <xsl:choose>
            <xsl:when test="/descendant::tei:cb"><xsl:copy-of select="1"/></xsl:when>
            <xsl:otherwise><xsl:copy-of select="0"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="aDesGb">
        <xsl:choose>
            <xsl:when test="/descendant::tei:gb"><xsl:copy-of select="1"/></xsl:when>
            <xsl:otherwise><xsl:copy-of select="0"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:text>,nbAbrev,nbCaracAttendu,nbAllogr,nbJambages,posDsMot1re,posDsMotDern,posDsLigne,posLigneDsPage,posPageDsCahier&#xA;</xsl:text>
        <xsl:apply-templates select="descendant::tei:w[not(ancestor::tei:corr)]"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tei:w[not(ancestor::tei:corr) and not(ancestor::tei:del) and not(ancestor::tei:add)]">
        <xsl:variable name="valeurTextuelle"><!-- Forme résolue -->
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="valeurTextuelleTokenisee">
            <xsl:call-template name="_tokenize-characters">
                <xsl:with-param name="string" select="$valeurTextuelle"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="caracTotal"><!-- Forme constatée -->
            <xsl:call-template name="_tokenize-characters">
                <xsl:with-param name="string">
                    <xsl:apply-templates mode="orig"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="caracTotal" select="$caracTotal/node()[not(normalize-space(.) = '')]"/>
        
        <!-- pour débugage -->
<!--            <xsl:text>ValText</xsl:text>
        <xsl:value-of select="$valeurTextuelle"/>
        <xsl:text>ValTextTokenizee</xsl:text>
        <xsl:value-of select="$valeurTextuelleTokenisee"/>-->
        <xsl:number 
            count="tei:w[not(ancestor::tei:corr)  and not(ancestor::tei:del) and not(ancestor::tei:add)]" 
            from="tei:body" level="any" format="000001"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="count(descendant::tei:abbr)"/>
        <xsl:text>,</xsl:text>
        <!-- Nombre de caractères de la forme résolue (attendue) -->
        <xsl:value-of select="count($valeurTextuelleTokenisee/node())"/>
        <xsl:text>,</xsl:text>
        <!-- Nombre d'allographes minoritaires, en fréquence relative à la forme constatée -->
        <!-- Traitements très spécifiques, car la définition varie d'un ms. (et d'une main) à un autre -->
        <xsl:choose>
            <xsl:when test="ancestor::tei:Tei/descendant::tei:msDesc/@xml:id='M'">
                <xsl:value-of select="
                    count(descendant::tei:orig[. = 'a' or . = 'B' or . = 'ꝺ' or . = 'D' or . = 'E' or . = 'G' or . = 'ȷ' or . = 'J' or . = 'L' or . = 'M' or . = 'N' or . = 'ꝛ' or . = 'R' or . = 's' or . = '' or . = '' or . = 'v'])
                    div count($caracTotal/node())
                    "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="
                    count(descendant::tei:orig[. = 'ɑ' or .= 'B' or .=  'd' or .=  'D' or .=  'E' or .=  'G' or .=  'ȷ' or .=  'J' or .=  'L' or .=  'M' or .=  'N' or .=  'ꝛ' or .=  'R' or .=  's' or .=  '' or .=  '' or .=  'v'])
                    div count($caracTotal/node())
                    "/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
        <!-- Nombre de jambages, en fréquence relative à la forme résolue attendue -->
        <xsl:value-of select="
           ( (count($valeurTextuelleTokenisee/token[.='m']) * 3)  +
            (count($valeurTextuelleTokenisee/token[.='n']) * 2)  +
            (count($valeurTextuelleTokenisee/token[.='u']) * 2 ) +
            (count($valeurTextuelleTokenisee/token[.='v']) * 2 ) +
            count($valeurTextuelleTokenisee/token[.='ı']) +
            count($valeurTextuelleTokenisee/token[.='i']) )
            div count($valeurTextuelleTokenisee/node())
            "/><!-- ı et i à cause des possibles résolutions d'abréviation. 
            On prend le parti de compter aussi v.
            -->
        <xsl:text>,</xsl:text>
        <!-- position dans le mot de la première abréviation et de la dernière --><!-- C'est un peu moche, mais avec un raisonnement "par mot", c'est à peu près le mieux qu'on puisse faire -->
        <xsl:choose>
            <!-- Cas des abréviations de niveau mot, par contraction ou suspension: position arbitrairement définie comme 0.5 -->
            <xsl:when test="count(child::node()[not(normalize-space(.) = '')]) = 1 and (tei:choice/tei:abbr | tei:hi/tei:choice/tei:abbr)"><!-- Ou: and descendant::tei:abbr, pour éviter les bugs surprise -->
                <xsl:value-of select="0.5"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="0.5"/>
            </xsl:when>
            <!-- Autres cas -->
            <xsl:when test="count(child::node()[not(normalize-space(.) = '')]) > 1 and descendant::tei:abbr">
                <xsl:variable name="idPremAbbr" select="generate-id(descendant::tei:abbr[1])"/>
                <xsl:variable name="caracPreced">
                   <xsl:choose>
                       <!-- Cas où l'abréviation débute le mot: on ne crée pas de nœud -->
                       <xsl:when 
                           test=
                           "not(descendant::text()[not(normalize-space(.) = '') and generate-id(following::tei:abbr[1]) = $idPremAbbr and not(ancestor::tei:expan) and not(ancestor::tei:corr) and not(ancestor::tei:note) and not(ancestor::tei:add)])"/>
                           <!--child::node()[not(normalize-space(.) = '')][1][(local-name(.) = 'choice' and child::tei:abbr) or (local-name(.) = 'hi' and child::tei:choice/tei:abbr)]"/>-->
                       <xsl:otherwise>
                           <xsl:call-template name="_tokenize-characters">
                               <xsl:with-param name="string">
                                   <xsl:apply-templates select="node()[generate-id(following::tei:abbr[1]) = $idPremAbbr]"/>
                               </xsl:with-param>
                           </xsl:call-template>
                       </xsl:otherwise>
                   </xsl:choose>
                </xsl:variable>
                <xsl:variable name="caracPreced" select="$caracPreced/node()[not(normalize-space(.) = '')]"/>
                <!-- débugage: -->
               <!-- <xsl:text>PRECED:</xsl:text>
                <xsl:value-of select="$caracPreced"/>
                <xsl:text>TOTAL:</xsl:text>
                <xsl:value-of select="$caracTotal"/>-->
                <xsl:value-of select="(count($caracPreced/node()) + 1) div  count($caracTotal/node())"/>
                <xsl:text>,</xsl:text><!-- et la position de la dernière -->
               <xsl:choose>
                   <!-- cas où il n'y a qu'une seule abréviation, on copie la même valeur -->
                   <xsl:when test="count(descendant::tei:abbr) = 1">
                       <xsl:value-of select="(count($caracPreced/node()) + 1) div  count($caracTotal/node())"/>
                   </xsl:when>
                   <xsl:when test="count(descendant::tei:abbr) > 1">
                       <xsl:variable name="idDernAbbr" select="generate-id(descendant::tei:abbr[last()])"/>
                       <xsl:variable name="caracSuiv">
                           <xsl:choose>
                               <!-- Cas où l'abréviation finit le mot: on ne crée pas de nœud -->
                               <xsl:when 
                                   test=
                                   "not(descendant::text()[not(normalize-space(.) = '') and not(. = '&#769;' or .='&#775;') and generate-id(preceding::tei:abbr[1]) = $idDernAbbr and not(ancestor::tei:expan) and not(ancestor::tei:corr) and not(ancestor::tei:note) and not(ancestor::tei:add)])"/>
                               <xsl:otherwise>
                                   <xsl:call-template name="_tokenize-characters">
                                       <xsl:with-param name="string">
                                           <xsl:apply-templates select="node()[generate-id(preceding::tei:abbr[1]) = $idDernAbbr]"/>
                                       </xsl:with-param>
                                   </xsl:call-template>
                               </xsl:otherwise>
                           </xsl:choose>
                       </xsl:variable>
                       <xsl:variable name="caracSuiv" select="$caracSuiv/node()[not(normalize-space(.) = '')]"/>
                       <xsl:value-of select="(count($caracTotal/node()) - count($caracSuiv/node())) div  count($caracTotal/node())"/>
                   </xsl:when>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>,</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
        <!-- Position dans la ligne -->
        <xsl:variable name="quantieme">
            <xsl:number count="tei:w[not(ancestor::tei:corr)]" from="tei:lb" level="any"/>    
        </xsl:variable>
        <xsl:value-of select="$quantieme div count(ancestor::tei:l/descendant::tei:w[not(ancestor::tei:corr)])"/>
        <xsl:text>,</xsl:text>
        <!-- Position ligne dans la page -->
        <xsl:variable name="quantieme">
            <xsl:choose>
                <xsl:when test="$aDesCb = 1">
                    <xsl:number count="tei:lb" from="tei:cb" level="any"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number count="tei:lb" from="tei:pb" level="any"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$aDesCb = 1">
                <xsl:variable name="idPb" select="generate-id(preceding::tei:cb[1])"/>
                <xsl:value-of select="$quantieme div count(preceding::tei:cb[1]/following::tei:lb[generate-id(preceding::tei:cb[1]) = $idPb])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="idPb" select="generate-id(preceding::tei:pb[1])"/>
                <xsl:value-of select="$quantieme div count(preceding::tei:pb[1]/following::tei:lb[generate-id(preceding::tei:pb[1]) = $idPb])"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,</xsl:text>
        <!-- position page dans le cahier -->
        <xsl:if test="$aDesGb = 1">
            <xsl:variable name="quantieme">
                <xsl:number count="tei:pb" from="tei:gb" level="any"/>    
            </xsl:variable>
            <xsl:variable name="idGb" select="generate-id(preceding::tei:gb[1])"/>
            <xsl:value-of select="$quantieme div count(preceding::tei:gb[1]/following::tei:pb[generate-id(preceding::tei:gb[1]) = $idGb])"/>
        </xsl:if>
        <!-- À faire plus tard: lemme et étiquette POS -->
        <xsl:text>&#xA;</xsl:text>
        
    </xsl:template>
    
    
    <!-- Au cas où, on supprime quelques éléments indésirés -->
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:gap"/>
    <xsl:template match="tei:space"/>
    <xsl:template match="tei:corr"/>
    <xsl:template match="tei:pc"/>
    <xsl:template match="tei:reg"/>
    <xsl:template match="tei:del"/>
    <xsl:template match="tei:orig[. = '&#769;' or .='&#775;']"/>
    
    <xsl:template match="tei:choice">
        <xsl:apply-templates select="tei:expan | tei:orig"/>
    </xsl:template>
    <!-- mode orig -->
    <xsl:template match="tei:note" mode="orig"/>
    <xsl:template match="tei:gap" mode="orig"/>
    <xsl:template match="tei:space" mode="orig"/>
    <xsl:template match="tei:corr" mode="orig"/>
    <xsl:template match="tei:pc" mode="orig"/>
    <xsl:template match="tei:reg" mode="orig"/>
    <xsl:template match="tei:del" mode="orig"/>
    <xsl:template match="tei:orig[. = '&#769;' or .='&#775;']" mode="orig"/>
    
    <xsl:template match="tei:choice" mode="orig">
        <xsl:apply-templates select="tei:abbr | tei:orig"/>
    </xsl:template>
    
</xsl:stylesheet>