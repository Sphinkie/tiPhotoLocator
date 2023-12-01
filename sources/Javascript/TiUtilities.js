// ------------------------------------------
// Misc javascript utilities usable in QML
// ------------------------------------------




/*!
 * \brief Transforme un chemin en format Windows "C:\Users\David\Pictures". Par exemple:
 * file:///E:/TiPhotos
 * file://nas/photo/1997/1997 Sicile
 * \param objet: un chemin au format "file:///C:/Users/David/Pictures"
 * @return un chemin au format "C:\Users\David\Pictures"
 */
function toStandardPath(objet)
{
    let texte = objet.toString();
    if (texte.length > 8)
    {
        texte = texte.replace("file:" , "");   // remplacement litéral
        texte = texte.replace("///" , "");     // remplacement litéral
        texte = texte.replace(/\//g, "\\");    // remplacement global des / par des \
    }
    // console.log(texte);
    return texte;
}
	
/*!
 * \brief Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "DD/MM/YYYY"
 * \param objet: une date du type "YYYY-MM-DD HH:MM:SS"
 * \param sep: (optionel) Le séparateur à utiliser dans le résultat
 * @return une date au format "DD<sep>MM<sep>YYYY"
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

/*!
 * \brief Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "HH:MM"
 * \param objet: une date du type "YYYY-MM-DD HH:MM:SS"
 * @return une heure au format "HH:MM"
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
