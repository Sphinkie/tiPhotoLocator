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
	
/**
 * Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "DD/MM/YYYY"
 */
function toStandardDate(objet, sep="/")
{
    let texte = objet.toString();
    if (texte.length > 10)
    {
        let groups = texte.split(/-|\:|\s|\+/);        // 4 séparateurs: '-', ':', 'space' et '+'
        texte = groups[2] + sep + groups[1] + sep + groups[0];
        // console.log(groups);
    }
    // console.log(texte);
    return texte;
}

/**
 * Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "HH:MM"
 */
function toStandardTime(objet)
{
    let texte = objet.toString();
    if (texte.length > 16)
    {
        let groups = texte.split(/-|\:|\s|\+/);  // 4 séparateurs: '-', ':', 'space' et '+'
        texte = groups[3] + ":" + groups[4];
    }
    return texte;
}
