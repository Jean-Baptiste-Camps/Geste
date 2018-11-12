<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <!-- Ne pas oublier d'intégrer les neutres, les indécidables, etc. -->
    <!-- 
        NB: on pourrait éviter d'avoir à créer des nœuds groupes en utilisant for-each $variable[] plutôt que $variable/*[] 
    http://www.dpawson.co.uk/xsl/rev2/sequences.html#d16069e16
    -->
    <!-- TODO: séparer les templates de phonologie, et ceux créant les paradigmes, dans des feuilles à part, pour réutilisation / maintenance? -->
    <!-- TODO: toute une série de value-of à remplacer par le template de comptage des groupes -->
    <!-- TODO: il faudrait vraiment améliorer tous les comptages du type A contient une séquence, B ne la contient pas
    en A contient tant d'occurrences de cette séquence, B en contient tant.
    -->
    <xsl:output indent="yes"/>
    <xsl:param name="cons"><xsl:text>[bcççꝯdfghjklmnpꝑꝓqrstvwxz]</xsl:text></xsl:param>
    <xsl:param name="voy"><xsl:text>[aeiouyäëïöü]</xsl:text></xsl:param>
    <!-- piece, pieç'a à vérifier -->
    <xsl:param name="diphtEouv" select="(
        'bien1',
        'brief',
        'dementieres',
        'endementieres',
        'fier',
        'piece', 
        'rier',
        'tierz',
        'vieil',
        'ariere',
        'criembre',
        'derrier(e)',
        'dieu',
        'entier',
        'fierement',
        'fierté',
        'ier',
        'matiere',
        'mien',
        'mier',
        'mieus',
        'piere',
        'pieça',
        'rien',
        'siecle',
        'siege',
        'mostier',
        'mestier'
        )"/><!-- trieue -->
    <xsl:param name="suffixeARIU" select="(
        'arbalestier',
        'archier',
        'berruiier',
        'cartier',
        'chevalier',
        'denier',
        'destrier1',
        'escuier2',
        'fevrier',
        'guerrier',
        'jenvier',
        'lorier',
        'messagier',
        'morier',
        'milier',
        'ogier',
        'plenier2',
        'premier',
        'puier',
        'sentier',
        'corsier',
        'encombrier',
        'encumbrier',
        'doblier',
        'garnier',
        'genestier',
        'loiier',
        'olivier1',
        'pomier',
        'poudriere',
        'prunier',
        'puier',
        'premierement',
        'sautier2',
        'vergier1',
        'vivier',
        'volentiers',
        'droiturier2',
        'esprevier',
        'gravier',
        'hainuier',
        'lanier',
        'losengier1',
        'lïemier',
        'pautonier',
        'portier2'
        )"></xsl:param><!-- priiere -->
    <xsl:param name="suffixeYARE" select="(
        'afichier',
        'alaschier',
        'baisier',
        'batisier',
        'brisier',
        'brochier',
        'chevauchier',
        'comencier',
        'conseillier1',
        'cuidier1',
        'depecier',
        'embracier',
        'esclairier',
        'froissier',
        'guiier',
        'gäaignier',
        'laiier2',
        'laissier',
        'mangier',
        'menacier',
        'otroiier',
        'percier',
        'ploiier',
        'priier',
        'prisier',
        'repairier',
        'sachier2',
        'saignier',
        'trenchier1',
        'vengier',
        'acointier',
        'agenoillier',
        'aidier',
        'alaschier',
        'alegier1',
        'aproismier',
        'atachier2',
        'atochier',
        'baignier',
        'baissier',
        'blanchoiier',
        'blecier',
        'cerchier',
        'changier',
        'chaploiier',
        'chaucier1',
        'commencier',
        'contrariier',
        'corrocier',
        'couchier',
        'covoitier',
        'damagier',
        'depercier',
        'depriier',
        'descirier',
        'desmaillier',
        'detrenchier',
        'empirier',
        'emploiier',
        'enchacier',
        'eschignier',
        'eslaissier',
        'eslaschier',
        'esmaier',
        'esmerveillier',
        'essaucier',
        'estraier3',
        'esveillier',
        'fichier',
        'gaitier',
        'glaçoiier',
        'guerroiier2',
        'haitier',
        'herbergier',
        'huchier1',
        'irier',
        'lacier',
        'lancier3',
        'liier3',
        'merveillier',
        'noncier1',
        'peschier2',
        'raiier',
        'ralier',
        'reconcilier',
        'resachier',
        'rochier1',
        'rongier2',
        'röeillier',
        'sacrefiier',
        'saintefiier',
        'seignier',
        'targier2',
        'tochier',
        'travaillier',
        'trebuchier',
        'taillier1',
        'vergoignier',
        'adrecier',
        'afebliier',
        'aprochier',
        'atargier',
        'avancier',
        'baillier',
        'baloiier',
        'chacier',
        'chalongier',
        'chamoissier',
        'delaiier1',
        'despechier',
        'drecier',
        'enchaucier',
        'enforcier1',
        'engignier1',
        'enragier',
        'envoiier',
        'escorchier',
        'esligier',
        'esloignier',
        'esmaiier',
        'espargnier',
        'esploitier',
        'esprisier',
        'essaiier',
        'essillier',
        'essuier',
        'flamboiier',
        'forgier',
        'formiier',
        'frapier',
        'haucier',
        'jugier',
        'mengier',
        'justicier2',
        'lancier',
        'laschier',
        'moillier1',
        'noiier1',
        'ondoiier',
        'paiier',
        'plaidier2',
        'plaiier',
        'reboisier',
        'recomencier',
        'rengier1',
        'renoiier1',
        'verdoiier',
        'veroillier',
        'äirier',
        'mahaignier'
        )"/>
    <xsl:param name="YplusAsubst" select="(
        'acier',
        'angiers',
        'braier',
        'chief1',
        'chier',
        'chiere',
        'ciel',
        'dangier',
        'desvoiier1',
        'eschiele1',
        'irieement',
        'legier2',
        'montpellier',
        'paien',
        'paienie',
        'eschiele',
        'esforcieement'
        )"/>
    <xsl:param name="triphtIEI" select="(
        'delit1',
        'delit2',
        'demi',
        'dis1',
        'eglise',
        'lit1', 
        'matiere',
        'mi2', 
        'en1+mi2',
        'midi',
        'mire1',
        'pejor', 
        'piz', 
        'pris1', 
        'sis2'
        )" />
    <xsl:param name="suffixeELLUS" select="(
        'bel1',
        'chastel',
        'clarel',
        'clavel2',
        'crenel',
        'damoisel',
        'novel',
        'oisel',
        'fläel1',
        'otinel',
        'penoncel'
        )"/>
    <xsl:param name="ibrefPLUSl" select="(
        'cil',
        'icil',
        'il'
        )"/>
    <!-- La liste qui suit mériterait d'être revérifiée -->
    <xsl:param name="diphtOFerm" select="(
        'amor',
        'deus',
        'flor',
        'lor2',
        'meillor',
        'more4',
        'plusor',
        'seignor',
        'sore',
        'aillors',
        'ambedos',
        'dolor',
        'dos',
        'flor1',
        'iror',
        'major',
        'menor',
        'merveillos',
        'nevo',
        'onor',
        'pejor',
        'pro',
        'prodome',
        'seror',
        'sol1',
        'sor2',
        'soz',
        'träitor',
        'vavassor',
        'baudor',
        'color',
        'doloros',
        'migrados',
        'orgoillos',
        'rador',
        'tristor',
        'valor',
        'vigor'
        )"/>
    <!-- fuerre et batistere ne devraient peut-être pas y être étymologiquement, mais fonctionnement avec cette déclinaison probable -->
    <xsl:param name="substMasc2Decl" select="(
        'arbre',
        'batistere',
        'erre3',
        'fevre',
        'fuerre2',  
        'frere',
        'feutre',
        'maistre',
        'martir|martre',
        'pere',
        'pere1',
        'povre',
        'vespre',
        'decembre',
        'arapater',
        'munmartre'
        )"/>
    <!-- prestre et provoire sont deux entrées différentes de TL, mais même substantif
    pere1 est une erreur de l'indexation du TL car pere2 n'est pas une vraie entrée mais un renvoi.
    -->
    <xsl:param name="substMasc3Decl" select="(
        'abé1',
        'aideor',
        'baron',
        'bricon1',
        'chantëor',
        'chantre',
        'compaignon',
        'conte1',
        'emperëor',
        'enfant',
        'felon',
        'gloton',
        'ome',
        'janglëor',
        'larron',
        'lechëor',
        'major',
        'nevo',
        'pastor',
        'pechëor',
        'peintor',
        'prëechëor',
        'prestre',
        'provoire',
        'prodome',
        'robëor',
        'seignor',
        'träitor',
        'trichëor',
        'trovëor',
        'vendëor',
        'venëor',
        'charle',
        'Otinel'
        )"/>
    <xsl:param name="substFem2Decl" select="(
        'Belisent',
        'Naimant',
        'Ninivent',
        'Verceles',
        'amor',
        'chançon',
        'cité',
        'crestïenté',
        'dent2',
        'flor',
        'foi',
        'garant',
        'gent1',
        'pute+gent1',
        'loi3',
        'mer',
        'merci',
        'mi2',
        'mort',
        'nef2',
        'part1',
        'belamer',
        'belisent',
        'betlïant',
        'char2',
        'color',
        'compassement',
        'contençon',
        'cort1',
        'croiz',
        'damïant',
        'dolor',
        'durendal',
        'fin1',
        'flor1',
        'foiz',
        'iror',
        'leçon',
        'main2',
        'maison',
        'melan',
        'menor',
        'naimant',
        'ninivent',
        'noif',
        'nuit',
        'onor',
        'passïon',
        'prim',
        'prison',
        'pëor',
        'raison',
        'räençon',
        'tor2',
        'vertu',
        'voiz',
        'biauté',
        'bonté',
        'fierté',
        'lëauté',
        'parenté',
        'pöesté',
        'verité',
        'volenté',
        'pais',
        'florïant',
        'tost1',
        'arestison',
        'baudor',
        'clarté',
        'foison',
        'forest',
        'frëor',
        'grant',
        'lüoison',
        'malëiçon',
        'moitié',
        'moillier2',
        'ost',
        'pitié',
        'plenté',
        'rador',
        'regïon',
        'sauveté',
        'tençon',
        'träison',
        'tristor',
        'valor',
        'vigor',
        'vilté',
        'betliant',
        'aquilant'
        )"/>
    <!-- tost1 comme nom propre; incertitude sur le genre de Durendal -->
    <xsl:param name="substFem3Decl" select="(
        'cosin',
        'seror',
        'none1',
        'pute',
        'taie'
        )"/>
    <xsl:param name="adj1DeclBis" select="(
        'autre',
        'destre',
        'delivre1'
        )"/>
    <xsl:param name="adj2Decl" select="(
        'brief',
        'cöart',
        'enfant',
        'fort',
        'garant',
        'grant',
        'omnipotent',
        'sanglent',
        'tel',
        'peser',
        'vaillant',
        'ferrant',
        'normant',
        'alïant',
        'auferrant',
        'pro',
        'engrant',
        'jazerenc',
        'joiant',
        'mescrëant',
        'persant',
        'poissant',
        'pöestëif',
        'vert',
        'crüel',
        'isnel',
        'gentil'
        )"/>
    <!-- 
        'dolent' paraît bien, contre la règle général, avoir un fém. en -e
        Les lemmes d'infinitifs viennent d'une petite irrégularité dans Cattex, qui traite
    comme adjectifs quelques participes présents dont le lien au verbe s'est distendu (pesant, etc.)
    -->
    <xsl:param name="adj3Decl" select="(
        'baron',
        'felon',
        'gloton',
        'bricon1',
        'graignor',
        'major',
        'menor',
        'meillor',
        'pejor'
        )"/>
    <!-- verbes -->
    <xsl:param name="parfaitsFaiblesEnUI" select="(
        'estre1',
        'morir',
        'chaloir',
        'corir',
        'criembre',
        'doloir',
        'moudre1',
        'valoir',
        'paroir'
        )"/>
    <xsl:param name="parfaitsFortsEnI" select="(
        'venir',
        'avenir',
        'devenir',
        'covenir',
        'tenir1',
        'vëoir',
        'voloir'
        )"/>
    <xsl:param name="parfaitsFortsEnS" select="(
        'metre2',
        'prometre',
        'trametre',
        'prendre',
        'lire1',
        'despire',
        'dire',
        'rire',
        'ocire',
        'faire',
        'jesir',
        'manoir1',
        'clore',
        'conclure',
        'ardre',
        'mordre1',
        'traire',
        'fraindre',
        'plaindre',
        'ceindre',
        'joindre',
        'soudre',
        'semondre',
        'sordre',
        'tordre',
        'criembre',
        'voloir',
        'escrire',
        'duire',
        'cuire',
        'nuire',
        'sëoir',
        'querre',
        'conquerre'
        )
        "/>
    <!-- TODO: liste plus complète dans Duval 2009 à reprendre -->
    <xsl:param name="parfaitsFortsEnU" select="(
        'avoir',
        'paistre',
        'plaisre',
        'savoir',
        'taire',
        'pöoir',
        'croire',
        'croistre',
        'devoir',
        'loisir1',
        'boivre',
        'recevoir',
        'decevoir',
        'jesir',
        'lire1', 
        'ramentevoir',
        'movoir',
        'estovoir1',
        'plovoir',
        'conoistre',
        'nuire',
        'ester',
        'arester'
        )"/>


    <xsl:template match="/">
        <xsl:variable name="arborescenceRegul">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
        <xsl:result-document href="{$filename}_arborescence_regul.xml">
            <xsl:copy-of select="$arborescenceRegul"/>
        </xsl:result-document>
        <!--<xsl:copy-of select="$arborescenceRegul"/>-->
        <xsl:call-template name="depouillements">
            <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul"/>
        </xsl:call-template>
        <xsl:result-document href="{$filename}_paradigmes.html">
            <xsl:call-template name="paradigmes">
                <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="depouillements">
        <xsl:param name="arborescenceRegul"/>
        <html>
            <head/>
            <body>
                <h1>Phonologie et graphématique</h1>
                <h2>Vocalisme</h2>
                <h3>Graphie ou pour ǫ</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat('o', $cons)) and matches(., 'ou')]"/>
                </xsl:call-template>
                <h3>Indices sur la palatalisation de /u/</h3>
                <xsl:value-of select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '[^o]u') and matches(., 'ou')]" separator=", "/>
                <h3>ié > i</h3>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma,  'ie') and not(matches(., 'ie'))])"/>
                <br />
                <b>Liste des lemmes en 'ié' non encore inclus dans la base de connaissance pour traitement</b>
                <xsl:for-each select="distinct-values($arborescenceRegul/descendant::tei:w/@lemma[contains(., 'ie') and not(. = $diphtEouv or . = $suffixeYARE or . = $suffixeARIU or . = $YplusAsubst)])"><xsl:sort order="ascending" data-type="text"/><xsl:value-of select="."/><xsl:text>, </xsl:text></xsl:for-each>
                <br />
                <b>Dans les formes verbales - dépouillement des lemmes qui pourraient convenir:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[tokenize(@ana, ' ') = '#VERcjg' and matches(@lemma, concat('^', $cons, '*e', $cons, '+', $voy, '+', $cons, '*\d?$'))]/@lemma"/>
                </xsl:call-template>
                <p>Ici, juste ferir, lever, tenir, venir (dépouillement manuel, à automatiser si besoin (touche les P1236)<!--; chëoir peut corresp.--></p> 
                <h4>Résultat de la diphtongaison de /ę́/</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[@lemma = $diphtEouv]"/>
                </xsl:call-template>
                <h5>Dans les formes verbales</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[@lemma = ('chëoir', 'ferir', 'lever', 'sëoir', 'tenir1', 'venir') 
                        and matches(@ana, 'VERcjg.*#(((1|2)\s+#s)|3)')]"></xsl:with-param><!-- TODO: cette liste pourrait sans doute être élargie -->
                </xsl:call-template>
                <h4>Y + ARE</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[@lemma = $suffixeYARE and (matches(@ana, 'VERinf') or matches(@ana, 'NOM'))]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h4>Y + A dans les substantifs</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[@lemma = $YplusAsubst]"/>
                </xsl:call-template>
                <h4>-ARIU-, -ARIA-</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[@lemma = $suffixeARIU]"/>
                </xsl:call-template>
                <h4>-ATA- > ie / iee</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[(matches(@lemma, 'ier\d?$')
                        and matches(@ana, 'VERppe.*#f')) or matches(@lemma, 'iee\d?$')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <p>Comptages des formes, pour l'exemple:
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[(matches(@lemma, 'ier\d?$')
                        and matches(@ana, 'VERppe.*#f')) or matches(@lemma, 'iee\d?$')]"/>
                </xsl:call-template>
                </p>
                <h4>Triphtongue /iei/</h4>
                <xsl:for-each select="$triphtIEI">
                    <xsl:variable name="lemme" select="."/>
                    <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma=$lemme]" group-by=".">
                        <xsl:value-of select="current-grouping-key()"/><xsl:text> (</xsl:text><xsl:value-of select="count(current-group())"/> <xsl:text>), </xsl:text>
                    </xsl:for-each-group>
                </xsl:for-each>
                <h4>Triphtongue /ieu/</h4>
                <xsl:for-each select="('dieu')">
                    <xsl:variable name="lemme" select="."/>
                    <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma=$lemme]" group-by=".">
                        <xsl:value-of select="current-grouping-key()"/><xsl:text> (</xsl:text><xsl:value-of select="count(current-group())"/> <xsl:text>), </xsl:text>
                    </xsl:for-each-group>
                </xsl:for-each>
                
                <h4>Diphtongaison de \textsc{ĕ́} en syllabe fermée devant /r/, /s/ > /yę/</h4>
                <h5>Sondage:</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(matches(@lemma, 'i(e|é)')) and matches(., 'ie')]"/>
                </xsl:call-template>                
                <h4> -ELLUS, -ELLOS et -IL.S</h4>
                <h5>Sondage global</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '(e|i)l\d?$')
                        and matches(@ana, '(#s\s+#m\s+#n|#p\s+#m\s+#r)')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h6>-ELLUS, -ELLOS</h6>
                <p>Formes de bel, clavel, chastel, damoisel, novel, flaiel</p>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $suffixeELLUS
                        and matches(., '(s|z|x)$')
                        ]"></xsl:with-param><!-- matches(@ana, '(#s\s+#m\s+#n|#p\s+#m\s+#r)') -->
                </xsl:call-template>
                <p><b>Comptage des formes:</b><br />
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $suffixeELLUS]"/>
                </xsl:call-template>
                </p>
                <h6>i bref + </h6>
                <p>Formes de cil, il, gentil</p>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $ibrefPLUSl
                        and matches(., '(s|z)$')
                        ]"></xsl:with-param><!-- matches(@ana, '(#s\s+#m\s+#n|#p\s+#m\s+#r)') -->
                </xsl:call-template>
                
                <h4>Diphtongaison de ŏ́ en syllabe fermée devant /r/, /s/ > /úo/, /úa/, /úe/</h4>
                <b>Formes de cors1 (CORPUS)</b> : <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[@lemma = 'cors1'])"/>
                <br />
                <b>Sondage élargi:</b> 
                <xsl:for-each select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, concat('o(', $cons,'{2}', '|', $cons, '\d?$)') )and matches(., concat('u(o|a|e)', $cons))])"><xsl:sort/> <xsl:value-of select="."/><xsl:text>, </xsl:text></xsl:for-each>
                <!-- TODO: une série de phénomènes à insérer ici dans notre grille d'analyse habituelle -->
                
                <h4>Diphtongaison de ŏ́</h4>
                <b>Sondage: </b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '[^qg]ue')]"/>
                </xsl:call-template>
                <h4>Diphtongaison de /ẹ́[/ > /éi̯/ > /ę́/ ou  > /ói̯/ (> /ó/)</h4>
                <h5>Sondage global (formes verbales exclues)</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'oi') and not(matches(@ana, 'VER(cjg|ppe|ppa)'))]"/>
                </xsl:call-template>
                <h5>oi non rendu par ei (formes verbales exclues)</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'oi') and not(matches(., 'ei')) and not(matches(@ana, 'VERcjg|ppe|ppa'))]"/>
                </xsl:call-template>
                <h5>oi non rendu par oi (formes verbales exclues)</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'oi') and not(matches(., 'oi')) and not(matches(@ana, 'VERcjg|ppe|ppa'))]"/>
                </xsl:call-template>
                <h5>Extension de oi ? (formes verbales exclues)</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(matches(@lemma, 'oi')) and matches(., 'oi') and not(matches(@ana, 'VERcjg|ppe|ppa'))]"/>
                </xsl:call-template>
                <h5>Emploi de la graphie &lt;oi></h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'oi')]"/>
                </xsl:call-template>
                
                <h4>/ẹ́/ + /l̮/ > oil</h4>
                <p><b>Sondage large:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'eil(le)?\d?')
                        ]"/>
                </xsl:call-template>
                </p>
                <h4>Diphtongaison de /ọ́[/ > /óu̯/ > /ú/</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $diphtOFerm]"/>
                </xsl:call-template>
                <!-- TODO: vérifier aussi les lemmes en eu (distinct-values(//w/@lemma[matches(., 'eu')]))
                parfois, mais rarement, utilisés par TL
                Au cas où, chercher toutes les occurrences de 'ou', 'eu'
                -->
                <b>Recherche de lemmes pouvant correspondre:</b>
                <xsl:for-each  select="distinct-values($arborescenceRegul/descendant::tei:w/@lemma[matches(., concat($cons, 'o', $cons, '+e?s?\d?$')) and not(. = $diphtOFerm)])"><xsl:sort/><xsl:value-of select="."/><xsl:text>, </xsl:text></xsl:for-each>
                
                <h4>Uniquement les adj. en -os (cf. Dees carte 143)</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'os\d?')
                        and matches(@ana, 'ADJqua')
                        ]"></xsl:with-param>
                </xsl:call-template>
                
                <h3>Réduction de la diphtongue /úi̯/ > /ú/</h3>
                <p><b>Sondage rapide:</b> 
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma[matches(., '[^qg]ui')] and not(matches(., 'ui'))]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                <p><b>Graphies inverses:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'ui') and not(matches(@lemma, 'ui'))]"/>
                    </xsl:call-template>
                </p>
                <h3>Réduction de la diphtongue /ai/ > /a/</h3>
                <p><b>Sondage: </b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            matches(@lemma, 'ai')
                            and not(matches(., 'ai'))
                            ]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                <h3>ai > ei, e, ?</h3>
                <h4>ai pour ai</h4>
                <p><b>Estimation totale: </b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and matches(., 'ai')])"/>
                </p>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and matches(., 'ai')]"/>
                </xsl:call-template>
                <h4>ei pour ai</h4>
                <p><b>Estimation totale: </b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and not(matches(., 'ai')) and matches(., 'ei')])"/>
                </p>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and not(matches(., 'ai')) and matches(., 'ei')]"/>
                </xsl:call-template>
                <h4>autres graphies pour ai</h4>
                <p><b>Estimation totale: </b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and not(matches(., 'ai')) and not(matches(., 'ei'))])"/>
                </p>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ai') and not(matches(., 'ai'))  and not(matches(., 'ei'))]"/>
                </xsl:call-template>
                <h4>Les formes du pp. de faire</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        @lemma = 'faire'
                        and matches(@ana, 'VERppe')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Devant nasale entravée: ain / ein</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'ain')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <p>Calculs:
                    <b>ain:</b> <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'ain') and matches(., 'ain')
                        ])
                        div
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'ain') 
                        ])
                        *
                        100
                    "/>
                    <br />
                    <b>ein:</b> <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'ain') and matches(., 'ein')
                        ])
                        div
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@lemma, 'ain') 
                        ])
                        *
                        100
                        "/>
                </p>
                <h3>ei > ei, e, ?</h3>
                <h4>ei pour ei</h4>
                <p><b>Estimation totale: </b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ei') and matches(., 'ei')])"/>
                </p>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ei') and matches(., 'ei')]"/>
                </xsl:call-template>
                <h4>Autres</h4>
                <p><b>Estimation totale: </b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ei') and not(matches(., 'ei'))])"/>
                </p>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ei') and not(matches(., 'ei'))]"/>
                </xsl:call-template>
                
                <h3> en / an: terminaison des adverbes en -ment </h3>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'ADV') and ends-with(@lemma, 'ment')]"/>
                </xsl:call-template>
                <!-- Faire aussi pour les 
                distinct-values(//w[matches(@ana, 'NOM') and ends-with(@lemma, 'ment')]/@lemma)
                -->
                <h3> en / an: terminaison des substantifs en -ment </h3>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'NOM') and ends-with(@lemma, 'ment')]"/>
                </xsl:call-template>
                <h3>en / an: calcul global (approximatif) de la graphie -an- pour des substantifs en -en- (entravé)</h3>
                <xsl:call-template name="graphiesAltern">
                    <xsl:with-param name="graphies" select="('(an|ã)','(en|ẽ)')"/>
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'NOM') and matches(@lemma, concat('en', $cons))]"/>
                </xsl:call-template>
                <h3>an / en: calcul global (approximatif) de la graphie -en- pour des substantifs en -an- (entravé)</h3>
                <xsl:call-template name="graphiesAltern">
                    <xsl:with-param name="graphies" select="('(an|ã)','(en|ẽ)')"/>
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'NOM') and matches(@lemma, concat('an', $cons))]"/>
                </xsl:call-template>
                <h3>Vélarisation de /ã/ > /õ/?</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, '(a|e)n') and matches(., '(on|õ)')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h3>Fermeture de e en syllabe initiale devant /l̮/ ou /n̮/</h3>
                <p><xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat('^', $cons, '?ei?[gl]+')) and matches(., concat('^', $cons, '?i'))]"/>
                </xsl:call-template></p>
                <p><b>Sondage élargi</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat('^', $cons, '*e')) and matches(., concat('^', $cons, '*i[^e]'))]"/>
                </xsl:call-template></p>
                <p>Songer à regarder le paradigme de legier2, seignor, etc.</p>
                
                <h3>Ouverture de /e/ > /a/ en syllabe initiale (devant /r/ ou /s/)</h3>
                <p><xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma,  concat('^', $cons, '{0,2}e[rs]')) and matches(.,  concat('^', $cons, '{0,2}a[rs]') )]"></xsl:with-param>
                </xsl:call-template></p>
                <p>
                    <b>Sondage élargi:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma,  concat('^', $cons, '{0,2}e', $cons)) and matches(.,  concat('^', $cons, '{0,2}a') )]"/>
                    </xsl:call-template>
                </p>
                <h3>Ouverture de de /o/ devant /r/ > /a/</h3>
                <p>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            matches(@lemma, 'or')
                            and matches(., 'ar')
                            ]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                
                
                <h3>Ouverture et vélarisation /e/ prétonique > /o/  sous l'effet d'une consonne labiale</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma,  concat('^', $cons, '{0,2}e', $cons)) and matches(.,  concat('^', $cons, '{0,2}o') )]"/>
                </xsl:call-template>
                
                <h3>Suffixe -ela, -el</h3>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma,  'ele?\d?$')]"/>
                </xsl:call-template>
                <h3>/a/ > /e/ en syllabe initiale ?</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma,  concat('^', $cons, '{0,2}a', $cons)) and matches(.,  concat('^', $cons, '{0,2}e', $cons) )]"></xsl:with-param>
                </xsl:call-template>
                <!--<b>Sondage élargi:</b>
                <xsl:value-of select="$arborescenceRegul/descendant::tei:w[matches(@lemma,  concat('^', $cons, '{0,2}e', $cons)) and matches(.,  concat('^', $cons, '{0,2}a') )]"/>-->
                <h3>Vélarisation de /a/</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="
                        $arborescenceRegul/descendant::tei:w[
                        matches(@lemma,  concat($cons, '{0,2}a[^ul]'))
                        and
                        matches(.,  concat($cons, '{0,2}au'))
                        ]
                        "/>
                </xsl:call-template>
                <br /><b>Devant s:</b>
                <xsl:call-template name="comptageFormes">
                <xsl:with-param name="groupe" select="
                    $arborescenceRegul/descendant::tei:w[
                    matches(@lemma,  concat($cons, '{0,2}as'))
                    and
                    matches(.,  concat($cons, '{0,2}au'))
                    ]
                    "/>
                </xsl:call-template>
                <p>
                    <b>Sondage élargi:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                              matches(@lemma, 'a[^ul]')
                              and matches(., 'au')
                            ]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                <h3>Graphie ee</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(., 'ee') and not(matches(@lemma, 'ee'))
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h3>e prosthétique</h3>
                <!--<xsl:value-of select="$arborescenceRegul/descendant::tei:w[matches(., concat('^s', $cons))]/@xml:id"/>-->
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="
                        $arborescenceRegul/descendant::tei:w[matches(., concat('^s', $cons))]
                        "/>
                </xsl:call-template>
                <h3>e svarabhaktique</h3>
                <h4>Futurs et conditionnels</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="
                        $arborescenceRegul/descendant::tei:w[
                        matches(@ana, '(fut|con)')
                        and matches(@lemma, '(re|oir)\d?$')
                        ]"/>
                </xsl:call-template>
                <h4>entre consonne sourde et liquide</h4>
                <b>Sourde et liquide au sens strict</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma,  '[ptfck][lr]')
                        and
                        matches(., '[ptfck](e|i)[lr]')
                        ]"/>
                </xsl:call-template>
                <br /><b>Version très étendue</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma,  concat($cons, '[lr]'))
                        and
                        matches(., concat($cons, '(e|i)[lr]'))
                        ]"/>
                </xsl:call-template>
                <h4>Détails</h4>
                <h5>v+r</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'vr')]"/>
                </xsl:call-template>
                <h5>d+r</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'dr')]"/>
                </xsl:call-template>
                <h5>t+r</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'tr')]"/>
                </xsl:call-template>
                <h3>Réduction des voyelles en hiatus</h3>
                <p>
                    <b>Formes qui présentent un hiatus présent également dans le lemme :</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, '[äëïöü]')
                        and matches(., '&#776;')])
                        "/>
                    </p><p>
                    <b>Détail: </b>
                        <xsl:call-template name="comptageFormes">
                            <xsl:with-param name="groupe"  select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '[äëïöü]')
                                and matches(., '&#776;')]
                                "></xsl:with-param>
                        </xsl:call-template>
                </p>
                <p>
                    <b>Autres:</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, '[äëïöü]')
                        and not(matches(., '&#776;'))])
                        "/>
                    </p><p>
                        <b>Détail: </b>
                        <xsl:call-template name="comptageFormes">
                            <xsl:with-param name="groupe"  select="$arborescenceRegul/descendant::tei:w[
                                matches(@lemma, '[äëïöü]')
                                and not(matches(., '&#776;'))]
                                "></xsl:with-param>
                        </xsl:call-template>
                </p>
                <h3>Chute de -e dans les féminins</h3>
                <p>
                    <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        (
                            matches(@lemma, 'ee\d?$')
                            or matches(@ana, 'VERppe.*#f')
                        ) 
                        and not(matches(., 'ees?\d?$'))
                        ]
                        "></xsl:with-param>
                </xsl:call-template>
                </p>
                <h2>Consonantisme</h2>
                <h3>Vélarisation de -bl- secondaire</h3>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, 'bl') and ( matches(., 'vl')   or matches(., 'ul') or matches(., 'ubl') or matches(., 'al')  )])" separator=", "/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'bl')])"/> cas max)<br/>
                <h3>Épenthèse</h3>
                <p>Regarder les paradigmes futur et conditionnel de venir, voloir, (a)mener, etc.</p>
                <b>m'l</b>: <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, 'mbl') and matches(., 'ml')])" separator=", "/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'mbl')])"/> cas indistincts maximum, non vérifiés, de la séquence, y compris à valeur étymologique)<br/> 
                <b>l'r</b>:  <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, 'udr') and (matches(., 'lr') or matches(., 'ur'))])" separator=", "/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'udr')])"/>)<br/>
                <b>n'r</b>:  <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ndr') and (matches(., 'nr') or matches(., 'rr'))])" separator=", "/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, 'ndr')])"/>)<br/>
                <br />
                <b>Sondage élargi</b><br/>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(., 'ml')])" separator=", "/>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(., 'lr')])" separator=", "/>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(., 'nr')])" separator=", "/>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(., 'sr')])" separator=", "/>
                <h3>Graphie de l antéconsonantique, l ou u</h3>
                <b>Sondage, voyelle + l + consonne: </b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(., concat($voy, 'l', '[bcdfghjkmnpqrstvwxz]'))]"/>
                </xsl:call-template>
                <br /><b>Sondage, voyelle + u + consonne: </b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(., concat($voy, 'u','[bcdfghjkmnpqrstvwxz]'))]"/>
                </xsl:call-template>
                <h3>Chute de /l/ dans a + l + consonne</h3>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@lemma, concat('au', $cons)) and matches(., 'a[bcdfghjkmnopqrstvxyz]')])" separator=", "/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, concat('au', $cons)) ])"/> cas indistincts)<br/>
                <h3>Extension des palatalisation de n</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei//w[not(matches(@lemma, 'gn')) and matches(., 'gn')]"/>
                </xsl:call-template>
                <h3>Dénasalisations ou chute de /n/</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, concat('n(', $cons, '|\d?$)'))
                        and not(matches(., concat('(n|&#x0303;)(', $cons, '|\d?$)')))
                        ]"/>
                </xsl:call-template>
                <br /><b>total d'occurrences de n implosif ou final</b>
                <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[
                    matches(@lemma, concat('n(', $cons, '|\d?$)')) and matches(., concat('(n|&#x0303;)(', $cons, '|\d?$)'))])"/>
                <p>
                    <b>P6:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            matches(@ana, 'VERcjg.*#3\s+#p')
                            and not(matches(., 'nt$'))
                            ]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                <p><b>Formes de bien, maintenant:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            @lemma = ('bien1', 'maintenant')
                            ]"/>
                    </xsl:call-template>
                    
                </p>
                
                <h3>Chute de r implosif (estimation)</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@lemma, concat('r(', $cons, '|\d?$)')) and not(matches(., concat('r(', $cons, '|\d?$)')))
                        and not(matches(@ana, 'VER(cjg|ppe|ppa)'))
                        ]"/>
                </xsl:call-template>
                <br/> (sur <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@lemma, concat('r', $cons))])"/> cas indistincts maximum)
                <h3> Métathèses er / re </h3>
                <h4>er pour re</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 're') and matches(., 'er')]"/>
                </xsl:call-template>
                <br /><b>maintient</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 're') and matches(., 're')]"/>
                </xsl:call-template>
                <h4>re pour er</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 're') and matches(@lemma, 'er')]"/>
                </xsl:call-template>
                <br /><b>maintient</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 're') and matches(@lemma, 're')]"/>
                </xsl:call-template>
                <h3>Chute de s implosif</h3>
                <b>Antéconsonantique</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 's[bcdfghjklmnpqrstvwxyz]') and not(matches(.,  's[bcdfghjklmnpqrstvwxyz]')) ]"></xsl:with-param>
                </xsl:call-template>
                <br /><b>Final:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 's\d?$') and not(matches(.,  's$')) ]"></xsl:with-param>
                </xsl:call-template>
                <b>Graphies inverses</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 's[bcdfghjklmnpqrstvwxyz]') and not(matches(@lemma,  's[bcdfghjklmnpqrstvwxyz]')) ]"></xsl:with-param>
                </xsl:call-template>
                <h3> -ss- / -s- </h3>
                <h4>s pour ss</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ss') and not(matches(., 'ss'))]"/>
                </xsl:call-template>
                <br /><b>ss pour ss</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'ss') and matches(., 'ss')]"/>
                </xsl:call-template>
                <h4>ss pour s</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'ss') and not(matches(@lemma, 'ss'))]"/>
                </xsl:call-template>
                <br /><b>s pour s</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '[^s]s[^s]') and matches(@lemma, '[^s]s[^s]')]"/>
                </xsl:call-template>
                <h3>Maintient de -t final non appuyé</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., concat($voy, '(t|d)$'))]"></xsl:with-param>
                </xsl:call-template>
                <h3>Sonorisation de -T- en -d- (estim. grossière)</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(matches(@lemma, 'd')) and matches(., 'd')]"/>
                </xsl:call-template>
                <h3>Conservation de /w-/ germanique</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[starts-with(., 'w')]"/>
                </xsl:call-template>
                <br />
                <b>Ensemble des occurrences de w:</b> 
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'w|W')]"/>
                </xsl:call-template>
                <h3>Graphie lh</h3>
                <b>Ensemble des occurrences de lh:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'lh')]"></xsl:with-param>
                </xsl:call-template>
               
                <h3>Dépalatalisations</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '(gn|ng\d?$)') and not(matches(.,  'gn')) ]"></xsl:with-param>
                </xsl:call-template>
                <br /><b>Graphies inverses:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(gn|ng\d?$)') and not(matches(@lemma,  'gn')) ]"></xsl:with-param>
                </xsl:call-template>
                <br /><b >l palatal</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '(li|il\d?$)') and not(matches(.,  'li')) ]"></xsl:with-param>
                </xsl:call-template>
                <br /><b>Graphies inverses:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(gn|ng\d?$)') and not(matches(@lemma,  'gn')) ]"></xsl:with-param>
                </xsl:call-template>
                
                <h3>KA- et GA-</h3>
                <h4>KA-</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '^ch(i?e|a)') and not(matches(., '^ch(i?e|a)'))]"/>
                </xsl:call-template>
                <h4>KA appuyé</h4>
                <xsl:call-template name="comptageFormes">
                <xsl:with-param 
                    name="groupe" 
                    select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat($cons, 'ch(i?e|a)')) 
                    and not(matches(., concat($cons, 'ch(i?e|a)')))]"/>
                    </xsl:call-template>
                <h4>GA-</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param 
                        name="groupe"
                        select="$arborescenceRegul/descendant::tei:w[matches(@lemma, '^j(i?e|a)') and not(matches(., '^j(i?e|a)'))]"/>
                </xsl:call-template>
                <h4>GA appuyé</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param 
                        name="groupe"
                        select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat($cons, 'j(i?e|a)')) and not(matches(., concat($cons, 'j(i?e|a)')))]"/>
                </xsl:call-template>
                <h3>KE- et KI- initiaux ou appuyés</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, concat('(^|', $cons, ')c(i|e)'))]"/>
                </xsl:call-template>
                <h3>Réduction  [tšyé] > [tšẹ́]</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'chie') and not(matches(., 'chie'))]"/>
                </xsl:call-template>
                <h3>-[p] + [y]- > [tš] / traitement des labiales suivies de /y/</h3>
                <h4>Impératif et subj. prés. des verbes en -voir</h4>
                <p><b>Lemmes:</b> <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@ana, 'sub|imp')]/@lemma[matches(., 'voir\d?$')])"/></p>
               <p>
                   <xsl:call-template name="comptageFormes">
                       <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'sub|imp') and @lemma[matches(., 'voir\d?$')]]"/>
                   </xsl:call-template>
               </p>
                <h3>Chute des consonnes finales</h3>
                <!-- Version très restrictive, pour éviter des tonnes de bruit -->
                <!--<xsl:for-each select="$arborescenceRegul/descendant::tei:w[not(matches(@ana, '(VER|PROper)'))
                    and not(matches(., '(s|z)$')) and not(descendant::tei:abbr)
                    ]">
                    <xsl:variable name="maForme" select="."/>
                    <xsl:analyze-string select="@lemma" regex="(\w)\d?$">
                        <xsl:matching-substring>
                            <xsl:if test="not(matches($maForme, concat(regex-group(1), '$')))">
                                <xsl:value-of select="$maForme"/><xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:for-each>-->
                
                <h2>Graphies</h2>
                <h3>&lt;k></h3>
                <h4>Emplois de &lt;k></h4>
                <!--<xsl:variable name="lemmes" select="distinct-values($arborescenceRegul/descendant::tei:w[matches(., 'k')]/@lemma)"/>-->
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[matches(., 'k')]" group-by="@lemma">
                    <xsl:value-of select="current-grouping-key()"/>: 
                    <xsl:for-each-group select="current-group()" group-by=".">
                        <xsl:value-of select="current-grouping-key()"/> (<xsl:value-of select="count(current-group())"/>)
                    </xsl:for-each-group>
                    <br/>
                </xsl:for-each-group>
                    <h4>Emplois de &lt;qw></h4>
                    <b>Total:</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(., 'q[u&#x0363;&#x0364;&#x0365;&#x0366;&#x0367;]')])"/>
                    <br/>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'q[u&#x0363;&#x0364;&#x0365;&#x0366;&#x0367;]')]"/>
                    </xsl:call-template>
                <h4>Emplois de &lt;z></h4>
                <h5>en position interne</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '\wz\w')]"></xsl:with-param>
                </xsl:call-template>
                <h5>À la finale</h5>
                <p>
                    <b>Nombre d'emplois: 
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(., 'z$')])"/>
                    </b>
                </p>
                <p><b>Tentative d'estimation de z pour s:</b><!-- J'élimine les verbes pour l'instant, cf. morpho -->
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            matches(., 'z$') and not(matches(@ana, 'VER'))
                            and not(matches(@lemma, '(t|z)d?$'))
                            ]"></xsl:with-param>
                    </xsl:call-template>
                    
                </p>
                
                <h1>Morphologie et morphosyntaxe</h1>
                <!-- ATTENTION:
                l'instruction suivante sert à retirer tous les mots se terminant par une abréviation, pour ne pas fausser 
                les calculs de désinence. À commenter (en attendant de mettre en place une meilleure solution)
                si besoin
                -->
                <!--<xsl:variable name="arborescenceRegul">
                    <xsl:apply-templates mode="sansAbbr"/>
                </xsl:variable>-->
                
                <h2>Déclinaison des substantifs</h2>
                <h3>Masculins</h3>
                <!--tokenize(@ana, ' ')[3] = '#m'-->
                <h4>Première déclinaison</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substMasc2Decl) and not(@lemma = $substMasc3Decl) and matches(@ana, 'NOM') and matches(@ana, '#m') and not(matches(@lemma, '(s|z)\d?$'))]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates 
                        mode="getDesinentia" 
                        select="$arborescenceRegul/descendant::tei:w[
                        not(@lemma = $substMasc2Decl) 
                        and not(@lemma = $substMasc3Decl) 
                        and matches(@ana, 'NOM')  
                        and matches(@ana, '#m')  
                        and not(matches(@lemma, '(s|z)\d?$'))
                        ]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <br />
                <h5>Sans les noms propres</h5>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates 
                        mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substMasc2Decl) and not(@lemma = $substMasc3Decl) and matches(@ana, 'NOMco')  and matches(@ana, '#m')  and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h5>Que les noms propres</h5>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substMasc2Decl) and not(@lemma = $substMasc3Decl) and matches(@ana, 'NOMpro')  and matches(@ana, '#m')  and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                
                <h4>Deuxième déclinaison</h4>
                <!-- TODO: transformer ces deux opérations en règle nommée, quand on aura le temps -->
                <b>Vérification qu'on ait tous les lemmes:</b>
                <xsl:value-of select="distinct-values($arborescenceRegul/descendant::tei:w[matches(@ana, 'NOM') and matches(@ana, '#m') and matches(@lemma, 're\d?$') and  not(@lemma = $substMasc2Decl)]/@lemma)"/>
                <p>fr.a. totale: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM')])"/>
                    <br />
                    CSS: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM.*#s\s+#(m|f|n|x)\s+#n')])"/><br />
                    CRS: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM.*#s\s+#(m|f|n|x)\s+#r')])"/><br />
                    CSP: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM.*#p\s+#(m|f|n|x)\s+#s')])"/><br />
                    CRP: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM.*#p\s+#(m|f|n|x)\s+#r')])"/><br />
                </p>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $substMasc2Decl and matches(@ana, 'NOM')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h4>Troisième déclinaison</h4>
                <p>fr.a. totale: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM')])"/>
                    <br />
                    CSS: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM.*#s\s+#(m|f|n|x)\s+#n')])"/><br />
                    CRS: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM.*#s\s+#(m|f|n|x)\s+#r')])"/><br />
                    CSP: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM.*#p\s+#(m|f|n|x)\s+#s')])"/><br />
                    CRP: <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM.*#p\s+#(m|f|n|x)\s+#r')])"/><br />
                </p>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $substMasc3Decl and matches(@ana, 'NOM')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h3>Féminins</h3>
                <h4>Première déclinaison</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substFem2Decl) and not(@lemma = $substFem3Decl) and matches(@ana, 'NOM') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$'))]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substFem2Decl) and not(@lemma = $substFem3Decl) and matches(@ana, 'NOM') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <br />
                <p><b >Cas problématiques</b><br />
                    <b>Mots qui ne terminent pas en e ou es:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substFem2Decl) and not(@lemma = $substFem3Decl) and matches(@ana, 'NOM') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$')) and not(matches(., 'es?$'))]"/>
                    </xsl:call-template>
                </p>
                <p>
                    <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[not(@lemma = $substFem2Decl) and not(@lemma = $substFem3Decl) and matches(@ana, 'NOM') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$')) and not(matches(., 'es?$'))]" group-by="@lemma">
                        <xsl:sort/>
                        <xsl:value-of select="current-grouping-key()"/> <xsl:text> (</xsl:text><xsl:value-of select="current-group()" separator=", "/><xsl:text>), </xsl:text>
                    </xsl:for-each-group>
                </p>
                <br />
                <h4>Deuxième déclinaison</h4>
                <b>Vérification qu'on ait tous les lemmes:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'NOM') and matches(@ana, '#f') and matches(@lemma, '[^e\d]\d?$') and  not(@lemma = $substFem2Decl)]/@lemma"></xsl:with-param>
                </xsl:call-template>
                <br /><b>Global</b>
                <xsl:variable name="monGroupe"><!-- TODO: je rajoute #f car certains lemmes paraissent renvoyer des masc. -->
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem2Decl and matches(@ana, 'NOM.*#f') and not(matches(@lemma, '(s|z)\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <p><b >Cas problématiques</b><br />
                    <b>Mots qui terminent en e ou es:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem2Decl and matches(@ana, 'NOM') and matches(@ana, '#f') and matches(., 'es?$')]"></xsl:with-param>
                    </xsl:call-template>
                </p>
                
                <!-- DEBUG -->
                <!--<xsl:value-of select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem2Decl and matches(@ana, 'NOM.*#p') and not(matches(@lemma, '(s|z)\d?$'))]"/>-->
                <h5>Sans les noms propres</h5>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w[matches(@ana, 'NOMcom')]"/>
                </xsl:call-template>
                <h5>Que les noms propres</h5>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w[matches(@ana, 'NOMpro')]"/>
                </xsl:call-template>
                <br /><b>Détail</b>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem2Decl and matches(@ana, 'NOM')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h4>Troisième déclinaison</h4>
                <xsl:call-template name="frequenceAbsolue">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem3Decl and matches(@ana, 'NOM.*#f')]"/>
                </xsl:call-template>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $substFem3Decl and matches(@ana, 'NOM.*#f')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                
                <h2>Déclinaison des adjectifs</h2>
                <b>Adj. neutres:</b> <xsl:value-of select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'ADJqua.*#(s|p)\s+#n')]"/>
                <h3>Première classe</h3>
                <h4>Masculins</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj1DeclBis) and not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#m') and not(matches(@lemma, 's\d?$'))]/@lemma"/></xsl:call-template>
                <xsl:call-template name="frequenceAbsolue">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj1DeclBis) and not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#m') and not(matches(@lemma, 's\d?$'))]"/>    
                </xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj1DeclBis) and not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#m') and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                
                <h5>1re classe bis, en -vre, -tre, -dre</h5>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj1DeclBis and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#m') and not(matches(@lemma, 's\d?$'))]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj1DeclBis and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#m') and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <p>
                    <b >Cas problématiques:</b><br />
                    <b>z ou s au CRS:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="
                            $arborescenceRegul/descendant::tei:w[not(@lemma = $adj1DeclBis) and not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#s\s+#m\s+#r') and not(matches(@lemma, 's\d?$')) and matches(., '(s|z)$')]
                            ">
                        </xsl:with-param>
                    </xsl:call-template>
                    <br />
                    <b>pas de z ou s au CRP:</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="
                            $arborescenceRegul/descendant::tei:w[not(@lemma = $adj1DeclBis) and not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#p\s+#m\s+#r') and not(matches(@lemma, 's\d?$')) and not(matches(., '(s|z)$'))]
                            ">
                        </xsl:with-param>
                    </xsl:call-template>
                </p>
                <h4>Neutres</h4>
                <!-- À aligner sur les autres à terme -->
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#(s|p)\s+#n') and not(matches(@lemma, 's\d?$'))]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h4>Féminins</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$'))]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#f') and not(matches(@lemma, 's\d?$'))]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <p><b >Cas problématiques:</b><br />
                <b>pas -e au sg.</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="
                        $arborescenceRegul/descendant::tei:w[not(@lemma = $adj2Decl) and not(@lemma = $adj3Decl) and matches(@ana, 'ADJ(qua|ind)') and matches(@ana, '#s\s+#f') and not(matches(@lemma, 's\d?$')) and not(matches(., 'e$'))]
                        "/>
                </xsl:call-template></p>
                <h3>Deuxième classe</h3>
                <b>Non pris en compte:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJ|DETind)') and matches(@lemma, '[ltdfv]\d?$') and not(@lemma = $adj2Decl)]/@lemma"></xsl:with-param>
                </xsl:call-template>
                <h4>Masc.</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#m')]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#m')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#m')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h4>Fém.</h4>
                <b>Liste des lemmes envisagés:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#f')]/@lemma"/></xsl:call-template>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#f')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $adj2Decl and matches(@ana, '(ADJ|DETind).*#f')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h3>Troisième classe</h3>
                <h4>Masculins</h4>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $adj3Decl and matches(@ana, 'ADJ.*#m')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h4>Féminins</h4>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[@lemma = $adj3Decl and matches(@ana, 'ADJ.*#f')]" group-by="@lemma">
                    <xsl:sort/>
                    <h5><xsl:value-of select="current-grouping-key()"/></h5>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h3>Altérations de la finale</h3>
                <p><b>Finale en -z</b>
                <xsl:variable name="finalesZ" 
                    select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ)') and ends-with(., 'z')]/@lemma"/>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ)') and ends-with(., 'z')]"/>
                </xsl:call-template>
                <br/><b>Finales en -s qui devraient être en -z:</b> 
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ)') and ends-with(., 's') and (matches(@lemma, concat('(t|d|(', $cons, '|i)n|il)\d?$')) or @lemma = $finalesZ)]"/>
                    </xsl:call-template>
                    <br/><b>Hypercorrections? </b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ)') and ends-with(., 'z') and not(matches(@lemma, concat('(t|d|', $cons, 'n|il|z)\d?$')))]"/>
                    </xsl:call-template>
                </p>
                <h2>Déterminants</h2>
                <h3>Article défini</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[@lemma = 'le' and tokenize(@ana, ' ')[1] = '#DETdef' ]"></xsl:with-param>
                </xsl:call-template>
                <p><b>Contraction ou pour en le (cf. Dees 1987, carte 91)</b>
                <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma = 'en1+le' and matches(@ana, '#s')]
                        "></xsl:with-param>
                </xsl:call-template>
                </p>
                <h3>Article non défini</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[@lemma = 'un'  and tokenize(@ana, ' ')[1] = '#DETndf' ]"></xsl:with-param>
                </xsl:call-template>
                <h2>Indéfinis</h2>
                <p>NB: songer à voir les cartes de Dees 1987 sur les indéfinis, cartes 44-62, et ensuite encore passim jusque carte 97</p>
                <p>Pourcentage d'emploi de l'article devant 'on':
                <br /><b>l'on:</b> <xsl:value-of 
                    select="count($arborescenceRegul//descendant::tei:w[@lemma = 'on' and preceding::tei:w[1]/@lemma = 'le' ])
                    div
                    count($arborescenceRegul//descendant::tei:w[@lemma = 'on'])
                    "/>
                    <b>on:</b> <xsl:value-of 
                        select="count($arborescenceRegul//descendant::tei:w[@lemma = 'on' and not(preceding::tei:w[1]/@lemma = 'le' )])
                        div
                        count($arborescenceRegul//descendant::tei:w[@lemma = 'on'])
                        "/>
                
                </p>
                <b>Lemmes concernés:</b> 
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJind|PROind|DETind)')]/@lemma"/>
                </xsl:call-template>
                <br /><b>Emplois:</b>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJind|PROind|DETind)')]" group-by="@lemma">
                    <xsl:sort order="ascending"/>
                    <xsl:value-of select="current-grouping-key()"/><xsl:text>: </xsl:text>
                    <xsl:for-each-group select="current-group()" group-by="tokenize(@ana, ' ')[1]">
                        <xsl:value-of select="current-grouping-key()"/> <xsl:text> (</xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                        <xsl:text>) </xsl:text>
                    </xsl:for-each-group>
                    <br/>
                </xsl:for-each-group>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="withCRI" select="true()"/>
                    <xsl:with-param name="withNeutral" select="true()"/>
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJind|PROind|DETind)')]"/>
                </xsl:call-template>
                
                <h2>Numéraux</h2>
                <h3>Cardinaux</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJ|DET|PRO)car')]"/>
                    <!--<xsl:with-param name="invariable_en_genre" select="true()"/>-->
                </xsl:call-template>
                <h4>Ordinaux</h4>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJ|PRO)ord')]"/>
                </xsl:call-template>
                <h2>Possessifs</h2>
                <b>Emplois comme déterminants:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'DETpos')]/@lemma"></xsl:with-param></xsl:call-template>
                <br/><b>Emplois comme adjectifs:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'ADJpos')]/@lemma"></xsl:with-param></xsl:call-template>
                <br/><b>Emplois comme pronoms:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'PROpos')]/@lemma"></xsl:with-param></xsl:call-template>
                <h3>Déterminants</h3>
                <!--<xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'DETpos')]" group-by="tokenize(@ana, ' ')[2]">
                    <xsl:sort/>
                    <h4>
                    <xsl:value-of select="current-grouping-key()"/>
                    </h4>
                    <xsl:for-each-group select="current-group()" group-by="@lemma">
                        <xsl:sort/>
                        <h5>
                            <xsl:value-of select="current-grouping-key()"/>
                        </h5>
                        <xsl:for-each-group select="current-group()" group-by="tokenize(@ana, ' ')[4]">
                            <h6>
                                <xsl:value-of select="current-grouping-key()"/>
                            </h6>
                                <xsl:variable name="currentGroup" select="current-group()"/>
                                <table>
                                    <tr>
                                        <td/>
                                        <th>Sg.</th>
                                        <th>Pl.</th>
                                    </tr>
                                    <tr>
                                        <th>CS</th>
                                        <td>
                                            <xsl:call-template name="makeWordCellValue">
                                                <xsl:with-param name="groupe"
                                                    select="$currentGroup[tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[5] = '#n']"
                                                />
                                            </xsl:call-template>
                                        </td>
                                        <td>
                                            <xsl:call-template name="makeWordCellValue">
                                                <xsl:with-param name="groupe"
                                                    select="$currentGroup[tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[5] = '#n']"
                                                />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>CR</th>
                                        <td>
                                            <xsl:call-template name="makeWordCellValue">
                                                <xsl:with-param name="groupe"
                                                    select="$currentGroup[tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[5] = '#r']"
                                                />
                                            </xsl:call-template>
                                        </td>
                                        <td>
                                            <xsl:call-template name="makeWordCellValue">
                                                <xsl:with-param name="groupe"
                                                    select="$currentGroup[tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[5] = '#r']"
                                                />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                </table>
                        </xsl:for-each-group>
                    </xsl:for-each-group>
                </xsl:for-each-group>-->
                <h4>Déterminant</h4>
                <xsl:call-template name="makePossessiveTable">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'DETpos')]"/>
                </xsl:call-template>
                <h3>Adjectifs ou pronoms</h3>
                <xsl:call-template name="makePossessiveTable">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJpos|PROpos)')]"/>
                </xsl:call-template>
                <!--<h3>Adjectifs ou pronoms</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(ADJpos|PROpos)')]"></xsl:with-param>
                </xsl:call-template>-->
                <h2>Démonstratifs</h2>
                <b>Emplois comme déterminants:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'DETdem')]/@lemma"></xsl:with-param></xsl:call-template>
                <br/><b>Emplois comme adjectifs:</b> <xsl:call-template name="comptageFormes"><xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'PROdem')]/@lemma"></xsl:with-param></xsl:call-template>
                <h3>Sans distinction</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="withCRI" select="true()"/>
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(DETdem|PROdem)')]"/>
                </xsl:call-template>
                <h3>Déterm.</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="withCRI" select="true()"/>
                    <xsl:with-param name="withNeutral" select="true()"/>
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'DETdem')]"/>
                </xsl:call-template>
                <h3>Pron.</h3>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="withCRI" select="true()"/>
                    <xsl:with-param name="withNeutral" select="true()"/>
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'PROdem')]"/>
                </xsl:call-template>
                
                <h2>Pronoms personnels</h2>
                <xsl:call-template name="makePronounTable">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[tokenize(@ana, ' ')[1] = '#PROper']"/>
                </xsl:call-template>
                <h3>Pron. indéf. 'on'</h3>>
                <xsl:call-template name="makeWordTable" >
                    <xsl:with-param name="currentGroup" select="$arborescenceRegul/descendant::tei:w[@lemma='on']"></xsl:with-param>
                </xsl:call-template>
                <h3>Pronoms adverbiaux</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[tokenize(@ana, ' ')[1] = '#PROadv']"></xsl:with-param>
                </xsl:call-template>
                <h2>Pronoms relatifs</h2>
                <xsl:call-template name="makeRelativeTable">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[tokenize(@ana, ' ')[1] = '#PROrel']"></xsl:with-param>
                </xsl:call-template>
                <br />
                <b>Emploi par formes</b>
                <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[tokenize(@ana, ' ')[1] = '#PROrel']" group-by="@lemma">
                    <xsl:sort/>
                    <br/><b>
                    <xsl:value-of select="current-grouping-key()"/>
                    </b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param name="groupe" select="current-group()/@ana"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                <h2>Entorses au système bicasuel selon les catégories</h2>
                <h3>Global</h3>
                <p>
                    <b>TOTAUX:</b><br />
                    <b>Nombre d'entorses:</b> <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa)') and matches(@ana, '#M:')])"/>
                    <b>Ratio</b> <xsl:value-of select="
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa)') and matches(@ana, '#M:')])
                        div
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa)')])
                        * 100
                        "/>
                </p>
                <!-- TODO: faire un template pour cela -->
                <table>
                    <td/>
                    <tr>
                        <th>Usages fautifs</th>
                        <th>Usages corr.</th>
                    </tr>
                    <xsl:for-each-group select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa)')]" group-by="tokenize(@ana, ' ')[1]">
                        <tr>
                            <td><xsl:value-of select="current-grouping-key()"/></td>
                            <td>
                                <xsl:value-of select="count(current-group()[matches(@ana, '#M:')])"/>
                            </td>
                            <td>
                                <xsl:value-of select="count(current-group()[not(matches(@ana, '#M:'))])"/>
                            </td>
                        </tr>
                    </xsl:for-each-group>
                </table>
                <h3>Masc. sg. nom. seul</h3>
                <table>
                    <td/>
                    <tr>
                        <th>Usages fautifs</th>
                        <th>Usages corr.</th>
                    </tr>
                    <xsl:for-each-group 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa).*#s\s+#m\s+#n')]"
                        group-by="tokenize(@ana, ' ')[1]">
                        <tr>
                            <td><xsl:value-of select="current-grouping-key()"/></td>
                            <td>
                                <xsl:value-of select="count(current-group()[matches(@ana, '#M:')])"/>
                            </td>
                            <td>
                                <xsl:value-of select="count(current-group()[not(matches(@ana, '#M:'))])"/>
                            </td>
                        </tr>
                    </xsl:for-each-group>
                </table>
                <h3>Masc. pl. nom. seul</h3>
                <table>
                    <td/>
                    <tr>
                        <th>Usages fautifs</th>
                        <th>Usages corr.</th>
                    </tr>
                    <xsl:for-each-group 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '(NOM|ADJ|PRO|DET|VERppe|VERppa).*#p\s+#m\s+#n')]"
                        group-by="tokenize(@ana, ' ')[1]">
                        <tr>
                            <td><xsl:value-of select="current-grouping-key()"/></td>
                            <td>
                                <xsl:value-of select="count(current-group()[matches(@ana, '#M:')])"/>
                            </td>
                            <td>
                                <xsl:value-of select="count(current-group()[not(matches(@ana, '#M:'))])"/>
                            </td>
                        </tr>
                    </xsl:for-each-group>
                </table>
                <h3>Entorses au CS en fonction de la position du sujet par rapport au verbe</h3>
                <h4>Sujet antéposé</h4>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n.*#M:')) and following-sibling::tei:w[matches(@ana, '#VERcjg')]])
                    div
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n')) and following-sibling::tei:w[matches(@ana, '#VERcjg')]])
                    "/>
                <h4>Sujet postposé</h4>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n.*#M:')) and preceding-sibling::tei:w[matches(@ana, '#VERcjg')]])
                    div
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n')) and preceding-sibling::tei:w[matches(@ana, '#VERcjg')]])
                    "/>
                <h5>Sujet coordonné</h5>
                <p>Sujet qui fait immédiatement suite à et</p>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n.*#M:')) and preceding::tei:w[1]/@lemma = 'et'])
                    div
                    count($arborescenceRegul/descendant::tei:w
                    [matches(@ana, ('#(m|f|n)\s+#n.*')) and preceding::tei:w[1]/@lemma = 'et'])
                    "/>
                
                <h2>Morphologie verbale</h2>
                <p>N.B.: les trois premières sont surtout là pour des vérifications; les 4-6 pour l'analyse (on pourra retirer le filtre sur les temps si on veut tout tester)</p>
                <h4>Terminaisons de la 1re personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*1\s+#s')]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Terminaisons de la 2e personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*2\s+#s')]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Terminaisons de la 3e personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*3\s+#s')]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Terminaisons de la 4e personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*1\s+#p')]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Terminaisons de la 5e personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*2\s+#p')]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Terminaisons de la 6e personne</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*(pst|imp|fut).*3\s+#p')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h3>Présents</h3>
                <h4>Verbes en -er</h4>
                <p>Désinence de la P3 des verbes en -er, cf. Dees 1987, carte 438 + Dees 1980, carte 217</p>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#pst.*#3\s+#s')
                        and matches(@lemma, 'er\d?$')
                        ]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Tous les présents de l'ind. en -er</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#pst.*')
                        and matches(@lemma, 'er\d?$')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Tous les présents de l'ind. en -ir</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#pst.*')
                        and matches(@lemma, '[^o]ir\d?$')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Tous les autres présents de l'ind.</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#pst.*')
                        and not(matches(@lemma, 'er\d?$') or matches(@lemma, '[^o]ir\d?$'))
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Tous les présents du subj. en -er</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#sub\s+#pst.*')
                        and matches(@lemma, 'er\d?$')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Tous les présents du subj. en -ir</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#sub\s+#pst.*')
                        and matches(@lemma, '[^o]ir\d?$')
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Tous les autres présents du subj.</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#sub\s+#pst.*')
                        and not(matches(@lemma, 'er\d?$') or matches(@lemma, '[^o]ir\d?$'))
                        ]"></xsl:with-param>
                </xsl:call-template>
                
                <h3>Parfaits</h3>
                <h4>Verbes en -er</h4>
                <h5>P1</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#1\s+#s')]"/>
                </xsl:call-template>
                <h5>P2</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#2\s+#s')]"/>
                </xsl:call-template>
                <h5>P3, -at ou -aø, cf. Dees 1980 carte 233</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#3\s+#s')]"/>
                </xsl:call-template>
                <h5>P4, -ins?</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#1\s+#p')]"/>
                </xsl:call-template>
                <h5>P5</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#2\s+#s')]"/>
                </xsl:call-template>
                <h5>P6, -arent ou -erent, Dees 1980 carte 234</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and matches(@ana, 'VERcjg.*#psp.*#3\s+#p')]"/>
                </xsl:call-template>
                <h4>Parfaits faibles en -i/3e en -i</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and
                        matches(@lemma, '[^o]ir\d?$')
                        and not(@lemma = ( $parfaitsFortsEnI, $parfaitsFortsEnS, $parfaitsFortsEnU, $parfaitsFaiblesEnUI))
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Parfaits faibles en -i/3e en -ié</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and
                        matches(@lemma, 're\d?$')
                        and not(@lemma = ( $parfaitsFortsEnI, $parfaitsFortsEnS, $parfaitsFortsEnU, $parfaitsFaiblesEnUI  ))
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Parfaits faibles en -ui</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and @lemma = $parfaitsFaiblesEnUI
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Parfaits forts en -i</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and @lemma = $parfaitsFortsEnI
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Parfaits forts en -s</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and @lemma = $parfaitsFortsEnS
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h4>Parfaits forts en -u</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#ind\s+#psp')
                        and @lemma = $parfaitsFortsEnU
                        ]"></xsl:with-param>
                </xsl:call-template>
                <h3>Subj. imparfait</h3>
                <h4>Type en -asse</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#sub\s+#ipf')
                        and matches(@lemma, 'er\d?$')
                        ]"/>
                </xsl:call-template>
                <h4>Type en -isse</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#sub\s+#ipf')
                        and (matches(@lemma, 're\d?$') or matches(@lemma, '[^o]ir\d?$')
                        or @lemma = ($parfaitsFortsEnI, $parfaitsFortsEnS))
                        and not(@lemma = ($parfaitsFortsEnU, $parfaitsFaiblesEnUI)
                        )
                        ]"/>
                </xsl:call-template>
                <h4>Type en -usse</h4>
                <h5>En base passé faible -ui</h5>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#sub\s+#ipf')
                        and @lemma = ($parfaitsFaiblesEnUI)
                        ]"/>
                </xsl:call-template>
                <h5>En base passé fort -u</h5>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg\s+#sub\s+#ipf')
                        and @lemma = ($parfaitsFortsEnU)
                        ]"/>
                </xsl:call-template>
                
                <h3>Futurs</h3>
                <p><b>Voir 3e pers. du sg (-t ou pas; ai/ei ou a)</b></p>>
                    <xsl:call-template name="verbalDesinentia">
                        <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERcjg.*#fut.*')]"/>
                    </xsl:call-template>
                <h3>Conditionnels</h3>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERcjg.*#con.*')]"/>
                </xsl:call-template>
                <h3>nr > rr > r dans futur et conditionnels</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                            matches(@ana, 'VERcjg.*#(con|fut)')
                        and matches(@lemma, 'n')
                        and not(matches(., 'n\w'))
                        ]"/>
                </xsl:call-template>
                <h3>rr > r</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERcjg.*#(con|fut)')
                        and not(matches(., 'rr'))
                        ]"/>
                </xsl:call-template>
                
                <h3>Imparfaits</h3>
                <h4>Désinence de la P3 des verbes en -er, cf. Dees, carte 442</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#ipf.*3\s+#s')
                        and matches(@lemma, 'er\d?$')
                        ]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Désinences de la P4, cf. Dees, carte 443</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#ipf.*1\s+#p')
                        and matches(@lemma, 'er\d?$')
                        ]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Désinences de la P6, cf. Dees, carte 444</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, '#VERcjg.*#ind\s+#ipf.*3\s+#p')
                        and matches(@lemma, 'er\d?$')
                        ]"/>
                    <xsl:with-param name="longueur" select="1"/>
                </xsl:call-template>
                <h4>Tous les imparfaits</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERcjg.*#ind\s+#ipf.*')]"/>
                </xsl:call-template>
                <h4>Tous les impératifs</h4>
                <xsl:call-template name="verbalDesinentia">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERcjg.*#imp.*')]"/>
                </xsl:call-template>
                <h3>Participe présent</h3>
                <h4>Répartition selon les usages</h4>
                <p>
                    <b>Emplois verbaux:</b> <xsl:value-of 
                        select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')])"/>
                    (   <xsl:value-of 
                        select="
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')])
                        div
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa')])
                        * 100
                        "/>%)
                </p>
                <p>
                    <b>Emplois nominaux:</b> 
                    <xsl:value-of 
                        select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#(s|p)\s+#(m|f|n)\s+#(n|r)')])"/>
                    (   <xsl:value-of 
                        select="
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#(s|p)\s+#(m|f|n)\s+#(n|r)')])
                        div
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa')])
                        * 100
                        "/>%)
                </p>
                <h4>Emplois nominaux</h4>
                <p>
                    <b>flexion:</b>
                </p>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates 
                        mode="getDesinentia" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h4>Emplois verbaux</h4>
                <p><b>Constructions avec le verbe aler:</b>
                    <xsl:value-of 
                        select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')
                        and ancestor::tei:l/descendant::tei:w[@lemma = 'aler']
                        ])"/>
                    (   <xsl:value-of 
                        select="
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')
                        and ancestor::tei:l/descendant::tei:w[@lemma = 'aler']
                        ])
                        div
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')])
                        "/>%)
                </p>
                <p><b>Précédé de en</b>
                    <xsl:value-of 
                        select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')
                        and preceding::tei:w[1]/@lemma = 'en1'
                        ])"/>
                    (   <xsl:value-of 
                        select="
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')
                        and preceding::tei:w[1]/@lemma = 'en1'
                        ])
                        div
                        count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')])
                        "/>%)
                </p>
                <p>
                    <b>Sondage élargi: mot précédant le participe présent</b>
                    <xsl:call-template name="comptageFormes">
                        <xsl:with-param 
                            name="groupe" 
                            select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppa\s+#x\s+#x\s+#x')]/preceding::tei:w[1]"/>
                    </xsl:call-template>
                </p>
                <h4>Finales des participes présents</h4>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppa')
                        and not(matches(., 'a(n|&#x0303;)t'))
                        ]"/>
                </xsl:call-template>
                <h3>Déclinaison des participes présents</h3>
                <h4>Masc.</h4>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppa.*#m')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h4>Fém.</h4>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppa.*#f')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h4>Gérondif invariable</h4>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppa.*#x')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>                
                
                
                <h3>Participes passés</h3>
                <h4>Finales</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h4>Finales par groupe</h4>
                <h5>Type faible en -é</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe') and matches(@lemma, 'er\d?$')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h5>Type faible en -i</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe') 
                        and (matches(@lemma, '[^o]ir\d?$')
                        and not(@lemma = ($parfaitsFaiblesEnUI, $parfaitsFortsEnU, $parfaitsFortsEnI))
                        )]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h5>Type faible en -u</h5>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param 
                        name="groupe" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe') 
                        and @lemma = ($parfaitsFaiblesEnUI, $parfaitsFortsEnU, $parfaitsFortsEnI)]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template>
                <h5>Type en -eit?</h5>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe') 
                        and matches(., '(e|o)i(t|z|s)$')]
                        "></xsl:with-param>
                </xsl:call-template>
                    <h5>Types forts</h5>
                        <xsl:call-template name="phonolFinales">
                            <xsl:with-param 
                                name="groupe" 
                                select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe') 
                                and @lemma =($parfaitsFortsEnS)]"/>
                            <xsl:with-param name="longueur" select="2"/>
                        </xsl:call-template>
                
                
                <h4>Finales des fém. du 1er gr. (iee / ie)</h4>
                <p><b>iee > ie</b><xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe.*#f') and matches(@lemma, 'ier\d?$')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template></p>
                
                <p><b>Sondage élargi:</b><xsl:call-template name="phonolFinales">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERppe.*#f') and matches(@lemma, 'er\d?$')]"/>
                    <xsl:with-param name="longueur" select="2"/>
                </xsl:call-template></p>
                
                <h4>Déclinaison</h4>
                <h5>Masc.</h5>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#m')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h5>Fém.</h5>
                <xsl:variable name="monGroupe">
                    <xsl:apply-templates mode="getDesinentia" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#f')]"/>
                </xsl:variable>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="$monGroupe/descendant::tei:w"/>
                </xsl:call-template>
                <h4>Accords des participes passés</h4>
                <h5>Avec estre1</h5>
                <h6>Masculin</h6>
                <!-- NB: il vaut mieux faire ce comptage dans le fichier pour avoir les contextes -->
                <b>Nombre de cas sans accord:</b>
                <p><b>Singulier</b>
                    <br /><b>Accord:</b> <xsl:value-of select="
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#n')
                        and matches(., '(z|s)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ])
                        "/>
                    <br /><b>Pas d'accord</b>
                    <xsl:value-of select="count(
                        $arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#n')
                        and not(matches(., '(z|s)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ]
                        )"/>
                    <br />
                    <b>Pluriel</b>
                    <b>Accord:</b> <xsl:value-of select="
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#n')
                        and not(matches(., '(z|s)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ])
                        "/>
                    <b>Pas d'accord</b>
                    <xsl:value-of select="count(
                        $arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#n')
                        and matches(., '(z|s)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ]
                        )"/>
                </p>
                <br /><b>Singulier, contexte des cas sans accord:</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#n')
                        and not(matches(., '(z|s)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#s\s+#m\s+#n') 
                    and not(matches(., '(z|s)$'))
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <br /><b>Pluriel</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#n')
                        and matches(., '(z|s)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#p\s+#m\s+#n') 
                    and matches(., '(z|s)$')
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <h6>PP féminins</h6>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#f')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#f') 
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'estre1']]
                    ]">
                    <p><b><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <h5>Avec avoir</h5>
                <h6>Masculin</h6>
                <!-- NB: il vaut mieux faire ce comptage dans le fichier pour avoir les contextes -->
                <p><b>Singulier</b>
                    <br /><b>Accord:</b> <xsl:value-of select="
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#r')
                        and not(matches(., '(z|s)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ])
                        "/>
                    <br /><b>Pas d'accord</b>
                    <xsl:value-of select="count(
                        $arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#r')
                        and matches(., '(z)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ]
                        )"/>
                    <br />
                    <b>Pluriel</b>
                    <b>Accord:</b> <xsl:value-of select="
                        count($arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#r')
                        and matches(., '(z)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ])
                        "/>
                    <b>Pas d'accord</b>
                    <xsl:value-of select="count(
                        $arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#r')
                        and not(matches(., '(z)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ]
                        )"/>
                </p>
                
                <b>Nombre de cas sans accord:</b>
                <br /><b>Singulier</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#s\s+#m\s+#r')
                        and matches(., '(z)$')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#s\s+#m\s+#r') 
                    and matches(., '(z)$')
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <br /><b>Pluriel</b>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[
                        matches(@ana, 'VERppe.*#p\s+#m\s+#r')
                        and not(matches(., '(z)$'))
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#p\s+#m\s+#r')
                    and not(matches(., '(z)$'))
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <h6>PP féminins</h6>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#f')
                        and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                        ]"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, 'VERppe.*#f') 
                    and ancestor::tei:l[descendant::tei:w[@lemma = 'avoir']]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                
                
                
                <h3>Infinitifs</h3>
                <h4>Finales du 1er groupe</h4>
                <xsl:call-template name="phonolFinales">
                    <xsl:with-param name="longueur" select="2" as="xs:integer"/>
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(@lemma, 'er\d?$') and tokenize(@ana, ' ')[1] =  '#VERinf']"/>
                </xsl:call-template>
                
                <h1>Syntaxe</h1>
                <h2>Ordre des mots et structure du vers</h2>
                <xsl:variable name="filename"
                    select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>
                
               <xsl:result-document href="../../../Langue/scripta/R/detail_ms/{$filename}_positions.csv">
                   <xsl:text>ID,POS,LEMME,POSITION&#xA;</xsl:text>
                   <xsl:apply-templates select="$arborescenceRegul/descendant::tei:w" mode="csv_positions"/>
               </xsl:result-document> 
               
                <h2>Expression du sujet</h2>
                <h3>Vers sans sujet exprimé</h3>
                <h4>Total</h4>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:l[not(descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')])])
                    div
                    count($arborescenceRegul/descendant::tei:l)
                    "/>
                <h4>Discours direct</h4>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:l[descendant::tei:q and not(descendant::tei:q/descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')])])
                    div
                    count($arborescenceRegul/descendant::tei:l[descendant::tei:q])
                    "/>
                <h4>Hors discours direct</h4>
                <xsl:value-of select="
                    count($arborescenceRegul/descendant::tei:l[
                    child::element()/local-name() != 'q' and
                    not(descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n') and not(ancestor::tei:q)])
                    ])
                    div
                    count($arborescenceRegul/descendant::tei:l[child::element()/local-name() != 'q'])
                    "/>
                
                <!-- IMPORTANT: ici, on se simplifie la vie, en ne gardant que les q et les w dans les vers-->
                <xsl:variable name="arborescenceSyntaxe">
                    <xsl:apply-templates select="$arborescenceRegul" mode="syntaxe"/>
                </xsl:variable>
                <xsl:result-document href="arborescence_syntaxe.xml">
                    <xsl:copy-of select="$arborescenceSyntaxe"/>
                </xsl:result-document>
                <!-- /// -->
                
                <h3>Vers sans sujet exprimé dans les vers introduits par un objet direct (hors réfléchi), un infinitif, un participe</h3>
                <h4>Total</h4>
                <xsl:value-of select="
                    count(
                    $arborescenceSyntaxe/descendant::tei:l[
                    descendant::tei:w[matches(@ana, '((NOM|PRO).*#r)|VERinf|VERppe|VERppa') and not(@lemma='soi1')]/following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and
                    not(descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')])])
                    div
                    count($arborescenceSyntaxe/descendant::tei:l[
                    descendant::tei:w[matches(@ana, '((NOM|PRO).*#r)|VERinf|VERppe|VERppa')  and not(@lemma='soi1')]/following-sibling::tei:w[matches(@ana, 'VERcjg')]])
                    "/>
                
                <h3>Place du sujet par rapport au verbe</h3>
                <h4>Globale</h4>
                <xsl:call-template name="placeSujet">
                    <xsl:with-param name="lines" select="$arborescenceSyntaxe/descendant::tei:l"/>
                </xsl:call-template>
                <h4>En cas d'antéposition d'un objet direct (réfléchi excepté)</h4>
                <xsl:call-template name="placeSujet">
                    <xsl:with-param name="lines" select="
                        $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                            and not(@lemma = 'soi1')
                            and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                            and not(preceding-sibling::tei:w[matches(@ana, 'VERcjg')])
                            ]
                        ]"/>
                </xsl:call-template>
                <h4>En cas d'antéposition d'un objet direct (réfléchi excepté et pronom personnel seul)</h4>
                <xsl:call-template name="placeSujet">
                    <xsl:with-param name="lines" select="
                        $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                        and not(@lemma = 'soi1')
                        and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                        and not(preceding-sibling::tei:w[matches(@ana, 'VERcjg')])
                        ]
                        ]"/>
                    <xsl:with-param name="sujet" select="'#PRO.*#(m|f|n)\s+#n'"></xsl:with-param>
                </xsl:call-template>
                <h4>En cas d'antéposition d'un objet direct (réfléchi excepté et nom seul)</h4>
                <xsl:call-template name="placeSujet">
                    <xsl:with-param name="lines" select="
                        $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                        and not(@lemma = 'soi1')
                        and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                        and not(preceding-sibling::tei:w[matches(@ana, 'VERcjg')])
                        ]
                        ]"/>
                    <xsl:with-param name="sujet" select="'#NOM.*#(m|f|n)\s+#n'"></xsl:with-param>
                </xsl:call-template>
                <h3>Pronoms personnels toniques par rapport au verbe</h3>
                <h4>Total</h4>
                <b>Avant: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '#PROper')
                    and (. ='mei' or .= 'moi' or . = 'mi' or . = 'tei' or . ='toi' or . ='lui' or . ='eus' or . ='ues' or . = 'els')
                    and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and not(preceding-sibling::tei:w[matches(@ana, 'VERcjg')])
                    ]
                    ])
                    "/>
                <b>Après: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '#PROper')
                    and (. ='mei' or .= 'moi' or . = 'mi' or . = 'tei' or . ='toi' or . ='lui' or . ='eus' or . ='ues' or . = 'els')
                    and preceding-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and not(following-sibling::tei:w[matches(@ana, 'VERcjg')])
                    ]
                    ])
                    "/>
                <h4>Discours direct</h4>
                <b>Avant: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:q[descendant::tei:w[matches(@ana, '#PROper')
                    and (. ='mei' or .= 'moi' or . = 'mi' or . = 'tei' or . ='toi' or . ='lui' or . ='eus' or . ='ues' or . = 'els')
                    and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and not(preceding-sibling::tei:w[matches(@ana, 'VERcjg')])
                    ]
                    ])
                    "/>
                <b>Après: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:q[descendant::tei:w[matches(@ana, '#PROper')
                    and (. ='mei' or .= 'moi' or . = 'mi' or . = 'tei' or . ='toi' or . ='lui' or . ='eus' or . ='ues' or . = 'els')
                    and preceding-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and not(following-sibling::tei:w[matches(@ana, 'VERcjg')])
                    ]
                    ])
                    "/>
                
                <h2>Objet direct</h2>
                <h3>Place de l'objet direct par rapport au verbe</h3>
                <h4>Avant</h4>
                <xsl:value-of select="count(
                    $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                    and not(@lemma = 'soi1')]/following-sibling::tei:w[matches(@ana, 'VERcjg')] ])
                    "/>
                <h4>Après</h4>
                <xsl:value-of select="count(
                    $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                    and not(@lemma = 'soi1')]/preceding-sibling::tei:w[matches(@ana, 'VERcjg')] ])
                    "/>
                <h3>Objet direct précédent le verbe, initial ou après le sujet</h3>
                <h4>Initial</h4>
                <xsl:value-of select="count(
                    $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                        and not(@lemma = 'soi1') 
                        and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                        and not(preceding-sibling::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')])
                    ] ] )
                    "/>
                <h4>Après le sujet</h4>
                <xsl:value-of select="count(
                    $arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[matches(@ana, '(NOM|PRO).*#r')
                    and not(@lemma = 'soi1') 
                    and following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    and preceding-sibling::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]
                    ] ] )
                    "/>
                <h3>Place de l'objet direct dans la relative introduite par qui</h3>
                <b>Avant: </b><!-- TODO: il faudrait remplacer toutes les occurrences de regex objet direct, etc. par un paramètre -->
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[@lemma = 'qui']
                    /following-sibling::tei:w[matches(@ana,  '(NOM|PRO).*#r')]/following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    ])
                    "/>
                <br /><b>Après: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:l[descendant::tei:w[@lemma = 'qui']
                    /following-sibling::tei:w[matches(@ana, 'VERcjg')]/following-sibling::tei:w[matches(@ana,  '(NOM|PRO).*#r')]
                    ])
                    "/>
                <h4>Discours direct</h4>
                <b>Avant: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:q[descendant::tei:w[@lemma = 'qui']
                    /following-sibling::tei:w[matches(@ana,  '(NOM|PRO).*#r')]/following-sibling::tei:w[matches(@ana, 'VERcjg')]
                    ])
                    "/>
                <br /><b>Après: </b>
                <xsl:value-of select="
                    count($arborescenceSyntaxe/descendant::tei:q[descendant::tei:w[@lemma = 'qui']
                    /following-sibling::tei:w[matches(@ana, 'VERcjg')]/following-sibling::tei:w[matches(@ana,  '(NOM|PRO).*#r')]
                    ])
                    "/>
                <h3>Verbe en position initiale du vers</h3>
                <h4>Impératifs</h4>
                <p><b>Total:</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*#imp') 
                        and . is ancestor::tei:l/descendant::tei:w[1] ])"/>
                </p>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*#imp') 
                    and . is ancestor::tei:l/descendant::tei:w[1]
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <h4>Annonce du discours direct</h4>
                <p><b>Total:</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*') 
                        and . is ancestor::tei:l/descendant::tei:w[1]
                        and @lemma = ('dire', 'respondre1')])"/>
                </p>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*') 
                    and . is ancestor::tei:l/descendant::tei:w[1]
                    and @lemma = ('dire', 'respondre1')]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                <h4>Autre cas</h4>
                <p><b>Total:</b>
                    <xsl:value-of select="count($arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*') 
                        and . is ancestor::tei:l/descendant::tei:w[1]
                        and not(@lemma = ('dire', 'respondre1'))
                        and not(matches(@ana, '#imp'))
                        ])"/>
                </p>
                <xsl:for-each select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VERcjg.*') 
                    and . is ancestor::tei:l/descendant::tei:w[1]
                    and not(@lemma = ('dire', 'respondre1'))
                    and not(matches(@ana, '#imp'))
                    ]">
                    <p><b ><xsl:value-of select="ancestor::tei:l/@n"/></b><xsl:value-of select="ancestor::tei:l"/></p>
                </xsl:for-each>
                
                
                
                <h1>Lexique</h1>
                <h2>Ewe</h2>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma='aigue']"></xsl:with-param>
                </xsl:call-template>
                <h2>Soleil</h2>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma='soleil']"></xsl:with-param>
                </xsl:call-template>
                <h2>Cuer2</h2>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma='cuer2']"></xsl:with-param>
                </xsl:call-template>
                <h2>poi</h2>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[@lemma='poi']"></xsl:with-param>
                </xsl:call-template>
                
                
                <!--<h4>Vers dans lequel un sujet se trouve avant un verbe conjugué</h4>
                <xsl:value-of select="
                    count(
                    $arborescenceRegul/descendant::tei:l[
                   /position() &lt; 
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    ])
                    "/>
                <br /><b>Dans le discours direct:</b>
                <xsl:value-of select="
                    count(
                    $arborescenceRegul/descendant::tei:l/descendant::tei:q[
                    descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]/position() &lt; 
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    ])
                    "/>
                
                <h4>Vers dans lequel un sujet se trouve après un verbe conjugué</h4>
                <xsl:value-of select="
                    count(
                    $arborescenceRegul/descendant::tei:l[
                    descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]/position() > 
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    ])
                    "/>
                <br /><b>Dans le discours direct:</b>
                <xsl:value-of select="
                    count(
                    $arborescenceRegul/descendant::tei:l/descendant::tei:q[
                    descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]/position() > 
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    ])
                    "/>
                <h4>Débogage: vers qui ne correspondent ni à l'un, ni à l'autre</h4>
                <xsl:for-each select="
                    $arborescenceRegul/descendant::tei:l[
                    not(
                    descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]/position() > 
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    )
                    and 
                    not(
                    descendant::tei:w[matches(@ana, '#(NOM|PRO).*#(m|f|n)\s+#n')]/position() &lt;
                    descendant::tei:w[matches(@ana, '#VERcjg')]/position()
                    )
                    ]
                    ">
                    <br/><xsl:value-of select="."/>
                </xsl:for-each>-->
                <h1>Question de résolution des abréviations</h1>
                <h2>Tilde droite</h2>
                <h3>com/con/cum/cun</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'c(o|u)(m|n|&#x0303;)')]"/>
                </xsl:call-template>
                <h3>m ou n devant p, b</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(m|n)(p|b)')]"/>
                </xsl:call-template>
                <h3>m devant t, d</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., 'm(t|d|g|s|c)')]"/>
                </xsl:call-template>
                <h3>m ou n devant t, d non finaux</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(m|n)(t|d|g|s|c).+')]"/>
                </xsl:call-template>
                <h3>m ou n devant m / n</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(m|n)(m|n)')]"/>
                </xsl:call-template>
                <h3>m ou n finale</h3>
                <xsl:call-template name="comptageFormes">
                    <xsl:with-param name="groupe" select="$arborescenceRegul/descendant::tei:w[matches(., '(m|n)$')]"/>
                </xsl:call-template>
            </body>
        </html>
        
    </xsl:template>
    
    
    <xsl:template name="paradigmes">
        <xsl:param name="arborescenceRegul"/>
        <html>
            <head/>
            <body>
                
                <h1>Paradigmes complets</h1>
                <!-- Substantifs -->
                <h2>Substantifs</h2>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#NOM')]"/>
                </xsl:call-template>
                <!-- Adjectifs -->
                <h2>Adjectifs</h2>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#ADJ')]"/>
                </xsl:call-template>
                <!-- Pronoms -->
                <h2>Pronoms</h2>
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param name="arborescenceRegul" select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#PRO')]"/>
                </xsl:call-template>
                <!-- Déterminants -->
                <xsl:call-template name="tableDeclinaison">
                    <xsl:with-param 
                        name="arborescenceRegul" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#DET')]"/>
                </xsl:call-template>
                <!-- Verbes -->
                <h1>Verbes</h1>
                <xsl:call-template name="verbes">
                    <xsl:with-param 
                        name="arborescenceRegul" 
                        select="$arborescenceRegul/descendant::tei:w[matches(@ana, '#VER')]"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>
    
    <!-- PHONOLOGIE -->
    <xsl:template name="comptageFormes">
        <xsl:param name="groupe"/>
        <xsl:for-each-group select="$groupe" group-by=".">
            <xsl:sort/>
            <xsl:value-of select="current-grouping-key()"/> 
            <xsl:text> (</xsl:text><xsl:value-of select="count(current-group())"/><xsl:text>), </xsl:text>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="graphiesAltern">
        <xsl:param name="graphies"/>
        <xsl:param name="groupe"/>
        <b>Tous les mots</b><br/>
        <xsl:call-template name="graphiesAlternIndiv">
            <xsl:with-param name="graphies" select="$graphies"/>
            <xsl:with-param name="groupe" select="$groupe"/>
        </xsl:call-template>
        <b>Sauf ceux à l'assonance</b><br/>
        <xsl:call-template name="graphiesAlternIndiv">
            <xsl:with-param name="graphies" select="$graphies"/>
            <xsl:with-param name="groupe" select="$groupe[not(. is ancestor::tei:l/descendant::tei:w[last()])]"/>
        </xsl:call-template>
        <b>Uniquement ceux à l'assonnance</b><br/>
        <xsl:call-template name="graphiesAlternIndiv">
            <xsl:with-param name="graphies" select="$graphies"/>
            <xsl:with-param name="groupe" select="$groupe[. is ancestor::tei:l/descendant::tei:w[last()]]"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- graphies alternatives -->
    <xsl:template name="graphiesAlternIndiv">
        <xsl:param name="graphies"/>
        <xsl:param name="groupe"/>
        <xsl:for-each select="$graphies">
            <b><xsl:value-of select="."/> :</b>
            <xsl:variable name="graphie" select="."/>
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="autreGraphie" select="$graphies[position() != $pos]"/>
            <xsl:value-of select="round-half-to-even(
                count($groupe[matches(., $graphie) and not(matches(., $autreGraphie))])
                div
                count($groupe)
                , 4)
                "/> 
            <br/>
        </xsl:for-each>
        
    </xsl:template>
    <!-- Finales -->
    <xsl:template name="phonolFinales">
        <xsl:param name="groupe"/>
        <xsl:param name="longueur" select="3" as="xs:integer"/>
        <b>Tous les mots</b><br/>
        <xsl:call-template name="phonolFinalesIndiv">
            <xsl:with-param name="groupe" select="$groupe"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <b>Sauf ceux à l'assonance</b><br/>
        <xsl:call-template name="phonolFinalesIndiv">
            <xsl:with-param name="groupe" select="$groupe[not(. is ancestor::tei:l/descendant::tei:w[last()])]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <b>Uniquement ceux à l'assonnance</b><br/>
        <xsl:call-template name="phonolFinalesIndiv">
            <xsl:with-param name="groupe" select="$groupe[. is ancestor::tei:l/descendant::tei:w[last()]]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="phonolFinalesIndiv">
        <xsl:param name="groupe"/>
        <xsl:param name="longueur" select=" 3 " as="xs:integer"/>
        <xsl:variable name="groupeTotal" select="count($groupe)"/>
        <xsl:for-each-group 
            select="$groupe"
            group-by="substring(., (string-length(.) - $longueur))"
            >
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="round(count(current-group()) div $groupeTotal * 100)"/>
            <xsl:text>%, fr.a. </xsl:text>
            <xsl:value-of select="count(current-group())"/>
            <xsl:text>) </xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:value-of select="."/>
                <xsl:text>, </xsl:text>
            </xsl:for-each>
            <br/>
        </xsl:for-each-group>
    </xsl:template>
    
    <!-- MORPHOLOGIE -->
<xsl:template match="node() | @*" mode="getDesinentia">
    <xsl:copy>
        <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
</xsl:template>    
    <xsl:template match="tei:w" mode="getDesinentia">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="substring(., string-length(.))"/>
        </xsl:copy>
    </xsl:template>
    <!-- COMPTAGES MORPHOLOGIQUES GLOBAUX -->
    <xsl:template name="frequenceAbsolue">
        <xsl:param name="groupe"/>
        <p>fr.a. totale: 
            <xsl:value-of select="count($groupe)"/>
            <br />
            CSS: <xsl:value-of select="count($groupe[matches(@ana, '#s\s+#(f|m|n)\s+#n')])"/><br />
            CRS: <xsl:value-of select="count($groupe[matches(@ana, '#s\s+#(f|m|n)\s+#r')])"/><br />
            CSP: <xsl:value-of select="count($groupe[matches(@ana, '#p\s+#(f|m|n)\s+#n')])"/><br />
            CRP: <xsl:value-of select="count($groupe[matches(@ana, '#p\s+#(f|m|n)\s+#r')])"/><br />
        </p>
    </xsl:template>

    <!-- SUBSTANTIFS -->
    <xsl:template name="tableDeclinaison">
        <!-- <w lemma="françois" ana="#NOMpro #p #m #n " xml:id="M_w_000003"> -->
        <xsl:param name="arborescenceRegul"/>
        <xsl:param name="withCRI" select="false()"/>
        <xsl:param name="withNeutral" select="false()"/>
        <xsl:param name="invariable_en_genre" select="false()"/>
        <xsl:choose>
            <xsl:when test="$invariable_en_genre = true()">
                <xsl:for-each-group
                    select="$arborescenceRegul"
                    group-by="@lemma">
                    <xsl:sort select="@lemma" order="ascending" data-type="text"/>
                    <h4>
                        <xsl:value-of select="current-grouping-key()"/>
                    </h4>
                    <xsl:call-template name="makeWordTable">
                        <xsl:with-param name="currentGroup" select="current-group()"/>
                        <xsl:with-param name="withCRI" select="$withCRI"/>
                    </xsl:call-template>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
        <h3>Masculins</h3>
        <xsl:for-each-group
            select="$arborescenceRegul[tokenize(@ana, ' ')[3] = '#m']"
            group-by="@lemma">
            <xsl:sort select="@lemma" order="ascending" data-type="text"/>
            <h4>
                <xsl:value-of select="current-grouping-key()"/>
            </h4>
            <xsl:call-template name="makeWordTable">
                <xsl:with-param name="currentGroup" select="current-group()"/>
                <xsl:with-param name="withCRI" select="$withCRI"/>
            </xsl:call-template>
        </xsl:for-each-group>

        <h3>Féminins</h3>
        <xsl:for-each-group
            select="$arborescenceRegul[tokenize(@ana, ' ')[3] = '#f']"
            group-by="@lemma">
            <xsl:sort select="@lemma" order="ascending" data-type="text"/>
            <h4>
                <xsl:value-of select="current-grouping-key()"/>
            </h4>
            <xsl:call-template name="makeWordTable">
                <xsl:with-param name="currentGroup" select="current-group()"/>
            </xsl:call-template>
        </xsl:for-each-group>
        <xsl:if test="$withNeutral">
            <h3>Neutres</h3>
            <xsl:for-each-group
                select="$arborescenceRegul[tokenize(@ana, ' ')[3] = '#n']"
                group-by="@lemma">
                <xsl:sort select="@lemma" order="ascending" data-type="text"/>
                <h4>
                    <xsl:value-of select="current-grouping-key()"/>
                </h4>
                <xsl:call-template name="makeWordTable">
                    <xsl:with-param name="currentGroup" select="current-group()"/>
                </xsl:call-template>
            </xsl:for-each-group>
        </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="makeWordTable">
        <xsl:param name="currentGroup"/>
        <xsl:param name="withCRI" select="false()"/>
        <xsl:call-template name="frequenceAbsolue">
            <xsl:with-param name="groupe" select="$currentGroup"/>
        </xsl:call-template>
        <!--Frequence absolue totale: <xsl:value-of select="count($currentGroup)"/><br/>
        CSS: <xsl:value-of select="count($currentGroup[matches(@ana, '#s\s+#(m|f|n|x)\s+#n')])"/><br/>
        CRS: <xsl:value-of select="count($currentGroup[matches(@ana, '#s\s+#(m|f|n|x)\s+#r')])"/><br/>
        CSP: <xsl:value-of select="count($currentGroup[matches(@ana, '#p\s+#(m|f|n|x)\s+#n')])"/><br/>
        CRP: <xsl:value-of select="count($currentGroup[matches(@ana, '#p\s+#(m|f|n|x)\s+#r')])"/>-->
        <table>
            <tr>
                <td/>
                <th>Sg.</th>
                <th>Pl.</th>
            </tr>
            <tr>
                <th>CS</th>
                <td>
                    <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$currentGroup[tokenize(@ana, ' ')[2] = '#s' and tokenize(@ana, ' ')[4] = '#n']"
                        />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$currentGroup[tokenize(@ana, ' ')[2] = '#p' and tokenize(@ana, ' ')[4] = '#n']"
                        />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>CR</th>
                <td>
                    <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$currentGroup[tokenize(@ana, ' ')[2] = '#s' and tokenize(@ana, ' ')[4] = '#r']"
                        />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$currentGroup[tokenize(@ana, ' ')[2] = '#p' and tokenize(@ana, ' ')[4] = '#r']"
                        />
                    </xsl:call-template>
                </td>
            </tr>
            <xsl:if test="$withCRI">
                <tr>
                    <th>CRI</th>
                    <td>
                        <xsl:call-template name="makeWordCellValue">
                            <xsl:with-param name="groupe"
                                select="$currentGroup[tokenize(@ana, ' ')[2] = '#s' and tokenize(@ana, ' ')[4] = '#i']"
                            />
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="makeWordCellValue">
                            <xsl:with-param name="groupe"
                                select="$currentGroup[tokenize(@ana, ' ')[2] = '#p' and tokenize(@ana, ' ')[4] = '#i']"
                            />
                        </xsl:call-template>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>
   
    <xsl:template name="makePronounTable">
        <xsl:param name="groupe"/>
        <table>
            <tr>
                <td/>
                <th>Sg.</th>
                <th>Pl.</th>
            </tr>
            <tr>
                <th>1re</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'je' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                        <br/> CR: <xsl:call-template name="makeWordCellValue">
                            <xsl:with-param name="groupe"
                                select="$groupe[@lemma = 'je' and tokenize(@ana, ' ')[5] = '#r' ]"
                            /></xsl:call-template>
                            <br/>
                            CRI: <xsl:call-template name="makeWordCellValue">
                                <xsl:with-param name="groupe"
                                    select="$groupe[@lemma = 'je' and tokenize(@ana, ' ')[5] = '#i' ]"
                                /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nos1' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nos1' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nos1' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2e</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'tu' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'tu' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'tu' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vos' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vos' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vos' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3e</th>
                <td>
                    <b>Masculin</b>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                    <br/>
                    <b>Féminin</b>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: 
                    <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                    <br/>
                    <b>Neutre</b>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#n' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#n' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <b>Masculin</b>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                    <br/>
                    <b>Féminin</b>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                    <br/>
                    CRI: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'il' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f' and tokenize(@ana, ' ')[5] = '#i' ]"
                        /></xsl:call-template>
                </td>
            </tr>
        </table>
        <br /><b>Réfléchi</b>
        <br /><b>Sg.</b>
        <br/> CR: <xsl:call-template name="makeWordCellValue">
            <xsl:with-param name="groupe"
                select="$groupe[@lemma = 'soi1' and tokenize(@ana, ' ')[3] = '#s'  and tokenize(@ana, ' ')[5] = '#r' ]"
            /></xsl:call-template>
        <br/>
        CRI: <xsl:call-template name="makeWordCellValue">
            <xsl:with-param name="groupe"
                select="$groupe[@lemma = 'soi1' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[5] = '#i' ]"
            /></xsl:call-template>
        <br /><b>Pl.</b>
        <br/> CR: <xsl:call-template name="makeWordCellValue">
            <xsl:with-param name="groupe"
                select="$groupe[@lemma = 'soi1' and tokenize(@ana, ' ')[3] = '#p'  and tokenize(@ana, ' ')[5] = '#r' ]"
            /></xsl:call-template>
        <br/>
        CRI: <xsl:call-template name="makeWordCellValue">
            <xsl:with-param name="groupe"
                select="$groupe[@lemma = 'soi1' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[5] = '#i' ]"
            /></xsl:call-template>
    </xsl:template>
    
    <xsl:template name="makePossessiveTable">
        <xsl:param name="groupe"/>
        <table>
            <tr>
                <td/>
                <th>Sg.</th>
                <th>Pl.</th>
            </tr>
            <tr>
                <th>1re SG masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>1re SG fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'mon1' or @lemma = 'mien')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2e SG masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen') and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2e SG fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'ton4' or @lemma = 'tuen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3e SG masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen') and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3e SG fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[(@lemma = 'son4' or @lemma = 'suen')  and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>1re pl. masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>1re pl. fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'nostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2e pl. masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2e pl. fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'vostre' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3e pl. masc.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#m'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3e pl. fém.</th>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2' and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'    and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2'  and tokenize(@ana, ' ')[3] = '#s' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
                <td>
                    <br/> CS: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#n' ]"
                        /></xsl:call-template>
                    <br/> CR: <xsl:call-template name="makeWordCellValue">
                        <xsl:with-param name="groupe"
                            select="$groupe[@lemma = 'lor2' and tokenize(@ana, ' ')[3] = '#p' and tokenize(@ana, ' ')[4] = '#f'  and tokenize(@ana, ' ')[5] = '#r' ]"
                        /></xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template name="makeRelativeTable">
        <xsl:param name="groupe"/>
        <h3>Par usage</h3>
        <table>
            <tr>
                <td/>
                <th>Masc. et Fém.</th>
                <th>Neutre</th>
            </tr>
            <tr>
                <th>CS</th>
               <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' ) and tokenize(@ana, ' ')[4] = '#n']"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[tokenize(@ana, ' ')[3] = '#n'  and tokenize(@ana, ' ')[4] = '#n']"
                    /></xsl:call-template></td>
            </tr>
            <tr>
                <th>CR</th>
                <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' ) and tokenize(@ana, ' ')[4] = '#r']"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[tokenize(@ana, ' ')[3] = '#n'  and tokenize(@ana, ' ')[4] = '#r']"
                    /></xsl:call-template></td>
            </tr>
            <tr>
                <th>CRI</th>
                <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' ) and tokenize(@ana, ' ')[4] = '#i']"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[tokenize(@ana, ' ')[3] = '#n'  and tokenize(@ana, ' ')[4] = '#i']"
                    /></xsl:call-template></td>
            </tr>
        </table>
        <h3>Par lemme</h3>
        <table>
            <tr>
                <td/>
                <th>Masc. et Fém.</th>
                <th>Neutre</th>
            </tr>
            <tr>
                <th>CS (qui)</th>
                <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[@lemma ='qui' and (tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' )]"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[@lemma ='qui' and tokenize(@ana, ' ')[3] = '#n']"
                    /></xsl:call-template></td>
            </tr>
            <tr>
                <th>CR1</th>
                <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(@lemma ='que2' or @lemma ='que3') and ((tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' ))]"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(@lemma ='que2' or @lemma ='que3') and tokenize(@ana, ' ')[3] = '#n']"
                    /></xsl:call-template></td>
            </tr>
            <tr>
                <th>CR2</th>
                <td> <xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[(@lemma = 'cui' or @lemma ='coi2') and ((tokenize(@ana, ' ')[3] = '#m'  or tokenize(@ana, ' ')[3] = '#f' ))]"
                    /></xsl:call-template></td>
                <td><xsl:call-template name="makeWordCellValue">
                    <xsl:with-param name="groupe"
                        select="$groupe[@lemma ='coi2' and tokenize(@ana, ' ')[3] = '#n'  ]"
                    /></xsl:call-template></td>
            </tr>
        </table>
        
    </xsl:template>

    <xsl:template name="makeWordCellValue">
        <xsl:param name="groupe"/>
        <xsl:for-each-group select="$groupe" group-by=".">
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="round(count(current-group()) div count($groupe) * 100)"/>
            <xsl:text>%; fr.a. </xsl:text>
            <xsl:value-of select="count(current-group())"/>
            <xsl:text>) </xsl:text>
        </xsl:for-each-group>
    </xsl:template>
    
    
    <!-- VERBES -->
    <!-- Règles à remanier assez largement (redécouper, revoir l'enchaînement) -->    
    <!-- Pour l'infinitif, serait chouette d'avoir sa flexion -->
    <!-- Il faut aussi songer à intégrer les pp -->
    <xsl:template name="verbes">
        <xsl:param name="arborescenceRegul"/>
        <!-- TODO: à modifier pour prendre en compte les ppe et ppa -->
        <xsl:for-each-group 
            select="$arborescenceRegul"
            group-by="@lemma">
            <xsl:sort select="@lemma" order="ascending" data-type="text"/>
            <h3>
                <xsl:value-of select="current-grouping-key()"/>
            </h3>
            <h4>Infinitif</h4>
            <xsl:variable name="infinitifTotal"
                select="count(current-group()[matches(@ana, '#VERinf')])"/>
            <xsl:for-each-group
                select="current-group()[matches(@ana, '#VERinf')]"
                group-by=".">
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="round(count(current-group()) div $infinitifTotal * 100)"/>
                <xsl:text>%; fr.a. </xsl:text>
                <xsl:value-of select="count(current-group())"/>
                <xsl:text>) </xsl:text>
            </xsl:for-each-group>
            <!-- ana="#VERcjg #ind #pst #3 #s " -->
            <xsl:for-each-group select="current-group()" group-by="tokenize(@ana, ' ')[2]">
                <xsl:choose>
                    <xsl:when test="current-grouping-key() = '#ind'">
                        <h4>Indicatif</h4>
                    </xsl:when>
                    <xsl:when test="current-grouping-key() = '#imp'">
                        <h4>Impératif</h4>
                    </xsl:when>
                    <xsl:when test="current-grouping-key() = '#con'">
                        <h4>Conditionnel</h4>
                    </xsl:when>
                    <xsl:when test="current-grouping-key() = '#sub'">
                        <h4>Subjonctif</h4>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <!-- On traite d'abord les modes qui se subdivisent en temps -->
                    <xsl:when test="current-grouping-key() = '#ind' or current-grouping-key() = '#sub'">
                <xsl:for-each-group select="current-group()" group-by="tokenize(@ana, ' ')[3]">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key() = '#pst'">
                            <h5>Présent</h5>
                        </xsl:when>
                        <xsl:when test="current-grouping-key() = '#ipf'">
                            <h5>Imparfait</h5>
                        </xsl:when>
                        <xsl:when test="current-grouping-key() = '#fut'">
                            <h5>Futur</h5>
                        </xsl:when>
                        <xsl:when test="current-grouping-key() = '#psp'">
                            <h5>Passé simple</h5>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:call-template name="makeVerbalTable">
                        <xsl:with-param name="groupe" select="current-group()"/>
                        <xsl:with-param name="personne" select="4"/>
                        <xsl:with-param name="nombre" select="5"/>
                    </xsl:call-template>
                </xsl:for-each-group>
                    </xsl:when>
                    <!-- puis les autres -->
                    <xsl:when test="current-grouping-key() = '#imp' or current-grouping-key() = '#con' ">
                        <xsl:call-template name="makeVerbalTable">
                            <xsl:with-param name="groupe" select="current-group()"/>
                            <xsl:with-param name="personne" select="3"/>
                            <xsl:with-param name="nombre" select="4"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="verbalDesinentia">
        <xsl:param name="groupe"/>
        <xsl:param name="longueur" select="1"/>
        <h4>P1</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#1\s+#s')]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <h4>P2</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#2\s+#s')]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <h4>P3</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#3\s+#s')]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <h4>P4</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#1\s+#p')]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <h4>P5</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#2\s+#p')]"/>
            <xsl:with-param name="longueur" select="$longueur"/>
        </xsl:call-template>
        <h4>P6</h4>
        <xsl:call-template name="phonolFinales">
            <xsl:with-param name="groupe" select="$groupe[matches(@ana, '#3\s+#p')]"/>
            <xsl:with-param name="longueur" select="$longueur + 1"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="makeVerbalTable">
        <xsl:param name="groupe"/>
        <xsl:param name="personne" as="xs:integer"/>
        <xsl:param name="nombre" as="xs:integer"/>
        <table>
            <thead>
                <tr>
                    <td/>
                    <th>Sg</th>
                    <th>Pl.</th>
                </tr>
            </thead>
            <tr>
                <th>1</th>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#1' and tokenize(@ana, ' ')[$nombre] = '#p']"/>                        
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>2</th>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#2' and tokenize(@ana, ' ')[$nombre] = '#p']"/>
                        </xsl:call-template>
                </td>
            </tr>
            <tr>
                <th>3</th>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#s']"/>
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="makeVerbalCell">
                        <xsl:with-param name="groupe" select="$groupe[tokenize(@ana, ' ')[$personne] = '#3' and tokenize(@ana, ' ')[$nombre] = '#p']"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="makeVerbalCell">
        <xsl:param name="groupe"/>
        <xsl:variable name="groupeTotal" select="count($groupe)"/>
        <xsl:for-each-group select="$groupe" group-by=".">
            <xsl:sort order="descending" data-type="text"/>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="round(count(current-group()) div $groupeTotal * 100)"/>
            <xsl:text>%; fr.a. </xsl:text>
            <xsl:value-of select="count(current-group())"/>
            <xsl:text>) </xsl:text>
        </xsl:for-each-group>
    </xsl:template>

<!-- SYNTAXE -->

<xsl:template match="tei:w" mode="csv_positions">
    <xsl:variable name="monW" select="."/>
    <xsl:value-of select="@xml:id"/>
    <xsl:text>,</xsl:text>
    <xsl:variable name="maPOS">
        <xsl:value-of select="tokenize(@ana, ' ')[1]"/>
    </xsl:variable>
    <!-- On réunit certaines catégories -->
    <xsl:choose>
        <xsl:when test="starts-with($maPOS, '#PROrel')">
            <xsl:text>#PROrel</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with($maPOS, '#PRE')">
            <xsl:text>#PRE</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$maPOS"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="@lemma"/>
    <xsl:text>,</xsl:text>
    <xsl:choose>
        <xsl:when test="ancestor::tei:l/descendant::tei:w[1] is $monW">
            <xsl:text>Init</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::tei:l/descendant::tei:w[last()] is $monW">
            <xsl:text>Finale</xsl:text>
        </xsl:when>
        <xsl:otherwise>Med</xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>
    
    
    
    <xsl:template name="placeSujet">
        <xsl:param name="lines"/>
        <xsl:param name="sujet" select="'#(NOM|PRO).*#(m|f|n)\s+#n'"/>
        <xsl:variable name="compte">
            <xsl:for-each select="$lines">
                <xsl:if 
                    test="descendant::tei:w
                    [matches(@ana, $sujet)]/following-sibling::tei:w[matches(@ana, '#VERcjg')]">
                    <noeud>avant</noeud>
                </xsl:if>
                <xsl:if 
                    test="descendant::tei:w
                    [matches(@ana, $sujet)]/preceding::tei:w[matches(@ana, '#VERcjg')]">
                    <noeud>après</noeud>
                </xsl:if>
                <xsl:for-each select="descendant::tei:q">
                    <xsl:if 
                        test="descendant::tei:w
                        [matches(@ana, $sujet)]/following-sibling::tei:w[matches(@ana, '#VERcjg')]">
                        <noeud>dd:avant</noeud>
                    </xsl:if>
                    <xsl:if 
                        test="descendant::tei:w
                        [matches(@ana, $sujet)]/preceding-sibling::tei:w[matches(@ana, '#VERcjg')]">
                        <noeud>dd:après</noeud>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <br /><b>Avant: </b> <xsl:value-of select="count($compte/noeud[.='avant'])"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="
            count($compte/noeud[.='avant'])
            div
            count($compte/noeud[.='avant' or . = 'après'])
            "/>
        <xsl:text>) </xsl:text>
        <br /><b>Après: </b> <xsl:value-of select="count($compte/noeud[.='après'])"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="
            count($compte/noeud[.='après'])
            div
            count($compte/noeud[.='avant' or . = 'après'])
            "/>
        <xsl:text>) </xsl:text>
        <br /><b>Avant (DD): </b> <xsl:value-of select="count($compte/noeud[.='dd:avant'])"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="
            count($compte/noeud[.='dd:avant'])
            div
            count($compte/noeud[.='dd:avant' or . = 'dd:après'])
            "/>
        <xsl:text>) </xsl:text>
        <br /><b>Après (DD): </b> <xsl:value-of select="count($compte/noeud[.='dd:après'])"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="
            count($compte/noeud[.='dd:après'])
            div
            count($compte/noeud[.='dd:avant' or . = 'dd:après'])
            "/>
        <xsl:text>) </xsl:text>
    </xsl:template>


    <!-- Normalisations (version avec ou sans les abréviations) -->
    <xsl:template match="node() | @*" mode="#default sansAbbr">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:choice" mode="#default sansAbbr">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <!--<xsl:template match="tei:abbr"/>-->
    <xsl:template match="tei:expan" mode="#default sansAbbr"/>
    <xsl:template match="tei:orig" mode="#default sansAbbr"/>
    <xsl:template match="tei:corr" mode="#default sansAbbr"/>
    <!--<xsl:template match="tei:expan | tei:ex | tei:reg | tei:hi">-->
    <xsl:template match="tei:abbr | tei:ex | tei:reg | tei:hi" mode="#default sansAbbr">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template match="text()[ancestor::tei:w]" mode="#default sansAbbr">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="tei:note" mode="#default sansAbbr"/>
    <xsl:template match="comment()[ancestor::tei:w]" mode="#all"/>

    <xsl:template mode="sansAbbr" match="tei:w[descendant::text()[normalize-space(.) != ''][last()][ancestor-or-self::tei:choice[tei:abbr] or ancestor-or-self::tei:pc[@type = 'orig'] ]]"/>

<!-- Normalisations en mode syntaxe -->
    <xsl:template match="tei:l|tei:q|tei:body" mode="syntaxe">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="syntaxe"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:w" mode="syntaxe">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="#default"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@* | node()" mode="syntaxe">
        <xsl:apply-templates mode="syntaxe"/>
    </xsl:template>

</xsl:stylesheet>
