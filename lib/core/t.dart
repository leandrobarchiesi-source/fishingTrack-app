import 'app_settings.dart';

class T {
  static String _tr({
    required String it,
    required String en,
    required String fr,
    required String es,
  }) {
    switch (AppSettings.language) {
      case 'en':
        return en;
      case 'fr':
        return fr;
      case 'es':
        return es;
      default:
        return it;
    }
  }

  // DASHBOARD

  static String get sessions => _tr(
        it: 'Sessioni',
        en: 'Sessions',
        fr: 'Sessions',
        es: 'Sesiones',
      );

  static String get spots => _tr(
        it: 'Spot',
        en: 'Spots',
        fr: 'Spots',
        es: 'Lugares',
      );

  static String get cloud => _tr(
        it: 'Cloud',
        en: 'Cloud',
        fr: 'Cloud',
        es: 'Cloud',
      );

  static String get newSession => _tr(
        it: 'Nuova Sessione',
        en: 'New Session',
        fr: 'Nouvelle Session',
        es: 'Nueva Sesión',
      );

  // LOGIN

  static String get login => _tr(
        it: 'Login',
        en: 'Login',
        fr: 'Connexion',
        es: 'Acceso',
      );

  static String get register => _tr(
        it: 'Registrati',
        en: 'Register',
        fr: 'Inscription',
        es: 'Registrarse',
      );

  static String get email => _tr(
        it: 'Email',
        en: 'Email',
        fr: 'Email',
        es: 'Email',
      );

  static String get password => _tr(
        it: 'Password',
        en: 'Password',
        fr: 'Mot de passe',
        es: 'Contraseña',
      );

  // SESSIONI

  static String get location => _tr(
        it: 'Luogo',
        en: 'Location',
        fr: 'Lieu',
        es: 'Lugar',
      );

  static String get fishingType => _tr(
        it: 'Tipo pescata',
        en: 'Fishing type',
        fr: 'Type de pêche',
        es: 'Tipo de pesca',
      );

  static String get notes => _tr(
        it: 'Note',
        en: 'Notes',
        fr: 'Notes',
        es: 'Notas',
      );

  static String get save => _tr(
        it: 'Salva',
        en: 'Save',
        fr: 'Enregistrer',
        es: 'Guardar',
      );

  static String get waterTemperature => _tr(
        it: 'Temperatura acqua',
        en: 'Water temperature',
        fr: 'Température de l’eau',
        es: 'Temperatura del agua',
      );

  static String get airTemperature => _tr(
        it: 'Temperatura aria',
        en: 'Air temperature',
        fr: 'Température de l’air',
        es: 'Temperatura del aire',
      );

  // PROFILO

  static String get language => _tr(
        it: 'Lingua',
        en: 'Language',
        fr: 'Langue',
        es: 'Idioma',
      );

  static String get logout => _tr(
        it: 'Logout',
        en: 'Logout',
        fr: 'Déconnexion',
        es: 'Cerrar sesión',
      );

  // MENU

  static String get settings => _tr(
        it: 'Impostazioni',
        en: 'Settings',
        fr: 'Paramètres',
        es: 'Configuración',
      );

  static String get statistics => _tr(
        it: 'Statistiche',
        en: 'Statistics',
        fr: 'Statistiques',
        es: 'Estadísticas',
      );

  static String get recentSessions => _tr(
        it: 'Sessioni recenti',
        en: 'Recent Sessions',
        fr: 'Sessions récentes',
        es: 'Sesiones recientes',
      );

  static String sessionType(String tipo) {
    switch (AppSettings.language) {
      case 'en':
        switch (tipo) {
          case 'Gara':
            return 'Competition';
          case 'Test-match':
            return 'Test Match';
          case 'Pool':
            return 'Pool';
          case 'Prova':
            return 'Practice';
          case 'Libera':
            return 'Free Session';
          default:
            return tipo;
        }

      case 'fr':
        switch (tipo) {
          case 'Gara':
            return 'Compétition';
          case 'Test-match':
            return 'Match test';
          case 'Pool':
            return 'Pool';
          case 'Prova':
            return 'Entraînement';
          case 'Libera':
            return 'Session libre';
          default:
            return tipo;
        }

      case 'es':
        switch (tipo) {
          case 'Gara':
            return 'Competición';
          case 'Test-match':
            return 'Partido de prueba';
          case 'Pool':
            return 'Pool';
          case 'Prova':
            return 'Entrenamiento';
          case 'Libera':
            return 'Sesión libre';
          default:
            return tipo;
        }

      default:
        return tipo;
    }
  }

  static String get profile => _tr(
        it: 'Profilo',
        en: 'Profile',
        fr: 'Profil',
        es: 'Perfil',
      );

  static String get firstName => _tr(
        it: 'Nome',
        en: 'First Name',
        fr: 'Prénom',
        es: 'Nombre',
      );

  static String get lastName => _tr(
        it: 'Cognome',
        en: 'Last Name',
        fr: 'Nom',
        es: 'Apellido',
      );

  static String get saveProfile => _tr(
        it: 'Salva profilo',
        en: 'Save Profile',
        fr: 'Enregistrer le profil',
        es: 'Guardar perfil',
      );

  static String get changePassword => _tr(
        it: 'Cambia password',
        en: 'Change Password',
        fr: 'Changer le mot de passe',
        es: 'Cambiar contraseña',
      );

  static String get profileUpdated => _tr(
        it: 'Profilo aggiornato',
        en: 'Profile updated',
        fr: 'Profil mis à jour',
        es: 'Perfil actualizado',
      );

  static String get onlineOnlyProfile => _tr(
        it: 'Profilo modificabile solo online',
        en: 'Profile can only be edited online',
        fr: 'Le profil ne peut être modifié qu’en ligne',
        es: 'El perfil solo puede modificarse en línea',
      );


  static String get newPassword => _tr(
        it: 'Nuova password',
        en: 'New Password',
        fr: 'Nouveau mot de passe',
        es: 'Nueva contraseña',
      );

  static String get cancel => _tr(
        it: 'Annulla',
        en: 'Cancel',
        fr: 'Annuler',
        es: 'Cancelar',
      );

  static String get minimum6Chars => _tr(
        it: 'Minimo 6 caratteri',
        en: 'Minimum 6 characters',
        fr: 'Minimum 6 caractères',
        es: 'Mínimo 6 caracteres',
      );

  static String get passwordUpdated => _tr(
        it: 'Password aggiornata',
        en: 'Password updated',
        fr: 'Mot de passe mis à jour',
        es: 'Contraseña actualizada',
      );

  static String get editSession => _tr(
        it: 'Modifica Sessione',
        en: 'Edit Session',
        fr: 'Modifier la session',
        es: 'Editar sesión',
      );

  static String get useCurrentLocation => _tr(
        it: 'Usa posizione attuale',
        en: 'Use current location',
        fr: 'Utiliser la position actuelle',
        es: 'Usar ubicación actual',
      );

  static String get selectFromMap => _tr(
        it: 'Seleziona da mappa',
        en: 'Select from map',
        fr: 'Sélectionner sur la carte',
        es: 'Seleccionar desde mapa',
      );

  static String get selectFromList => _tr(
        it: 'Seleziona da lista',
        en: 'Select from list',
        fr: 'Sélectionner depuis la liste',
        es: 'Seleccionar desde la lista',
      );

  static String get date => _tr(
        it: 'Data',
        en: 'Date',
        fr: 'Date',
        es: 'Fecha',
      );

  static String get startTime => _tr(
        it: 'Ora inizio',
        en: 'Start time',
        fr: 'Heure de début',
        es: 'Hora de inicio',
      );

  static String get endTime => _tr(
        it: 'Ora fine',
        en: 'End time',
        fr: 'Heure de fin',
        es: 'Hora de finalización',
      );

  static String get saveSession => _tr(
        it: 'Salva Sessione',
        en: 'Save Session',
        fr: 'Enregistrer la session',
        es: 'Guardar sesión',
      );

  static String get saveChanges => _tr(
        it: 'Salva Modifiche',
        en: 'Save Changes',
        fr: 'Enregistrer les modifications',
        es: 'Guardar cambios',
      );

  static String get enterLocation => _tr(
        it: 'Inserisci luogo',
        en: 'Enter location',
        fr: 'Saisissez un lieu',
        es: 'Introduzca una ubicación',
      );

  static String get gpsDisabled => _tr(
        it: 'GPS disattivato',
        en: 'GPS disabled',
        fr: 'GPS désactivé',
        es: 'GPS desactivado',
      );

  static String moonPhase(String fase) {
    final f = fase.toLowerCase();

    switch (AppSettings.language) {
      case 'en':
        if (f.contains('luna nuova')) {
          return '🌑 New Moon';
        }

        if (f.contains('luna crescente')) {
          return '🌒 Waxing Crescent';
        }

        if (f.contains('primo quarto')) {
          return '🌓 First Quarter';
        }

        if (f.contains('gibbosa crescente')) {
          return '🌔 Waxing Gibbous';
        }

        if (f.contains('luna piena')) {
          return '🌕 Full Moon';
        }

        if (f.contains('gibbosa calante')) {
          return '🌖 Waning Gibbous';
        }

        if (f.contains('ultimo quarto')) {
          return '🌗 Last Quarter';
        }

        if (f.contains('luna calante')) {
          return '🌘 Waning Crescent';
        }

        return fase;

      case 'fr':
        if (f.contains('luna nuova')) {
          return '🌑 Nouvelle lune';
        }

        if (f.contains('luna crescente')) {
          return '🌒 Premier croissant';
        }

        if (f.contains('primo quarto')) {
          return '🌓 Premier quartier';
        }

        if (f.contains('gibbosa crescente')) {
          return '🌔 Gibbeuse croissante';
        }

        if (f.contains('luna piena')) {
          return '🌕 Pleine lune';
        }

        if (f.contains('gibbosa calante')) {
          return '🌖 Gibbeuse décroissante';
        }

        if (f.contains('ultimo quarto')) {
          return '🌗 Dernier quartier';
        }

        if (f.contains('luna calante')) {
          return '🌘 Dernier croissant';
        }

        return fase;

      case 'es':
        if (f.contains('luna nuova')) {
          return '🌑 Luna nueva';
        }

        if (f.contains('luna crescente')) {
          return '🌒 Luna creciente';
        }

        if (f.contains('primo quarto')) {
          return '🌓 Cuarto creciente';
        }

        if (f.contains('gibbosa crescente')) {
          return '🌔 Gibosa creciente';
        }

        if (f.contains('luna piena')) {
          return '🌕 Luna llena';
        }

        if (f.contains('gibbosa calante')) {
          return '🌖 Gibosa menguante';
        }

        if (f.contains('ultimo quarto')) {
          return '🌗 Cuarto menguante';
        }

        if (f.contains('luna calante')) {
          return '🌘 Luna menguante';
        }

        return fase;

      default:
        return fase;
    }
  }

  static String get sessionSummary => _tr(
        it: 'Riepilogo Sessione',
        en: 'Session Summary',
        fr: 'Résumé de la session',
        es: 'Resumen de la sesión',
      );

  static String get duration => _tr(
        it: 'Durata',
        en: 'Duration',
        fr: 'Durée',
        es: 'Duración',
      );

  static String get coordinates => _tr(
        it: 'Coordinate',
        en: 'Coordinates',
        fr: 'Coordonnées',
        es: 'Coordenadas',
      );

  static String get openInMaps => _tr(
        it: 'Apri in Maps',
        en: 'Open in Maps',
        fr: 'Ouvrir dans Maps',
        es: 'Abrir en Maps',
      );

  static String get weather => _tr(
        it: 'Meteo',
        en: 'Weather',
        fr: 'Météo',
        es: 'Tiempo',
      );

  static String get deleteSession => _tr(
        it: 'Elimina Sessione',
        en: 'Delete Session',
        fr: 'Supprimer la session',
        es: 'Eliminar sesión',
      );

  static String get deleteSessionQuestion => _tr(
        it: 'Vuoi eliminare questa sessione?',
        en: 'Do you want to delete this session?',
        fr: 'Voulez-vous supprimer cette session ?',
        es: '¿Desea eliminar esta sesión?',
      );

  static String get delete => _tr(
        it: 'Elimina',
        en: 'Delete',
        fr: 'Supprimer',
        es: 'Eliminar',
      );

  static String weatherCondition(String condition) {
    switch (AppSettings.language) {
      case 'en':
        switch (condition) {
          case 'Sereno':
            return 'Clear';
          case 'Poco nuvoloso':
            return 'Partly Cloudy';
          case 'Coperto':
            return 'Overcast';
          case 'Nebbia':
            return 'Fog';
          case 'Pioggia':
            return 'Rain';
          case 'Temporali':
            return 'Thunderstorms';
          case 'Variabile':
            return 'Variable';
          default:
            return condition;
        }

      case 'fr':
        switch (condition) {
          case 'Sereno':
            return 'Dégagé';
          case 'Poco nuvoloso':
            return 'Partiellement nuageux';
          case 'Coperto':
            return 'Couvert';
          case 'Nebbia':
            return 'Brouillard';
          case 'Pioggia':
            return 'Pluie';
          case 'Temporali':
            return 'Orages';
          case 'Variabile':
            return 'Variable';
          default:
            return condition;
        }

      case 'es':
        switch (condition) {
          case 'Sereno':
            return 'Despejado';
          case 'Poco nuvoloso':
            return 'Parcialmente nublado';
          case 'Coperto':
            return 'Cubierto';
          case 'Nebbia':
            return 'Niebla';
          case 'Pioggia':
            return 'Lluvia';
          case 'Temporali':
            return 'Tormentas';
          case 'Variabile':
            return 'Variable';
          default:
            return condition;
        }

      default:
        return condition;
    }
  }

  static String get edit => _tr(
        it: 'Modifica',
        en: 'Edit',
        fr: 'Modifier',
        es: 'Editar',
      );

  static String get spotDeleted => _tr(
        it: 'Spot eliminato',
        en: 'Spot deleted',
        fr: 'Spot supprimé',
        es: 'Spot eliminado',
      );

  static String get deleteSpot => _tr(
        it: 'Elimina Spot',
        en: 'Delete Spot',
        fr: 'Supprimer le spot',
        es: 'Eliminar lugar',
      );

  static String get deleteSpotQuestion => _tr(
        it: 'Vuoi eliminare questo spot?',
        en: 'Do you want to delete this spot?',
        fr: 'Voulez-vous supprimer ce spot ?',
        es: '¿Desea eliminar este lugar?',
      );

  static String spotLinkedSessions(int count) => _tr(
        it: 'Impossibile eliminare lo spot ($count sessioni collegate)',
        en: 'Cannot delete spot ($count linked sessions)',
        fr: 'Impossible de supprimer le spot ($count sessions liées)',
        es: 'No se puede eliminar el lugar ($count sesiones vinculadas)',
      );

 static String get selectSpot => _tr(
      it: 'Seleziona Spot',
      en: 'Select Spot',
      fr: 'Sélectionner un spot',
      es: 'Seleccionar lugar',
    );

static String get editSpot => _tr(
      it: 'Modifica Spot',
      en: 'Edit Spot',
      fr: 'Modifier le spot',
      es: 'Editar lugar',
    );

static String get spotName => _tr(
      it: 'Nome',
      en: 'Name',
      fr: 'Nom',
      es: 'Nombre',
    );

static String get latitude => _tr(
      it: 'Lat',
      en: 'Lat',
      fr: 'Lat',
      es: 'Lat',
    );

static String get longitude => _tr(
      it: 'Lon',
      en: 'Lon',
      fr: 'Lon',
      es: 'Lon',
    );

static String get spotAlreadyExists => _tr(
      it: 'Spot già esistente',
      en: 'Existing spot',
      fr: 'Spot existant',
      es: 'Punto ya existente',
    );

static String get createNewSpot => _tr(
      it: 'Crea nuovo',
      en: 'Create new',
      fr: 'Créer un nouveau',
      es: 'Crear nuevo',
    );

static String get useExistingSpot => _tr(
      it: 'Usa questo',
      en: 'Use this',
      fr: 'Utiliser celui-ci',
      es: 'Usar este',
    );

static String get searchingPosition => _tr(
      it: 'Ricerca posizione...',
      en: 'Searching position...',
      fr: 'Recherche de la position...',
      es: 'Buscando ubicación...',
    );

static String get noNearbySpot => _tr(
      it: 'Nessuno spot trovato nelle vicinanze',
      en: 'No nearby spot found',
      fr: 'Aucun spot trouvé à proximité',
      es: 'No se encontró ningún punto cercano',
    );

static String get weatherUpdated => _tr(
      it: '🌤 Meteo aggiornato',
      en: '🌤 Weather updated',
      fr: '🌤 Météo mise à jour',
      es: '🌤 Tiempo actualizado',
    );

static String get updatingWeather => _tr(
      it: 'Aggiornamento meteo...',
      en: 'Updating weather...',
      fr: 'Mise à jour de la météo...',
      es: 'Actualizando el tiempo...',
    );

static String get foundSpot => _tr(
      it: 'Spot trovato',
      en: 'Spot found',
      fr: 'Spot trouvé',
      es: 'Punto encontrado',
    );


    static String get useExistingSpotQuestion => _tr(
      it: 'Vuoi utilizzare questo spot oppure crearne uno nuovo?',
      en: 'Do you want to use this spot or create a new one?',
      fr: 'Voulez-vous utiliser ce spot ou en créer un nouveau ?',
      es: '¿Desea utilizar este punto o crear uno nuevo?',
    );

static String distance(double meters) => _tr(
      it: '📏 Distanza: ${meters.toStringAsFixed(1)} m',
      en: '📏 Distance: ${meters.toStringAsFixed(1)} m',
      fr: '📏 Distance : ${meters.toStringAsFixed(1)} m',
      es: '📏 Distancia: ${meters.toStringAsFixed(1)} m',
    );

    static String accuracy(double meters) => _tr(
      it: 'Precisione: ${meters.toStringAsFixed(1)} m',
      en: 'Accuracy: ${meters.toStringAsFixed(1)} m',
      fr: 'Précision : ${meters.toStringAsFixed(1)} m',
      es: 'Precisión: ${meters.toStringAsFixed(1)} m',
    );

static String get positionFound => _tr(
      it: 'Posizione trovata',
      en: 'Position found',
      fr: 'Position trouvée',
      es: 'Posición encontrada',
    );

    static String gpsError(String error) => _tr(
      it: 'Errore GPS: $error',
      en: 'GPS error: $error',
      fr: 'Erreur GPS : $error',
      es: 'Error de GPS: $error',
    );

    static String get sync => _tr(
      it: 'Sincronizza',
      en: 'Sync',
      fr: 'Synchroniser',
      es: 'Sincronizar',
    );

static String get offlineMode => _tr(
  it: 'Modalità offline',
  en: 'Offline mode',
  fr: 'Mode hors ligne',
  es: 'Modo sin conexión',
);

static String get profileViewOnlyOffline => _tr(
  it: 'Il profilo può essere visualizzato ma non modificato.',
  en: 'The profile can be viewed but cannot be edited.',
  fr: 'Le profil peut être consulté mais ne peut pas être modifié.',
  es: 'El perfil puede visualizarse, pero no modificarse.',
);

static String get status => _tr(
  it: 'Stato',
  en: 'Status',
  fr: 'État',
  es: 'Estado',
);

static String get online => _tr(
  it: 'Connesso',
  en: 'Online',
  fr: 'Connecté',
  es: 'Conectado',
);

static String get offline => _tr(
  it: 'Offline',
  en: 'Offline',
  fr: 'Hors ligne',
  es: 'Sin conexión',
);

static String get lastSync => _tr(
  it: 'Ultima sincronizzazione',
  en: 'Last synchronization',
  fr: 'Dernière synchronisation',
  es: 'Última sincronización',
);

static String get never => _tr(
  it: 'Mai',
  en: 'Never',
  fr: 'Jamais',
  es: 'Nunca',
);

static String get version => _tr(
  it: 'Versione',
  en: 'Version',
  fr: 'Version',
  es: 'Versión',
);

static String get account => _tr(
  it: 'Account',
  en: 'Account',
  fr: 'Compte',
  es: 'Cuenta',
);

static String get information => _tr(
  it: 'Informazioni',
  en: 'Information',
  fr: 'Informations',
  es: 'Información',
);

static String get about => _tr(
  it: 'Informazioni',
  en: 'About',
  fr: 'Informations',
  es: 'Información',
);

static String get syncCompleted => _tr(
  it: "Sincronizzazione completata",
  en: "Synchronization completed",
  fr: "Synchronisation terminée",
  es: "Sincronización completada",
);

static String get noInternet => _tr(
  it: "Connessione Internet non disponibile.",
  en: "No Internet connection.",
  fr: "Connexion Internet indisponible.",
  es: "Conexión a Internet no disponible.",
);


static String get wind => _tr(
      it: 'Vento',
      en: 'Wind',
      fr: 'Vent',
      es: 'Viento',
    );

static String get pressure => _tr(
      it: 'Pressione',
      en: 'Pressure',
      fr: 'Pression',
      es: 'Presión',
    );

static String get catches => _tr(
      it: 'Catture',
      en: 'Catches',
      fr: 'Captures',
      es: 'Capturas',
    );

static String get species => _tr(
      it: 'Specie',
      en: 'Species',
      fr: 'Espèce',
      es: 'Especie',
    );

static String get addSpecies => _tr(
      it: 'Aggiungi specie',
      en: 'Add species',
      fr: 'Ajouter une espèce',
      es: 'Añadir especie',
    );

static String get sessionMode => _tr(
      it: 'Modalità sessione',
      en: 'Session mode',
      fr: 'Mode de session',
      es: 'Modo de sesión',
    );

static String get summaryMode => _tr(
      it: 'Riepilogo',
      en: 'Summary',
      fr: 'Résumé',
      es: 'Resumen',
    );

static String get liveMode => _tr(
      it: 'Live',
      en: 'Live',
      fr: 'Live',
      es: 'Live',
    );

static String get select => _tr(
      it: 'Seleziona...',
      en: 'Select...',
      fr: 'Sélectionner...',
      es: 'Seleccionar...',
    );

static String get startSession => _tr(
      it: 'Inizia sessione',
      en: 'Start session',
      fr: 'Démarrer la session',
      es: 'Iniciar sesión',
    );

static String get counter => _tr(
      it: 'Contatore',
      en: 'Counter',
      fr: 'Compteur',
      es: 'Contador',
    );

static String counterNumber(int number) => _tr(
      it: 'Contatore $number',
      en: 'Counter $number',
      fr: 'Compteur $number',
      es: 'Contador $number',
    );

    static String get liveSession => _tr(
      it: 'Sessione Live',
      en: 'Live Session',
      fr: 'Session Live',
      es: 'Sesión Live',
    );

static String get start => _tr(
      it: 'Start',
      en: 'Start',
      fr: 'Démarrer',
      es: 'Iniciar',
    );

static String get stop => _tr(
      it: 'Stop',
      en: 'Stop',
      fr: 'Arrêter',
      es: 'Detener',
    );

static String get cast => _tr(
      it: 'Lancio',
      en: 'Cast',
      fr: 'Lancer',
      es: 'Lanzamiento',
    );

static String get addCounter => _tr(
      it: 'Nuovo contatore',
      en: 'New counter',
      fr: 'Nouveau compteur',
      es: 'Nuevo contador',
    );

static String get totalFish => _tr(
      it: 'Pesci',
      en: 'Fish',
      fr: 'Poissons',
      es: 'Peces',
    );

static String get lastCatch => _tr(
  it: 'Ultima cattura',
  en: 'Last catch',
  fr: 'Dernière capture',
  es: 'Última captura',
);

static String get recovery => _tr(
      it: 'Recupero',
      en: 'Recovery',
      fr: 'Récupération',
      es: 'Recuperación',
    );

static String get off => _tr(
      it: 'OFF',
      en: 'OFF',
      fr: 'OFF',
      es: 'OFF',
    );

static String casts(int value) => _tr(
      it: 'Lanci ($value)',
      en: 'Casts ($value)',
      fr: 'Lancers ($value)',
      es: 'Lances ($value)',
    );

static String catchesCount(int value) => _tr(
      it: 'Catture ($value)',
      en: 'Catches ($value)',
      fr: 'Captures ($value)',
      es: 'Capturas ($value)',
    );

static String get endSession => _tr(
      it: 'Termina sessione',
      en: 'End session',
      fr: 'Terminer la session',
      es: 'Finalizar sesión',
    );

    static String get deleteCounter => _tr(
  it: 'Elimina contatore',
  en: 'Delete counter',
  fr: 'Supprimer le compteur',
  es: 'Eliminar contador',
);

static String deleteCounterQuestion(int number) => _tr(
  it: 'Eliminare il Contatore $number?',
  en: 'Delete Counter $number?',
  fr: 'Supprimer le compteur $number ?',
  es: '¿Eliminar el contador $number?',
);

static String get resumeSession => _tr(
  it: 'Riprendi sessione',
  en: 'Resume session',
  fr: 'Reprendre la session',
  es: 'Reanudar sesión',
);

static String get viewLog => _tr(
  it: 'Visualizza log',
  en: 'View log',
  fr: 'Voir le journal',
  es: 'Ver registro',
);

static String get editSpotAndNotes => _tr(
  it: 'Modifica spot e note',
  en: 'Edit spot and notes',
  fr: 'Modifier le spot et les notes',
  es: 'Editar punto y notas',
);

}
