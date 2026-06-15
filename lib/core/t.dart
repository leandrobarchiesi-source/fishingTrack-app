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
}
