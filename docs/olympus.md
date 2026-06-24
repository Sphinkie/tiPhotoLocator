# Format des traces GPS Olympus OI.Track

L'application mobile **Olympus OI.Track** génère des traces GPS pour les appareils photo Olympus/OM System.
Chaque session produit une paire de fichiers nommés par leur timestamp de création (`YYYYMMDDHHMMSS`) :

- `YYYYMMDDHHMMSS.LOG` — trace GPS au format NMEA 0183
- `YYYYMMDDHHMMSS.SNS` — mesures capteurs internes (non utilisé)

---

## Fichier .LOG — Trace GPS

### Structure générale

Fichier texte ASCII/UTF-8, sans BOM. Deux types de lignes :

1. **Ligne d'en-tête** (toujours la première ligne) : signature propriétaire Olympus
2. **Sentences NMEA** : paires `$GPGGA` + `$GPRMC` représentant chaque point GPS

### En-tête Olympus

```
@Olympus/+0200/+0200
```

Format : `@Olympus/<offset1>/<offset2>`

Les deux champs `+HHMM` indiquent le **fuseau horaire local** au moment de l'enregistrement
(ex: `+0100` en hiver CET, `+0200` en été CEST). Les timestamps NMEA étant en UTC,
cet offset permet de reconstituer l'heure locale si nécessaire.

### Format des track-points

Chaque point GPS est représenté par **deux sentences consécutives** :

#### `$GPGGA` — Position et qualité du fix GPS

```
$GPGGA,HHMMSS.s,Lat,N/S,Lon,E/W,Q,Sat,HDOP,Alt,M,GeoSep,M,Age,*checksum
```

| Champ | Exemple | Description |
|---|---|---|
| `HHMMSS.s` | `053703.1` | Heure UTC (05:37:03.1) |
| `Lat` | `4850.3813` | Latitude NMEA format `DDmm.mmmm` |
| `N/S` | `N` | Hémisphère Nord/Sud |
| `Lon` | `00229.2302` | Longitude NMEA format `DDDmm.mmmm` |
| `E/W` | `E` | Est/Ouest |
| `Q` | `1` | Qualité fix : 1 = GPS valide |
| `Sat` | `00` | Nombre de satellites (souvent 0 dans ces fichiers) |
| `HDOP` | `00.00` | Précision horizontale (souvent 0) |
| `Alt` | `0.0` | Altitude MSL en mètres (toujours 0 dans ces fichiers) |
| `*checksum` | `*4b` | Checksum XOR NMEA |

#### `$GPRMC` — Position, vitesse, cap et date

```
$GPRMC,HHMMSS,Status,Lat,N/S,Lon,E/W,Speed,Course,DDMMYY,MagDec,*checksum
```

| Champ | Exemple | Description |
|---|---|---|
| `HHMMSS` | `053703` | Heure UTC |
| `Status` | `A` | `A` = Active (fix valide), `V` = Void (fix invalide) |
| `Lat` | `4850.3813` | Latitude NMEA |
| `N/S` | `N` | Hémisphère |
| `Lon` | `00229.2302` | Longitude NMEA |
| `E/W` | `E` | Est/Ouest |
| `Speed` | `000.0` | Vitesse en nœuds (souvent 0) |
| `Course` | `000.0` | Cap en degrés vrais (souvent 0) |
| `DDMMYY` | `240626` | Date : 24 juin 2026 |
| `*checksum` | `*11` | Checksum XOR NMEA |

### Exemple complet

```
@Olympus/+0200/+0200
$GPGGA,053703.1,4850.3813,N,00229.2302,E,1,00,00.00,0.0,M,0,M,0,*4b
$GPRMC,053703,A,4850.3813,N,00229.2302,E,000.0,000.0,240626,00,*11
$GPGGA,053816.5,4850.3845,N,00229.2252,E,1,00,00.00,0.0,M,0,M,0,*43
$GPRMC,053816,A,4850.3845,N,00229.2252,E,000.0,000.0,240626,00,*1d
```

### Conversion en coordonnées décimales

Les coordonnées NMEA sont au format `DDmm.mmmm` (degrés + minutes décimales) :

```
Degrés décimaux = D + mm.mmmm / 60
```

Exemples :
- `4850.3813,N` → `48 + 50.3813/60` = **48.839688° N**
- `00229.2302,E` → `2 + 29.2302/60` = **2.487170° E**
- `00205.9767,W` → `-(2 + 05.9767/60)` = **-2.099611°** (W = négatif)

### Reconstruction du timestamp ISO 8601

La **date** est uniquement dans `$GPRMC` (champ `DDMMYY`), l'**heure** dans les deux sentences.
Il faut croiser les deux lignes d'une même paire :

```
DDMMYY = "240626"  → 2026-06-24
HHMMSS = "053703"  → 05:37:03Z (UTC)
→ ISO 8601 : "2026-06-24T05:37:03Z"
```

### Fréquence d'échantillonnage

La cadence est **irrégulière** : l'enregistrement est déclenché par le mouvement de l'appareil
(ou manuellement), pas à intervalle fixe. Les intervalles observés vont de quelques secondes
à plusieurs dizaines de minutes.

### Champs à ignorer

Dans tous les fichiers analysés, les champs suivants sont systématiquement à zéro et inutilisables :
altitude, HDOP, nombre de satellites, vitesse, cap. Seuls **lat, lon et datetime** sont fiables.

---

## Fichier .SNS — Capteurs internes (non utilisé)

Le fichier `.SNS` contient des mesures des capteurs embarqués de l'appareil photo (baromètre,
hygromètre, thermomètre, accéléromètre, boussole) au format de sentences propriétaires Olympus
(`$OLTIM`, `$OLPRE`, `$OLTMP`, `$OLACC`, `$OLCMP`). Il ne contient **aucune coordonnée GPS**.
Ses timestamps sont en heure locale (contrairement au `.LOG` qui est en UTC). Il n'est pas utilisé
par TiPhotoLocator car le géotagging repose exclusivement sur les coordonnées lat/lon fournies
par le seul fichier `.LOG`.
