<?xml version="1.0" encoding="UTF-8"?>
<!-- TODO: marche pas trop mal maintenant, mais il faudrait encore la modifier un peu, pour éviter
la répétition des numéros de laisse entre M et B
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

<!-- TODO: 
        * possible de simplifier le code en utilisant l'opérateur XPath 2.0 'is', c'est-à-dire, 
            . is preceding::lb[1]/following::w[1]
                plutôt que
            generate-id(.) = generate-id(preceding::lb[1]/following::w[1])
        
        parmi de nombreuses choses:
    - manque encore l'affichage de l'explicit de Vatican (ab, pas dans un lg)
    - surtout, il faut trouver un moyen d'améliorer l'alignement. Déjà mieux avec stanza. 
            Augmenter encore le nombre de \Pages?
    -->
    <!--<xsl:import href="teiverslatex_facsimilaire.xsl"/>-->
    <!--<xsl:import href="teiverslatex_diplomatique.xsl"/>-->

    <!-- en entrée, le fichier Alignement.xml, en sortie, les témoins alignés en LaTeX -->
    <xsl:variable name="bodmer"
        select="document('../Transcriptions_diplomatiques/Bodmer_token_num_pos.xml')"/>
    <xsl:variable name="mende"
        select="document('../Transcriptions_diplomatiques/Mende_token_num_pos.xml')"/>
    <xsl:variable name="vatican"
        select="document('../Transcriptions_diplomatiques/Vatican_token_num.xml')"/>
    <xsl:variable name="alignement"
        select="document('../Transcriptions_diplomatiques/Alignement.xml')/descendant::div[@type='alignement_vers_par_vers']"/>
    
    <!-- Premier et dernier linkGrp à contenir 3 col. -->
    <xsl:param name="debut3col">
        <xsl:for-each select="$alignement/descendant::linkGrp">
            <xsl:if test="descendant::link[matches(@target, '#M_l_1(\s|$)')]">
                <xsl:value-of select="position()"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>
    
    <xsl:param name="fin3col">
        <xsl:for-each select="$alignement/descendant::linkGrp">
            <xsl:if test="descendant::link[matches(@target, '#M_l_293(\s|$)')]">
                <xsl:value-of select="position()"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>

<!-- Deux approches possibles: 
        1. On part des linkGrp, et on crée une entrée par ligne;
        2. Par les manuscrits: on part des mss Bodmer, Vatican, etc. et on applique les règles,
        en calculant en leur sein s'il faut ajouter des lignes vides.
        Les deux sont assez complexes à mettre en œuvre. Inconvénient de la 1, on raisonne plus ou moins à plat
        Inconvénient de la 2, gros temps d'exécution à cause des tests.
    -->

    <xsl:template match="/">
        <!--<xsl:value-of select="$debut3col"/>
        <xsl:value-of select="$fin3col"/>-->
        <!-- 1er bloc -->
        <!-- Je suis contraint de dupliquer le code pour pouvoir insérer des commandes \Pages relativement régulièrement-->
        <!-- Il va falloir encore ajouter un niveau "makeVersion" pour pouvoir gérer les différents rendus -->
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'first'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() &lt; 6 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 6 and position() &lt; 12 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 12 and position() &lt; 14 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 14 and position() &lt; 18 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 18 and position() &lt; $debut3col ]"/>
        </xsl:call-template>
        <!-- C'est cette portion qui doit être sur trois colonnes -->
        <xsl:text>\newgeometry{inner=1.5cm, outer=2cm}&#xA;</xsl:text>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="colonnes" select="'3col'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= $debut3col and position() &lt; 24 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="colonnes" select="'3col'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 24 and position() &lt; 25 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="colonnes" select="'3col'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 25 and position() &lt; 26 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="colonnes" select="'3col'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 26 and position() &lt;= $fin3col ]"/>
        </xsl:call-template>
        <!--<xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="colonnes" select="'3col'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() = $fin3col ]"/>
        </xsl:call-template>-->
        <xsl:text>\restoregeometry&#xA;</xsl:text>
        <!-- / fin portion 3 colonnes -->
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= ($fin3col + 1) and position() &lt; 38 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 38 and position() &lt; 39 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 39 and position() &lt; 40 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 40 and position() &lt; 41 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 41 and position() &lt; 42 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 42 and position() &lt; 43 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 43 and position() &lt; 45 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 45 and position() &lt; 46 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 46 and position() &lt; 48 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 48 and position() &lt; 50 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 50 and position() &lt; 51 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 51 and position() &lt; 52 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 52 and position() &lt; 53 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 53 and position() &lt; 54 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 54 and position() &lt; 58 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 58 and position() &lt; 60 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 60 and position() &lt; 63 ]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 63 and position() &lt; 64]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'middle'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 64 and position() &lt; 65]"/>
        </xsl:call-template>
        <xsl:call-template name="makePages">
            <xsl:with-param name="position" select="'last'"/>
            <xsl:with-param name="linkGrp" select="$alignement/linkGrp[position() >= 65]"/>
        </xsl:call-template>
        <!-- 2e bloc -->
        <!-- 3e bloc -->
    </xsl:template>
    
    <xsl:template name="makePages">
        <xsl:param name="linkGrp"/>
        <xsl:param name="position"/>
        <xsl:param name="colonnes"/>
        <xsl:text>
\begin{pages}
\begin{Leftside}
</xsl:text>
<xsl:choose>
    <xsl:when test="$position = 'first' ">\beginnumbering</xsl:when>
    <xsl:otherwise>\resumenumbering</xsl:otherwise>
</xsl:choose>
        <xsl:for-each select="$linkGrp">
            <xsl:call-template name="makeStanza">
                <xsl:with-param name="colonnes" select="$colonnes"/>
                <xsl:with-param name="manuscrit" select="$bodmer"/>
                <xsl:with-param name="sigle" select="'B'"/>
                <xsl:with-param name="linkGrp" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="$position = 'last' ">\endnumbering</xsl:when>
            <xsl:otherwise>\pausenumbering</xsl:otherwise>
        </xsl:choose>
        <xsl:text>
\end{Leftside}
\begin{Rightside}
</xsl:text>
<xsl:choose>
            <xsl:when test="$position = 'first' ">\beginnumbering</xsl:when>
            <xsl:otherwise>\resumenumbering</xsl:otherwise>
</xsl:choose>
        <xsl:for-each select="$linkGrp">
            <xsl:call-template name="makeStanza">
                <xsl:with-param name="colonnes" select="$colonnes"/>
                <xsl:with-param name="manuscrit" select="$vatican"/>
                <xsl:with-param name="sigle" select="'A'"/>
                <xsl:with-param name="linkGrp" select="."/>
            </xsl:call-template>
        </xsl:for-each>
<xsl:choose>
            <xsl:when test="$position = 'last' ">\endnumbering</xsl:when>
            <xsl:otherwise>\pausenumbering</xsl:otherwise>
</xsl:choose>
        <xsl:text>
\end{Rightside}
\end{pages}
\Pages</xsl:text>
    </xsl:template>
    
    <xsl:template name="makeStanza">
        <xsl:param name="manuscrit"/>
        <xsl:param name="sigle"/>
        <xsl:param name="linkGrp"/>
        <xsl:param name="colonnes"/>
        <xsl:choose>
            <xsl:when test="$colonnes = '3col'">
                    <xsl:text>\pstart[</xsl:text>
            </xsl:when>
            <xsl:otherwise><xsl:text>\stanza[</xsl:text></xsl:otherwise>
        </xsl:choose>
        <!-- On a besoin d'avoir la section avant le début du tableau… 
                    c'est à dire, d'appliquer la règle du "lg" qui est l'ancêtre du vers du ms. B référencé dans le premier lien de notre linkGrp
                    -->
        <xsl:choose>
            <xsl:when test="$manuscrit/descendant::l[@xml:id = translate(tokenize($linkGrp/link[matches(@target, $sigle)][1]/@target, ' ')[contains(., $sigle)], '#', '')]/ancestor::lg">
                <xsl:apply-templates
                    select="
                    $manuscrit/descendant::l[@xml:id = translate(tokenize($linkGrp/link[matches(@target, $sigle)][1]/@target, ' ')[contains(., $sigle)], '#', '')]/ancestor::lg"    
                /><!-- ouuuuf -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\subsection*{~}</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>] &#xA;</xsl:text>
        <!--<xsl:if test="$colonnes ='3col' and not( $manuscrit/descendant::l[@xml:id = translate(tokenize($linkGrp/link[matches(@target, $sigle)][1]/@target, ' ')[contains(., $sigle)], '#', '')]/ancestor::lg)">
            <!-\- On traite le cas ultraspécifique des laisses bis de M, non existantes dans B -\->
            <xsl:apply-templates
                select="
                $manuscrit/descendant::l[@xml:id = translate(tokenize($linkGrp/link[matches(@target, 'M')][1]/@target, ' ')[contains(., 'M')], '#', '')]/ancestor::lg"    
            />
        </xsl:if>-->
        <!-- => NON, c'est une problématique philologique, à régler en amont: structuration des laisses
        dans le linkGrp => est-ce qu'on considère ou non qu'il y a une laisse ici. Une fois ça fait, rétablir la règle
        -->
        <xsl:if test="$colonnes = '3col' and $sigle = 'B'">
            <xsl:text>\begin{edtabularl} </xsl:text>
        </xsl:if>
        <xsl:text> \noindent </xsl:text>
        <xsl:call-template name="printText">
            <xsl:with-param name="manuscrit" select="$manuscrit"/>
            <xsl:with-param name="sigle" select="$sigle"/>
            <xsl:with-param name="linkGrp" select="$linkGrp"/>
            <xsl:with-param name="colonnes" select="$colonnes"/>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="$colonnes = '3col'">
                <xsl:if test="$sigle = 'B'">
                    <xsl:text> \end{edtabularl} </xsl:text>
                </xsl:if>
            <xsl:text>\pend </xsl:text>
            </xsl:when>
            <xsl:otherwise><xsl:text> \&amp; <!--\\--></xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="printText">
        <xsl:param name="manuscrit"/>
        <xsl:param name="sigle"/>
        <xsl:param name="linkGrp"/>
        <xsl:param name="colonnes"/>
<!--        <xsl:choose>
            <!-\- Début du fatras pour le texte sur trois colonnes -\->
            <xsl:when test="descendant::link[contains(@target, '#M')] and $sigle = 'B'">
                <xsl:text>\begin{edtabularl}</xsl:text>
                <xsl:for-each select="$linkGrp/link">
                            <xsl:choose>
                                <xsl:when test="contains(@target, $sigle)">
                                    <xsl:variable name="macible"
                                        select="translate(tokenize(@target, ' ')[contains(., $sigle)], '#', '')"/>
                                    <xsl:apply-templates select="$manuscrit/descendant::l[@xml:id = $macible]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>&#xA; \skipnumbering ~ </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    <xsl:text>&amp; \hspace{3cm}</xsl:text>
                            <xsl:choose>
                                <xsl:when test=" contains(@target, 'M')">
                                    <xsl:variable name="macible"
                                        select="translate(tokenize(@target, ' ')[contains(., 'M')], '#', '')"/>
                                    <xsl:apply-templates select="$manuscrit/descendant::l[@xml:id = $macible]"/>
                                    <xsl:text> ~ \\</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> ~ \\</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                </xsl:for-each>
                <xsl:text>\end{edtabularl}</xsl:text>
            </xsl:when>
            <!-\- Fin du fatras -\->
            <xsl:otherwise>-->
        <xsl:for-each select="$linkGrp/link[not(@type='repetitionVers')]"><!--[position() &lt; $debut3col]">-->
                    <xsl:choose>
                        <xsl:when test="contains(@target, $sigle)">
                            <xsl:variable name="macible"
                                select="translate(tokenize(@target, ' ')[contains(., $sigle)], '#', '')"/>
                            <xsl:choose>
                                <xsl:when test="$colonnes = '3col'">
                                    <xsl:apply-templates 
                                        select="$manuscrit/descendant::l[@xml:id = $macible]" 
                                        mode="troisCol"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="$manuscrit/descendant::l[@xml:id = $macible]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                                    <xsl:text>&#xA; \skipnumbering ~ </xsl:text> 
                                        <xsl:choose>
                                            <xsl:when test="@type = 'omission'">
                                                <xsl:text>\textbf{-}</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="@type = 'ajout'">
                                                <xsl:text>\textbf{+}</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="@type = 'inversion'">
                                                <xsl:text> $\rightarrow$ </xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>\phantom{M} </xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- 
                                        Pour que la numérotation des lignes ne bugue pas, on doit absolument faire croire à eledmac/par
                                        qu'il y a du contenu, autre que de l'espace insécable, à imprimer dans cette ligne…
                                        TODO: c'est ici que, si on a le temps, 
                                        il faudra ajouter un test sur un attribut du link, pour savoir si l'absence du vers correspond à une omission
                                    de ce manuscrit, un ajout d'un autre, ou un cas équipollent et, ajouter un symbole en fonction +/-/°
                                    -->
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:choose>
                <xsl:when test="$colonnes = '3col'">
                    <xsl:if test="$sigle = 'B'">
                        <xsl:text> &amp; </xsl:text>
                        <xsl:choose>
                        <xsl:when test="contains(@target, 'M')">
                            <xsl:variable name="macible"
                                select="translate(tokenize(@target, ' ')[contains(., 'M')], '#', '')"/>
                            <xsl:apply-templates select="$mende/descendant::l[@xml:id = $macible]" mode="troisCol"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="@type = 'omission'">
                                    <xsl:text>\textbf{-}</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'ajout'">
                                    <xsl:text>\textbf{+}</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'inversion'">
                                    <xsl:text> $\rightarrow$ </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>\phantom{M} </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    </xsl:if>
                    <xsl:if test="not(. is $linkGrp/link[not(@type='repetitionVers')][last()])">
                        <xsl:text> \\ </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="not(. is $linkGrp/link[last()])">
                        <xsl:text> &amp;</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
                </xsl:for-each>
<!--            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
    
    <xsl:template match="l">
        <xsl:variable name="monId" select="generate-id(.)"/>
<!--  Voyons si nous sommes le premier depuis le début de la laisse -->
        <xsl:choose>
            <xsl:when test="$monId = generate-id(ancestor::lg/l[1])">
                <!--<xsl:apply-templates select="ancestor::lg"/>-->
                <xsl:apply-templates select="preceding-sibling::*"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="
                    ./preceding-sibling::l[1]/following-sibling::*[generate-id(following-sibling::l[1]) = $monId]"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]">
            <xsl:variable name="pluriel">
                <xsl:if test="count(following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]) > 1">
                    <xsl:text>oui</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
            <xsl:apply-templates select="./descendant::w[last()]" mode="lemme"/>
            <xsl:text>}\Bfootnote{ \textit{à la suite}</xsl:text>
            <xsl:choose>
                <xsl:when test="$pluriel = 'oui'">
                    <xsl:text> \textit{les vers} </xsl:text>
                    <xsl:value-of select="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ][1]/@sameAs"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ][last()]/@sameAs"/>
                    <xsl:text> \textit{ont été répétés par le copiste}</xsl:text>
                </xsl:when>
                <xsl:otherwise> <xsl:text> \textit{le vers} </xsl:text>
                    <xsl:value-of select="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]/@sameAs"/>
                    <xsl:text> \textit{a été répété par le copiste}</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Un peu grossier: on teste que tout a été supprimé d'un coup -->
            <xsl:if test="not(following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]/child::element()[not(local-name(.) = 'del')])">
                <xsl:text> (et suppr. par lui)</xsl:text>
            </xsl:if>
            <xsl:if test="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]/descendant::note">
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select="following::l[$monId = generate-id(preceding::l[not(@sameAs)][1]) and @sameAs ]/descendant::note/(child::*|text())"/>
                <!-- TODO: y a-t-il autre chose que des notes que nous voulons y récupérer? Il faut voir aussi comment on décide de distinguer les étages… -->
            </xsl:if>
            <xsl:text>}} </xsl:text>  
        </xsl:if>
        <xsl:if test="@real">
            <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
            <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
            <xsl:text> \dots{} </xsl:text>
            <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            <xsl:text>}\Afootnote{\textbf{</xsl:text>
            <xsl:value-of select="@real"/>
            <xsl:text>}}}</xsl:text>
        </xsl:if>

        <xsl:apply-templates/>
        
        <!-- et si nous sommes les derniers -->
            <xsl:if test="$monId = generate-id(ancestor::lg/l[last()])">
                <xsl:apply-templates select="following-sibling::*"/>
            </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="l" mode="troisCol">
        <xsl:variable name="monId" select="generate-id(.)"/>
        <!--  Voyons si nous sommes le premier depuis le début de la laisse -->
        <xsl:choose>
            <xsl:when test="$monId = generate-id(ancestor::lg/l[1])">
                <!--<xsl:apply-templates select="ancestor::lg" mode="#default"/>--><!-- On ne veut pas de subsection dans notre tableau nécessaire aux trois colonnes -->
                <xsl:apply-templates select="preceding-sibling::*" mode="#default"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="
                    ./preceding-sibling::l[1]/following-sibling::*[generate-id(following-sibling::l[1]) = $monId]" mode="#default"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="@real">
            <xsl:text>\edtext{}{%
                      \lemma{</xsl:text>
            <xsl:apply-templates select="descendant::w[1]" mode="lemme"/>
            <xsl:text> \dots{} </xsl:text>
            <xsl:apply-templates select="descendant::w[last()]" mode="lemme"/>
            <xsl:if test="tokenize(@xml:id, '_')[1] = 'M'">
                <xsl:text> \textit{M}</xsl:text>
            </xsl:if>
            <xsl:text>}\Afootnote{\textbf{</xsl:text>
            <xsl:value-of select="@real"/>
            <xsl:text>}}}</xsl:text>
        </xsl:if>
        
        <xsl:apply-templates mode="#default"/>
        
        <!-- et si nous sommes les derniers -->
            <xsl:if test="$monId = generate-id(ancestor::lg/l[last()])">
                <xsl:apply-templates select="following-sibling::*" mode="#default"/>
            </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="lg">
        <xsl:if test="not(generate-id(.) = generate-id(ancestor::body/descendant::lg[1]))">
        </xsl:if>
<xsl:text>\subsection*{</xsl:text><xsl:value-of select="@n"/><xsl:text>}</xsl:text>
    </xsl:template>


    <!-- 2nde approche, je redéfinis le template pour les vers pour qu'il tienne compte des linkGrp -->
<!--    <xsl:template match="l">
        <xsl:apply-templates/>
        <xsl:variable name="monIdRefPattern" select="concat('#', @xml:id, '(\s|$)')"/>
        <xsl:variable name="monSuivantIdRefPattern"
            select="concat('#', ./following::l[1]/@xml:id, '(\s|$)')"/>
        <xsl:variable name="sigle" select="substring(@xml:id,1,1)"/>
        <!-\- Pour l'instant, je vois deux manières de l'écrire, qui apparemment consomment toutes deux énormément de ressources...
        $linkGrp/link[
                preceding-sibling::link[matches(@target, $monIdRefPattern)] and
                following-sibling::link[matches(@target, $monSuivantIdRefPattern)]
                ]
        ou
        $linkGrp/link[matches(@target, $monIdRefPattern)]/
                    following-sibling::link[following-sibling::link[matches(@target, $monSuivantIdRefPattern)]]
                    
        Troisième méthode, avec generate-id
        -\->
        
        <xsl:if test="following-sibling::l or not($linkGrp/link[matches(@target, $monIdRefPattern)]/following-sibling::link[1]/contains(@target, $sigle))">
            <xsl:text>\\</xsl:text> 
        <!-\- Supprimer des tests inutiles pour gagner de la rapidité -\->
        <xsl:if test="
            not($linkGrp/link[matches(@target, $monIdRefPattern)]/following-sibling::link[1]/contains(@target, $sigle))">
            <xsl:for-each
                select="
                $linkGrp/link[matches(@target, $monIdRefPattern)]/
                following-sibling::link[following-sibling::link[matches(@target, $monSuivantIdRefPattern)]]
                ">
                <xsl:text>&#xA; \skipnumbering ~\\</xsl:text>
            </xsl:for-each>
        </xsl:if>
        </xsl:if>
        <!-\- Tentative avec apply-templates -\->
        <!-\-<xsl:apply-templates select="$linkGrp/link[matches(@target, $monIdRefPattern)]/
            following-sibling::link[following-sibling::link[matches(@target, $monSuivantIdRefPattern)]]"/>-\->
    </xsl:template>-->
    
<!--    <xsl:template match="link">
        <xsl:text>&#xA; \skipnumbering ~\\</xsl:text>
    </xsl:template>-->



</xsl:stylesheet>
