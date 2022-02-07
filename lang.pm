#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## lang.pm   -  language package for jugglingTB                             ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2022  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
##                                                                          ##
##                                                                          ##
## This program is free software; you can redistribute it and/or modify it  ##
## under the terms of the GNU General Public License version 3 as           ##
## published by the Free Software Foundation; version 3.                    ##
##                                                                          ##
## This program is distributed in the hope that it will be useful, but      ##
## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
## General Public License for more details.                                 ##
##                                                                          ##
##############################################################################

#this Package is mainly dedicated to have several languages in jugglingTB.
#You may here use ASCII characters (7bits). 
#If you need to use some special ones (in Extended ASCII for example), you may undicate unicode value here 
#(ex : \x{e9} is for e with acute accent, é).
#      \x{e8} : è
#      \x{e0} : à
#      \x{ea} : ê
#      \x{e7} : ç
#      \x{ef} : ï

#).

package lang;
use conf;
require Devel::Symdump;

sub initLang
{   
    if ($conf::LANG eq "FRENCH") {   	 
	#############################################################################################################################################
	##
	##  FRENCH Section
	##
	#############################################################################################################################################


	################################################"
	#
	# MAIN Menu Messages 
	#
	################################################"

	our $MSG_MAIN_MENU_CREDITS_1 = "Cr\x{e9}dits.";
	our $MSG_MAIN_MENU_LSC_1 = "Liste l'int\x{e9}gralit\x{e9} des commandes disponibles.";
	our $MSG_MAIN_MENU_LSC_2 = "Liste l'int\x{e9}gralit\x{e9} des commandes disponibles ainsi que leurs param\x{e8}tres.";
	our $MSG_MAIN_MENU_MAIN_1 = "Menu principal.";
	our $MSG_MAIN_MENU_HELP_1 = "Utile dans le Menu des modules pour une aide g\x{e9}n\x{e9}rique ou sp\x{e9}cialis\x{e9}e. <help>, <help(\"command\")> ou encore <help(\"module\")>.";
	our $MSG_MAIN_MENU_HELP_2 = "Utilisez :\n\- <help> pour obtenir l'Aide courante dans le Menu Principal ou le Menu d'un Module;\n\- <help(\"command\")> pour obtenir une Aide sp\x{e9}cifique sur une commande du module courant; \n\- <help(\"module\")> pour obtenir une Aide sp\x{e9}cifique sur un Module;\n - <help(\"command::module\")> pour obtenir une Aide sp\x{e9}cifique sur une commande d'un module donn\x{e9}.";
	our $MSG_MAIN_MENU_HELP2_1 = "Utile pour obtenir les param\x{e8}tres des commandes.";
	our $MSG_MAIN_MENU_HELP2_2 = "Utilisez :\n\- <help2> pour obtenir l'ensemble des commandes disponibles du module courant ainsi que leur param\x{e8}tres;\n\- <help2(\"command\")> pour obtenir une Aide sp\x{e9}cifique d\x{e9}taill\x{e9}e sur une commande du module courant;\n\- <help2(\"module\")> pour obtenir une Aide sp\x{e9}cifique et d\x{e9}taill\x{e9}e sur les param\x{e8}tres des commandes d'un Module;\n\- <help2(\"commande::module\")> pour obtenir une Aide sp\x{e9}cifique et d\x{e9}taill\x{e9}e sur les param\x{e8}tres d'une commande d'un Module donn\x{e9}.";
	our $MSG_MAIN_MENU_EXIT_1 = "Quitte le Programme. \"bye\" ou \"quit\" peuvent \x{e9}galement \x{ea}tre utilis\x{e9}s.";
	our $MSG_MAIN_MENU_EXC_1 = "Lance une commande Shell.";
	our $MSG_MAIN_MENU_EXC_2 = "!! : Lance une commande Shell mais dans le processus courant.";
	our $MSG_MAIN_MENU_MODS_1 = "Affiche les modules disponibles.";
	our $MSG_MAIN_MENU_INT_1 = "R\x{e9}sultat de la commande pr\x{e9}c\x{e9}dente.";
	our $MSG_MAIN_MENU_INT_2 = "<1> pour OK.";
	our $MSG_MAIN_MENU_USAGE_1 = "Options au lancement de jugglingTB.";

	our $MSG_MAIN_USAGE_s = "Affiche les caract\x{e8}res sp\x{e9}ciaux (Unicodes) des Menus.";
	our $MSG_MAIN_USAGE_a = "Active l'autocompletion (C^d et <TAB>, C^U pour effacer). [Fonctionne mal avec Cmd sur MsWindows ;-(].";
	our $MSG_MAIN_USAGE_h = "Aide de jugglingTB.";
	our $MSG_MAIN_USAGE_H = "Aide \x{e9}tendue de jugglingTB.";
	our $MSG_MAIN_USAGE_v = "Donne la version sans lancer jugglingTB.";
	our $MSG_MAIN_USAGE_u = "Usage pour lancer jugglingTB.";
	our $MSG_MAIN_USAGE_i = "Fichier de Configuration pour jugglingTB (D\x{e9}faut:conf.ini).";
	our $MSG_MAIN_USAGE_f = "Fichier de Commandes \x{e0} lancer.";
	our $MSG_MAIN_USAGE_c = "Colorise jugglingTB. Fonctionne uniquement sur un terminal ANSI ;-(";
	our $MSG_MAIN_USAGE_e = "Commande \x{e0} lancer.";
	our $MSG_MAIN_USAGE_d = "Mode Debug.";
	our $MSG_MAIN_USAGE_CONF = "\nPar d\x{e9}faut chacune de ces options est d\x{e9}sactiv\x{e9}e. Ce comportement peut \x{ea}tre modifi\x{e9} dans le fichier <conf.ini>. Dans ce cas la d\x{e9}sactivation des options est explicitement indiqu\x{e9}e par l'utilisation du prefix <-no>. \nDiff\x{e9}rents param\x{e8}tres de configuration peuvent \x{e9}galement \x{ea}tre positionn\x{e9}s dans <conf.ini> (Tel que le langage usit\x{e9} par exemple).\n";

	our $MSG_MAIN_LSC = "\nVoici les diff\x{e9}rentes commandes utilisables au gr\x{e9} des diff\x{e9}rents menus.\nPour acc\x{e9}der \x{e0} un menu de Module, entrez simplement son nom (ou simplement ses 2 premi\x{e8}res lettres).\nUne fonction d'un module MOD peut directement \x{ea}tre acc\x{e9}d\x{e9}e par son nom dans le Menu MOD ou bien par MOD::LaFonction depuis n'importe quel Menu.\n\n";
	our $MSG_MAIN_LSC_NOMODA = "\tAucun Module disponible\n";
	our $MSG_MAIN_LSC_MODA = "\tModules disponibles : ";
	our $MSG_MAIN_LSC_MAINCMDS = "COMMANDES PRINCIPALES";
	our $MSG_MAIN_LSC_MOD = "  CONTEXTE DES MODULES  ";

	our $MSG_MAIN_ERR1 = "EOF non attendu.";
	our $MSG_MAIN_ERR2 = "\x{e9}chec";

	our $MSG_MAIN_WINDOWS_CHARSET = "Vous devriez avoir Defini la police <Lucida Console> si vous utilisez Cmd.\n";

	################################################"
	#
	# BTN Module Messages 
	#
	################################################"
	
	our $MSG_BTN_MENU_HELP = "Dans ce module un lancer BTN sera compos\x{e9} d'une succession de trous pris parmi AC, AL, BOL ainsi que de l'op\x{e9}rateur OP (Minuscule ou Majuscule).\n\n\tExemples : OPALAC, BOLAL, OPALOPAC ..."; 

	our $MSG_BTN_MENU_GENTHROWS_1 = "Donne les lancers BTN limit\x{e9}s par le nombre de trous travers\x{e9}s.";
	our $MSG_BTN_MENU_GENTHROWS2_1 = "Donne les lancers BTN sans les lancers dont le corps contient 2 trous successifs identiques.";
	our $MSG_BTN_MENU_GENTHROWS_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre maximum de trous travers\x{e9}s [>4 r\x{e9}serv\x{e9} aux Extra-Terrestres ;-)].\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.";	
	our $MSG_BTN_MENU_SIZE_1 = "Donne la taille du lancer en nombre de trous travers\x{e9}s.";
	our $MSG_BTN_MENU_SIZE_2 = "Param\x{e8}tres :\n\n\- <Throw> : Lancer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_BTN_MENU_ISVALID_1 = "Teste la validit\x{e9} du lancer BTN.";
	our $MSG_BTN_MENU_ISVALID_2 = "Param\x{e8}tres :\n\n\- <Lancer> : Lancer \x{e0} valider.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_BTN_MENU_TIMEREVERSED_1 = "Donne le lancer BTN Time Reversed associ\x{e9}.";
	our $MSG_BTN_MENU_TIMEREVERSED_2 = "Param\x{e8}tres :\n\n\- <Lancer> : Lancer dont on veut obtenir le Time Reversed.\n\- <Parit\x{e9}> : Parit\x{e9} du lancer (0: paire, 1: impaire).\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";

	our $MSG_BTN_MENU_BTNPARITY_1 = "Donne la parit\x{e9} BTN.";
	our $MSG_BTN_MENU_BTNPARITY_2 = "Param\x{e8}tres :\n\n\- <Throw> : Lancer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher. En retour 0 indique une parit\x{e9} Paire, 1 indique Impaire";

	our $MSG_BTN_GENTHROWS_1 = "\t";
	our $MSG_BTN_GENTHROWS_2 = " Lancer(s) BTN traversant au maximum ";
	our $MSG_BTN_GENTHROWS_3 = " Trou(s) :\n";
	our $MSG_BTN_GENTHROWSEXT_3 = " Trou(s) sans redondance successive dans le corps :\n";
	our $MSG_BTN_GENTHROWS_EVEN = "Pair";
	our $MSG_BTN_GENTHROWS_ODD = "Impair";

	our $MSG_BTN_ISVALID_ERR1 = "(Taille impaire)\n";
	our $MSG_BTN_ISVALID_ERR2 = "(1er Trou non valide)\n";
	our $MSG_BTN_ISVALID_ERR3 = "(Dernier Trou non valide)\n";
	our $MSG_BTN_ISVALID_ERR4 = "(Dernier Trou de la portion <";
	our $MSG_BTN_ISVALID_ERR4b = "> non valide)\n";
	our $MSG_BTN_ISVALID_ERR5 = "(Trouv\x{e9} 2 cons\x{e9}cutifs <";
	our $MSG_BTN_ISVALID_ERR5b = "> dans la portion <";
	our $MSG_BTN_ISVALID_ERR5c = ">)\n";	 
	our $MSG_BTN_ISVALID_WARN1 = "(Accessible uniquement aux Extra-Terrestres (ie > 4 trous))\n";	 	
	our $MSG_BTN_TIMEREVERSED_ERR1 = "(Param\x{e8}tre <Parit\x{e9}> incorrect)\n";
	our $MSG_BTN_TIMEREVERSED_ERR2 = "(Lancer non valide)\n";
	our $MSG_BTN_TIMEREVERSED_ERR3 = "(Premier Trou non valide)\n";
	our $MSG_BTN_TIMEREVERSED_ERR4 = "(Dernier Trou non valide)\n";
	our $MSG_BTN_TIMEREVERSED_ERR5 = "(Trou non valide dans la portion : ";
	our $MSG_BTN_TIMEREVERSED_ERR5b = "\n; ";

	our $MSG_BTN_BTNPARITY_0 = "(Indiff\x{e9}rent)";
	our $MSG_BTN_BTNPARITY_1 = "(Paire)";
	our $MSG_BTN_BTNPARITY_2 = "(Impaire)";


	################################################"
	#
	# SOU Module Messages 
	#
	################################################"

	our $MSG_SOU_MENU_HELP = "Dans ce module un pattern SOU sera compos\x{e9} d'une succession d'\x{e9}tats (O, Ob, U, Ub, S, Sb) et d'\x{e9}changes (<in>, <out>).\n\nExemple : O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb"; 

	our $MSG_SOU_MENU_ISEQUIVALENT_1 = "Teste l'\x{e9}quivalence de 2 patterns.";
	our $MSG_SOU_MENU_ISEQUIVALENT_2 = "Param\x{e8}tres :\n\n\- <pattern1> <pattern2> : patterns \x{e0} comparer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher."; 			 	
	our $MSG_SOU_MENU_ISSYMETRIC_1 = "Teste la sym\x{e9}trie de 2 patterns.";
	our $MSG_SOU_MENU_ISSYMETRIC_2 = "Param\x{e8}tres :\n\n\- <pattern1> <pattern2> : patterns \x{e0} comparer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SOU_MENU_ISVALID_1 = "Teste la validit\x{e9} d'un pattern.";
	our $MSG_SOU_MENU_ISVALID_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SOU_MENU_SYM_1 = "Calcule la sym\x{e9}trie d'un pattern donn\x{e9}.";
	our $MSG_SOU_MENU_SYM_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SOU_MENU_INV_1 = "Calcule l'inversion d'un pattern donn\x{e9}.";
	our $MSG_SOU_MENU_INV_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SOU_MENU_GENALLPATTERNSBYSTATE_1 = "G\x{e9}n\x{e9}ration de tous les patterns avec classification par Etat.";
	our $MSG_SOU_MENU_GENALLPATTERNSBYSTATE_2 = "Param\x{e8}tres :\n\n\- <cpt> : Nombre de Passages maximum par Etat\n\- <pathLenMax> : Longueur du chemin maximum (-1 : toute longueur)\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.";
	our $MSG_SOU_MENU_GENALLPATTERNS_1 = "G\x{e9}n\x{e9}ration de tous les patterns avec suppression des redondances.";
	our $MSG_SOU_MENU_GENALLPATTERNS_2 = "Param\x{e8}tres :\n\n\- <cpt> : Nombre de Passages maximum par Etat\n\- <pathLenMax> : Longueur du chemin maximum (-1 : toute longueur)\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.";
	our $MSG_SOU_MENU_GRAPH_1 = "Affiche le Graphe SOU des transitions valides.";
	our $MSG_SOU_MENU_GRAPH_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	our $MSG_SOU_MENU_SIZE_1 = "Donne la longueur du pattern en nombre d'Etats.";
	our $MSG_SOU_MENU_SIZE_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern. Une unit\x{e9} est consid\x{e9}r\x{e9}e uniquement sur composition d'un Etat et d'une transition.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SOU_MENU_TOMMSTD_1 = "Donne la notation MMSTD correspondante.";
	our $MSG_SOU_MENU_TOMMSTD_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";

	our $MSG_SOU_GENPATTERN_1 = "\t";
	our $MSG_SOU_GENPATTERN_2 = " R\x{e9}sultats S,O,U \x{e0} partir de l'Etat ";
	our $MSG_SOU_GENPATTERN_3 = " R\x{e9}sultats S,O,U :\n";
	our $MSG_SOU_GENPATTERN_4 = "Etats";

	our $MSG_SOU_ISVALID_ERR1 = "(nombre d'Etats+Echanges impair et dernier \x{e9}l\x{e9}ment diff\x{e9}rent du premier)";
	our $MSG_SOU_ISVALID_ERR2 = "(Etat invalide";
	our $MSG_SOU_ISVALID_ERR3 = "(transition SOU invalide";
	our $MSG_SOU_ISVALID_ERR4 = "(Echange invalide"; 

	our $MSG_SOU_INV_ERR1 = "inv :";
	our $MSG_SOU_INV_ERR1b = "n'est pas un pattern valide (";
	our $MSG_SOU_INV_ERR1c = " non d\x{e9}fini).\n";

	our $MSG_SOU_ISSYMETRIC_ERR1 = "isSymetric :";
	our $MSG_SOU_ISSYMETRIC_ERR1b = "n'est pas un pattern valide (";
	our $MSG_SOU_ISSYMETRIC_ERR1c = " non d\x{e9}fini).\n";

	our $MSG_SOU_SYM_ERR1 = "sym :";
	our $MSG_SOU_SYM_ERR1b = "n'est pas un pattern valide (";
	our $MSG_SOU_SYM_ERR1c = " non d\x{e9}fini).\n";
	
	our $MSG_SOU_TOMMSTD_ERR1 = "toMMSTD :";
	our $MSG_SOU_TOMMSTD_ERR1b = "n'est pas un pattern valide (";
	our $MSG_SOU_TOMMSTD_ERR1c = " non d\x{e9}fini).\n";
	

	################################################"
	#
	# MMSTD Module Messages 
	#
	################################################"

	our $MSG_MMSTD_MENU_HELP = "Dans ce module un pattern MMSTD sera compos\x{e9} d'une succession d'\x{e9}tats (Ur, Ul, Rl, Rr, Lr, Lr) et d'\x{e9}changes (-+->, -o->).\n\n\tExemples : Ur -o-> Ll -+> Ur , Rr -+-> Ul -o->"; 

	our $MSG_MMSTD_MENU_ISEQUIVALENT_1 = "Teste l'\x{e9}quivalence de 2 patterns.";
	our $MSG_MMSTD_MENU_ISEQUIVALENT_2 = "Param\x{e8}tres :\n\n\- <pattern1> <pattern2> : patterns \x{e0} comparer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher."; 			 	
	our $MSG_MMSTD_MENU_ISSYMETRIC_1 = "Teste la sym\x{e9}trie de 2 patterns.";
	our $MSG_MMSTD_MENU_ISSYMETRIC_2 = "Param\x{e8}tres :\n\n\- <pattern1> <pattern2> : patterns \x{e0} comparer.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_MMSTD_MENU_ISVALID_1 = "Teste la validit\x{e9} d'un pattern.";
	our $MSG_MMSTD_MENU_ISVALID_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_MMSTD_MENU_SYM_1 = "Calcule la sym\x{e9}trie d'un pattern.";
	our $MSG_MMSTD_MENU_SYM_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_MMSTD_MENU_INV_1 = "Calcule l'inversion d'un pattern.";
	our $MSG_MMSTD_MENU_INV_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_1 = "G\x{e9}n\x{e9}ration de tous les patterns avec classification par Etat.";
	our $MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_2 = "Param\x{e8}tres :\n\n\- <cpt> : Nombre de Passages maximum par Etat\n\- <pathLenMax> : Longueur du chemin maximum (-1 : toute longueur)\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.";
	our $MSG_MMSTD_MENU_GENALLPATTERNS_1 = "G\x{e9}n\x{e9}ration de tous les patterns avec suppression des redondances.";
	our $MSG_MMSTD_MENU_GENALLPATTERNS_2 = "Param\x{e8}tres :\n\n\- <cpt> : Nombre de Passages maximum par Etat\n\- <pathLenMax> : Longueur du chemin maximum (-1 : toute longueur)\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.";
	our $MSG_MMSTD_MENU_GRAPH_1 = "Affiche le Graphe MMSTD des transitions valides."; 
	our $MSG_MMSTD_MENU_GRAPH_2 = "Param\x{e8}tres :\n\n\- Aucun ou sinon Graphviz doit pr\x{e9}alablement \x{ea}tre install\x{e9} et son Path correctement configur\x{e9} dans <conf.ini>\n\n\- <\"fichier\"> : fichier de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_FORMAT;
	our $MSG_MMSTD_MENU_SIZE_1 = "Donne la longueur du pattern en nombre d'Etats.";
	our $MSG_MMSTD_MENU_SIZE_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern. Une unit\x{e9} est consid\x{e9}r\x{e9}e uniquement sur composition d'un Etat et d'une transition.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_MMSTD_MENU_TOSOU_1 = "Donne la notation SOU correspondante.";
	our $MSG_MMSTD_MENU_TOSOU_2 = "Param\x{e8}tres :\n\n\- <pattern> : pattern.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";

	our $MSG_MMSTD_GENPATTERN_1 = "\t";
	our $MSG_MMSTD_GENPATTERN_2 = " R\x{e9}sultats MMSTD \x{e0} partir de l'Etat ";
	our $MSG_MMSTD_GENPATTERN_3 = " R\x{e9}sultats MMSTD :\n";
	our $MSG_MMSTD_GENPATTERN_4 = "Etats";

	our $MSG_MMSTD_ISVALID_ERR1 = "(nombre d'Etats+Echanges impair et dernier \x{e9}l\x{e9}ment diff\x{e9}rent du premier)";
	our $MSG_MMSTD_ISVALID_ERR2 = "(Etat invalide";
	our $MSG_MMSTD_ISVALID_ERR3 = "(transition MMSTD invalide";
	our $MSG_MMSTD_ISVALID_ERR4 = "(Echange invalide"; 
	
	our $MSG_MMSTD_INV_ERR1 = "inv :";
	our $MSG_MMSTD_INV_ERR1b = "n'est pas un pattern valide (";
	our $MSG_MMSTD_INV_ERR1c = " non d\x{e9}fini).\n";

	our $MSG_MMSTD_ISSYMETRIC_ERR1 = "isSymetric :";
	our $MSG_MMSTD_ISSYMETRIC_ERR1b = "n'est pas un pattern valide (";
	our $MSG_MMSTD_ISSYMETRIC_ERR1c = " non d\x{e9}fini).\n";

	our $MSG_MMSTD_SYM_ERR1 = "sym :";
	our $MSG_MMSTD_SYM_ERR1b = "n'est pas un pattern valide (";
	our $MSG_MMSTD_SYM_ERR1c = " non d\x{e9}fini).\n";
	
	our $MSG_MMSTD_TOSOU_ERR1 = "toSOU :";
	our $MSG_MMSTD_TOSOU_ERR1b = "n'est pas un pattern valide (";
	our $MSG_MMSTD_TOSOU_ERR1c = " non d\x{e9}fini).\n";


	################################################"
	#
	# SSWAP Module Messages 
	#
	################################################"

	our $MSG_SSWAP_MENU_HELP = "Dans ce module un SITESWAP sera not\x{e9} selon la notation Siteswap classique telle qu'elle est utilis\x{e9}e par JugglingLab\n\n\tExemples : 534, (6x,4)*, (2x,[22x])(2,[22])(2,[22x])*.\n\nOn consid\x{e9}rera en plus une notation MultiSynchrone combinant lancers Synchrones et Asynchrones avec les symboles '!' et '*' :\n\n'!' : supprime un Beat de temps. Apr\x{e8}s un Siteswap Synchrone il indique que le lancer suivant se fait sur le Beat suivant cens\x{e9} \x{ea}tre un Beat de r\x{e9}cup\x{e9}ration (et non plus 2 Beats apr\x{e8}s). Apr\x{e8}s un lancer Asynchrone, il indique que le lancer suivant se fait au m\x{ea}me Beat. Il devient alors possible de repr\x{e9}senter un Siteswap Synchrone par un Siteswap Asynchrone. Les Multiplexes peuvent \x{e9}galement \x{ea}tre adapt\x{e9}s selon ce sch\x{e9}ma (ie *! ou !*).\n\n'*' : dans le cas d'un Siteswap Synchrone il indique un changement de l'ordre des mains et n'est plus obligatoirement positionn\x{e9} \x{e0} la fin. Dans le cas d'un Siteswap Asynchrone, le prochain lancer se fait par la m\x{ea}me main (Notion de Hurry).\n\n\tExemples : 4!40, 5!*4!*3, 6x0*, (6x,0)*, 51x*, (1x,3)!11x* ...\n\nRespectez les conseils suivants dans les diff\x{e9}rentes fonctions de ce module :\n\t - Evitez au maximum d'utiliser \"!*\" et \"*!\" en d\x{e9}but et \n\tfin de Siteswap; \"!\" en d\x{e9}but et \"!\" en \n\tfin de Siteswap apr\x{e8}s un lancer en repr\x{e9}sentation Asynchrone;\n\t- La hauteur des objets sera g\x{e9}n\x{e9}ralement en hexad\x{e9}cimale sauf\n\t pr\x{e9}cision contraire."; 

	our $MSG_SSWAP_MENU_ANIMATE_1 = "Montre l'animation d'un Siteswap (JugglingLab).";
	our $MSG_SSWAP_MENU_ANIMATE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap dont on veut obtenir l'animation.";
	our $MSG_SSWAP_MENU_ANIMATE_ANTISS_1 = "Montre l'animation d'un Antisiteswap (PowerJuggler de Marco Tarini).";
	our $MSG_SSWAP_MENU_ANIMATE_ANTISS_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	our $MSG_SSWAP_MENU_GENTRANSTEODORO_1 = "Lance les G\x{e9}n\x{e9}rateurs de Siteswaps \& de Transitions de Pedro Teodoro.";
	our $MSG_SSWAP_MENU_GENTRANSTEODORO_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	our $MSG_SSWAP_MENU_REALSIM_1 = "Lance le Simulateur de Pedro Teodoro.";
	our $MSG_SSWAP_MENU_REALSIM_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	our $MSG_SSWAP_MENU_SHOWVANILLADIAG_1 = "Affichage des Diagrammes Etats/Transitions Vanilles.";
	our $MSG_SSWAP_MENU_SHOWVANILLADIAG_2 = "Param\x{e8}tres :\n\n\- Aucun.";	
	our $MSG_SSWAP_MENU_GENSS_1 = "G\x{e9}n\x{e9}ration de Siteswaps (JugglingLab).";
	our $MSG_SSWAP_MENU_GENSS_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\- <int> : P\x{e9}riode.\n\- [\"-O [options]\"] Optionnel, Diff\x{e9}rentes options pr\x{e9}cis\x{e9}es ci-dessous.\n".$MSG_SSWAP_MENU_GENSS_OPT."\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.\nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n";
	our $MSG_SSWAP_MENU_GENSS_OPT="\n\tles options incluent :\n\t\-s : mode synchrone\n\t\-j : <nombre> d\x{e9}finit le nombre de jongleurs\n\t\-n : affiche le nombre de Siteswaps g\x{e9}n\x{e9}r\x{e9}s\n\t\-m : <nombre> multiplex avec au moins le nombre donn\x{e9} de lancers simultan\x{e9}s\n\t\-no : imprime juste le nombre de Siteswaps g\x{e9}n\x{e9}r\x{e9}s\n\t\-g : figures fondamentales\n\t\-mf : permet les r\x{e9}ceptions multiples\n\t\-ng : figures excit\x{e9}es\n\t\-mc : emp\x{ea}che les lancers multiplex en grappes\n\t\-f : liste compl\x{e8}te (avec les figures compos\x{e9}es)\n\t\-mt : vrai multiplexes uniquement\n\t\-d <nombre> : retard de communication (passing)\n\t\-se : disable starting/ending\n\t\-l <nombre> : passing leader person number\n\t\-prime : premiers seulement\n\t\-x <lancer> : exclure les lancers\n\t\-rot : avec permutations des figures\n\t\-i <lancer> : inclure les lancers\n\t\-lame : supprimer les '11' en mode asynchrone\n\t\-cp : connected patterns only\n\t\-jp : show all juggler permutations";
	our $MSG_SSWAP_MENU_GENTRANS_1 = "G\x{e9}n\x{e9}ration de Transitions entre Siteswaps (JugglingLab).";
	our $MSG_SSWAP_MENU_GENTRANS_2 = "Param\x{e8}tres :\n\n\- <ss1> : Siteswap1.\n\- <ss2> : Siteswap2.\n\- [\"-O [options]\"] Optionnel, Diff\x{e9}rentes options pr\x{e9}cis\x{e9}es ci-dessous.\n".$MSG_SSWAP_MENU_GENTRANS_OPT."\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.\nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMOLD_1 = "G\x{e9}n\x{e9}ration de Polyrythmes (D\x{e9}pr\x{e9}ci\x{e9}).";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMOLD_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <int> : Ratio Droit.\n\- <int> : Ratio Gauche.\n\- [\\\@List] Optionnel, Lancers \x{e0} exclure.\n\tEx: \@List=('0','e','ex','f','fx').\n\t Si non pr\x{e9}cis\x{e9}, sans autre param\x{e8}tre optionnel, 0 est exclu;\n\t si \'\', pas d'exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.\nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHM_1 = "G\x{e9}n\x{e9}ration de Polyrythmes.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHM_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <int> : Hauteur Max en h\x{e9}xa.\n\- <int> : Ratio Droit.\n\- <int> : Ratio Gauche.\n\- [\\\@List] Optionnel, Lancers \x{e0} exclure.\n\tEx: \@List=('0','2','1x').\n\t Si non pr\x{e9}cis\x{e9}, sans autre param\x{e8}tre optionnel, 0 est exclu;\n\t si \'\', pas d'exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-J <y|n> : Double le Tempo pour les polyrythmes 1:M principalement afin d'\x{e9}viter les squeezes (D\x{e9}faut:n).\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.\nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.\n\t\- \'HTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant les Diagrammes Ladder, les Siteswaps \n\t\tModifi\x{e9}s avec conservation du Tempo mais r\x{e9}duction des \n\t\thauteurs et les fichiers JML associ\x{e9}s.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMMULT_1 = "G\x{e9}n\x{e9}ration de Polyrythmes avec Multiplexes.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMMULT_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <int> : Hauteur Max en h\x{e9}xa.\n\- <int> : Nombre de lancers simultan\x{e9}s max.\n\- <int> : Ratio Droit.\n\- <int> : Ratio Gauche.\n\- [\\\@List] Optionnel, Lancers \x{e0} exclure.\n\tEx: \@List=('0','2','1x').\n\t Si non pr\x{e9}cis\x{e9}, sans autre param\x{e8}tre optionnel, 0 est exclu;\n\t si \'\', pas d'exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-J <y|n> : Double le Tempo pour les polyrythmes 1:M principalement afin d'\x{e9}viter les squeezes (D\x{e9}faut:n).\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats.\nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.\n\t\- \'HTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant les Diagrammes Ladder, les Siteswaps \n\t\tModifi\x{e9}s avec conservation du Tempo mais r\x{e9}duction des \n\t\thauteurs et les fichiers JML associ\x{e9}s.";
	our $MSG_SSWAP_MENU_GENTRANS_OPT="\n\tles options incluent : \n\t\-m <num> : Multiplexe avec au plus num lancers simultan\x{e9}s.\n\t\-mf : Authorise catchs simultan\x{e9}s non triviaux (squeeze)\n\t\-mc : Interdit lancers Multiplexes Cluster (i.e. [33])\n\t\-limits : D\x{e9}sactive Temporisation d'\x{e9}x\x{e9}cution (Recherches peuvent \x{ea}tre tr\x{e8}s longue!).";
	our $MSG_SSWAP_MENU_GENSTATES_1 = "G\x{e9}n\x{e9}ration des Matrices Etats/Transitions.";
	our $MSG_SSWAP_MENU_GENSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher; Si le fichier commence par \'XLS:\', g\x{e9}n\x{e8}re un fichier Excel en y ajoutant l'extension .xlsx";	
	our $MSG_SSWAP_MENU_GENAGGRSTATES_1 = "G\x{e9}n\x{e9}ration des Matrices Etats/Transitions R\x{e9}duites.";
	our $MSG_SSWAP_MENU_GENAGGRSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n\- [\"fichier1\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher; Si le fichier commence par \'XLS:\', g\x{e9}n\x{e8}re un fichier Excel en y ajoutant l'extension .xlsx. \n\n\- [\"fichier2\"] Optionnel, fichier XLS Matrice Etats/Transitions valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu).";
	our $MSG_SSWAP_MENU_GENPROBERTDIAG_1 = "G\x{e9}n\x{e9}ration des Diagrammes de Martin Probert.";
	our $MSG_SSWAP_MENU_GENPROBERTDIAG_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <nb> : Hauteur Max des Siteswaps (-1 toute hauteur).\n\- <int> : P\x{e9}riode des Siteswaps.\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher; Si le fichier commence par \'XLS:\', g\x{e9}n\x{e8}re un fichier Excel en y ajoutant l'extension .xlsx";
	our $MSG_SSWAP_MENU_GENPROBERTSS_1 = "G\x{e9}n\x{e9}ration de Siteswaps Vanilles depuis Diagrammes de Martin Probert.";
	our $MSG_SSWAP_MENU_GENPROBERTSS_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\n\- <nb> : Hauteur Max des Siteswaps (-1 toute hauteur).\n\n\- <int> : P\x{e9}riode des Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENSSFROMSTATES_1 = "G\x{e9}n\x{e9}ration de Siteswaps depuis Diagrammes Etats/Transitions.";
	our $MSG_SSWAP_MENU_GENSSFROMSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : P\x{e9}riode des Siteswaps.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\t\- <int> : P\x{e9}riode des Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\- [\"fichier\"] Optionnel, fichier XLS Matrice Etats/Transitions valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu)."; 
	our $MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_1 = "G\x{e9}n\x{e9}ration de Siteswaps depuis Diagrammes Etats/Transitions R\x{e9}duits.";
	our $MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : P\x{e9}riode des Siteswaps.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\t\- <int> : P\x{e9}riode des Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\- [\"fichier\"] Optionnel, fichier XLS Matrice Etats/Transitions R\x{e9}duite valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu)."; 
	our $MSG_SSWAP_MENU_GENPERMSS_1 = "G\x{e9}n\x{e9}ration de Siteswaps Vanilles Par Test de Permutation (Algorithme de Polster).";
	our $MSG_SSWAP_MENU_GENPERMSS_2 = "Param\x{e8}tres :\n\n\- <int> : Nombre d'objets.\n\- <int> : P\x{e9}riode des Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENMAGICSS_1 = "G\x{e9}n\x{e9}ration de Magics Siteswaps.";
	our $MSG_SSWAP_MENU_GENMAGICSS_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S', 'MULTI' ==\n\t\- <mode> : Mode de Magics Siteswaps (Pair/Impair/All).\n\t\- <nb> : Valeur Minimum stricte des Lancers.\n\t\- <int> : P\x{e9}riode des Siteswaps.\n\n== cas 'M', 'MS' ==\n\t\- <mode> : Mode de Magics Siteswaps (Pair/Impair/All).\n\t\- <nb> : Valeur Minimum stricte des Lancers.\n\t\- <int> : Nombre de Lancers.\n\t\- <int> : Nombre Max de Lancers Multiplexes.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENMAGICSTADLERSS_1 = "G\x{e9}n\x{e9}ration Partielle de Magics Siteswaps Vanilles par l'algorithme de Jon Stadler.";
	our $MSG_SSWAP_MENU_GENMAGICSTADLERSS_2 = "Param\x{e8}tres :\n\n\- <int> : P\x{e9}riode Maximum.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_1 = "G\x{e9}n\x{e9}ration de Siteswaps Vanilles Scramblables par Algorithme de Polster.\n";
	our $MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_2 = "Les Siteswaps Scramblables respectent le format suivant (p \x{e9}tant la p\x{e9}riode, c et Ak des entiers positifs) : {Ak*p + c} [k=0...k=p\-1]\n\nParam\x{e8}tres :\n\n\- <int> : P\x{e9}riode p.\n\- <int> : Valeur Maximum de Ak.\n\- <int> : Valeur Maximum de Constante c.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;	
	our $MSG_SSWAP_MENU_GENSSFROMTHROWS_1 = "G\x{e9}n\x{e9}ration de Siteswaps depuis liste de lancers.\n";
	our $MSG_SSWAP_MENU_GENSSFROMTHROWS_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n\- <\"siteswap\"> : Suite de chiffres dont on veut obtenir l'ensemble des combinaisons valides.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-A <y|n> : Une option particuli\x{e8}re non r\x{e9}pertori\x{e9}e qui consid\x{e8}re uniquement les sym\x{e8}tries pour les Siteswap S et MS (D\x{e9}faut:n).".$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENTRANSBTWNSS_1 = "G\x{e9}n\x{e9}ration de Transitions entre Siteswaps depuis les Diagrammes Etats/Transitions.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSS_2 = "Param\x{e8}tres :\n\n\- <\"siteswap1\"> : Siteswap Initial.\n\n\- <\"siteswap2\"> : Siteswap Final.\n\n\- <int> : Profondeur.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[h|m|c|g|i|o|p|r|s|t|u] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-h <nb> : Hauteur Max en h\x{e9}xad\x{e9}cimal.\n\n\t\-m <int> : Nombre Min de Lancers Multiplexes.\n\n\nLes options suivantes ne sont consid\x{e9}r\x{e9}es que lors de la g\x{e9}n\x{e9}ration d'un fichier SSHTML ou JML :".$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c1."\n\n\- [\"fichier\"] Optionnel, fichier XLS Matrice Etats/Transitions valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu).";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_1 = "G\x{e9}n\x{e9}ration de Transitions entre Siteswaps depuis les Diagrammes Etats/Transitions R\x{e9}duits.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_2 = "Param\x{e8}tres :\n\n\- <\"siteswap1\"> : Siteswap Initial.\n\n\- <\"siteswap2\"> : Siteswap Final.\n\n\- <int> : Profondeur.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[h|m|c|g|i|o|p|r|s|t|u] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-h <nb> : Hauteur Max en h\x{e9}xad\x{e9}cimal.\n\n\t\-m <int> : Nombre Min de Lancers Multiplexes.\n\n\nLes options suivantes ne sont consid\x{e9}r\x{e9}es que lors de la g\x{e9}n\x{e9}ration d'un fichier SSHTML ou JML :".$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c1."\n\n\- [\"fichier\"] Optionnel, fichier XLS Matrice Etats/Transitions R\x{e9}duite valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu).";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSTATES_1 = "G\x{e9}n\x{e9}ration de Transitions entre Etats depuis les Diagrammes Etats/Transitions.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSTATES_2 = "Param\x{e8}tres :\n\n\- <\"state1\"> : Etat Initial.\n\n\- <\"state2\"> : Etat Final.\n\n\- <int> : Profondeur.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[h|m] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-h <nb> : Hauteur Max en h\x{e9}xad\x{e9}cimal.\n\t\-m <int> : Nombre Min de Lancers Multiplexes.\n\n\- [\"fichier1\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher.\n\n\- [\"fichier2\"] Optionnel, fichier XLS Matrice Etats/Transitions valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu)."; 
	our $MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_1 = "G\x{e9}n\x{e9}ration de Transitions entre Etats depuis les Diagrammes Etats/Transitions R\x{e9}duits.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_2 = "Param\x{e8}tres :\n\n\- <\"state1\"> : Etat Initial.\n\n\- <\"state2\"> : Etat Final.\n\n\- <int> : Profondeur.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[h|m] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-h <nb> : Hauteur Max en h\x{e9}xad\x{e9}cimal.\n\t\-m <int> : Nombre Min de Lancers Multiplexes.\n\n\- [\"fichier1\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher.\n\n\- [\"fichier2\"] Optionnel, fichier XLS Matrice Etats/Transitions R\x{e9}duite valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu)."; 
	our $MSG_SSWAP_MENU_DRAW_1 = "Dessine le Diagramme associ\x{e9} au Siteswap.";
	our $MSG_SSWAP_MENU_DRAW_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} dessiner.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1."\n\n\- [\\%hash] : Optionnel, hash des transitions. Dans ce cas le Siteswap n'est utilis\x{e9} que pour le titre. Chaque Cl\x{e9}/Valeur est de la forme : Ri:j pour une transition amorc\x{e9}e \x{e0} droite ou Li:j lorsqu'il s'agit de la gauche. i correspond au Beat du lancer et j est le num\x{e9}ro de l'objet lors du lancer (en commen\x{e7}ant \x{e0} 0) pour aider \x{e0} la colorisation. \n\tEx :  %hash = (
	\t'L2:0' => 'R4:0',
	\t'R2:0' => 'R4:1',
	\t'L4:0' => 'R6:0',
	\t'R4:0' => 'R5:0',
	\t'R4:1' => 'L6:0',
	\t'R6:0' => 'R6:0'
	\t);";
	our $MSG_SSWAP_MENU_DRAWSTATES_1 = "G\x{e9}n\x{e9}ration des Graphes Etats/Transitions (Graphviz).";
	our $MSG_SSWAP_MENU_DRAWSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n\- <\"fichier1\"> : fichier de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_FORMAT."\n\n\- [\"fichier2\"] Optionnel, fichier XLS Matrice Etats/Transitions valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu).";
	our $MSG_SSWAP_MENU_DRAWSTATES_OPT="\n Graphviz doit pr\x{e9}alablement \x{ea}tre install\x{e9} et son Path correctement configur\x{e9} dans <conf.ini>";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_1 = "G\x{e9}n\x{e9}ration des Graphes Etats/Transitions R\x{e9}duits (Graphviz).";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n\- <\"fichier1\"> : fichier de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_FORMAT."\n\n\- [\"fichier2\"] Optionnel, fichier XLS Matrice Etats/Transitions R\x{e9}duite valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu).";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_OPT="\n Graphviz doit pr\x{e9}alablement \x{ea}tre install\x{e9} et son Path correctement configur\x{e9} dans <conf.ini>";
	our $MSG_SSWAP_MENU_TIMEREV_1 = "Calcule l'inversion (Time-Reversed) d'un Siteswap.";
	our $MSG_SSWAP_MENU_TIMEREV_2 = "Le Siteswap obtenu ne prend pas en compte la colorisation.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher."; 
	our $MSG_SSWAP_MENU_TIMEREVDIAG_1 = "Calcule l'inversion (Time-Reversed) d'un Siteswap par M\x{e9}thode des Diagrammes.";
	our $MSG_SSWAP_MENU_TIMEREVDIAG_2 = "Le Siteswap obtenu ne prend pas en compte la colorisation; le diagramme la consid\x{e8}re, cependant le Siteswap obtenu peut\-\x{ea}tre moins synth\x{e9}tique que celui rendu par la function timeRev.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 
	our $MSG_SSWAP_MENU_SYM_1 = "Calcule la sym\x{e9}trie d'un Siteswap.";
	our $MSG_SSWAP_MENU_SYM_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher."; 
	our $MSG_SSWAP_MENU_SYMDIAG_1 = "Calcule la sym\x{e9}trie d'un Siteswap par M\x{e9}thode des Diagrammes.";
	our $MSG_SSWAP_MENU_SYMDIAG_2 = "Le Siteswap obtenu peut\-\x{ea}tre moins synth\x{e9}tique que celui rendu par la function sym.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher;\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 
	our $MSG_SSWAP_MENU_GETORBITS_1 = "Donne les Orbites d'un Siteswap.";
	our $MSG_SSWAP_MENU_GETORBITS_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- <int> : Mode de colorisation (D\x{e9}faut:2)\n\t\t'0' : pas de colorisation;\n\t\t'1' : Multiplexe dans l'ordre croissant des valeurs \n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents;\n\t\t'2' : Multiplexe dans l'ordre d\x{e9}croissant des valeurs\n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents.\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher."; 
	our $MSG_SSWAP_MENU_GETORBITSAGGR_1 = "Donne les Orbites Aggr\x{e9}g\x{e9}es d'un Siteswap.";
	our $MSG_SSWAP_MENU_GETORBITSAGGR_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap\n\n\- <int> : Mode de colorisation (D\x{e9}faut:2)\n\t\t'0' : pas de colorisation;\n\t\t'1' : Multiplexe dans l'ordre croissant des valeurs \n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents;\n\t\t'2' : Multiplexe dans l'ordre d\x{e9}croissant des valeurs\n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents.\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher."; 
	our $MSG_SSWAP_MENU_EXPANDSYNC_1 = "D\x{e9}veloppe un Siteswap Synchrone.";
	our $MSG_SSWAP_MENU_EXPANDSYNC_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} d\x{e9}velopper.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_ISVALID_1 = "Teste la validit\x{e9} du Siteswap.";
	our $MSG_SSWAP_MENU_ISVALID_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_ISSYNTAXVALID_1 = "Teste la syntaxe grammaticale du Siteswap.";
	our $MSG_SSWAP_MENU_ISSYNTAXVALID_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_SHRINK_1 = "Forme Abr\x{e9}g\x{e9}e d'un Siteswap.";
	our $MSG_SSWAP_MENU_SHRINK_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} abr\x{e9}g\x{e9}.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_SIMPLIFY_1 = "Simplification d'un Siteswap.";
	our $MSG_SSWAP_MENU_SIMPLIFY_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} simplifier.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_PERIODMIN_1 = "Longueur de la P\x{e9}riode Minimum d'un Siteswap.";
	our $MSG_SSWAP_MENU_PERIODMIN_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap dont on veut obtenir la P\x{e9}riode minimum.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETINFO_1 = "Affiche des informations sur le Siteswap.";
	our $MSG_SSWAP_MENU_GETINFO_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETHEIGHTMAX_1 = "Donne la hauteur Maximum du Siteswap.";
	our $MSG_SSWAP_MENU_GETHEIGHTMAX_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETHEIGHTMIN_1 = "Donne la hauteur Minimum du Siteswap.";
	our $MSG_SSWAP_MENU_GETHEIGHTMIN_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETSSTYPE_1 = "Donne la famille du Siteswap parmi V (Vanille), M (Multiplexe), S (Synchrone), MS (Multiplexe-Synchrone), MULTI (MultiSynchrone).";
	our $MSG_SSWAP_MENU_GETSSTYPE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";	
	our $MSG_SSWAP_MENU_GETNUMBER_1 = "Donne le nombre d'objets du Siteswap.";
	our $MSG_SSWAP_MENU_GETNUMBER_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETPERIOD_1 = "Donne la P\x{e9}riode du Siteswap.";
	our $MSG_SSWAP_MENU_GETPERIOD_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETANAGRAMMES_1 = "Donne les Anagrammes du Siteswap."; 
	our $MSG_SSWAP_MENU_GETANAGRAMMES_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap (V,M,S ou MS).\n\- [\"options\"] Diff\x{e9}rentes options [r|k]:\n\t\-r <y|n> : suppression des Siteswaps \x{e9}quivalents (D\x{e9}faut:y).\n\t\-k <y|n> : option pour Siteswaps S et MS: pour les Siteswaps sym\x{e9}triques finissant par *, le statut Scramblable est consid\x{e9}r\x{e9} uniquement sur la premi\x{e8}re portion. (D\x{e9}faut:y).\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_GETSSSTATUS_1 = "Donne le Statut du Siteswap (Excit\x{e9} [Excited], non excit\x{e9} [Ground] ou [Unknown] si le nombre d'objets ne permet pas de le dire)";
	our $MSG_SSWAP_MENU_GETSSSTATUS_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} analyser.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_WRITESTATES_1 = "G\x{e9}n\x{e9}ration en Excel des Matrices Etats/Transitions.";
	our $MSG_SSWAP_MENU_WRITESTATES_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets (-1 non sp\x{e9}cifi\x{e9}).\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n\- <\"fichier\"> : corps du fichier de r\x{e9}sultats sans l'extension .xlsx\n\nVous devez disposer auparavant d'Excel avec une license valide ! (Fonctionne sous Windows).";	
	our $MSG_SSWAP_MENU_ISEQUIVALENT_1 = "Teste l'\x{e9}quivalence de 2 Siteswaps.";
	our $MSG_SSWAP_MENU_ISEQUIVALENT_2 = "Param\x{e8}tres :\n\n\- <\"siteswap1\"> <\"siteswap2\"> : Siteswaps \x{e0} comparer.\n\n\- [\"options\"] Diff\x{e9}rentes options [c|p|s] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-c <y|n> : Consid\x{e8}re la colorisation des multiplexes dans\n\t\tl'\x{e9}quivalence (D\x{e9}faut:n).\n\n\t\-s <y|n> : Consid\x{e8}re la sym\x{e9}trie dans l'\x{e9}quivalence \n\t\t(D\x{e9}faut:n).\n\n\t\-p <y|n> : Consid\x{e8}re les permutations de Siteswap dans \n\t\tl'\x{e9}quivalence, la sym\x{e9}trie en fait partie (D\x{e9}faut:y).\n\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	
	our $MSG_SSWAP_MENU_PRINTSSLIST_1 = "Met en forme une Liste de Siteswaps (Texte, Fichier ou dans fichier JML JugglingLab).";
	our $MSG_SSWAP_MENU_PRINTSSLIST_2 = "Param\x{e8}tres :\n\n\- <List> : Liste Perl de Siteswaps. Si vide utilise le fichier Input.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\- [\"fichierInput\"] : Fichier Input utilis\x{e9} si Liste vide.";
	our $MSG_SSWAP_MENU_PRINTSSLISTHTML_1 = "Cr\x{e9}e un fichier HTML depuis une Liste de Siteswaps en ajoutant diagrammes Ladder, JML JugglingLab et liste TXT.";
	our $MSG_SSWAP_MENU_PRINTSSLISTHTML_2 = "Param\x{e8}tres :\n\n\- <\"fichierInput\"> : Fichier contenant la Liste de Siteswaps.\n\n\- <\"fichierOutput\"> : Fichiers r\x{e9}sultats (avec ajout extensions .html/.jml/.txt).\n\n\- <\"string\"> : Titre.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[v|l|j|f|m] ".$MSG_SSWAP_PRINTSS_OPTS_a1_ssListHTML."\n\n\t\-v <y|n> : Ajoute une colonne avec Siteswaps simplifi\x{e9}s (D\x{e9}faut:n).\n\t\-l <y|n> : Ajoute une colonne avec Siteswaps transform\x{e9}s pour des lancers plus bas mais en conservant le Tempo des lancers par le biais de Hold Times suppl\x{e9}mentaires (D\x{e9}faut:n).\n\t\-j <y|n> : Ajoute une colonne avec Siteswaps transform\x{e9}s pour des lancers plus bas mais en conservant le Tempo des lancers par le biais de Hold Times suppl\x{e9}mentaires et adapt\x{e9} pour une visualisation JugglingLab. JugglingLab ne comprenant que des Hold Times sur des lancers 1x ou 2, les Hold Times de valeur sup\x{e9}rieure seront donc convertis (D\x{e9}faut:n).\n\t\-f <int> : Nombre de Free Beats Minimums sur la transformation entre 2 lancers (D\x{e9}faut:1). Comme l'objet est r\x{e9}cup\x{e9}r\x{e9} un peu avant son lancer, avec g\x{e9}n\x{e9}ralement un Dwell Time autour de 1, une valeur inf\x{e9}rieure occasionne des squeezes.\n\t\-m <int> : Valeur Minimum du lanc\x{e9} sur m\x{ea}me main apr\x{e8}s transformation afin d'\x{e9}viter par exemple une transformation d'un lanc\x{e9} en hold (D\x{e9}faut:3)".$MSG_SSWAP_PRINTSS_OPTS_b1;       
	our $MSG_SSWAP_MENU_GETSTATES_1 = "Donne les Etats travers\x{e9}s.";
	our $MSG_SSWAP_MENU_GETSTATES_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";
	our $MSG_SSWAP_MENU_ISFULLMAGIC_1 = "Teste si un Siteswap est Magique Complet.";
	our $MSG_SSWAP_MENU_ISFULLMAGIC_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher. Les Valeurs de Retour sont -1 (Non/Invalide), 0 (Full), 1 (Odd/Impair), 2 (Even/Pair).";    
	our $MSG_SSWAP_MENU_ISPRIME_1 = "Teste si un Siteswap est Premier.";
	our $MSG_SSWAP_MENU_ISPRIME_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";    
	our $MSG_SSWAP_MENU_ISREVERSIBLE_1 = "Teste si un Siteswap est Reversible.";
	our $MSG_SSWAP_MENU_ISREVERSIBLE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";    
	our $MSG_SSWAP_MENU_ISPALINDROME_1 = "Teste si un Siteswap est un Palindrome.";
	our $MSG_SSWAP_MENU_ISPALINDROME_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";    
	our $MSG_SSWAP_MENU_ISSQUEEZE_1 = "Teste si un Siteswap Multiplexe, Synchrone Multiplexe ou MultiSynchrone est un Squeeze.";
	our $MSG_SSWAP_MENU_ISSQUEEZE_2 = "Lancers de m\x{ea}me hauteur et tenue en main ne sont pas consid\x{e9}r\x{e9}s.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";    
	our $MSG_SSWAP_MENU_ISSCRAMBLABLE_1 = "Teste si un Siteswap est Scramblable.";
	our $MSG_SSWAP_MENU_ISSCRAMBLABLE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} tester (V,M,S ou MS).\n\- [\"options\"] : Diff\x{e9}rentes options \-[k|l|v]:\n\t\-k <y|n> : option pour Siteswaps S et MS: pour les Siteswaps sym\x{e9}triques finissant par *, le statut Scramblable est consid\x{e9}r\x{e9} uniquement sur la premi\x{e8}re portion. (D\x{e9}faut:y).\n\t\-l <y|n> : option pour limiter la p\x{e9}riode des Siteswaps pour \x{e9}viter de saturer M\x{e9}moire/CPU (D\x{e9}faut:y).\n\t\-v <int> : P\x{e9}riode Maximum \x{e0} consid\x{e9}rer (D\x{e9}faut:8).\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";    
	our $MSG_SSWAP_MENU_GENSSPRIME_1 = "G\x{e9}n\x{e8}re les Siteswaps Premiers.";
	our $MSG_SSWAP_MENU_GENSSPRIME_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'S' (Synchrone), 'M' (Multiplexe), 'MS' (Multiplexe Synchrone), 'MULTI' (MultiSynchrone).\n\n== cas 'V', 'S' ==\n\t\- <int> : Nombre d'objets.\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\n== cas 'M', 'MS', 'MULTI' ==\n\t\- <int> : Nombre d'objets.\n\t\- <nb> : Valeur du lancer max en h\x{e9}xad\x{e9}cimal.\n\t\- <int> : Nombre Max de lancers Simultan\x{e9}s.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a2.$MSG_SSWAP_PRINTSS_OPTS_b2.$MSG_SSWAP_PRINTSS_OPTS_c2."\n\n\- [\"fichier\"] Optionnel, fichier XLS Matrice Etats/Transitions (R\x{e9}duite ou non) valide en entr\x{e9}e pour acc\x{e9}l\x{e9}rer les calculs (chemin absolu)."; 
	our $MSG_SSWAP_MENU_TOSTACK_1 = "Donne la Notation Stack correspondante [Exp\x{e9}rimental].";
	our $MSG_SSWAP_MENU_TOSTACK_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[m|s] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-m <int> : Mode de Calcul des trous pour les multiplexes\n\t(D\x{e9}faut:1)\n\t\t'0' : Pas de trou entre les lancers multiplex [D\x{e9}mo];\n\t\t'1' : Ordre Croissant d'arriv\x{e9}e;\n\t\t'2' : Ordre D\x{e9}croissant d'arriv\x{e9}e.\n\n\t\-s <n|r|l> : Mode de Calcul des trous pour les Synchrones \n\t(D\x{e9}faut:r)\n\t\t'n' : Synchro totale. Pas de consid\x{e9}ration entre les mains, \n\t\tstacks ind\x{e9}pendantes [D\x{e9}mo];\n\t\t'r' : Main droite en premier;\n\t\t'l' : Main gauche en premier.\n\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";

	our $MSG_SSWAP_MENU_JDEEP_1 = "G\x{e9}n\x{e9}ration de Siteswaps Premiers (jdeep from Jack Boyce).";
	our $MSG_SSWAP_MENU_JDEEP_2 = "jdeep version 5.1, Jack Boyce\n(02/17/99) jboyce@users.sourceforge.net\n\nCe programme a pour but la recherche des longs Siteswaps Premiers.\n\nformat : \n\tjdeep (\'<# objects> <max. throw> [<min. length>] [options]\')\n\navec :\n\t<# objects>   = Nombre d'objets dans les patterns trouv\x{e9}s.\n\t<max. throw>  = plus grand lancer \x{e0} utiliser.\n\t<min. length> = plus petits patterns \x{e0} trouver (optionnel, pour acc\x{e9}l\x{e9}rer les recherches)\n\nDiverses options sont disponibles :\n\t-block <skips> : donne les patterns en block form, en\n\t\t\t autorisant le nombre de skips sp\x{e9}cifi\x{e9}s.\n\t-super <shifts> : trouve (presque) les patterns superprim\x{e9}, en\n\t\t\t autorisant le nombre de lancer shift sp\x{e9}cifi\x{e9}s.\n\t-inverse : affiche l'inverse \x{e9}galement, en mode -super.\n\t-g : donne les patterns ground-state (fondamentaux)\n\t\t\t uniquement.\n\t-ng : donne les patterns excit\x{e9}s uniquement.\n\t-full : donne tous les patterns; sinon seuls les patterns aussi\n\t\t\t longs que les patterns les plus longs sont affich\x{e9}s.\n\t-noprint : suprime l'affichage des patterns.\n\t-exact : affiche les patterns de la longueur sp\x{e9}cifi\x{e9}e\n\t\t\t (pas plus long).\n\t-x <throw1 throw2 ...> : exclu les lancers list\x{e9}s \n\t\t\t (pour acc\x{e9}l\x{e9}rer les recherches).\n\t-trim : active l'algorithme de graph trimming.\n\t-notrim : d\x{e9}sactive l'algorithme de graph trimming.\n\t-fichier : mode de sortie fichier.\n\t-temps <secs> : temps maximum d'ex\x{e9}cution de la fonction.";

	our $MSG_SSWAP_MENU_DUAL_1 = "G\x{e9}n\x{e9}ration du Siteswap Dual.";
	our $MSG_SSWAP_MENU_DUAL_2 = "Param\x{e8}tres :\n\n\- <type> : Type de g\x{e9}n\x{e9}rateur parmi 'V' (Vanille), 'M' (Multiplexe).\n\n\- <\"siteswap\"> : Siteswap.\n\n== cas 'V' ==\n\t\- <nb> : Valeur du lancer max en hexad\x{e9}cimal.\n\n== cas 'M' ==\n\t\- <nb> : Valeur du lancer max en hexad\x{e9}cimal.\n\t\- <int> : Nombre de Max de lancers simultan\x{e9}s.\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. Si -1, retourne le r\x{e9}sultat sans l'afficher.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 

	our $MSG_SSWAP_MENU_SLIDESWITCHSYNC_1 = "Donne les Siteswaps associ\x{e9}s en changeant la Synchronisation.";
	our $MSG_SSWAP_MENU_SLIDESWITCHSYNC_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\- [\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher.";

	    
	our $MSG_SSWAP_MENU_POLYRHYTHMFOUNTAIN_1 = "Outil Fontaine Polyrythmique de Josh Mermelstein.";
	our $MSG_SSWAP_MENU_POLYRHYTHMFOUNTAIN_2 = "Param\x{e8}tres :\n\n\- Aucun.";

	our $MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_1 = "Transformation de Siteswaps pour des lanc\x{e9}s plus bas en conservant le Tempo des lanc\x{e9}s mais en ajoutant des temps suppl\x{e9}mentaires de Hold Times.";
	our $MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_2 = "Particuli\x{e8}rement int\x{e9}ressant pour les Polyrythmes.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} transformer.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[f|j|m] pr\x{e9}cis\x{e9}es ci-dessous:\n\t\-f <int> : Nombre de Free Beats Minimums sur la transformation entre 2 lancers (D\x{e9}faut:1). Comme l'objet est r\x{e9}cup\x{e9}r\x{e9} un peu avant son lancer, avec g\x{e9}n\x{e9}ralement un Dwell Time autour de 1, une valeur inf\x{e9}rieure occasionne des squeezes.\n\t\-j <y|n> : Adaptation JugglingLab. JugglingLab ne comprenant que des Hold Times sur des lancers 1x ou 2, les Hold Times de valeur sup\x{e9}rieure seront donc convertis.\n\t\-m <int> : Valeur Minimum du lanc\x{e9} sur m\x{ea}me main apr\x{e8}s transformation afin d'\x{e9}viter par exemple une transformation d'un lanc\x{e9} en hold (D\x{e9}faut:3).\n\n[\-1] Optionnel, retourne le r\x{e9}sultat sans l'afficher (D\x{e9}faut:n)";	
	our $MSG_SSWAP_SLIDESWITCHSYNC_ERR1 = "Famille De Siteswaps non trait{e9}e.";
	
	our $MSG_SSWAP_DUAL_ERR0 = "G\x{e9}n\x{e9}ration Possible uniquement pour Siteswaps des familles V et M.";
	our $MSG_SSWAP_DUAL_ERR1 = "Param\x{e8}tre Hauteur doit \x{ea}tre sup\x{e9}rieure \x{e0} Hauteur Max.";
	our $MSG_SSWAP_DUAL_ERR2 = "G\x{e9}n\x{e9}ration Possible uniquement pour ce Siteswap en Famille M.";
	our $MSG_SSWAP_DUAL_ERR3 = "Param\x{e8}tre Multiplexe doit \x{ea}tre sup\x{e9}rieure au Nombre Multiplexes Max du Siteswap.";

	our $MSG_SSWAP_ANIMATE_ANTISS_ERR0 = "Non disponible sur ce syst\x{e8}me.";
	
	our $MSG_SSWAP_GENSS_1 = "\t ";
	our $MSG_SSWAP_GENSS_2 = " Siteswap(s) g\x{e9}n\x{e9}r\x{e9}(s)\n";
	our $MSG_SSWAP_GENSS_3 = "\t (Nombre d'objets : ";
	our $MSG_SSWAP_GENSS_4 = "; Valeur du lancer max : ";
	our $MSG_SSWAP_GENSS_5 = "; P\x{e9}riode : ";
	our $MSG_SSWAP_GENSS_6 = ")\n";	
	our $MSG_SSWAP_GENSS_7 = "Siteswap(s)";
	
	our $MSG_SSWAP_GENTRANS_1 = "\t ";
	our $MSG_SSWAP_GENTRANS_2 = " Siteswap(s) g\x{e9}n\x{e9}r\x{e9}(s)\n";
	our $MSG_SSWAP_GENTRANS_3 = "\t (Siteswap1 : ";
	our $MSG_SSWAP_GENTRANS_4 = "; Siteswap2 : ";
	our $MSG_SSWAP_GENTRANS_5 = ")\n";	
	our $MSG_SSWAP_GENTRANS_6 = "Siteswap(s)";

	our $MSG_SSWAP_TIMEREV_ERR0 = "Siteswap Invalide : "; 

	our $MSG_SSWAP_SYM_ERR0 = "Siteswap Invalide : ";

	our $MSG_SSWAP_ISSCRAMBLABLE_ERR1 = "Erreur : P\x{e9}riode de Siteswaps Non g\x{e9}r\x{e9}s : ";

	our $MSG_SSWAP_ISVALID_ERR0 = "Siteswap Invalide "; 
	our $MSG_SSWAP_ISVALID_ERR1 = "(Syntaxe Invalide)\n";
	our $MSG_SSWAP_ISVALID_ERR3a = "(Moyenne Invalide : ";
	our $MSG_SSWAP_ISVALID_ERR3b = ")\n";
	our $MSG_SSWAP_ISVALID_MSG1a = "Contient des R\x{e9}ceptions Simultan\x{e9}es en Main Droite.\n";
	our $MSG_SSWAP_ISVALID_MSG1b = "Contient des R\x{e9}ceptions Simultan\x{e9}es en Main Gauche.\n";
	our $MSG_SSWAP_ISVALID_MSG2 = "Contient des Lancers en grappes de m\x{ea}me valeur\n";
	our $MSG_SSWAP_ISVALID_MSG3 = "Vrai Multiplexes Uniquement\n";
	our $MSG_SSWAP_ISVALID_MSG4 = "MultiSync R\x{e9}duit : ";	
	our $MSG_SSWAP_ISVALID_MSG4b = "MultiSync Etendu : ";	
	our $MSG_SSWAP_ISVALID_MSG5a = "Multiplexe";
	our $MSG_SSWAP_ISVALID_MSG5b = "et Squeeze";
	our $MSG_SSWAP_ISVALID_MSG5c = "ne correspondent pas pour : ";

	our $MSG_SSWAP_GENSTATES_MSG1a = "Matrice Etats-Transitions";
	our $MSG_SSWAP_GENSTATES_MSG1 = "Etat Non Consid\x{e9}r\x{e9} : ";

	our $MSG_SSWAP_GETSTATES_ERR2 = "Erreur : Siteswap Invalid.";

	our $MSG_SSWAP_GETANAGRAMMES_ERR1 = "Erreur : Siteswaps MultiSynchrones Non g\x{e9}r\x{e9}s";

	our $MSG_SSWAP_GENSSFROMSTATES_MSG1 = "Type";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG2 = "Redondances supprim\x{e9}es";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG3 = "Hauteur Max";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG4 = "P\x{e9}riode";
	our $MSG_SSWAP_GENSSFROMSTATES_ERR1 = "Type Invalide.";

	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG1 = "Type";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a = "Etat Initial";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b = "Etat Final";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG3 = "Hauteur Max";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG4 = "P\x{e9}riode";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_ERR1 = "Incompatibili\x{e9} de Siteswaps.";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_ERR2 = "Incompatibili\x{e9} du nombre d'objets.";

	our $MSG_SSWAP_GENTRANSBTWNSS_MSG1 = "Type";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG2a = "Siteswap Initial";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG2b = "Siteswap Final";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG3 = "Hauteur Max";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG4 = "P\x{e9}riode";
	our $MSG_SSWAP_GENTRANSBTWNSS_ERR0 = "Siteswap Invalide.";
	our $MSG_SSWAP_GENTRANSBTWNSS_ERR2 = "Incompatibili\x{e9} du nombre d'objets.";
	
	our $MSG_SSWAP_GENAGGRSTATES_MSG1a = "Matrice Etats/Transitions R\x{e9}duite";
	
	our $MSG_SSWAP_WRITE_EXCEL_FROM_STATES1 = "Abandon ... trop d'\x{e9}tats pour g\x{e9}n\x{e9}rer le fichier Excel. Utilisez write_states_xls ...\n";
	our $MSG_SSWAP_WRITE_EXCEL_FROM_STATES2 = "Conversion de la Matrice en fichier Excel.\n"; 	

	our $MSG_SSWAP_WRITE_TXT_FROM_STATES2 = "Conversion de la Matrice en fichier Texte.\n"; 

	our $MSG_SSWAP_GENPROBERTDIAG_MSG1a = "Diagramme de Martin Probert";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1b = "Nombre Objets";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1c = "Hauteur Max";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1d = "P\x{e9}riode";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1h = "Toute Hauteur";

	our $MSG_SSWAP_GENPROBERTSS_MSG1a = "G\x{e9}n\x{e9}ration de Siteswaps Vanilles depuis Diagrammes de Martin Probert";
	our $MSG_SSWAP_GENPROBERTSS_MSG1b = "Nombre Objets";
	our $MSG_SSWAP_GENPROBERTSS_MSG1c = "Hauteur Max";
	our $MSG_SSWAP_GENPROBERTSS_MSG1d = "P\x{e9}riode";
	our $MSG_SSWAP_GENPROBERTSS_MSG1e = "Siteswap(s)";
	our $MSG_SSWAP_GENPROBERTSS_MSG1f = "Rejet : ";
	our $MSG_SSWAP_GENPROBERTSS_MSG1g = "Redondances supprim\x{e9}es ";
	our $MSG_SSWAP_GENPROBERTSS_MSG1h = "Toute Hauteur";

	our $MSG_SSWAP_GENMAGICSS_MSG1a = "Redondances supprim\x{e9}es ";

	our $MSG_SSWAP_ISPRIME_MSG1 = "Erreur : Siteswap MultiSynchrone (non impl\x{e9}ment\x{e9}) ou Siteswap Invalide.";
	our $MSG_SSWAP_GENSSPRIME_MSG0 = "SITESWAPS PREMIERS (PRIME SITESWAPS)";
	our $MSG_SSWAP_GENSSPRIME_MSG1 = "Nombre de Siteswaps Premiers : ";
	our $MSG_SSWAP_GENSSPRIME_MSG2 = "Plus long(s) Circuit(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG3 = "Etat(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG4 = "Plus long(s) Siteswap(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG5 = "P\x{e9}riode =";
	our $MSG_SSWAP_GENSSPRIME_MSG6 = "Histogramme Nombre d'\x{e9}tats";
	our $MSG_SSWAP_GENSSPRIME_MSG7 = "(Nombre de Circuits Premiers par Nombre d'\x{e9}tats)";
	our $MSG_SSWAP_GENSSPRIME_MSG8 = "(Nombre de Siteswaps Premiers par Nombre d'\x{e9}tats))";
	our $MSG_SSWAP_GENSSPRIME_MSG9 = "Occurrence des \x{e9}tats";
	our $MSG_SSWAP_GENSSPRIME_MSG10 = "Longueur";
	our $MSG_SSWAP_GENSSPRIME_MSG11 = "Etat Initial";

	our $MSG_SSWAP_TOSTACK_MSG1 = "Erreur : Siteswap MultiSynchrone (non impl\x{e9}ment\x{e9}) ou Siteswap Invalide.";

	our $MSG_SSWAP_GETSTATES_FROM_XLS_MSG1 = "Matrice Etats/Transitions charg\x{e9}e.";

	our $MSG_SSWAP_CHECK_XLS_FILE_1 = "Attention : le fichier XLS n'est pas celui escompt\x{e9} ";
	our $MSG_SSWAP_CHECK_XLS_FILE_2 = "V\x{e9}rifiez ce que vous faites sinon vous risquez d'obtenir un r\x{e9}sultat incoh\x{e9}rent !";

	our $MSG_SSWAP_GENERAL1 = "Siteswap Asynchrone";
	our $MSG_SSWAP_GENERAL1p = "Siteswap(s) Asynchrone(s)";
	our $MSG_SSWAP_GENERAL1b = "Siteswap Synchrone";
	our $MSG_SSWAP_GENERAL1c = "Siteswap MultiSynchrone";
	our $MSG_SSWAP_GENERAL1cp = "Siteswap(s) MultiSynchrone(s)";
	our $MSG_SSWAP_GENERAL1bp = "Siteswap(s) Synchrone(s)";
	our $MSG_SSWAP_GENERAL2 = "Nombre d'Objets";
	our $MSG_SSWAP_GENERAL2b = "Pas de limitation sur le Nombre d'Objets";
	our $MSG_SSWAP_GENERAL3 = "Hauteur Max";
	our $MSG_SSWAP_GENERAL3b = "Hauteur Min";
	our $MSG_SSWAP_GENERAL4 = "Nombre de Lancers Simultan\x{e9}s Max par Multiplexe";
	our $MSG_SSWAP_GENERAL5 = "Somme";
	our $MSG_SSWAP_GENERAL6 = "P\x{e9}riode";
	our $MSG_SSWAP_GENERAL10 = "Etat(s)";
	our $MSG_SSWAP_GENERAL11 = "Transition(s)";
	our $MSG_SSWAP_GENERAL12 = "Siteswap Time Reversed";
	our $MSG_SSWAP_GENERAL13 = "P\x{e9}riode Min";
	our $MSG_SSWAP_GENERAL14 = "Mode";
	our $MSG_SSWAP_GENERAL15 = "Nombre de Lancers";
	our $MSG_SSWAP_GENERAL16 = "Nombre Max de Lancers Multiplexes";
	our $MSG_SSWAP_GENERAL17 = "Objet(s)";
	our $MSG_SSWAP_GENERAL18 = "Pas de license Excel d\x{e9}tect\x{e9}e. Certaines fonctions ne seront pas disponibles.";
	our $MSG_SSWAP_GENERAL19 = "Sym\x{e9}trie";

	our $MSG_SSWAP_PRINTSS_OPTS_a1 = "\- [\"options\"] Diff\x{e9}rentes options \-[b|c|d|g|i|n|o|p|r|s|t|u] pr\x{e9}cis\x{e9}es ci-dessous :";
	our $MSG_SSWAP_PRINTSS_OPTS_a1_ssListHTML = "ainsi que les options d'affichages \-[b|c|d|g|i|n|o|p|r|s|t|u] pr\x{e9}cis\x{e9}es ci-dessous :";
	our $MSG_SSWAP_PRINTSS_OPTS_a2 = "\- [\"options\"] Diff\x{e9}rentes options \-[b|c|d|g|h|i|l|n|o|p|s|t] pr\x{e9}cis\x{e9}es ci-dessous :";
	our $MSG_SSWAP_PRINTSS_OPTS_b1 = "\n\n\t\-r <0|1|2> :  suppression des redondances (D\x{e9}faut:0):\n\t\t'0' : Pas de suppression;\n\t\t'1' : Suppression des redondances avec conservation \n\t\tdes Siteswaps Ground prioritairement;\n\t\t'2' : Suppression des redondances selon l'ordre de la liste.\n\n\t\-c <y|n> : Consid\x{e8}re la colorisation des multiplexes pour la \n\tsuppression des redondances (D\x{e9}faut:n).\n\n\t\-g <y|n> : Ground Seulement (D\x{e9}faut:n).\n\n\t\-b <y|n> : Reversible Seulement (D\x{e9}faut:n).\n\n\t\-d <y|n> : Scramblable Seulement (D\x{e9}faut:n).\n\n\t\-i <y|n> : Donne des Informations suppl\x{e9}mentaires (D\x{e9}faut:n).\n\n\t\-n <y|n> : Palindrome Seulement (D\x{e9}faut:n).\n\n\t\-q <y|n> : Non Squeeze Seulement (D\x{e9}faut:n).\n\n\t\-o <0|1|2|3> : Arrangement du R\x{e9}sultat (D\x{e9}faut:1).\n\t\t'0' : Pas d'arrangement;\n\t\t'1' : Tri Alphanum\x{e9}rique;\n\t\t'2' : Classification par nombre d'objets;\n\t\t'3' : Classification par p\x{e9}riode.\n\n\t\-p <y|n> : Consid\x{e8}re les permutations de Siteswap pour la \n\tsuppression des redondances, la sym\x{e9}trie en fait partie (D\x{e9}faut:y).\n\n\t\-s <y|n> : Consid\x{e8}re la sym\x{e9}trie pour la \n\tsuppression des redondances (D\x{e9}faut:n).\n\n\t\-t <\"string\"> : Titre.\n\n\t\-u <y|n> : Premiers Seulement (D\x{e9}faut:n)";
	our $MSG_SSWAP_PRINTSS_OPTS_b2 = "\n\n\t\-r <0|1|2> :  suppression des redondances (D\x{e9}faut:0):\n\t\t'0' : Pas de suppression;\n\t\t'1' : Suppression des redondances avec conservation \n\t\tdes Siteswaps Ground prioritairement;\n\t\t'2' : Suppression des redondances selon l'ordre de la liste.\n\n\t\-c <y|n> : Consid\x{e8}re la colorisation des multiplexes pour la \n\tsuppression des redondances (D\x{e9}faut:n).\n\n\t\-g <y|n> : Ground Seulement (D\x{e9}faut:n).\n\n\t\-b <y|n> : Reversible Seulement (D\x{e9}faut:n).\n\n\t\-d <y|n> : Scramblable Seulement (D\x{e9}faut:n).\n\n\t\-i <y|n> : Donne des Informations suppl\x{e9}mentaires (D\x{e9}faut:n).\n\n\t\-n <y|n> : Palindrome Seulement (D\x{e9}faut:n).\n\n\t\-q <y|n> : Non Squeeze Seulement (D\x{e9}faut:n).\n\n\t\-o <0|1|2|3> : Arrangement du R\x{e9}sultat (D\x{e9}faut:1).\n\t\t'0' : Pas d'arrangement;\n\t\t'1' : Tri Alphanum\x{e9}rique;\n\t\t'2' : Classification par nombre d'objets;\n\t\t'3' : Classification par p\x{e9}riode.\n\n\t\-p <y|n> : Consid\x{e8}re les permutations de Siteswap pour la \n\tsuppression des redondances, la sym\x{e9}trie en fait partie (D\x{e9}faut:y).\n\n\t\-s <y|n> : Consid\x{e8}re la sym\x{e9}trie pour la \n\tsuppression des redondances (D\x{e9}faut:n).\n\n\t\-t <\"string\"> : Titre.\n\n\t\-h <y|n> : histogrammes & circuits utilis\x{e9}s (D\x{e9}faut:n).\n\n\t\-l <y|n> : Synth\x{e8}se de R\x{e9}sultats & plus longs Siteswaps Premiers (D\x{e9}faut:y).";
	our $MSG_SSWAP_PRINTSS_OPTS_c = "\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. \nSi -1, retourne le r\x{e9}sultat sans l'afficher. \nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml; \n\t\tLes Siteswaps invalides sont masqu\x{e9}s.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.";
	our $MSG_SSWAP_PRINTSS_OPTS_c1 = "\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. \nSi -1, retourne le r\x{e9}sultat sans l'afficher. \nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier constitu\x{e9} de siteswaps complets pour une vue JugglingLab \n\t\ten JML en y ajoutant l'extension .jml; \n\t\tLes Siteswaps invalides sont masqu\x{e9}s.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML constitu\x{e9} de siteswaps complets, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.";
	our $MSG_SSWAP_PRINTSS_OPTS_c2 = "\n\n\- [\"fichier\"] Optionnel, fichier de r\x{e9}sultats. \nSi -1, retourne le r\x{e9}sultat sans l'afficher. \nSi -2, affiche les circuits utilis\x{e9}s et la synth\x{e8}se si ceux-ci sont positionn\x{e9}s dans les options. \nSi le fichier commence par : \n\t\- \'JML:\', g\x{e9}n\x{e8}re un fichier constitu\x{e9} de siteswaps complets pour une vue JugglingLab \n\t\ten JML; \n\t\tLes Siteswaps invalides sont masqu\x{e9}s.\n\t\- \'SSHTML:\', g\x{e9}n\x{e8}re un fichier HTML constitu\x{e9} de siteswaps complets, en y ajoutant l'extension \n\t\t.html et contenant diff\x{e9}rentes informations sur \n\t\tles Siteswaps.";
	our $MSG_SSWAP_JML = "Fichier JML g\x{e9}n\x{e9}r\x{e9} \x{e0} charger dans JugglingLab: ";  

	our $MSG_SSWAP_POLYRHYTHM_MSG1 = "Ratio";
	

	################################################"
	#
	# LADDER Module Messages 
	#
	################################################"

	our $MSG_LADDER_MENU_HELP = "La description des Diagrammes se fera en utilisant la notation SITESWAP Classique telle qu'elle est utilis\x{e9}e par JugglingLab.\n\n\tExemples : 534, (6x,4)*, (2x,[22x])(2,[22])(2,[22x])*.\n\nOn consid\x{e9}rera en plus les symboles '!' et '*' que ce soit en Synchrone ou en Asynchrone :\n\n'!' : supprime un Beat de temps. Apr\x{e8}s un Siteswap Synchrone il indique que le lancer suivant se fait sur le Beat suivant cens\x{e9} \x{ea}tre un Beat de r\x{e9}cup\x{e9}ration (et non plus 2 Beats apr\x{e8}s). Apr\x{e8}s un lancer Asynchrone, il indique que le lancer suivant se fait au m\x{ea}me Beat. Il devient alors possible de repr\x{e9}senter un Siteswap Synchrone par un Siteswap Asynchrone. Les Multiplexes peuvent \x{e9}galement \x{ea}tre adapt\x{e9}s selon ce sch\x{e9}ma
\n'*' : dans le cas d'un Siteswap Synchrone il indique un changement de l'ordre des mains et n'est plus obligatoirement positionn\x{e9} \x{e0} la fin. Dans le cas d'un Siteswap Asynchrone, le prochain lancer se fait par la m\x{ea}me main (Notion de Hurry).
\n\n\tExemples : 4!40, 5!*4!*3, 6x0*, (6x,0)*, 51x*, (1x,3)!11x* ...
\n\nCe module diff\x{e9}rentie aussi la colorisation des multiplexes.
\n\n\tExemples : 24[54] et 24[45] ont une colorisation diff\x{e9}rente.
"; 
	
	our $MSG_LADDER_MENU_DRAW_1 = "Dessine le Diagramme en Echelle associ\x{e9} au Siteswap. Graphviz doit avoir \x{e9}t\x{e9} install\x{e9} au pr\x{e9}alable.";
	our $MSG_LADDER_MENU_DRAW_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} dessiner.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1."\n\n\- [\\%hash] : Optionnel, hash des transitions. Dans ce cas le Siteswap n'est utilis\x{e9} que pour le titre. Chaque Cl\x{e9}/Valeur est de la forme : Ri:j pour une transition amorc\x{e9}e \x{e0} droite ou Li:j lorsqu'il s'agit de la gauche. i correspond au Beat du lancer et j est le num\x{e9}ro de l'objet lors du lancer (en commen\x{e7}ant \x{e0} 0) pour aider \x{e0} la colorisation. \n\tEx :  %hash = (
	\t'L2:0' => 'R4:0',
	\t'R2:0' => 'R4:1',
	\t'L4:0' => 'R6:0',
	\t'R4:0' => 'R5:0',
	\t'R4:1' => 'L6:0',
	\t'R6:0' => 'R6:0'
	\t);";
	our $MSG_LADDER_MENU_REMOVE_OBJ_1 = "Dessine le Diagramme en Echelle associ\x{e9} au Siteswap apr\x{e8}s suppression d'un ou plusieurs objets.";
	our $MSG_LADDER_MENU_REMOVE_OBJ_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <int ou \"[list]\"> : Num\x{e9}ro de l'objet \x{e0} supprimer (en commen\x{e7}ant \x{e0} 0) ou liste d'objets s\x{e9}par\x{e9}s par des \",\".\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 
	our $MSG_LADDER_MENU_SYM_1 = "Dessine le Sym\x{e9}trique du Diagramme en Echelle associ\x{e9} au Siteswap.";
	our $MSG_LADDER_MENU_SYM_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 
	our $MSG_LADDER_MENU_INV_1 = "Dessine le Diagramme Time-Reversed du Diagramme en Echelle associ\x{e9} au Siteswap.";
	our $MSG_LADDER_MENU_INV_2 = "Le Siteswap obtenu ne prend pas en compte la colorisation; le diagramme la consid\x{e8}re.\n\nParam\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_MERGE_1 = "Superpose 2 Siteswaps et dessine le Diagramme associ\x{e9}.";
	our $MSG_LADDER_MENU_MERGE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap1\"> : Siteswap1. \n\n\- <\"siteswap2\"> : Siteswap2.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a2.$MSG_GRAPHVIZ_OPTS_b1."\n\n\t\-r <int> : Suppression des 0 dans les Multiplexes (D\x{e9}faut:0)\n\t\t'0' : Suppression;\n\t\t'1' : Conservation.";
	our $MSG_LADDER_MENU_SLIDE_1 = "Dessine le Diagramme en Echelle apr\x{e8}s d\x{e9}calage(s) de la main droite ou gauche d'un Siteswap.";
	our $MSG_LADDER_MENU_SLIDE_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"main\"> : Main \x{e0} d\x{e9}caler (droite : \"R\" ou gauche : \"L\")\n\n\- <\"dec\"> : Valeur du d\x{e9}calage (ex : +1 , -2, 3)\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_TO_MULTISYNC_1 = "Donne le Siteswap MultiSynchrone correspondant (ie transformation des multiplexes, des lancers synchrones)";
	our $MSG_LADDER_MENU_TO_MULTISYNC_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <Type> : Type de MultiSynchrone (0: MultiSynchrone R\x{e9}duit, 1: Combinaison Synchrone/Asynchrone, 2: MultiSynchrone \x{e9}tendu format Async, 3: MultiSynchrone \x{e9}tendu format Sync )\n\n\- [\"fichier\"] Optionnel, fichier image de r\x{e9}sultats au format png. Si -1 pas d'image g\x{e9}n\x{e9}r\x{e9}\x{e9}\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;

	our $MSG_LADDER_DRAW_1 = "Diagramme g\x{e9}n\x{e9}r\x{e9}";
	our $MSG_LADDER_SLIDE_1 = "D\x{e9}calage trop grand => Lancers n\x{e9}gatifs invalides !";


	################################################"
	#
	# SPYRO Module Messages 
	#
	################################################"

	our $MSG_SPYRO_MENU_HELP = "SPYRO d\x{e9}finit un spyrographe pour jongleur. Il permet la mod\x{e9}lisation des Spins, Antispins, Hybrides, Isolations, Extensions dans un unique plan.\n";

	our $MSG_SPYRO_MENU_ANIMATE_1 = "Lance JuggleSpyro HTML5.";
	our $MSG_SPYRO_MENU_ANIMATE_2 = "Param\x{e8}tres :\n\n\- Aucun ou optionnellement le port du serveur HTTP.";
	our $MSG_SPYRO_MENU_STAFFSIMMCP_1 = "Lance le Simulateur de Staffs de MCP.";
	our $MSG_SPYRO_MENU_STAFFSIMMCP_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	our $MSG_SPYRO_MENU_POIFLOWERS_1 = "Lance le Simulateur de Po\x{ef} de David Lyons.";
	our $MSG_SPYRO_MENU_POIFLOWERS_2 = "Param\x{e8}tres :\n\n\- Aucun.";


	################################################"
	#
	# HTN Module Messages 
	#
	################################################"

	our $MSG_HTN_MENU_HELP = "Harmonic Throws Notation (3\-Layers Notation).\n"; 
	
	our $MSG_HTN_MENU_DRAWGRID_1 = "Dessine la Grille associ\x{e9}e au Siteswap. Gnuplot et \x{e9}ventuellement Ghostscript et ImageMagick (converter) doivent avoir \x{e9}t\x{e9} install\x{e9}s au pr\x{e9}alable (Sinon les images sont PostScript uniquement).";
	our $MSG_HTN_MENU_DRAWGRID_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap \x{e0} dessiner.\n\n\- <\"fichier\"> : fichier image de r\x{e9}sultats.\n\n\- [\"options\"] Diff\x{e9}rentes options \-[a|b|c|d|e|h|l|p|r|s|t|u|v|y|z] pr\x{e9}cis\x{e9}es ci-dessous :\n\n\t\-a <dec> : Hauteur Agrafe pour lancer depuis main identique (D\x{e9}faut:0.4).\n\n\t\-b <color> : Couleur d'agrafe (D\x{e9}faut:green).\n\n\t\-c <color> : Couleur de cercle (D\x{e9}faut:#a935bd).\n\n\t\-d <color> : Couleur de sync (D\x{e9}faut:blue).\n\n\t\-e <color> : Couleur de Mode de Main (D\x{e9}faut:blue).\n\n\t\-h <r|l> : Mode des Mains (D\x{e9}faut:r).\n\n\t\-l <y|n> : Affichage des Labels (D\x{e9}faut:y).\n\n\t\-p <int> : P\x{e9}riode \x{e0} afficher (D\x{e9}faut:10).\n\n\t\-r <dec> : Rayon des Cercles (D\x{e9}faut:0.2).\n\n\t-s <int> : Affichage du r\x{e9}sultat (D\x{e9}faut:0)\n\t\t'0' : Affiche le r\x{e9}sultat;\n\t\t'1' : Pas d'affichage.\n\n\t\-t <y|n> : Affichage du titre (D\x{e9}faut:y).\n\n\t\-u <y|n> : Affichage du Mode des Mains dans le titre (D\x{e9}faut:y).\n\n\t\-v <\"string\"> : Force la valeur du Titre de l'image.\n\n\t\-y <dec> : D\x{e9}calage Y pour Lancers superpos\x{e9}s (D\x{e9}faut:0.25).\n\n\t\-z <\"string\"> : Terminal Driver. Mettre une valeur vide pour liste des possibilit\x{e9}s (D\x{e9}faut:auto).";
	our $MSG_HTN_MENU_HTNMAKER_1 = "HTNMaker de Shawn Pinciara pour cr\x{e9}er des Grilles Harmoniques.";
	our $MSG_HTN_MENU_HTNMAKER_2 = "Param\x{e8}tres :\n\n\- Aucun.";
	
	our $MSG_HTN_DRAWGRID_1 = "Grille g\x{e9}n\x{e9}r\x{e9}e";
	our $MSG_HTN_ERR_OVERLAP_1 = "Overlapping de cercles sur l'affichage. R\x{e9}duiser YShift pour am\x{e9}liorer cela."; 
	our $MSG_HTN_ERR_DRAWGRID_1 = "Error : Pas de points dans la grille."; 


	################################################"
	#
	# HSS Module Messages 
	#
	################################################"

	our $MSG_HSS_MENU_HELP = "Hand Siteswap Notation (HSS). Supporte actuellement uniquement le HSS Vanille.\n"; 

	our $MSG_HSS_MENU_BASICMAP_1 = "Cartographie des types de Siteswaps Multi-Mains Asynchrone de Base, nombre Mains x Objets.";
	our $MSG_HSS_MENU_BASICMAP_2 = "Param\x{e8}tres :\n\n\- [int] : Nombre Max de Mains (D\x{e9}faut:15).\n\n\- [int] : Nombre Max d'Objets (D\x{e9}faut:15).";
	our $MSG_HSS_MENU_CHANGEHSS_1 = "Donne le Siteswap obtenu en changeant l'HSS \x{e0} 2 mains mais en conservant les Mains pour les throws et catchs [Exp\x{e9}rimental].";
	our $MSG_HSS_MENU_CHANGEHSS_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap Asynchrone.\n\n\- <hss> : Hand Siteswap Initial.\n\n\- <hss> : Hand Siteswap Final.";

	our $MSG_HSS_MENU_GETHANDSSEQ_1 = "Donne le s\x{e9}quencement des mains selon l'HSS d'entr\x{e9}e.";
	our $MSG_HSS_MENU_GETHANDSSEQ_2 = "Param\x{e8}tres :\n\n\- <hss> : Hand Siteswap.\n\n\- <\"string\"> : Mains impliqu\x{e9}es s\x{e9}par\x{e9}es par des , .";

	our $MSG_HSS_CHANGEHSS_ERROR1 = "Siteswap Invalide."; 
	our $MSG_HSS_CHANGEHSS_ERROR2 = "HSS Invalide."; 

	our $MSG_HSS_ERROR1 = "HSS Invalide."; 
	our $MSG_HSS_ERROR2 = "Seul HSS de type Vanille support\x{e9}."; 
	our $MSG_HSS_ERROR3 = "Le nombre de mains en param\x{e8}tre doit \x{ea}tre identique au nombre de mains du HSS."; 


	
	################################################"
	#
	# Generic Messages 
	#
	################################################"
	
	our $MSG_GENERAL_ERR1="Erreur dans l'ouverture du fichier";
	our $MSG_GENERAL_ERR1b="en \x{e9}criture";
	our $MSG_GENERAL_ERR2="Erreur dans la cr\x{e9}ation du fichier";
	our $MSG_GENERAL_GRAPHVIZ="G\x{e9}n\x{e9}ration par Graphviz\n";
	
	our $MSG_MOD_VERSION_1 = "Retourne la version du Module.";
	our $MSG_MOD_VERSION_2 = "Pas de Param\x{e8}tre.";
	
	our $MSG_GRAPHVIZ_OPTS_a1 = "\- [\"options\"] Diff\x{e9}rentes options \-[c|d|e|g|h|i|l|m|n|o|p|s|t|v] pr\x{e9}cis\x{e9}es ci-dessous :";
	our $MSG_GRAPHVIZ_OPTS_a2="\- [\"options\"] Diff\x{e9}rentes options \-[c|d|h|l|m|n|o|p|r|s|t|v] pr\x{e9}cis\x{e9}es ci-dessous :";
	our $MSG_GRAPHVIZ_OPTS_b1 = "\n\n\t\-c <int> :  Mode de colorisation (D\x{e9}faut:2)\n\t\t'0' : pas de colorisation;\n\t\t'1' : Multiplexe dans l'ordre croissant des valeurs \n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents;\n\t\t'2' : Multiplexe dans l'ordre d\x{e9}croissant des valeurs\n\t\t Siteswap des lancers pr\x{e9}c\x{e9}dents.\n\n\t\-d <int> :  Synchronous Hack (D\x{e9}faut:0)\n\t\t'0' : Suppression des 0 dans le diagramme apr\x{e8}s les lancers \n\t\tsynchrones puisqu'il s'agit des r\x{e9}ceptions;\n\t\t'1' : Pas de hack.\n\n\t\-e <\"string\"> : Couleur du Label de la fl\x{e8}che selon le codage X11 \n\tde Graphviz (ex : dodgerblue, red, springgreen, darkviolet, \n\tmagenta, goldenrod, saddlebrown, azure4, khaki4, \n\tdarkorange, olivedrab1, turquoise4, black, peru, \n\tmediumslateblue). E pour couleur identique \x{e0} la fl\x{e8}che \n\t(D\x{e9}faut:E).\n\n\t\-g <y|n> : Conserve Fichier Graphviz pour g\x{e9}n\x{e9}ration (D\x{e9}faut:n).\n\n\t\-h <y|n> : Affichage des Mains.\n\n\t\-i \"Liste avec ,\": Enumeration des mains pour les diagrammes Vanille.\n\n\t\-l <pos> : Position du label de Siteswap (D\x{e9}faut:s)\n\t\t't': tail, pr\x{e8}s de la queue de la fl\x{e8}che; \n\t\t'h': head, pr\x{e8}s de la t\x{ea}te; \n\t\t'm': middle, au centre de la fl\x{e8}che; \n\t\t'x': external, au centre de la fl\x{e8}che apr\x{e8}s trac\x{e9}; \n\t\t's': state, pr\x{e8}s de l'Etat; \n\t\t'n': Pas de label de Siteswap.\n\n\t\-m <0|1|2> : Mod\x{e8}le de diagramme (D\x{e9}faut: selon le type de Siteswap)\n\t\t'0' : Ladder;\n\t\t'1' : Applanissement de Ladder (Siteswap Asynchrone);\n\t\t'2' : Ladder avec suppression des Beats impairs en \n\t\tcommen\x{e7}ant \x{e0} 0 (Siteswap Synchrone).\n\n\t\-n <y|n> : Affichage des lancers n\x{e9}gatifs [Exp\x{e9}rimental] \n\t\t(D\x{e9}faut:n).\n\n\t\-o <type> : format d'image (D\x{e9}faut:png) parmi : bmp (Windows Bitmap Format), cmapx (client-side imagemap for use in html and xhtml), dia (GTK+ based diagrams), eps (Encapsulated PostScript), fig (XFIG graphics), gd, gd2 (GD/GD2 formats), gif (bitmap graphics), gtk (GTK canvas), hpgl (HP pen plotters) and pcl (Laserjet printers), imap (imagemap files for httpd servers for each node or edge that has a non\-null \"href\" attribute.), jpg, jpeg, jpe (JPEG), mif (FrameMaker graphics), pdf (Portable Document Format), png (Portable Network Graphics format), ps (PostScript), ps2 (PostScript for PDF), svg, svgz (Structured Vector Graphics), tif, tiff (Tag Image File Format), vml, vmlz (Vector Markup Language), vrml (VRML), wbmp (Wireless BitMap format), xlib (Xlib canvas), canon, dot, xdot (Output in DOT langage), plain , plain\-ext (Output in plain text).\n\n\t\-p <int> : P\x{e9}riode minimum \x{e0} afficher (D\x{e9}faut:25).\n\n\t\-s <int> : Affichage du r\x{e9}sultat (D\x{e9}faut:0)\n\t\t'0' : Affiche le r\x{e9}sultat;\n\t\t'1' : Pas d'affichage.\n\n\t\-t <y|n> : Affichage du titre de l'image (D\x{e9}faut:y).\n\n\t\-v <\"string\"> : Force la valeur du Titre de l'image";
	our $MSG_GRAPHVIZ_FORMAT = "\- [\"Format\"] Optionnel, format d'image (D\x{e9}faut:png) parmi : bmp (Windows Bitmap Format), cmapx (client-side imagemap for use in html and xhtml), dia (GTK+ based diagrams), eps (Encapsulated PostScript), fig (XFIG graphics), gd, gd2 (GD/GD2 formats), gif (bitmap graphics), gtk (GTK canvas), hpgl (HP pen plotters) and pcl (Laserjet printers), imap (imagemap files for httpd servers for each node or edge that has a non\-null \"href\" attribute.), jpg, jpeg, jpe (JPEG), mif (FrameMaker graphics), pdf (Portable Document Format), png (Portable Network Graphics format), ps (PostScript), ps2 (PostScript for PDF), svg, svgz (Structured Vector Graphics), tif, tiff (Tag Image File Format), vml, vmlz (Vector Markup Language), vrml (VRML), wbmp (Wireless BitMap format), xlib (Xlib canvas), canon, dot, xdot (Output in DOT langage), plain, plain\-ext (Output in plain text)\n\n\- [\"G\x{e9}n\x{e9}rateur\"] Optionnel, filtre g\x{e9}n\x{e9}rateur Graphviz (D\x{e9}faut:dot) parmi : circo (circular layout), dot(directed graphs), neato (undirected graphs), twopi (radial layouts), fdp (undirected graphs), sfdp (large undirected graphs), osage (clustered graphs).";
	

    } else {

	#############################################################################################################################################
	##
	##  ENGLISH Section
	##
	#############################################################################################################################################

	################################################"
	#
	# MAIN Menu Messages 
	#
	################################################"
	
	our $MSG_MAIN_MENU_CREDITS_1 = "Credits.";

	our $MSG_MAIN_MENU_LSC_1 = "List All available commands.";
	our $MSG_MAIN_MENU_LSC_2 = "List All available commands with their parameters.";

	our $MSG_MAIN_MENU_MAIN_1 = "Go up to Main Menu.";
	our $MSG_MAIN_MENU_HELP_1 = "Useful in Modules Menu for generic help, command help or menu help. <help>, <help(\"command\")> or <help(\"module\")>";
	our $MSG_MAIN_MENU_HELP_2 = "Use :\n\- <help> for current Help in Main Menu or Module Menu;\n\- <help(\"command\")> to get Help for a particular command in the current Module;\n\- <help(\"module\")> to get Help for a particular module;\n\- <help(\"module::command\")> to get Help for a particular command of a given Module.";
	our $MSG_MAIN_MENU_HELP2_1 = "Useful for help on commands parameters";
	our $MSG_MAIN_MENU_HELP2_2 = "Use :\n\n\- <help2> for all available commands with their parameters in the current Module;\n\- <help2(\"command\")> to get Help on parameters for a particular command in the current Module;\n\- <help2(\"module\")> to get Help of all commands parameters for a particular module;\n\- <help2(\"module::command\")> to get Help on parameters for a particular command of a given module."; 
	our $MSG_MAIN_MENU_EXIT_1 = "Exit the Program. \"bye\" or \"quit\" may also be used instead.";
	our $MSG_MAIN_MENU_EXC_1 = "To run Shell command.";
	our $MSG_MAIN_MENU_EXC_2 = "!! : run a Shell command in the current process.";
	our $MSG_MAIN_MENU_MODS_1 = "Print the available Modules.";
	our $MSG_MAIN_MENU_INT_1 = "To get the Execution result of the previous command.";
	our $MSG_MAIN_MENU_INT_2 = "<1> means OK.";
	our $MSG_MAIN_MENU_USAGE_1 = "Options for running jugglingTB.";
	
	our $MSG_MAIN_USAGE_s = "Display Special Characters (Unicode) in the Menus.";
	our $MSG_MAIN_USAGE_H = "Extended Help for jugglingTB.";
	our $MSG_MAIN_USAGE_i = "Configuration File for jugglingTB (Default:conf.ini).";
	our $MSG_MAIN_USAGE_h = "Help for jugglingTB.";
	our $MSG_MAIN_USAGE_a = "Activate autocompletion (Using C^d and <TAB>,  C^U to clear). [Very Bad using Cmd on MsWindows ;-(].";
	our $MSG_MAIN_USAGE_v = "Give the Version without running jugglingTB.";
	our $MSG_MAIN_USAGE_u = "Usage for running jugglingTB.";
	our $MSG_MAIN_USAGE_c = "Give a colored interface for jugglingTB. It can be used only on ANSI capable terminal ;-(";
	our $MSG_MAIN_USAGE_e = "Command to run.";
	our $MSG_MAIN_USAGE_f = "File of Commands to run.";
	our $MSG_MAIN_USAGE_d = "Debug Mode.";
	our $MSG_MAIN_USAGE_CONF = "\nBy default, these options are not set. This default behaviour may be changed in <conf.ini>. In this case, to unset an option you may have to explicitely indicate this by using the prefix <-no>.\nSome configuration parameters may also be configured in <conf.ini> (such as the language for example).\n ";

	our $MSG_MAIN_LSC = "\nHereafter you will see the different commands you may use in the different available Modules Menus.\nTo enter into a Module Menu, juste type its name (or only its 2 first letters).\nA particular function related to a module MOD may be called by its name in the MOD Menu or using MOD::TheFunction from any Menu.\n\n";
	our $MSG_MAIN_LSC_NOMODA = "\tNo Module Available\n";
	our $MSG_MAIN_LSC_MODA = "\tModules Available : ";
	our $MSG_MAIN_LSC_MAINCMDS = "MAIN COMMANDS";
	our $MSG_MAIN_LSC_MOD = "MODULES CONTEXT";

	our $MSG_MAIN_ERR1 = "unexpected EOF";
	our $MSG_MAIN_ERR2 = "fails";
	
	our $MSG_MAIN_WINDOWS_CHARSET = "You Should have defined the Police <Lucida Console> if you use Cmd.\n";

	################################################"
	#
	# BTN Module Messages 
	#
	################################################"

	our $MSG_BTN_MENU_HELP = "In this module a BTN throw will be made of a list of holes AC, AL, BOL and the OP operator (Uppercase/Lowercase).\n\n\tExamples : OPALAC, BOLAL, OPALOPAC ..."; 

	our $MSG_BTN_MENU_GENTHROWS_1 = "Give all BTN throws limited by the number of holes encountered.";
	our $MSG_BTN_MENU_GENTHROWS2_1 = "Give all BTN throws, excepted throws that contains two same successive holes in the body.";
	our $MSG_BTN_MENU_GENTHROWS_2 = "Parameters :\n\n\- <int> : Maximum number of holes to go through [>4 is for Extra-Terrestrial ;-)].\n\- [\"file\"] Optional, file to write results in.";
	our $MSG_BTN_MENU_SIZE_1 = "Give the Throw Length in Hole Unit.";
	our $MSG_BTN_MENU_SIZE_2 = "Parameters :\n\n\- <Throw> : Throw that we want to get the length.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_BTN_MENU_ISVALID_1 = "Test if the BTN Throw is valid.";
	our $MSG_BTN_MENU_ISVALID_2 = "Parameters :\n\n\- <Throw> : Throw to check.\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_BTN_MENU_TIMEREVERSED_1 = "Give the BTN Time Reversed throw related.";
	our $MSG_BTN_MENU_TIMEREVERSED_2 = "Parameters :\n\n\- <Throw> : Throw to Time Reversered.\n\- <Parity> : Siteswap parity (0: even, 1: odd).\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_BTN_MENU_BTNPARITY_1 = "Give the BTN Parity.";
	our $MSG_BTN_MENU_BTNPARITY_2 = "Parameters :\n\n\- <Throw> : Throw.\n\- [\-1] Optional, return the result, but do not print it (0: even, 1: odd)";	

	our $MSG_BTN_GENTHROWS_1 = "\tHere are the ";
	our $MSG_BTN_GENTHROWS_2 = " BTN throw(s) going through ";
	our $MSG_BTN_GENTHROWS_3 = " Hole(s) maximum :\n";
	our $MSG_BTN_GENTHROWSEXT_3 = " Hole(s) maximum without redondancies in the body:\n";
	our $MSG_BTN_GENTHROWS_EVEN = "Even";
	our $MSG_BTN_GENTHROWS_ODD = "Odd";

	our $MSG_BTN_ISVALID_ERR1 = "(Size is odd)\n";
	our $MSG_BTN_ISVALID_ERR2 = "(First Hole uncorrect)\n";
	our $MSG_BTN_ISVALID_ERR3 = "(Last Hole uncorrect)\n";
	our $MSG_BTN_ISVALID_ERR4 = "(Last Hole of slice <";
	our $MSG_BTN_ISVALID_ERR4b = "> uncorrect)\n";
	our $MSG_BTN_ISVALID_ERR5 = "(Encountered 2 consecutive <";
	our $MSG_BTN_ISVALID_ERR5b = "> inside the slice <";
	our $MSG_BTN_ISVALID_ERR5c = ">)\n";
	our $MSG_BTN_ISVALID_WARN1 = "(Only possible by Extra-Terrestrials (ie > 4 holes))\n";	 

	our $MSG_BTN_TIMEREVERSED_ERR1 = "(Parameters <Parity> uncorrect)\n";
	our $MSG_BTN_TIMEREVERSED_ERR2 = "(Invalid Throw)\n";
	our $MSG_BTN_TIMEREVERSED_ERR3 = "(First Hole uncorrect)\n";
	our $MSG_BTN_TIMEREVERSED_ERR4 = "(Last Hole uncorrect)\n";
	our $MSG_BTN_TIMEREVERSED_ERR5 = "(Uncorrect throw in the slice : ";
	our $MSG_BTN_TIMEREVERSED_ERR5b = "\n; ";

	our $MSG_BTN_BTNPARITY_0 = "(Any)";
	our $MSG_BTN_BTNPARITY_1 = "(Even)";
	our $MSG_BTN_BTNPARITY_2 = "(Odd)";


	################################################"
	#
	# SOU Module Messages 
	#
	################################################"
	
	our $MSG_SOU_MENU_HELP = "In this module a SOU pattern will be made of a states (O, Ob, U, Ub, S, Sb) and exchanges (<in>, <out>) sequence.\n\nExample : O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb"; 

	our $MSG_SOU_MENU_ISEQUIVALENT_1 = "Test equivalence between 2 patterns.";
	our $MSG_SOU_MENU_ISEQUIVALENT_2 = "Parameters :\n\n\- <pattern1> <pattern2> : patterns to compare.\n\- [\-1] Optional, return the result, but do not print it."; 			 
	our $MSG_SOU_MENU_ISSYMETRIC_1 = "Test if two patterns are symetric.";
	our $MSG_SOU_MENU_ISSYMETRIC_2 = "Parameters :\n\n\- <pattern1> <pattern2> : patterns to check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SOU_MENU_ISVALID_1 = "Test if the pattern is valid.";
	our $MSG_SOU_MENU_ISVALID_2 = "Parameters :\n\n\- <pattern> : pattern to test.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SOU_MENU_SYM_1 = "Compute symetry of a designated pattern.";
	our $MSG_SOU_MENU_SYM_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the symetry\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SOU_MENU_INV_1 = "Compute inversion of a designated pattern.";
	our $MSG_SOU_MENU_INV_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the inversion\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SOU_MENU_GENALLPATTERNSBYSTATE_1 = "Generation of all patterns classified per state.";
	our $MSG_SOU_MENU_GENALLPATTERNSBYSTATE_2 = "Parameters :\n\n\- <cpt> : Number of Passages per State\n\- <pathLenMax> : Path Length Maximum (-1 : any length)\n\- [\"file\"] Optional, file to write results in.";
	our $MSG_SOU_MENU_GENALLPATTERNS_1 = "Generation of all patterns with duplication removal.";
	our $MSG_SOU_MENU_GENALLPATTERNS_2 = "Parameters :\n\n\- <cpt> : Number of Passages per State\n\- <pathLenMax> : Path Length Maximum (-1 : any length)\n\- [\"file\"] Optional, file to write results in.";
	our $MSG_SOU_MENU_GRAPH_1 = "Display the SOU Graph of valid transitions.";
	our $MSG_SOU_MENU_GRAPH_2 = "Parameters :\n\n\- None.";
	our $MSG_SOU_MENU_SIZE_1 = "Give the Pattern Length in State Unit.";
	our $MSG_SOU_MENU_SIZE_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the length. One Unit is considered only if it is composed of a State and a Transition.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SOU_MENU_TOMMSTD_1 = "Give the corresponding MMSTD Notation.";
	our $MSG_SOU_MENU_TOMMSTD_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the MMSTD Notation.\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_SOU_GENPATTERN_1 = "\tHere are the ";
	our $MSG_SOU_GENPATTERN_2 = " S,O,U result(s) from State ";
	our $MSG_SOU_GENPATTERN_3 = " S,O,U result(s) :\n";
	our $MSG_SOU_GENPATTERN_4 = "States";

	our $MSG_SOU_ISVALID_ERR1 = "(number of States+Throws is odd and last element different from the first one)";
	our $MSG_SOU_ISVALID_ERR2 = "(uncorrect State";
	our $MSG_SOU_ISVALID_ERR3 = "(invalid SOU transition";
	our $MSG_SOU_ISVALID_ERR4 = "(uncorrect Exchange";

	our $MSG_SOU_INV_ERR1 = "inv :";
	our $MSG_SOU_INV_ERR1b = "is not a valid pattern (";
	our $MSG_SOU_INV_ERR1c = " undefined).\n";

	our $MSG_SOU_ISSYMETRIC_ERR1 = "isSymetric :";
	our $MSG_SOU_ISSYMETRIC_ERR1b = "is not a valid pattern (";
	our $MSG_SOU_ISSYMETRIC_ERR1c = " undefined).\n";

	our $MSG_SOU_SYM_ERR1 = "sym :";
	our $MSG_SOU_SYM_ERR1b = "is not a valid pattern (";
	our $MSG_SOU_SYM_ERR1c = " undefined).\n";
	
	our $MSG_SOU_TOMMSTD_ERR1 = "toMMSTD :";
	our $MSG_SOU_TOMMSTD_ERR1b = "is not a valid pattern (";
	our $MSG_SOU_TOMMSTD_ERR1c = " undefined).\n";
	

	################################################"
	#
	# MMSTD Module Messages 
	#
	################################################"

	our $MSG_MMSTD_MENU_HELP = "In this module a SOU pattern will be made of a states (Ur, Ul, Rl, Rr, Lr, Lr) and exchanges (<in>, <out>) sequence.\n\n\tExample : Ur -o-> Ll -+> Ur , Rr -+-> Ul -o->";

	our $MSG_MMSTD_MENU_ISEQUIVALENT_1 = "Test equivalence between 2 patterns.";
	our $MSG_MMSTD_MENU_ISEQUIVALENT_2 = "Parameters :\n\n\- <pattern1> <pattern2> : patterns to compare.\n\- [\-1] Optional, return the result, but do not print it."; 			 
	our $MSG_MMSTD_MENU_ISSYMETRIC_1 = "Test if two patterns are symetric.";
	our $MSG_MMSTD_MENU_ISSYMETRIC_2 = "Parameters :\n\n\- <pattern1> <pattern2> : patterns to check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_MMSTD_MENU_ISVALID_1 = "Test if the pattern is valid.";
	our $MSG_MMSTD_MENU_ISVALID_2 = "Parameters :\n\n\- <pattern> : pattern to test.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_MMSTD_MENU_SYM_1 = "Compute symetry of a designated pattern.";
	our $MSG_MMSTD_MENU_SYM_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the symetry\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_MMSTD_MENU_INV_1 = "Compute inversion of a designated pattern.";
	our $MSG_MMSTD_MENU_INV_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the inversion\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_1 = "Generation of all patterns classified per state.";
	our $MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_2 = "Parameters :\n\n\- <cpt> : Number of Passages per State\n\- <pathLenMax> : Path Length Maximum (-1 : any length)\n\- [\"file\"] Optional, file to write results in.";
	our $MSG_MMSTD_MENU_GENALLPATTERNS_1 = "Generation of all patterns with duplication removal.";
	our $MSG_MMSTD_MENU_GENALLPATTERNS_2 = "Parameters :\n\n\- <cpt> : Number of Passages per State\n\- <pathLenMax> : Path Length Maximum (-1 : any length)\n\- [\"file\"] Optional, file to write results in.";
	our $MSG_MMSTD_MENU_GRAPH_1 = "Display the MMSTD Graph of valid transitions.";
	our $MSG_MMSTD_MENU_GRAPH_2 = "Parameters :\n\n\- None otherwise Graphviz MUST be installed prior and its Path correctly set in <conf.ini>.\n\n\- <\"file\"> : file for results.\n\n".$MSG_GRAPHVIZ_FORMAT;
	our $MSG_MMSTD_MENU_SIZE_1 = "Give the Pattern Length in State Unit.";
	our $MSG_MMSTD_MENU_SIZE_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the length. One Unit is considered only if it is composed of a State and a Transition.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_MMSTD_MENU_TOSOU_1 = "Give the corresponding SOU Notation.";
	our $MSG_MMSTD_MENU_TOSOU_2 = "Parameters :\n\n\- <pattern> : pattern that we want to get the MMSTD Notation.\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_MMSTD_GENPATTERN_1 = "\tHere are the ";
	our $MSG_MMSTD_GENPATTERN_2 = " MMSTD result(s) from State ";
	our $MSG_MMSTD_GENPATTERN_3 = " MMSTD result(s) :\n";
	our $MSG_MMSTD_GENPATTERN_4 = "States";

	our $MSG_MMSTD_ISVALID_ERR1 = "(number of States+Throws is odd and last element different from the first one)";
	our $MSG_MMSTD_ISVALID_ERR2 = "(uncorrect State";
	our $MSG_MMSTD_ISVALID_ERR3 = "(invalid MMSTD transition";
	our $MSG_MMSTD_ISVALID_ERR4 = "(uncorrect Exchange";

	our $MSG_MMSTD_INV_ERR1 = "inv :";
	our $MSG_MMSTD_INV_ERR1b = "is not a valid pattern (";
	our $MSG_MMSTD_INV_ERR1c = " undefined).\n";

	our $MSG_MMSTD_ISSYMETRIC_ERR1 = "isSymetric :";
	our $MSG_MMSTD_ISSYMETRIC_ERR1b = "is not a valid pattern (";
	our $MSG_MMSTD_ISSYMETRIC_ERR1c = " undefined).\n";

	our $MSG_MMSTD_SYM_ERR1 = "sym :";
	our $MSG_MMSTD_SYM_ERR1b = "is not a valid pattern (";
	our $MSG_MMSTD_SYM_ERR1c = " undefined).\n";
	
	our $MSG_MMSTD_TOSOU_ERR1 = "toSOU :";
	our $MSG_MMSTD_TOSOU_ERR1b = "is not a valid pattern (";
	our $MSG_MMSTD_TOSOU_ERR1c = " undefined).\n";


	################################################"
	#
	# SSWAP Module Messages 
	#
	################################################"

	our $MSG_SSWAP_MENU_HELP = "In this module a SITESWAP will be written similarly to JugglingLab.\n\n\tExamples : 534, (6x,4)*, (2x,[22x])(2,[22])(2,[22x])*\n\nIn addition we will consider a MultiSynchronous notation combining Synchronous and Asynchronous throws thanks to symbols <!> and <*> in.\n\n'!' : Remove one Beat. After a Synchronous Siteswap, it means that the next throw is on the next Beat (without it should be a catch Beat). After an Asynchronous Siteswap, it means that the next throw is also on the current Beat. Thus it gives a way to represent all Synchronous and/or Multiplex Siteswaps using an Asynchronous-like Siteswap.\n\n'*' : In a Synchronous Siteswap it means a hand swap in the next Beats and is not necessary at the end. In an Asynchronous Siteswap, it means that the next throw is done using the same hand. (Hurry Throw)\n\n\tExemples : 4!40, 5!*4!*3, 6x0*, (6x,0)*, 51x*, (1x,3)!11x* ...\n\nFollow following rules when using the different functions :\n\t - Avoid to use \"!*\" et \"*!\" at the beginning and at the end \n\tof Siteswaps, \"!\" at the beginning and \"!\" at the end of an throw in asynchronous reprsentation;\n\t- The objects height will be in hexadecimal excepted if it is \n\texplicitely written."; 

	our $MSG_SSWAP_MENU_ANIMATE_1 = "Animate a designated Siteswap (JugglingLab).";
	our $MSG_SSWAP_MENU_ANIMATE_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap that we want to animate.";
	our $MSG_SSWAP_MENU_ANIMATE_ANTISS_1 = "Antisiteswaps Animation (PowerJugller by Marco Tarini).";
	our $MSG_SSWAP_MENU_ANIMATE_ANTISS_2 = "Parameters :\n\n\- None.";
	our $MSG_SSWAP_MENU_GENTRANSTEODORO_1 = "Start the Siteswaps \& Transitions Generators designed by Pedro Teodoro.";
	our $MSG_SSWAP_MENU_GENTRANSTEODORO_2 = "Parameters :\n\n\- None.";
	our $MSG_SSWAP_MENU_REALSIM_1 = "Start the Simulator designed by Pedro Teodoro.";
	our $MSG_SSWAP_MENU_REALSIM_2 = "Parameters :\n\n\- None.";
	our $MSG_SSWAP_MENU_SHOWVANILLADIAG_1 = "Draw Vanilla States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_SHOWVANILLADIAG_2 = "Parameters :\n\n\- None.";	
	our $MSG_SSWAP_MENU_GENSS_1 = "Siteswaps Generation (JugglingLab).";
	our $MSG_SSWAP_MENU_GENSS_2 = "Parameters :\n\n\- <int> : Objects number\n\- <nb> : Higher throw value\n\- <int> : Period.\n\- [\"-O [options]\"] Optional, several options available.\n".$MSG_SSWAP_MENU_GENSS_OPT."\n\n\- [\"file\"] Optional, file to write results in. \nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view.\n\t\- \'SSHTML:\', issue an HTML file with extension .html with \n\tsome information on the Siteswaps.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n";
	our $MSG_SSWAP_MENU_GENSS_OPT="\n\tOptions are the following :\n\t\-s : synchronous patterns\n\t\-j <number> : number of jugglers\n\t\-n : print the number of generated Siteswaps\n\t\-m <number> : multiplex with at least the given number of simultaneous throws \n\t\-no : print only the number of generated Siteswaps\n\t\-g : Print only ground state patterns\n\t\-mf : allows synchronous catches\n\t\-ng : Print only excited state patterns (no ground)\n\t\-mc : forbid multiplex per group \n\t\-f : whole list with combinated patterns\n\t\-mt : true multiplexing patterns only\n\t\-d <number> : delay for passing patterns\n\t\-se : disable starting/ending\n\t\-l <number> : passing leader person number\n\t\-prime : prime only\n\t\-x <throw> : exclude throws\n\t\-rot : with permutation\n\t\-i <throw> : include throws\n\t\-lame : delete '11' in synchronous mode\n\t\-cp : connected patterns only\n\t\-jp : show all juggler permutations";
	our $MSG_SSWAP_MENU_GENTRANS_1 = "Siteswaps Transitions Generation (JugglingLab).";
	our $MSG_SSWAP_MENU_GENTRANS_2 = "Parameters :\n\n\- <ss1> : Siteswap1.\n\- <ss2> : Siteswap2.\n\- [\"-O [options]\"] Optional, several options available.\n".$MSG_SSWAP_MENU_GENTRANS_OPT."\n\n\- [\"file\"] Optional, file to write results in.\nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view.";
	our $MSG_SSWAP_MENU_GENTRANS_OPT="\n\tOptions are the following :\n\t\-m <number> : multiplexing with at most <number> simultaneous throws.\n\t\-mf : allow simultaneous nontrivial catches (squeeze patterns).\n\t\-mc : disallow multiplex clustered throws (e.g. [33])\n\t\-limits : turn off limits on runtime (warning: searches may be long!)";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMOLD_1 = "Polyrhythms Gneration (Old Version).";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMOLD_2 = "Parameters :\n\n\- <int> : Number of objects.\n\- <int> : Right Ratio.\n\- <int> : Left Ratio.\n\- [\\\@List] Optional, Throws to exclude.\n\tEx: \@List=('0','e','ex','f','fx').\n\t If not set, without other optional parameters, 0 is not used;\n\t if \'\', no exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\- [\"file\"] Optional, file to write results in. \nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view.\n\t\- \'SSHTML:\', issue an HTML file with extension .html with \n\tsome information on the Siteswaps.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHM_1 = "Polyrhythms Generation.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHM_2 = "Parameters :\n\n\- <int> : Number of objects.\n\- <int> : Max height in hex.\n\- <int> : Right Ratio.\n\- <int> : Left Ratio.\n\- [\\\@List] Optional, Throws to exclude.\n\tEx: \@List=('0','2','1x').\n\t If not set, without other optional parameters, 0 is not used;\n\t if \'\', no exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-J <y|n> : Double the Tempo for polyrhythms 1:M mainly to avoid squeezes (Default:n).\n\n\- [\"file\"] Optional, file to write results in. \nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view.\n\t\- \'SSHTML:\', issue an HTML file with extension .html with \n\tsome information on the Siteswaps.\n\t\- \'HTML:\', issue an HTML file with extension \n\t\t.html with Ladder Diagrams in it, modified \n\t\tSiteswaps, keeping Tempo mais lowering throw height and related JML Files.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMMULT_1 = "Polyrhythms Generation with Multiplexes.";
	our $MSG_SSWAP_MENU_GENPOLYRHYTHMMULT_2 = "Parameters :\n\n\- <int> : Number of objects.\n\- <int> : Max height in hex.\n\- <int> : Number Max of simultaneous throws.\n\- <int> : Right Ratio.\n\- <int> : Left Ratio.\n\- [\\\@List] Optional, Throws to exclude.\n\tEx: \@List=('0','2','1x').\n\t If not set, without other optional parameters, 0 is not used;\n\t if \'\', no exclusion.\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-J <y|n> : Double the Tempo for polyrhythms 1:M mainly to avoid squeezes (Default:n).\n\n\- [\"file\"] Optional, file to write results in. \nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view.\n\t\- \'SSHTML:\', issue an HTML file with extension .html with \n\tsome information on the Siteswaps.\n\t\- \'HTML:\', issue an HTML file with extension \n\t\t.html with Ladder Diagrams in it, modified \n\t\tSiteswaps, keeping Tempo mais lowering throw height and related JML Files.";
	our $MSG_SSWAP_MENU_GENSTATES_1 = "Matrix States/Transitions Generation.";
	our $MSG_SSWAP_MENU_GENSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchonous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- [\"file\"] Optional, file to write results in. If -1, return the result but do not print/write it; If the file starts with \'XLS:\', issue an Excel file with extension .xlsx";
	our $MSG_SSWAP_MENU_GENAGGRSTATES_1 = "Reduced Matrix States/Transitions Generation.";
	our $MSG_SSWAP_MENU_GENAGGRSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchonous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- [\"file1\"] Optional, file to write results in. If -1, return the result but do not print/write it; If the file starts with \'XLS:\', issue an Excel file with extension .xlsx\n\n\-[\"file2\"] Optional, valid Input XLS file with States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENPROBERTDIAG_1 = "Martin Probert's Diagram Generation.";
	our $MSG_SSWAP_MENU_GENPROBERTDIAG_2 = "Parameters :\n\n\- <int> : Number of objects.\n\- <nb> : Height Max (-1 for any height).\n\- <int> : Siteswaps Period.\n\- [\"file\"] Optional, file to write results in. If -1, return the result but do not print/write it; If the file starts with \'XLS:\', issue an Excel file with extension .xlsx";
	our $MSG_SSWAP_MENU_GENPROBERTSS_1 = "Vanilla Siteswaps Generation from Martin Probert's Diagram.";
	our $MSG_SSWAP_MENU_GENPROBERTSS_2 = "Parameters :\n\n\- <int> : Number of objects.\n\n\- <nb> : Height Max (-1 for any height).\n\n\- <int> : Siteswaps Period.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENSSFROMSTATES_1 = "Siteswaps Generation from States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENSSFROMSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Siteswaps Period.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\t\- <int> : Siteswaps Period.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\-[\"file\"] Optional, valid Input XLS file with States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_1 = "Siteswaps Generation from Reduced States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Siteswaps Period.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\t\- <int> : Siteswaps Period.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\-[\"file\"] Optional, valid Input XLS file with Reduced States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENPERMSS_1 = "Vanilla Siteswaps Generation from Permutation Test (Polster's Algorithm)";
	our $MSG_SSWAP_MENU_GENPERMSS_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous).\n\- <int> : Number of objects.\n\- <int> : Siteswaps Period.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c; 
	our $MSG_SSWAP_MENU_GENMAGICSS_1 = "Magic Siteswaps Generation.";
	our $MSG_SSWAP_MENU_GENMAGICSS_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S', 'MULTI' ==\n\t\- <mode> : Magic Siteswap Type (Odd/Even/All).\n\t\- <nb> : Minimum value for throws.\n\t\- <int> : Siteswaps Period.\n\n== case 'M', 'MS' ==\n\t\- <mode> : Magic Siteswap Type (Odd/Even/All).\n\t\- <nb> : Minimum value for throws.\n\t\- <int> : Number of throws.\n\t\- <int> : Max Number of Multiplexes throws.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENMAGICSTADLERSS_1 = "Partial Generation of Magic Vanilla Siteswaps using Jon Stadler's algorithm.";
	our $MSG_SSWAP_MENU_GENMAGICSTADLERSS_2 = "Parameters :\n\n\- <int> : Maximum Siteswaps Period.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;
	our $MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_1 = "Vanilla Scramblable Siteswaps Generation from Polster Algorithm.";
	our $MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_2 = "Scramblables Siteswaps have following format (p is the period, c and Ak positive integers) : {Ak*p + c} [k=0...k=p\-1]\n\nParameters :\n\n\- <int> : Periode p.\n\- <int> : Maximum Value for Ak.\n\- <int> : Maximum Value for c.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c;	
	our $MSG_SSWAP_MENU_GENSSFROMTHROWS_1 = "Siteswaps Generation From Throws list.";
	our $MSG_SSWAP_MENU_GENSSFROMTHROWS_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n\- <\"siteswap\"> : suite of hexadecimal values from which we want all the available combination.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1."\n\n\t\-A <y|n> : an extra option to consider only symetrical Siteswaps for S and MS family (Default:n).".$MSG_SSWAP_PRINTSS_OPTS_c; 
	our $MSG_SSWAP_MENU_GENTRANSBTWNSS_1 = "Transitions Generation between Siteswaps based upon States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSS_2 = "Parameters :\n\n\- <\"siteswap1\"> : Initial Siteswap.\n\n\- <\"siteswap2\"> : Final Siteswap.\n\n\- <int> : Computing Depth.\n\n\- [\"options\"] Several options among [h|m|c|g|i|o|p|r|s|t|u] :\n\t\-h <nb> : Max Height in hexadecimal.\n\n\t\-m <int> : Min Number of Multiplex Throws.\n\n\nFollowings options are only considered during SSHTML or JML generation :".$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c1."\n\n\-[\"file\"] Optional, valid Input XLS file with States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_1 = "Transitions Generation between Siteswaps based upon Reduced States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_2 = "Parameters :\n\n\- <\"siteswap1\"> : Initial Siteswap.\n\n\- <\"siteswap2\"> : Final Siteswap.\n\n\- <int> : Computing Depth.\n\n\- [\"options\"] Several options among [h|m|c|g|i|o|p|r|s|t|u] :\n\t\-h <nb> : Max Height in hexadecimal.\n\n\t\-m <int> : Min Number of Multiplex Throws.\n\n\nFollowings options are only considered during SSHTML or JML generation :".$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c1."\n\n\-[\"file\"] Optional, valid Input XLS file with Reduced States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSTATES_1 = "Transitions Generation between Siteswaps based upon States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNSTATES_2 = "Parameters :\n\n\- <\"state1\"> : Initial State.\n\n\- <\"state2\"> : Final State.\n\n\- <int> : Computing Depth.\n\n\- [\"options\"] Several options among [h|m] :\n\t\-h <nb> : Max Height in hexadecimal.\n\n\t\-m <int> : Min Number of Multiplex Throws.\n\n\-[\"file2\"] Optional, file to write results in. If -1, return the result but do not print/write it.\n\n\-[\"file2\"] Optional, valid Input XLS file with States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_1 = "Transitions Generation between Siteswaps based upon Reduced States/Transitions Diagrams.";
	our $MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_2 = "Parameters :\n\n\- <\"state1\"> : Initial State.\n\n\- <\"state2\"> : Final State.\n\n\- <int> : Computing Depth.\n\n\- [\"options\"] Several options among [h|m] :\n\t\-h <nb> : Max Height in hexadecimal.\n\n\t\-m <int> : Min Number of Multiplex Throws.\n\n\-[\"file2\"] Optional, file to write results in. If -1, return the result but do not print/write it.\n\n\-[\"file2\"] Optional, valid Input XLS file with Reduced States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_DRAW_1 = "Draw the Diagram of a given Siteswap.";
	our $MSG_SSWAP_MENU_DRAW_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to draw.\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1."\n\n\- [\\%hash] : Optional, transitions hash. In this case the Siteswap is used for the title only. Each key is Ri:j for a right transition or Li:j for a left one. i is the throw Beat and j is the numero of the thrown object (starting from 0) to help the colorization\n\tEx :  %hash = (
	\t'L2:0' => 'R4:0',
	\t'R2:0' => 'R4:1',
	\t'L4:0' => 'R6:0',
	\t'R4:0' => 'R5:0',
	\t'R4:1' => 'L6:0',
	\t'R6:0' => 'R6:0'
	\t);";
	our $MSG_SSWAP_MENU_DRAWSTATES_1 = "Graph States/Transitions Generation (Graphviz).";
	our $MSG_SSWAP_MENU_DRAWSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- <\"file1\"> : file for results.\n\n".$MSG_GRAPHVIZ_FORMAT."\n\n\-[\"file2\"] Optional, valid Input XLS file with States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_DRAWSTATES_OPT="\n Graphviz MUST be installed prior and its Path correctly set in <conf.ini>";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_1 = "Reduced States/Transitions Graph Generation (Graphviz).";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous)n 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- <\"file\"> : file for results.\n\n".$MSG_GRAPHVIZ_FORMAT."\n\n\-[\"file2\"] Optional, valid Input XLS file with Reduced States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_DRAWAGGRSTATES_OPT="\n Graphviz MUST be installed prior and its Path correctly set in <conf.ini>";
	our $MSG_SSWAP_MENU_WRITESTATES_1 = "Matrix States/Transitions Generation in an Excel file.";
	our $MSG_SSWAP_MENU_WRITESTATES_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects (-1 unspecified).\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- <\"file\"> : Excel Body file to write results in, without extension .xlsx. You must have Excel with a valid license prior ! (Windows Only).";
	our $MSG_SSWAP_MENU_TIMEREV_1 = "Compute inversion (Time-Reversed) of a designated Siteswap.";
	our $MSG_SSWAP_MENU_TIMEREV_2 = "The resulting Siteswap does not take into account the colorization mode.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap that we want to get the inversion\n\n\- [\-1] Optional, return the result, but do not print it."; 	
	our $MSG_SSWAP_MENU_TIMEREVDIAG_1 = "Compute inversion (Time-Reversed) of a designated Siteswap by Diagram Method.";
	our $MSG_SSWAP_MENU_TIMEREVDIAG_2 = "The resulting Siteswap does not take into account the colorization mode; the diagram considers it.However the resulting Siteswap may be less synthetic than the one get using the timeRev function.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap that we want to get the inversion\n\n\- [\"file\"] Optional, File for result. if -1 return the result, but do not print it;\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 	
	our $MSG_SSWAP_MENU_ISEQUIVALENT_1 = "Test equivalence between 2 Siteswaps.";
	our $MSG_SSWAP_MENU_ISEQUIVALENT_2 = "Parameters :\n\n\- <\"siteswap1\"> <\"siteswap2\"> : Siteswaps to compare.\n\n\- [\"options\"] Several options among [c|p|s] :\n\n\t\-c <y|n> : Take into account the Multiplex colorization Model \n\tfor Equivalence (Default:n).\n\n\t\-s <y|n> : Take into account the Symetry for Equivalence \n\t(Default:n).\n\n\t\-p <y|n> : Take into account permutations for Equivalence \n\t(Default:y).\n\n\- [\-1] Optional, return the result, but do not print it.";    	
	our $MSG_SSWAP_MENU_EXPANDSYNC_1 = "Expand a Synchronous Siteswap.";
	our $MSG_SSWAP_MENU_EXPANDSYNC_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to expand.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISVALID_1 = "Check the Siteswap validity.";
	our $MSG_SSWAP_MENU_ISVALID_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to check.\n\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISSYNTAXVALID_1 = "Check the Siteswap grammar syntax.";
	our $MSG_SSWAP_MENU_ISSYNTAXVALID_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISFULLMAGIC_1 = "Check if a given Siteswap is Full Magic.";
	our $MSG_SSWAP_MENU_ISFULLMAGIC_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap To check.\n\- [\-1] Optional, return the result, but do not print it. return Value are -1 (Not/Invalid), 0 (Full), 1 (Odd), 2 (Even).";    

	our $MSG_SSWAP_MENU_ISPRIME_1 = "Check if a given Siteswap is Prime.";
	our $MSG_SSWAP_MENU_ISPRIME_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap To check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISREVERSIBLE_1 = "Check if a given Siteswap is reversible.";
	our $MSG_SSWAP_MENU_ISREVERSIBLE_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap To check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISPALINDROME_1 = "Check if a given Siteswap is a Palindrome.";
	our $MSG_SSWAP_MENU_ISPALINDROME_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap To check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_ISSQUEEZE_1 = "Check if a Multiplex, Synchronous Multiplex or MultiSynchronous is a Squeeze.";
	our $MSG_SSWAP_MENU_ISSQUEEZE_2 = "Thows of same height and holds are not considered.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap To check.\n\- [\-1] Optional, return the result, but do not print it.";	
	our $MSG_SSWAP_MENU_ISSCRAMBLABLE_1 = "Check if a given Siteswap is Scramblable.";
	our $MSG_SSWAP_MENU_ISSCRAMBLABLE_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap To check (V,M,S or MS).\n\- [\"options\"] : Several options among [k|l|v]:\n\t\-k <y|n> : option for Siteswaps S and MS: for symetric Siteswaps ending with *, the Scramblable status is considered only on the first part. (Default:y).\n\t\-l <y|n> : option to limit the siteswap Period to avoid Memory/CPU exhausting (Default:y).\n\t\-v <int> : Maximum Period to consider (Default:8).\n\- [\-1] Optional, return the result, but do not print it (Default:y).";	
	our $MSG_SSWAP_MENU_GENSSPRIME_1 = "Give Prime Siteswaps.";
	our $MSG_SSWAP_MENU_GENSSPRIME_2 =  "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'S' (Synchronous), 'M' (Multiplex), 'MS' (Multiplex Synchronous), 'MULTI' (MultiSynchronous).\n\n== case 'V', 'S' ==\n\t\- <int> : Number of objects.\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M', 'MS', 'MULTI' ==\n\t\- <int> : Number of objects.\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a2.$MSG_SSWAP_PRINTSS_OPTS_b2.$MSG_SSWAP_PRINTSS_OPTS_c2."\n\n\-[\"file\"] Optional, valid Input XLS file with (Reduced or not) States/Transitions Matrix to speed up the computation (absolute path).";
	our $MSG_SSWAP_MENU_SHRINK_1 = "Shrink a Siteswap.";
	our $MSG_SSWAP_MENU_SHRINK_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to shrink.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_SIMPLIFY_1 = "Simplify a Siteswap.";
	our $MSG_SSWAP_MENU_SIMPLIFY_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to simplify.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_PERIODMIN_1 = "Give the length of the Min Period of a Siteswap.";
	our $MSG_SSWAP_MENU_PERIODMIN_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_SSWAP_MENU_SYM_1 = "Compute the symetric Siteswap by Diagram Method.";
	our $MSG_SSWAP_MENU_SYM_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap that we want to get the symmetry\n\n\- [\-1] Optional, return the result, but do not print it."; 
	our $MSG_SSWAP_MENU_SYMDIAG_1 = "Compute the symetric Siteswap.";
	our $MSG_SSWAP_MENU_SYMDIAG_2 = "The resulting Siteswap may be less synthetic than the one get using the sym function.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap that we want to get the symmetry\n\n\- [\"file\"] Optional, File for result. if -1 return the result, but do not print it;\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 
	our $MSG_SSWAP_MENU_GETORBITS_1 = "Give Orbits of a Siteswap.";
	our $MSG_SSWAP_MENU_GETORBITS_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap\n\n\- <int> :  Colorization Model (Default:2)\n\t\t'0' : No colorization;\n\t\t'1' : Multiplex in increasing order of\n\t\t Siteswap values of previous throws;\n\t\t'2' : Multiplexe in increasing order of \n\t\t Siteswap values of previous throws.\n\n\-[\"file\"] Optional, File for result. if -1 return the result, but do not print it."; 
	our $MSG_SSWAP_MENU_GETORBITSAGGR_1 = "Give Aggregated Orbits of a Siteswap.";
	our $MSG_SSWAP_MENU_GETORBITSAGGR_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap\n\n\- <int> :  Colorization Model (Default:2)\n\t\t'0' : No colorization;\n\t\t'1' : Multiplex in increasing order of\n\t\t Siteswap values of previous throws;\n\t\t'2' : Multiplexe in increasing order of \n\t\t Siteswap values of previous throws.\n\n\-[\"file\"] Optional, File for result. if -1 return the result, but do not print it."; 
	our $MSG_SSWAP_MENU_GETINFO_1 = "Give information on the Siteswap.";
	our $MSG_SSWAP_MENU_GETINFO_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to check.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_GETHEIGHTMAX_1 = "Give the Max Height of the Siteswap";
	our $MSG_SSWAP_MENU_GETHEIGHTMAX_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";	
	our $MSG_SSWAP_MENU_GETHEIGHTMIN_1 = "Give the Min Height of the Siteswap";
	our $MSG_SSWAP_MENU_GETHEIGHTMIN_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";	
	our $MSG_SSWAP_MENU_GETSSTYPE_1 = "Give the Siteswap family : V (Vanilla), M (Multiplex), S (Synchronous), MS (Multiplex-Synchronous), MULTI (MultiSynchronous).";
	our $MSG_SSWAP_MENU_GETSSTYPE_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_GETNUMBER_1 = "Give the number of objects needed for the Siteswap";
	our $MSG_SSWAP_MENU_GETNUMBER_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";	
	our $MSG_SSWAP_MENU_GETPERIOD_1 = "Give the Siteswap Period";
	our $MSG_SSWAP_MENU_GETPERIOD_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_GETANAGRAMMES_1 = "Give Anagrammes of a Siteswap.";
	our $MSG_SSWAP_MENU_GETANAGRAMMES_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap (V,M,S or MS).\n\- [\"options\"] Different options \-[r|k]:\n\t\-r <y|n> : remove equivalent Siteswaps (Default:y).\n\t\-k <y|n> : option for Siteswaps S and MS: for symetric Siteswaps ending with *, the Scramblable status is considered only on the first part (Default:y).\n\- [\-1] Optional, return the result, but do not print it.";	
	our $MSG_SSWAP_MENU_GETSSSTATUS_1 = "Give the Siteswap Status (Excited, Ground or Unknown if the Siteswap length do not permit to compute it).";
	our $MSG_SSWAP_MENU_GETSSSTATUS_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to analyze.\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_PRINTSSLIST_1 = "Show in a better way a List of Siteswaps (in Text/File or in a JML JugglingLab File).";
	our $MSG_SSWAP_MENU_PRINTSSLIST_2 = "Parameters :\n\n\- <List> : a Perl List of Siteswaps. Use Input File if empty.\n\n".$MSG_SSWAP_PRINTSS_OPTS_a1.$MSG_SSWAP_PRINTSS_OPTS_b1.$MSG_SSWAP_PRINTSS_OPTS_c."\n\n\- [\"inputFile\"] : Input File used if list is empty.";
	our $MSG_SSWAP_MENU_PRINTSSLISTHTML_1 = "HTML file creation from a Siteswaps list, adding Ladder diagrams, JML JugglingLab file and TXT list.";
	our $MSG_SSWAP_MENU_PRINTSSLISTHTML_2 = "Parameters :\n\n\- <\"inputFile\"> : File with the Siteswaps list.\n\n\- <\"outputFile\"> : HTML Files for results (adding extension .html/.jml/.txt).\n\n\- <\"string\"> : Title.\n\n\- [\"options\"] Several options \-[v|l|j|f|m] ".$MSG_SSWAP_PRINTSS_OPTS_a1_ssListHTML."\n\n\t\-v <y|n> : Add a column with simplified Siteswaps (Default:n).\n\t\-l <y|n> : Add a column with modified Siteswaps with lower throws, keeping the throws tempo thanks to extra Hold Times (Default:n).\n\t\-j <y|n> : Add a column with modified Siteswaps with lower throws, keeping the throws tempo thanks to extra Hold Times and usable on JugglingLab. JugglingLab only handles Hold Times for throws 1x or 2, Hold Times are then converted (Default:n).\n\t\-f <int> : Number of Minimum Free Beats during transformation between two consecutive throws (Default:1). As the object is catch a small time before being throwed, with a Dwell time around 1 in general a lower value implies Squeezes.\n\t\-m <int> : Minimum value for throw on same hand after transformation in order to avoid for example a transformation of throw into hold (Default:3).\n\n[\-1] Optional, return the result, but do not print it (Default:n).".$MSG_SSWAP_PRINTSS_OPTS_b1;
	our $MSG_SSWAP_MENU_GETSTATES_1 = "Give States used.";
	our $MSG_SSWAP_MENU_GETSTATES_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\- [\-1] Optional, return the result, but do not print it.";      
	our $MSG_SSWAP_MENU_JDEEP_1 = "Prime Siteswaps Generation (jdeep de Jack Boyce).";
	our $MSG_SSWAP_MENU_JDEEP_2 = "jdeep version 5.1 by Jack Boyce\n(02/17/99) jboyce@users.sourceforge.net\n\nThe purpose of this program is to search for long prime asynch siteswap patterns.\n\nCall format is: \n\tjdeep (\'<# objects> <max. throw> [<min. length>] [options]\')\n\nwhere :\n\t<# objects>   = number of objects in the patterns found.\n\t<max. throw>  = largest throw value to use.\n\t<min. length> = shortest patterns to find (optional, speeds search)\n\nThe various options are :\n\t-block <skips> : find patterns in block form, allowing\n\t\t\t the specified number of skips.\n\t-super <shifts> : find (nearly) superprime patterns, allowing\n\t\t\t the specified number of shift throws.\n\t-inverse : print inverse also, in -super mode.\n\t-g : find ground-state patterns only.\n\t-ng : find excited-state patterns only.\n\t-full : print all patterns; otherwise only patterns as long\n\t\t\t currently-longest one found are printed.\n\t-noprint : suppress printing of patterns.\n\t-exact : prints patterns of exact length specified (no longer).\n\t-x <throw1 throw2 ...> : exclude listed throws (speeds search).\n\t-trim : force graph trimming algorithm on.\n\t-notrim : force graph trimming algorithm off.\n\t-file : run in file output mode.\n\t-time <secs> : run for specified time before stopping.";
	our $MSG_SSWAP_MENU_TOSTACK_1 = "Give the corresponding Stack Notation [Experimental].";
	our $MSG_SSWAP_MENU_TOSTACK_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- [\"options\"] Several options \-[m|s] defined hereafter :\n\n\t\-m <int> : Computation Mode for Holes in Multiplexes\n\t(Default:1)\n\t\t'0' : No Hole between Multiplexes Throws [Demo Purpose];\n\t\t'1' : Increasing Order for arrival;\n\t\t'2' : Decreasing order for arrival.\n\n\t\-s <n|r|l> : Computation Mode for Holes in Synchonous \n\t(Defaut:r)\n\t\t'n' : Complete Synchro. Independant Stacks [Demo Purpose];\n\t\t'r' : Right Hand first;\n\t\t'l' : Left Hand first.\n\n\- [\-1] Optional, return the result, but do not print it.";
	our $MSG_SSWAP_MENU_SLIDESWITCHSYNC_1 = "Give related Siteswaps with Synchonization switching.";
	our $MSG_SSWAP_MENU_SLIDESWITCHSYNC_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\- [\-1] Optional, return the result, but do not print it.";

	our $MSG_SSWAP_MENU_POLYRHYTHMFOUNTAIN_1 = "Polyrhythmic Fountain Tool from Josh Mermelstein.";
	our $MSG_SSWAP_MENU_POLYRHYTHMFOUNTAIN_2 = "Parameters :\n\n\- None.";
	
	our $MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_1 = "Siteswaps transformation for lower throws, keeping the Tempo of throws but adding extra Hold Times.";
	our $MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_2 = "Interesting to simplify Polyrhythms.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap to adapt.\n\n\- [\"options\"] Several options \-[f|j|m] described hereafter:\n\t\-f <int> : Number of Minimum Free Beats during transformation between two consecutive throws (Default:1). As the object is catch a small time before being throwed, with a Dwell time around 1 in general a lower value implies Squeezes.\n\t\-j <y|n> : JugglingLab Adaptation. JugglingLab only render Hold Times for throws 1x or 2. It then convert Hold Times with greater values.\n\t\-m <int> : Minimum value for throw on same hand after transformation in order to avoid for example a transformation of throw into hold (Default:3).\n\n[\-1] Optional, return the result, but do not print it (Default:n).";
	
	our $MSG_SSWAP_SLIDESWITCHSYNC_ERR1 = "Siteswap Family not handled.";

	our $MSG_SSWAP_MENU_DUAL_1 = "Generation of Dual Siteswap."; 
	our $MSG_SSWAP_MENU_DUAL_2 = "Parameters :\n\n\- <type> : Type of generator through 'V' (Vanilla), 'M' (Multiplexe).\n\n\- <\"siteswap\"> : Siteswap.\n\n== case 'V' ==\n\t\- <nb> : Max height in hexadecimal.\n\n== case 'M' ==\n\t\- <nb> : Max height in hexadecimal.\n\t\- <int> : Max Simultaneous throws.\n\n\- [\"file\"] Optional, fichier for results. If -1, gives the result without printing it.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1; 

	our $MSG_SSWAP_DUAL_ERR0 = "Generation Possible only for Siteswaps families V and M.";
	our $MSG_SSWAP_DUAL_ERR1 = "Parameter Heightmust be greater than Height Maximum.";
	our $MSG_SSWAP_DUAL_ERR2 = "Generation Possible only for this Siteswap in Family M.";
	our $MSG_SSWAP_DUAL_ERR3 = "Parameter Multiplexe must be greater than the number max of Multiplexes in the Siteswap.";

	our $MSG_SSWAP_ANIMATE_ANTISS_ERR0 = "Invalid on Such OS.";
	
	our $MSG_SSWAP_GENSS_1 = "\tHere are the ";
	our $MSG_SSWAP_GENSS_2 = " Siteswap result(s)\n";
	our $MSG_SSWAP_GENSS_3 = "\t(Objects number : ";
	our $MSG_SSWAP_GENSS_4 = "; Higher throw value : ";
	our $MSG_SSWAP_GENSS_5 = "; Period : ";
	our $MSG_SSWAP_GENSS_6 = ")\n";
	our $MSG_SSWAP_GENSS_7 = "Siteswap(s)";

	our $MSG_SSWAP_GENTRANS_1 = "\tHere are the ";
	our $MSG_SSWAP_GENTRANS_2 = " Siteswap result(s)\n";
	our $MSG_SSWAP_GENTRANS_3 = "\tSiteswap1 : ";
	our $MSG_SSWAP_GENTRANS_4 = "; Siteswap2 : ";
	our $MSG_SSWAP_GENTRANS_5 = ")\n";
	our $MSG_SSWAP_GENTRANS_6 = "Siteswap(s)";

	our $MSG_SSWAP_TIMEREV_ERR0 = "Invalid Siteswap : ";

	our $MSG_SSWAP_SYM_ERR0 = "Invalid Siteswap : "; 

	our $MSG_SSWAP_ISSCRAMBLABLE_ERR1 = "Error : Siteswaps Period not handled : ";

	our $MSG_SSWAP_ISVALID_ERR0 = "Invalid Siteswap"; 
	our $MSG_SSWAP_ISVALID_ERR1 = "(Invalid Syntax)\n";
	our $MSG_SSWAP_ISVALID_ERR3a = "(Invalid Average : ";
	our $MSG_SSWAP_ISVALID_ERR3b = ")\n";
	our $MSG_SSWAP_ISVALID_MSG1a = "Contains Simultaneous Catches in Right Hand.\n";
	our $MSG_SSWAP_ISVALID_MSG1b = "Contains Simultaneous Catches in Left Hand.\n";
	our $MSG_SSWAP_ISVALID_MSG2 = "Contains Clustered Multiplex(es) Throws\n";
	our $MSG_SSWAP_ISVALID_MSG3 = "True Multiplexing Only\n";	
	our $MSG_SSWAP_ISVALID_MSG4 = "MultiSync Reduced : ";	
	our $MSG_SSWAP_ISVALID_MSG4b = "MultiSync Extended : ";	
	our $MSG_SSWAP_ISVALID_MSG5a = "Multiplex";
	our $MSG_SSWAP_ISVALID_MSG5b = "and Squeeze";
	our $MSG_SSWAP_ISVALID_MSG5c = "does not correspond for : ";

	our $MSG_SSWAP_GENSTATES_MSG1a = "States-Transitions Matrix ";
	our $MSG_SSWAP_GENSTATES_MSG1 = "State Not Considered : ";

	our $MSG_SSWAP_GETSTATES_ERR2 = "Cannot Solve States : Invalid Siteswap.";

	our $MSG_SSWAP_GETANAGRAMMES_ERR1 = "Error : Siteswaps MultiSynchrones Not handled";

	our $MSG_SSWAP_GENSSFROMSTATES_MSG1 = "Type";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG2 = "Redundancies removed";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG3 = "Max Height";
	our $MSG_SSWAP_GENSSFROMSTATES_MSG4 = "Period";
	our $MSG_SSWAP_GENSSFROMSTATES_ERR1 = "Invalid Type.";

	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG1 = "Type";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a = "Start State";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b = "End State";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG3 = "Max Height";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_MSG4 = "Period";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_ERR1 = "Siteswaps not compatible.";
	our $MSG_SSWAP_GENTRANSBTWNSTATES_ERR2 = "not the same objects number.";

	our $MSG_SSWAP_GENTRANSBTWNSS_MSG1 = "Type";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG2a = "Start Siteswap";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG2b = "End Siteswap";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG3 = "Max Height";
	our $MSG_SSWAP_GENTRANSBTWNSS_MSG4 = "Period";
	our $MSG_SSWAP_GENTRANSBTWNSS_ERR0 = "Invalid Siteswap .";
	our $MSG_SSWAP_GENTRANSBTWNSS_ERR2 = "not the same objects number.";

	our $MSG_SSWAP_GENAGGRSTATES_MSG1a = "Reduced States/Transitions Matrix ";

	our $MSG_SSWAP_WRITE_EXCEL_FROM_STATES1 = "Aborting ... too much states for writing the Excel File. Use write_states_xls instead.\n";
	our $MSG_SSWAP_WRITE_EXCEL_FROM_STATES2 = "Matrix Conversion into Excel file.\n"; 

	our $MSG_SSWAP_WRITE_TXT_FROM_STATES2 = "Matrix Conversion into Text file.\n"; 

	our $MSG_SSWAP_GENPROBERTDIAG_MSG1a = "Martin Probert's Diagram";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1b = "Objects Number";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1c = "Max Height";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1d = "Period";
	our $MSG_SSWAP_GENPROBERTDIAG_MSG1h = "Any Height";

	our $MSG_SSWAP_GENPROBERTSS_MSG1a = "Vanilla Siteswaps Generation from Martin Probert's Diagrams";
	our $MSG_SSWAP_GENPROBERTSS_MSG1b = "Objects Number";
	our $MSG_SSWAP_GENPROBERTSS_MSG1c = "Period";
	our $MSG_SSWAP_GENPROBERTSS_MSG1d = "Max Height";
	our $MSG_SSWAP_GENPROBERTSS_MSG1e = "Siteswap(s)";
	our $MSG_SSWAP_GENPROBERTSS_MSG1f = "Reject : ";
	our $MSG_SSWAP_GENPROBERTSS_MSG1g = "Redundancies removed";
	our $MSG_SSWAP_GENPROBERTSS_MSG1h = "Any Height";

	our $MSG_SSWAP_GENMAGICSS_MSG1a = "Redundancies removed";

	our $MSG_SSWAP_ISPRIME_MSG1 = "MultiSynchronous Siteswap (not implemented) or Invalid Siteswap.";

	our $MSG_SSWAP_GENSSPRIME_MSG0 = "PRIME SITESWAPS";
	our $MSG_SSWAP_GENSSPRIME_MSG1 = "Number of Prime Siteswaps : ";
	our $MSG_SSWAP_GENSSPRIME_MSG2 = "Longest Circuit(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG3 = "State(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG4 = "Longest Siteswap(s)";
	our $MSG_SSWAP_GENSSPRIME_MSG5 = "Period =";
	our $MSG_SSWAP_GENSSPRIME_MSG6 = "States Number Histogram";
	our $MSG_SSWAP_GENSSPRIME_MSG7 = "(Number of Prime Circuits per Number of States)";
	our $MSG_SSWAP_GENSSPRIME_MSG8 = "(Number of Prime Siteswaps per Number of States)";
	our $MSG_SSWAP_GENSSPRIME_MSG9 = "States Occurrences";
	our $MSG_SSWAP_GENSSPRIME_MSG10 = "Length";
	our $MSG_SSWAP_GENSSPRIME_MSG11 = "Initial State";


	our $MSG_SSWAP_TOSTACK_MSG1 = "MultiSynchronous Siteswap (not implemented) or Invalid Siteswap.";

	our $MSG_SSWAP_GETSTATES_FROM_XLS_MSG1 = "States/Transitions Matrix Loaded.";

	our $MSG_SSWAP_CHECK_XLS_FILE_1 = "Warning : The XLS File is not the one awaited ";
	our $MSG_SSWAP_CHECK_XLS_FILE_2 = "Check what you do or you may get some unexpected results !";

	our $MSG_SSWAP_GENERAL1 = "Asynchronous Siteswap";
	our $MSG_SSWAP_GENERAL1p = "Asynchronous Siteswap(s)";
	our $MSG_SSWAP_GENERAL1b = "Synchronous Siteswap";
	our $MSG_SSWAP_GENERAL1bp = "Synchronous Siteswap(s)";
	our $MSG_SSWAP_GENERAL1c = "MultiSynchronous Siteswap";
	our $MSG_SSWAP_GENERAL1cp = "MultiSynchronous Siteswap(s)";
	our $MSG_SSWAP_GENERAL2 = "Number of Objects";
	our $MSG_SSWAP_GENERAL2b = "Any number of Objects";
	our $MSG_SSWAP_GENERAL3 = "Max Height";
	our $MSG_SSWAP_GENERAL3b = "Min Height";
	our $MSG_SSWAP_GENERAL4 = "Number of Multiplex Max";
	our $MSG_SSWAP_GENERAL5 = "Sum";
	our $MSG_SSWAP_GENERAL6 = "Period";
	our $MSG_SSWAP_GENERAL10 = "State(s)";
	our $MSG_SSWAP_GENERAL11 = "Transition(s)";
	our $MSG_SSWAP_GENERAL12 = "Time Reversed Siteswap";
	our $MSG_SSWAP_GENERAL13 = "Min Period";
	our $MSG_SSWAP_GENERAL14 = "Mod";
	our $MSG_SSWAP_GENERAL15 = "Number Throws";
	our $MSG_SSWAP_GENERAL16 = "Number Max of Multiplex Throws";
	our $MSG_SSWAP_GENERAL17 = "Object(s)";
	our $MSG_SSWAP_GENERAL18 = "No Excel licence detected. Some functions will not be available.";
	our $MSG_SSWAP_GENERAL19 = "Symetry";

	our $MSG_SSWAP_PRINTSS_OPTS_a1="\- [\"options\"] Several options among \-[b|c|d|g|i|n|o|p|r|s|t|u] :";
	our $MSG_SSWAP_PRINTSS_OPTS_a1_ssListHTML = "and printing options \-[b|c|d|g|i|n|o|p|r|s|t|u] described hereafter :";
	our $MSG_SSWAP_PRINTSS_OPTS_a2="\- [\"options\"] Several options among \-[b|c|d|g|h|i|l|n|o|p|s|t] :";
	our $MSG_SSWAP_PRINTSS_OPTS_b1 = "\n\n\t\-r <0|1|2> :  Redundancy elimination (Default:0):\n\t\t'0' : No suppression;\n\t\t'1' : Remove Redundancy, trying to keep Ground Siteswaps;\n\t\t'2' : Remove Redundancy according to the list order.\n\n\t\-c <y|n> : Take into account the Multiplex colorization Model \n\tfor Redundancy Elimination (Default:n).\n\n\t\-g <y|n> : Ground Only (Default:n).\n\n\t\-b <y|n> : Reversible Only (Default:n).\n\n\t\-d <y|n> : Scramblable Only (Default:n).\n\n\t\-i <y|n> : Give some more information (Default:n).\n\n\t\-n <y|n> : Palindrome Only (Default:n).\n\n\t\-q <y|n> : No Squeeze Only (Default:n).\n\n\t\-o <0|1|2|3> : Ordering the result (Default:1).\n\t\t'0' : No ordering;\n\t\t'1' : Alphanumerical Sort;\n\t\t'2' : According to the Object number;\n\t\t'3' : According to the Period.\n\n\t\-p <y|n> : Take into account permutations for Redundancy \n\tElimination, Symetry is considered also (Default:y).\n\n\t\-s <y|n> : Take into account the Symetry for Redundancy \n\tElimination (Default:n).\n\n\t\-t <\"string\"> : Title.\n\n\t\-u <y|n> : Prime Only (Default:n).";
	our $MSG_SSWAP_PRINTSS_OPTS_b2 = "\n\n\t\-r <0|1|2> :  Redundancy elimination (Default:0):\n\t\t'0' : No suppression;\n\t\t'1' : Remove Redundancy, trying to keep Ground Siteswaps;\n\t\t'2' : Remove Redundancy according to the list order.\n\n\t\-c <y|n> : Take into account the Multiplex colorization Model \n\tfor Redundancy Elimination (Default:n).\n\n\t\-g <y|n> : Ground Only (Default:n).\n\n\t\-b <y|n> : Reversible Only (Default:n).\n\n\t\-d <y|n> : Scramblable Only (Default:n).\n\n\t\-i <y|n> : Give some more information (Default:n).\n\n\t\-n <y|n> : Palindrome Only (Default:n).\n\n\t\-q <y|n> : No Squeeze Only (Default:n).\n\n\t\-o <0|1|2|3> : Ordering the result (Default:1).\n\t\t'0' : No ordering;\n\t\t'1' : Alphanumerical Sort;\n\t\t'2' : According to the Object number;\n\t\t'3' : According to the Period.\n\n\t\-p <y|n> : Take into account permutations for Redundancy \n\tElimination, Symetry is considered also (Default:y).\n\n\t\-s <y|n> : Take into account the Symetry for Redundancy \n\tElimination (Default:n).\n\n\t\-t <\"string\"> : Title.\n\n\t\-h <y|n> : Histograms & used circuits (Default:n).\n\n\t\-l <y|n> : Results Synthesis & Longest Prime Siteswaps (Default:y).";
	our $MSG_SSWAP_PRINTSS_OPTS_c = "\n\n\- [\"file\"] Optional, file for the result. \nIf -1, return the result but do not print/write it.\nIf the file starts with \n\t\- \'JML:\', issue a JML file with extension .jml \n\tfor JugglingLab view; Invalid Siteswaps are not showed.\n\t\- \'SSHTML:\', issue an HTML file with extension .html with \n\tsome information on the Siteswaps.";    
	our $MSG_SSWAP_PRINTSS_OPTS_c1 = "\n\n\- [\"file\"] Optional, file for the result. \nIf -1, return the result but do not print/write it.\nIf the file starts with \n\t\- \'JML:\', issue a JML file containing full siteswaps with extension .jml \n\tfor JugglingLab view; Invalid Siteswaps are not showed.\n\t\- \'SSHTML:\', issue an HTML file containg full siteswaps with extension .html with \n\tsome information on the Siteswaps.";    
	our $MSG_SSWAP_PRINTSS_OPTS_c2 = "\n\n\- [\"file\"] Optional, file for the result. \nIf -1, return the result but do not print/write it.\nIf -2, print the circuits used and the synthesis if set in previous options. \nIf the file starts with \n\t\- \'JML:\', issue a JML file containing full siteswaps with extension .jml \n\tfor JugglingLab view; Invalid Siteswaps are not showed.\n\t\- \'SSHTML:\', issue an HTML file containg full siteswaps with extension .html with \n\tsome information on the Siteswaps.";    
	our $MSG_SSWAP_JML = "Fichier JML generated to load in JugglingLab: ";  

	our $MSG_SSWAP_POLYRHYTHM_MSG1 = "Ratio";

	
	################################################"
	#
	# LADDER Module Messages 
	#
	################################################"

	our $MSG_LADDER_MENU_HELP = "In this module a SITESWAP will be written similarly to JugglingLab.\n\n\tExamples : 534, (6x,4)*, (2x,[22x])(2,[22])(2,[22x])*. In addition we will consider symbols <!> and <*> in Synchronous or Asynchronous.\n\n'!' : Remove one Beat. After a Synchronous Siteswap, it means that the next throw is on the next Beat (without it should be a catch Beat). After an Asynchronous Siteswap, it means that the next throw is also on the current Beat. Thus it gives a way to represent all Synchronous and/or Multiplex Siteswaps using an Asynchronous-like Siteswap.\n'*' : In a Synchronous Siteswap it means a hand swap in the next Beats and is not necessary at the end. In an Asynchronous Siteswap, it means that the next throw is done using the same hand. (Hurry Throw)\n\n\tExemples : 4!40, 5!*4!*3, 6x0*, (6x,0)*, 51x*, (1x,3)!11x* ... 
\n\nThis module takes also into account the different possible ways to colorize a multiplex throw.
\n\n\tExamples : 24[54] and 24[45] are different"; 	
	our $MSG_LADDER_MENU_DRAW_1 = "Draw the Ladder Diagram of a given Siteswap. Graphviz has to be installed first.";
	our $MSG_LADDER_MENU_DRAW_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to draw.\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1."\n\n\- [\\%hash] : Optional, transitions hash. In this case the Siteswap is used for the title only. Each key is Ri:j for a right transition or Li:j for a left one. i is the throw Beat and j is the numero of the thrown object (starting from 0) to help the colorization\n\tEx :  %hash = (
	\t'L2:0' => 'R4:0',
	\t'R2:0' => 'R4:1',
	\t'L4:0' => 'R6:0',
	\t'R4:0' => 'R5:0',
	\t'R4:1' => 'L6:0',
	\t'R6:0' => 'R6:0'
	\t);";
	our $MSG_LADDER_MENU_REMOVE_OBJ_1 = "Draw the Ladder Diagram after removing one or several objects.";
	our $MSG_LADDER_MENU_REMOVE_OBJ_2 = "Parameters :\n\n\- <\"siteswap1\"> : Siteswap.\n\n\- <int or \"[list]\"> : Object to remove (starting at 0) or Objects list sperared by \",\".\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_SYM_1 = "Draw the Symetric Ladder Diagram of a given Siteswap.";
	our $MSG_LADDER_MENU_SYM_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_INV_1 = "Draw the Time Reversed Ladder Diagram of a given Siteswap.";
	our $MSG_LADDER_MENU_INV_2 = "The resulting Siteswap does not take into account the colorization mode; the diagram considers it.\n\nParameters :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_MERGE_1 = "Merge 2 Siteswaps and draw the corresponding Ladder Diagram.";
	our $MSG_LADDER_MENU_MERGE_2 = "Parameters :\n\n\- <\"siteswap1\"> : Siteswap1.\n\n\- <\"siteswap2\"> : Siteswap2.\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a2.$MSG_GRAPHVIZ_OPTS_b1."\n\n\t\-r <int> : Remove 0 in Multiplexes (Default:0)\n\t\t'0' : remove it;\n\t\t'1' : keep it.";
	our $MSG_LADDER_MENU_SLIDE_1 = "Draw the Ladder Diagram of a given Siteswap after shifting the right/left hand .";
	our $MSG_LADDER_MENU_SLIDE_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <\"hand\"> : Shifting Hand (right : \"R\" or left : \"L\")\n\n\- <\"dec\"> : Shifting Value (ex : +1 , -2, 3)\n\n\- <\"file\"> : image file for the result.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	our $MSG_LADDER_MENU_TO_MULTISYNC_1 = "Give the MultiSynchronous Siteswap. (ie multiplexes and synchronous throws adaptation).";
	our $MSG_LADDER_MENU_TO_MULTISYNC_2 = "Param\x{e8}tres :\n\n\- <\"siteswap\"> : Siteswap.\n\n\- <Type> : Type of MultiSynchronous Siteswap (0: Reduced MultiSynchronous, 1: Synchronous/Asynchronous combination, 2 : Extended MultiSynchronous Async format, 3 : Extended MultiSynchronous Sync format)\n\n\- [\"fichier\"] Optional, image file (.png) for the result. If -1, No picture is generating.\n\n".$MSG_GRAPHVIZ_OPTS_a1.$MSG_GRAPHVIZ_OPTS_b1;
	
	our $MSG_LADDER_DRAW_1 = "Diagram generated";

	our $MSG_LADDER_SLIDE_1 = "Too big shift => negative throws invalid !";


	################################################"
	#
	# SPYRO Module Messages 
	#
	################################################"

	our $MSG_SPYRO_MENU_HELP = "SPYRO defines a Spyrograph for jugglers to model Spins, Antispins, Hybrids, Extensions, Isolations in a single plane.\n";

	our $MSG_SPYRO_MENU_ANIMATE_1 = "Start JuggleSpyro HTML5.";
	our $MSG_SPYRO_MENU_ANIMATE_2 = "Parameters :\n\n\- None or optionaly the HTTP Server Port.";
	our $MSG_SPYRO_MENU_STAFFSIMMCP_1 = "Start the MCP's Staffs Simulator.";
	our $MSG_SPYRO_MENU_STAFFSIMMCP_2 = "Parameters :\n\n\- None.";
	our $MSG_SPYRO_MENU_POIFLOWERS_1 = "Start David Lyons's Po\x{ef} Simulator.";
	our $MSG_SPYRO_MENU_POIFLOWERS_2 = "Parameters :\n\n\- None.";


	################################################"
	#
	# HSS Module Messages 
	#
	################################################"

	our $MSG_HSS_MENU_HELP = "Hand Siteswap Notation (HSS). It currently support only Vanilla HSS.\n"; 

	our $MSG_SSWAP_MENU_MHASYNCBASICMAP_1 = "Map of Asynchronous MultiHand Siteswaps Basic types, Hands x Objects number.";
	our $MSG_SSWAP_MENU_MHASYNCBASICMAP_2 = "Parameters :\n\n\- [int] : Max number of Hands (Default:15).\n\n\- [int] : Max number of Objects (Default:15).";
	our $MSG_SSWAP_MENU_MHASYNCCHANGEHSS_1 = "Give Siteswap get by swapping hands (HSS with 2 hands) but keeping throw and catch hands. [Experimental]";
	our $MSG_SSWAP_MENU_MHASYNCCHANGEHSS_2 = "Parameters :\n\n\- <\"siteswap\"> : Asynchronous Siteswap.\n\n\- <hss> : Initial Hand Siteswap.\n\n\- <hss> : Ending Hand Siteswap.";

	our $MSG_HSS_MENU_GETHANDSSEQ_1 = "Give Hands sequence according to input HSS.";
	our $MSG_HSS_MENU_GETHANDSSEQ_2 = "Param\x{e8}tres :\n\n\- <hss> : Hand Siteswap.\n\n\- <\"string\"> : Hands involved separated by , .";


	our $MSG_HSS_CHANGEHSS_ERROR1 = "Invalid Siteswap."; 
	our $MSG_HSS_CHANGEHSS_ERROR2 = "Invalid HSS."; 
	
	our $MSG_HSS_ERROR1 = "Invalid HSS."; 
	our $MSG_HSS_ERROR2 = "Only Vanilla HSS is handled."; 
	our $MSG_HSS_ERROR3 = "Number of hands in parameter must be equal to the number of hands in HSS."; 

	
	################################################"
	#
	# HTN Module Messages 
	#
	################################################"

	our $MSG_HTN_MENU_HELP = "Harmonic Throws Notation (3\-Layers Notation).\n"; 
	
	our $MSG_HTN_MENU_DRAWGRID_1 = "Draw the grid related to the given Siteswap. Gnuplot and eventually Ghostscript and ImageMagick (converter) have to be installed prior (images are only PostScript otherwise).";
	our $MSG_HTN_MENU_DRAWGRID_2 = "Parameters :\n\n\- <\"siteswap\"> : Siteswap to draw.\n\n\- <\"file\"> : Image file for the result.\n\n\- [\"options\"] Several options among \-[a|b|c|d|e|h|l|p|r|s|t|u|v|y|z] :\n\n\t\-a <dec> : Staple height for throw on same hand (Default:0.4).\n\n\t\-b <color> : Staple color (Default:green).\n\n\t\-c <color> : Circle color (Default:#a935bd).\n\n\t\-d <color> : Sync color (Default:blue).\n\n\t\-e <color> : Hand Mode color (Default:blue).\n\n\t\-h <r|l> : Hand Mode (Default:r).\n\n\t\-l <y|n> : Print Labels on axis (Default:y).\n\n\t\-p <int> : Period to draw (Default:10).\n\n\t\-r <dec> : Circles Radius (Default:0.2).\n\n\t-s <int> : Print the result (Default:0)\n\t\t'0' : Print the result;\n\t\t'1' : No printing.\n\n\t\-t <y|n> : Print the title (Default:y).\n\n\t\-u <y|n> : Print the Hand Mode in title (Default:y).\n\n\t\-v <\"string\"> : Title Value to set.\n\n\t\-y <dec> : Y Shift for overlapping throws (Default:0.25).\n\n\t\-z <\"string\"> : Terminal Driver. Set Value to empty to see possibilities (Default:auto).";
	our $MSG_HTN_MENU_HTNMAKER_1 = "HTNMaker made by Shawn Pinciara to build Harmonic Grids.";
	our $MSG_HTN_MENU_HTNMAKER_2 = "Parameters :\n\n\- None.";

	
	our $MSG_HTN_DRAWGRID_1 = "Grid generated";

	our $MSG_HTN_ERR_OVERLAP_1 = "Circle Overlapping upon drawing. Try to reduce YShift to improve it."; 
	our $MSG_HTN_ERR_DRAWGRID_1 = "Error : No point to draw."; 

	
	################################################
	#
	# Generic Messages 
	#
	################################################

	our $MSG_GENERAL_ERR1="Cannot Open file";
	our $MSG_GENERAL_ERR1b="for writing.";
	our $MSG_GENERAL_ERR2="Cannot Create file";
	our $MSG_GENERAL_GRAPHVIZ="Graphviz Generation Process\n";

	our $MSG_MOD_VERSION_1 = "Give the Module Version.";
	our $MSG_MOD_VERSION_2 = "No Parameter.";

	our $MSG_GRAPHVIZ_OPTS_a1="\- [\"options\"] Several options among \-[c|d|e|g|h|i|l|m|n|o|p|s|t|v] :";
	our $MSG_GRAPHVIZ_OPTS_a2="\- [\"options\"] Several options among \-[c|d|h|l|m|n|o|p|r|s|t|v]";
	our $MSG_GRAPHVIZ_OPTS_b1="\n\n\t\-c <int> :  Colorization Model (Default:2)\n\t\t'0' : No colorization;\n\t\t'1' : Multiplex in increasing order of\n\t\t Siteswap values of previous throws;\n\t\t'2' : Multiplexe in increasing order of \n\t\t Siteswap values of previous throws.\n\n\t\-d <int> :  Synchronous Hack (Default:0)\n\t\t'0' : Remove 0 in the drawing after sync throw since \n\t\tit is catches beats;\n\t\t'1' : No hack.\n\n\t\-e <\"string\"> : Label Edge Color according to the Graphviz X11 \n\tscheme (ex : dodgerblue, red, springgreen, darkviolet, \n\tmagenta, goldenrod, saddlebrown, azure4, khaki4, \n\tdarkorange, olivedrab1, turquoise4, black, peru, \n\tmediumslateblue). E for same as the arrow \n\t(Default:E).\n\n\t\-g <y|n> : Keep Graphviz File used for generating (Default:n).\n\n\t\-h <y|n> : Print Hands.\n\n\t\-i \"list using ,\" : Print Hands Enumeration for Vanilla Flat diagram.\n\n\t\-l <pos> : Position of the Siteswap label (Default:s)\n\t\t't': near arrow tail; \n\t\t'h': near arrow head; \n\t\t'm': middle of the arrow; \n\t\t'x': middle of the arrow after drawing; \n\t\t's': around the State; \n\t\t'n': No Siteswap label.\n\n\t\-m <0|1|2> : Diagram Model (Default: According to the Siteswap Type)\n\t\t'0' : Ladder;\n\t\t'1' : Flattened Ladder (Asynchronous Siteswap);\n\t\t'2' : Ladder with odd Beats removed starting from 0\n\t\t\t(Synchronous Siteswap).\n\n\t\-n <y|n> : Draw negatives throws [Experimental] \n\t\t(Default:n).\n\n\t\-p : Periode min to draw (Default:25).\n\n\t\-o <type> : image format (Default:png) through : bmp (Windows Bitmap Format), cmapx (client-side imagemap for use in html and xhtml), dia (GTK+ based diagrams), eps (Encapsulated PostScript), fig (XFIG graphics), gd, gd2 (GD/GD2 formats), gif (bitmap graphics), gtk (GTK canvas), hpgl (HP pen plotters) and pcl (Laserjet printers), imap (imagemap files for httpd servers for each node or edge that has a non\-null \"href\" attribute.), jpg, jpeg, jpe (JPEG), mif (FrameMaker graphics), pdf (Portable Document Format), png (Portable Network Graphics format), ps (PostScript), ps2 (PostScript for PDF), svg, svgz (Structured Vector Graphics), tif, tiff (Tag Image File Format), vml, vmlz (Vector Markup Language), vrml (VRML), wbmp (Wireless BitMap format), xlib (Xlib canvas), canon, dot, xdot (Output in DOT langage), plain , plain\-ext (Output in plain text).\n\n\t\-s <int> : Print or not the result (Default:0)\n\t\t'0' : print the result;\n\t\t'1' : Silence the result.\n\n\t\-t <y|n> : Draw the image title (Default:y)\n\n\t\-v <\"string\"> : Value to use for the title";
	our $MSG_GRAPHVIZ_FORMAT= "\- [\"Format\"] Optional, image format (D\x{e9}fault:png) through : bmp (Windows Bitmap Format), cmapx (client-side imagemap for use in html and xhtml), dia (GTK+ based diagrams), eps (Encapsulated PostScript), fig (XFIG graphics), gd, gd2 (GD/GD2 formats), gif (bitmap graphics), gtk (GTK canvas), hpgl (HP pen plotters) and pcl (Laserjet printers), imap (imagemap files for httpd servers for each node or edge that has a non\-null \"href\" attribute.), jpg, jpeg, jpe (JPEG), mif (FrameMaker graphics), pdf (Portable Document Format), png (Portable Network Graphics format), ps (PostScript), ps2 (PostScript for PDF), svg, svgz (Structured Vector Graphics), tif, tiff (Tag Image File Format), vml, vmlz (Vector Markup Language), vrml (VRML), wbmp (Wireless BitMap format), xlib (Xlib canvas), canon, dot, xdot (Output in DOT langage), plain , plain\-ext (Output in plain text)\n\n\- [\"Generator\"] Optional, Graphviz generation filter (D\x{e9}fault:dot) through : circo (circular layout), dot(directed graphs), neato (undirected graphs), twopi (radial layouts), fdp (undirected graphs), sfdp (large undirected graphs), osage (clustered graphs).";

    }

    # Remove Unicode char in lang.pm 
    if ($common::NoSpecialChar == 1) {
	my @packs = qw(lang);
	my $printVarTab = Devel::Symdump->new(@packs); 
	
	foreach my $printVar ($printVarTab -> scalars) {
	    for my $nletter (keys %common::HASH_SPECIAL_UNICODE_CHAR) {
		$$printVar =~ s/$nletter/$common::HASH_SPECIAL_UNICODE_CHAR{$nletter}/ig;
	    }	 	
	}    
    }
}

1;
