// ------------------------------------------
// Misc javascript utilities usable in QML
// ------------------------------------------



/**
 * Transforme un chemin du type "file:///C:/Users/David/Pictures" en "C:\Users\David\Pictures"
 */
function toStandardPath(objet)
{
    let texte = objet.toString();
    if (texte.length > 8)
    {
        texte = texte.replace("file:///" , "");   // remplacement litéral
        texte = texte.replace(/\//g, "\\");       // remplacement global des / par des \
    }
    // console.log(texte);
    return texte;
}
	
