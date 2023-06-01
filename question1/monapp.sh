#!/bin/bash


#*************************************************************
# Fichier   : MonApp.sh 
# Projet    : Travail Pratique 1 
# Auteur(s) : Kevin Jobin & Jérémy Faucher 
# Équipe    : 6 
# Cours     : Systèmes d'exploitation
# École     : Université Laval
# Session   : Été 2023
# Notes     : 
#************************************************************* 

#******************************************
# Fonction : ShowMainMenu
# Objectif : Affiches le menu principal
# Notes    :
#******************************************
function ShowMainMenu() {
    clear
    
    echo "Équipe 6"
    echo -e "1: Système \n2: Réseau \n3: Disque \n4: Menu du Chef \n5: Quitter"

    read -n 1 mainMenuInput

    case $mainMenuInput in
        1) ShowSystemMenu ;;
        2) ShowNetworkMenu ;;
        3) ShowDiskMenu ;;
        4) ShowChefMenu ;;
        5) Exit ;;
        *) ShowMainMenu ;;
    esac
}

#******************************************
# Fonction : WaitForAnyInput
# Objectif : Attend qu'une touche soit entré
# Notes    :
#******************************************
function WaitForAnyInput() {
    echo -e "\nAppuyer sur une touche pour revenir au menu précédent..."
    while true
    do
        read -n 1 -t 0.1 exitInput

        case $exitInput in
            "") continue ;;
            *) break ;;
        esac
    done
}

#******************************************
# Fonction : ShowTopSubMenu
# Objectif : Affiche le sous-menu top du menu Système
# Notes    :
#******************************************
function ShowTopSubMenu() {
    clear
    nbRefresh=$1

    if [ -z "$nbRefresh" ]
    then
        top -H
    else
        top -H -n "$nbRefresh"
    fi
    
    ShowSystemMenu
}

#******************************************
# Fonction : ShowCPUDetailsMenu
# Objectif : Affiche le sous-menu d'informations sur le processeur dans le menu Système
# Notes    :
#******************************************
function ShowCPUDetailsMenu() {
    clear

    lscpu

    WaitForAnyInput
    ShowSystemMenu
}

#******************************************
# Fonction : ShowOpenFilesMenu
# Objectif : Affiche le sous-menu des fichiers ouverts du menu Système
# Notes    :
#******************************************
function ShowOpenFilesMenu() {
    clear
    process=$1

    if [ -z "$process" ]
    then
        ps -aef
    else
        ps -aef | grep "$process"
    fi

    WaitForAnyInput
    ShowSystemMenu
}

#******************************************
# Fonction : ShowSystemMenu
# Objectif : Affiche le menu du système
# Notes    :
#******************************************
function ShowSystemMenu() {
    clear
    
    echo "Système"
    echo -e "1: top \n2: Processeur \n3: Fichiers ouverts \n4: Retour au menu principal"

    read topInput

    splits=(${topInput// / })

    menu="${splits[0]}"
    arg="${splits[1]}"

    case $menu in
        1) ShowTopSubMenu $arg ;;
        2) ShowCPUDetailsMenu ;;
        3) ShowOpenFilesMenu $arg ;;
        4) ShowMainMenu ;;
        *) ShowSystemMenu ;;
    esac
}

#******************************************
# Fonction : ShowNetworkMenu
# Objectif : Affiche le menu du réseau
# Notes    :
#******************************************
function ShowNetworkMenu() {
    clear
    echo "Sous-menu Réseau :"
    echo -e "1: Socket ouverts (distant) \n2: Page distante \n3: Socket en écoute (LISTENING) localement \n4: Connexions réseau \n5: Retour au menu principal"

    read topInput

    splits=(${topInput// / })

    menu="${splits[0]}"
    arg="${splits[1]}"

    case $menu in
        1) ShowDistantOpenSockets $arg;;
        2) ShowDistantPage $arg;;  
        3) ShowSocketOnListening $arg;;
        4) ShowNetworkConnections $arg;;
        5) ShowMainMenu;;
        *) ShowNetworkMenu;;
    esac
}

#******************************************
# Fonction : ShowDistantOpenSockets
# Objectif : Affiche les sockets ouverts (distant)
# Notes    :
#******************************************

ShowDistantOpenSockets() {
    clear

    read -p "Entrez une adresse IP : " ip
   
    #Exécution de nmap pour analyser les ports
    output=$(nmap -p- --open $ip)

    # Récupération des ports ouverts à partir de la sortie de nmap
    openPorts=$(echo "$output" | awk '/^ *[0-9]+\/.*open/ {print $1}')

    # Affichage des ports ouverts
    if [[ -z $openPorts ]]; then
        echo "Aucun port ouvert trouvé sur l'adresse IP $ip."
    else
        echo "Les ports suivants sont ouverts sur l'adresse IP $ip :"
        echo "$openPorts"
    fi
    
    WaitForAnyInput
    ShowNetworkMenu
}

#******************************************
# Fonction : ShowDistantPage
# Objectif : Affiche une page distante
# Notes    :
#******************************************

ShowDistantPage() {
    clear
    read -p "Entrez une adresse IP : " ip
    curl $ip
    
    WaitForAnyInput
    ShowNetworkMenu
}

#******************************************
# Fonction : ShowSocketOnListening
# Objectif : Affiche les sockets en écoute active
# Notes    :
#******************************************

ShowSocketOnListening() {
    clear
    netstat -tuln
    
    WaitForAnyInput
    ShowNetworkMenu
}

#******************************************
# Fonction : ShowNetworkConnections
# Objectif : Affiche les connections du réseau 
# Notes    :
#******************************************
ShowNetworkConnections() {
    while true
    do
    	clear
        netstat -an | tail -n 10

        echo -e "\nAppuyer sur une touche pour revenir au menu précédent..."
        read -n 1 -t 5 exitInput

        case $exitInput in
            "") continue ;;
            *) break ;;
        esac
    done
    ShowNetworkMenu
}

#******************************************
# Fonction : ShowUtilisationsMenu
# Objectif : Affiche le sous-menu Sur-utilisation du menu Disque
# Notes    :
#******************************************
function ShowUtilisationsMenu() {
    clear

    find / -type f -size +100M

    WaitForAnyInput
    ShowDiskMenu
}

#******************************************
# Fonction : ShowFileSystemMenu
# Objectif : Affiche le sous-menu Fichiers du menu Disque
# Notes    :
#******************************************
function ShowFileSystemMenu() {
    clear

    mount | column -t

    WaitForAnyInput
    ShowDiskMenu
}

#******************************************
# Fonction : ShowSearchMenu
# Objectif : Affiche le sous-menu Recherher du menu Disque
# Notes    :
#******************************************
function ShowSearchMenu() {
    clear
    pattern=$1

    find / -type f -print | grep "$pattern"

    WaitForAnyInput
    ShowDiskMenu
} 

#******************************************
# Fonction : ShowDiskMenu
# Objectif :  Affiche le menu Disque
# Notes    :
#******************************************
function ShowDiskMenu() {
    clear
    echo "Disque"
    echo -e "1: Sur-utilisation \n2: Fichiers \n3: Recherche \n4: Retour au menu principal"

    read topInput

    splits=(${topInput// / })

    menu="${splits[0]}"
    arg="${splits[1]}"

    case $menu in
        1) ShowUtilisationsMenu ;;
        2) ShowFileSystemMenu ;;
        3) ShowSearchMenu $arg ;;
        4) ShowMainMenu ;;
        *) ShowDiskMenu ;;
    esac
}

#******************************************
# Fonction :  ShowChefMenu
# Objectif :  Affiche le sous-menu personnalisé
# Notes    :
#******************************************
ShowChefMenu() {
    clear
    echo "Chef:"
    echo -e "1: Système et réseau \n2: Recherche récursive \n3: Espace Disque \n4: Retour au menu principal"

    read -p "Choisissez une option : " selectedOption

    case $selectedOption in
        1) ShowSystemAndNetworkInfo;;
        2) ShowRecursiveSearch;;
        3) ShowDiskSpaceUsage;;
        4) ShowMainMenu ;;
        *) ShowChefMenu;;
    esac
}

#******************************************
# Fonction : ShowSystemAndNetworkInfo
# Objectif : Afficher les informations système et réseau
# Notes    :
#******************************************

ShowSystemAndNetworkInfo() {
    clear
    echo "Infos du système :"
    lscpu
    echo ""
    echo "Infos du réseau :"
    ip a
    WaitForAnyInput
    ShowChefMenu
}

#******************************************
# Fonction : ShowActiveConnexions
# Objectif : Afficher les connexions actives au réseau
# Notes    :
#******************************************

ShowActiveConnexions() {
  echo "Connexions actives :"
  netstat -natp
  WaitForAnyInput
  ShowChefMenu
}

#******************************************
# Fonction : ShowRecursiveSearch
# Objectif : Effectuer une recherche récursive dans les fichiers
# Notes    :
#******************************************

ShowRecursiveSearch() {
    clear
    read -p "Entrez un terme de recherche : " searchTerm
    echo "Résultats :"
    grep -r "$searchTerm" *
    WaitForAnyInput
    ShowChefMenu
}

#******************************************
# Fonction : ShowDiskSpaceUsage
# Objectif : Affiche l'utilisation du disque et les fichiers de plus de 1 Go
# Notes    :
#******************************************

ShowDiskSpaceUsage() {
    clear
    echo "Utilisation du disque :"
    df -h
    echo ""
    echo "Fichiers gourmands (> 1 Go) :"
    find / -type f -size +1G
    WaitForAnyInput
    ShowChefMenu
}

#******************************************
# Fonction : Exit
# Objectif : Quitte l'application après avoir affiché un message à l'utilisateur
# Notes    :
#******************************************
function Exit(){
    clear
    echo "                                                      
  # #   #    #    #####  ###### #    #  ####  # #####    ##
 #   #  #    #    #    # #      #    # #    # # #    #   ##
#     # #    #    #    # #####  #    # #    # # #    #   ## 
####### #    #    #####  #      #    # #    # # #####    ##
#     # #    #    #   #  #       #  #  #    # # #   #    
#     #  ####     #    # ######   ##    ####  # #    #   ##"
    sleep 2
    clear
    exit 0
}


# Lancer l'application

ShowMainMenu
