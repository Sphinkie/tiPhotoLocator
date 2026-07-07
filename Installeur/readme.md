# La certification

Sans certificat, Windows affiche un SmartScreen "Windows a protégé votre PC".   
Avec un certificat auto-signé, Windows affiche un SmartScreen "Editeur inconnu".   
Avec un certificat payant, Windows n'affiche plus de SmartScreen.  

## Génération du certificat

- `create_certificate.ps1` est à exécuter une seule fois pour générer un certificat auto-signé.
- `sphinkie.pfx` : contient le **certificat** qui identifie le développeur en tant qu'éditeur de logiciel, et la **clef privée**. 
- `sign.local.bat`: contient le mot de passe afin qu'il ne soit pas en clair dans `generateSetup.bat.` 


**A conserver et ne PAS partager : le mot de passe et le fichier pfx.**


## Utilisation du certificat

Le fichier `generateSetup.bat` contient une commande **signtool** qui signe l'application générée avec le certificat.

Le certificat peut être utilisé pour d'autres applications et sur d'autres ordinateurs.

Note: pour partager le certificat entre plusieurs projets: 

- déplacer le fichier `pfx` dans `C:\Users\David\Certificates`
- indiquer le chemin dans `generateSetup.bat` avec :

```
set "CertFile=C:\Users\David\Certificates\sphinkie.pfx"
```
