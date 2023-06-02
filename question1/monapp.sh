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
    echo -e "1: Système \n2: Réseau \n3: Disque \n4: Autre \n5: Quitter"

    read -n 1 mainMenuInput

    case $mainMenuInput in
        1) ShowSystemMenu ;;
        2) ShowNetworkMenu ;;
        3) ShowDiskMenu ;;
        4) ShowOtherMenu ;;
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
    echo -e "\nAppuyer sur une touche..."
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

    read input

    splits=(${input// / })

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

    read input

    splits=(${input// / })

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

function ShowDistantOpenSockets() {
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

function ShowDistantPage() {
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

function ShowSocketOnListening() {
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
function ShowNetworkConnections() {
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

    find ~ -type f -size +100M

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

    find ~ -type f -print | grep "$pattern"

    WaitForAnyInput
    ShowDiskMenu
} 

#******************************************
# Fonction : ShowDiskMenu
# Objectif : Affiche le menu Disque
# Notes    :
#******************************************
function ShowDiskMenu() {
    clear
    echo "Disque"
    echo -e "1: Sur-utilisation \n2: Fichiers \n3: Recherche \n4: Retour au menu principal"

    read input

    splits=(${input// / })

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
# Fonction :  ShowOtherMenu
# Objectif :  Affiche le sous-menu personnalisé
# Notes    :
#******************************************
function ShowOtherMenu() {
    clear
    echo "Chef:"
    echo -e "1 [int]: Facteurs \n2: Calendrier \n3: Utilisateur actuel \n4 [file]: En-tête Fichier \n5: Surprise!!! \n5: Retour au menu principal"

    read -p "Choisissez une option : " input

    splits=(${input// / })

    menu="${splits[0]}"
    arg="${splits[1]}"

    case $menu in
        fact) ShowFactorMenu $arg;;
        2) ShowCalendarMenu;;
        3) ShowCurrentUserMenu;;
        5) ShowSurpriseMenu ;;
        4) WriteFileHeader $arg;;
        6) ShowMainMenu ;;
        *) ShowOtherMenu;;
    esac
}

#******************************************
# Fonction : ShowFactorMenu
# Objectif : Afficher les facteurs du nombre passé en paramètre
# Notes    :
#******************************************
function ShowFactorMenu() {
    clear
    valueEntered=$1
    echo "$valueEntered"

    if [ -z "$valueEntered" ]
    then
        echo "Aucune valeur passée"
    else
        factor "$valueEntered"
    fi

    WaitForAnyInput
    ShowOtherMenu
}

#******************************************
# Fonction : ShowCalendarMenu
# Objectif : Affiche le calendrier du mois en cours
# Notes    :
#******************************************

function ShowCalendarMenu() {
    clear

    cal

    WaitForAnyInput
    ShowOtherMenu
}

#******************************************
# Fonction : ShowCurrentUserMenu
# Objectif : Affiche des informations sur l'utilisateur actuel
# Notes    :
#******************************************
function ShowCurrentUserMenu() {
    clear

    w

    WaitForAnyInput
    ShowOtherMenu
}


#******************************************
# Fonction : WriteFileHeader
# Objectif : Ajoutes une en-tête de remise à un fichier passé en paramètre
# Notes    :
#******************************************

WriteFileHeader() {
  clear
  local fileName="$1"

  # Vérifier si le fichier existe
  if [[ ! -f "$fileName" ]]; then
    echo "Le fichier '$fileName' n'existe pas."
    sleep 1
    clear
    ShowOtherMenu 
  fi

  # Demander les informations pour l'en-tête
  echo "Entrez la description de ce fichier :"
  read -r fileDescription

  echo "Entrez le ou les auteurs (séparés par '&') :"
  read -r fileAuthors

  echo "Entrez le numéro d'équipe (laissez vide si non applicable) :"
  read -r teamNumber

  echo "Entrez le nom du travail (ex: 'TP1') :"
  read -r assignmentName

  # Création du contenu de l'en-tête
  local fileHeader="\
#*************************************************************
# Fichier   : $fileName 
# Description : $fileDescription
# Projet    : $assignmentName 
# Auteur(s) : $fileAuthors
# Équipe    : $teamNumber 
# Cours     : IFT-2101 - Protocoles et technologies Internet
# École     : Université Laval
# Session   : Été 2023
# Notes     : 
#*************************************************************
"
# Création d'un fichier temporaire comme 'backup'
  local tempFile=$(mktemp)

  # Copier le contenu original dans le fichier temporaire
  cat "$fileName" > "$tempFile"

  # Création du nouveau contenu avec l'en-tête + le contenu d'origine
  local newFile=$(cat <<EOF
$fileHeader

$(cat "$tempFile")
EOF
)

  # Mettre à jour le fichier d'origine
  echo "$newFile" > "$fileName"

  # Supprimer le fichier temporaire
  rm "$tempFile"

  # Demandé à l'utilisateur s'il veut afficher le contenu du fichier
  echo "Voulez-vous afficher le contenu du fichier? (y/N)"
  read -r showFileContent

  if [[ "$showFileContent" =~ ^[Yy]$ ]]; then
    cat "$fileName"
  fi
  
  sleep 2 
  WaitForAnyInput
  ShowOtherMenu
}


#******************************************
# Fonction : ShowSurpriseMenu
# Objectif : Ouvre une page dans le navigateur sur une vidéo populaire
# Notes    :
#******************************************
function ShowSurpriseMenu() {
    clear
    echo "You've been Rickrolled!"

    sleep 1
    xdg-open "https://youtu.be/dQw4w9WgXcQ?autoplay=1" 2>/dev/null

    WaitForAnyInput
    ShowOtherMenu
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
