// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FishingSessionsTable extends FishingSessions
    with TableInfo<$FishingSessionsTable, FishingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FishingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spotIdMeta = const VerificationMeta('spotId');
  @override
  late final GeneratedColumn<String> spotId = GeneratedColumn<String>(
      'spot_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _luogoMeta = const VerificationMeta('luogo');
  @override
  late final GeneratedColumn<String> luogo = GeneratedColumn<String>(
      'luogo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoPescataMeta =
      const VerificationMeta('tipoPescata');
  @override
  late final GeneratedColumn<String> tipoPescata = GeneratedColumn<String>(
      'tipo_pescata', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudineMeta =
      const VerificationMeta('latitudine');
  @override
  late final GeneratedColumn<double> latitudine = GeneratedColumn<double>(
      'latitudine', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudineMeta =
      const VerificationMeta('longitudine');
  @override
  late final GeneratedColumn<double> longitudine = GeneratedColumn<double>(
      'longitudine', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _oraInizioMeta =
      const VerificationMeta('oraInizio');
  @override
  late final GeneratedColumn<DateTime> oraInizio = GeneratedColumn<DateTime>(
      'ora_inizio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _oraFineMeta =
      const VerificationMeta('oraFine');
  @override
  late final GeneratedColumn<DateTime> oraFine = GeneratedColumn<DateTime>(
      'ora_fine', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _temperaturaMeta =
      const VerificationMeta('temperatura');
  @override
  late final GeneratedColumn<double> temperatura = GeneratedColumn<double>(
      'temperatura', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _temperaturaAcquaMeta =
      const VerificationMeta('temperaturaAcqua');
  @override
  late final GeneratedColumn<double> temperaturaAcqua = GeneratedColumn<double>(
      'temperatura_acqua', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ventoMeta = const VerificationMeta('vento');
  @override
  late final GeneratedColumn<String> vento = GeneratedColumn<String>(
      'vento', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pressioneMeta =
      const VerificationMeta('pressione');
  @override
  late final GeneratedColumn<double> pressione = GeneratedColumn<double>(
      'pressione', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _condizioniMeta =
      const VerificationMeta('condizioni');
  @override
  late final GeneratedColumn<String> condizioni = GeneratedColumn<String>(
      'condizioni', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _faseLunareMeta =
      const VerificationMeta('faseLunare');
  @override
  late final GeneratedColumn<String> faseLunare = GeneratedColumn<String>(
      'fase_lunare', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        spotId,
        luogo,
        tipoPescata,
        latitudine,
        longitudine,
        data,
        oraInizio,
        oraFine,
        note,
        temperatura,
        temperaturaAcqua,
        vento,
        pressione,
        condizioni,
        faseLunare,
        synced,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fishing_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<FishingSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('spot_id')) {
      context.handle(_spotIdMeta,
          spotId.isAcceptableOrUnknown(data['spot_id']!, _spotIdMeta));
    }
    if (data.containsKey('luogo')) {
      context.handle(
          _luogoMeta, luogo.isAcceptableOrUnknown(data['luogo']!, _luogoMeta));
    } else if (isInserting) {
      context.missing(_luogoMeta);
    }
    if (data.containsKey('tipo_pescata')) {
      context.handle(
          _tipoPescataMeta,
          tipoPescata.isAcceptableOrUnknown(
              data['tipo_pescata']!, _tipoPescataMeta));
    } else if (isInserting) {
      context.missing(_tipoPescataMeta);
    }
    if (data.containsKey('latitudine')) {
      context.handle(
          _latitudineMeta,
          latitudine.isAcceptableOrUnknown(
              data['latitudine']!, _latitudineMeta));
    }
    if (data.containsKey('longitudine')) {
      context.handle(
          _longitudineMeta,
          longitudine.isAcceptableOrUnknown(
              data['longitudine']!, _longitudineMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('ora_inizio')) {
      context.handle(_oraInizioMeta,
          oraInizio.isAcceptableOrUnknown(data['ora_inizio']!, _oraInizioMeta));
    } else if (isInserting) {
      context.missing(_oraInizioMeta);
    }
    if (data.containsKey('ora_fine')) {
      context.handle(_oraFineMeta,
          oraFine.isAcceptableOrUnknown(data['ora_fine']!, _oraFineMeta));
    } else if (isInserting) {
      context.missing(_oraFineMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('temperatura')) {
      context.handle(
          _temperaturaMeta,
          temperatura.isAcceptableOrUnknown(
              data['temperatura']!, _temperaturaMeta));
    }
    if (data.containsKey('temperatura_acqua')) {
      context.handle(
          _temperaturaAcquaMeta,
          temperaturaAcqua.isAcceptableOrUnknown(
              data['temperatura_acqua']!, _temperaturaAcquaMeta));
    }
    if (data.containsKey('vento')) {
      context.handle(
          _ventoMeta, vento.isAcceptableOrUnknown(data['vento']!, _ventoMeta));
    }
    if (data.containsKey('pressione')) {
      context.handle(_pressioneMeta,
          pressione.isAcceptableOrUnknown(data['pressione']!, _pressioneMeta));
    }
    if (data.containsKey('condizioni')) {
      context.handle(
          _condizioniMeta,
          condizioni.isAcceptableOrUnknown(
              data['condizioni']!, _condizioniMeta));
    }
    if (data.containsKey('fase_lunare')) {
      context.handle(
          _faseLunareMeta,
          faseLunare.isAcceptableOrUnknown(
              data['fase_lunare']!, _faseLunareMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FishingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FishingSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      spotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spot_id']),
      luogo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}luogo'])!,
      tipoPescata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_pescata'])!,
      latitudine: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitudine']),
      longitudine: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitudine']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
      oraInizio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ora_inizio'])!,
      oraFine: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ora_fine'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      temperatura: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temperatura']),
      temperaturaAcqua: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}temperatura_acqua']),
      vento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vento']),
      pressione: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pressione']),
      condizioni: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condizioni']),
      faseLunare: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fase_lunare']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FishingSessionsTable createAlias(String alias) {
    return $FishingSessionsTable(attachedDatabase, alias);
  }
}

class FishingSession extends DataClass implements Insertable<FishingSession> {
  final String id;
  final String userId;
  final String? spotId;
  final String luogo;
  final String tipoPescata;
  final double? latitudine;
  final double? longitudine;
  final DateTime data;
  final DateTime oraInizio;
  final DateTime oraFine;
  final String? note;
  final double? temperatura;
  final double? temperaturaAcqua;
  final String? vento;
  final double? pressione;
  final String? condizioni;
  final String? faseLunare;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FishingSession(
      {required this.id,
      required this.userId,
      this.spotId,
      required this.luogo,
      required this.tipoPescata,
      this.latitudine,
      this.longitudine,
      required this.data,
      required this.oraInizio,
      required this.oraFine,
      this.note,
      this.temperatura,
      this.temperaturaAcqua,
      this.vento,
      this.pressione,
      this.condizioni,
      this.faseLunare,
      required this.synced,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || spotId != null) {
      map['spot_id'] = Variable<String>(spotId);
    }
    map['luogo'] = Variable<String>(luogo);
    map['tipo_pescata'] = Variable<String>(tipoPescata);
    if (!nullToAbsent || latitudine != null) {
      map['latitudine'] = Variable<double>(latitudine);
    }
    if (!nullToAbsent || longitudine != null) {
      map['longitudine'] = Variable<double>(longitudine);
    }
    map['data'] = Variable<DateTime>(data);
    map['ora_inizio'] = Variable<DateTime>(oraInizio);
    map['ora_fine'] = Variable<DateTime>(oraFine);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || temperatura != null) {
      map['temperatura'] = Variable<double>(temperatura);
    }
    if (!nullToAbsent || temperaturaAcqua != null) {
      map['temperatura_acqua'] = Variable<double>(temperaturaAcqua);
    }
    if (!nullToAbsent || vento != null) {
      map['vento'] = Variable<String>(vento);
    }
    if (!nullToAbsent || pressione != null) {
      map['pressione'] = Variable<double>(pressione);
    }
    if (!nullToAbsent || condizioni != null) {
      map['condizioni'] = Variable<String>(condizioni);
    }
    if (!nullToAbsent || faseLunare != null) {
      map['fase_lunare'] = Variable<String>(faseLunare);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FishingSessionsCompanion toCompanion(bool nullToAbsent) {
    return FishingSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      spotId:
          spotId == null && nullToAbsent ? const Value.absent() : Value(spotId),
      luogo: Value(luogo),
      tipoPescata: Value(tipoPescata),
      latitudine: latitudine == null && nullToAbsent
          ? const Value.absent()
          : Value(latitudine),
      longitudine: longitudine == null && nullToAbsent
          ? const Value.absent()
          : Value(longitudine),
      data: Value(data),
      oraInizio: Value(oraInizio),
      oraFine: Value(oraFine),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      temperatura: temperatura == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatura),
      temperaturaAcqua: temperaturaAcqua == null && nullToAbsent
          ? const Value.absent()
          : Value(temperaturaAcqua),
      vento:
          vento == null && nullToAbsent ? const Value.absent() : Value(vento),
      pressione: pressione == null && nullToAbsent
          ? const Value.absent()
          : Value(pressione),
      condizioni: condizioni == null && nullToAbsent
          ? const Value.absent()
          : Value(condizioni),
      faseLunare: faseLunare == null && nullToAbsent
          ? const Value.absent()
          : Value(faseLunare),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FishingSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FishingSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      spotId: serializer.fromJson<String?>(json['spotId']),
      luogo: serializer.fromJson<String>(json['luogo']),
      tipoPescata: serializer.fromJson<String>(json['tipoPescata']),
      latitudine: serializer.fromJson<double?>(json['latitudine']),
      longitudine: serializer.fromJson<double?>(json['longitudine']),
      data: serializer.fromJson<DateTime>(json['data']),
      oraInizio: serializer.fromJson<DateTime>(json['oraInizio']),
      oraFine: serializer.fromJson<DateTime>(json['oraFine']),
      note: serializer.fromJson<String?>(json['note']),
      temperatura: serializer.fromJson<double?>(json['temperatura']),
      temperaturaAcqua: serializer.fromJson<double?>(json['temperaturaAcqua']),
      vento: serializer.fromJson<String?>(json['vento']),
      pressione: serializer.fromJson<double?>(json['pressione']),
      condizioni: serializer.fromJson<String?>(json['condizioni']),
      faseLunare: serializer.fromJson<String?>(json['faseLunare']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'spotId': serializer.toJson<String?>(spotId),
      'luogo': serializer.toJson<String>(luogo),
      'tipoPescata': serializer.toJson<String>(tipoPescata),
      'latitudine': serializer.toJson<double?>(latitudine),
      'longitudine': serializer.toJson<double?>(longitudine),
      'data': serializer.toJson<DateTime>(data),
      'oraInizio': serializer.toJson<DateTime>(oraInizio),
      'oraFine': serializer.toJson<DateTime>(oraFine),
      'note': serializer.toJson<String?>(note),
      'temperatura': serializer.toJson<double?>(temperatura),
      'temperaturaAcqua': serializer.toJson<double?>(temperaturaAcqua),
      'vento': serializer.toJson<String?>(vento),
      'pressione': serializer.toJson<double?>(pressione),
      'condizioni': serializer.toJson<String?>(condizioni),
      'faseLunare': serializer.toJson<String?>(faseLunare),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FishingSession copyWith(
          {String? id,
          String? userId,
          Value<String?> spotId = const Value.absent(),
          String? luogo,
          String? tipoPescata,
          Value<double?> latitudine = const Value.absent(),
          Value<double?> longitudine = const Value.absent(),
          DateTime? data,
          DateTime? oraInizio,
          DateTime? oraFine,
          Value<String?> note = const Value.absent(),
          Value<double?> temperatura = const Value.absent(),
          Value<double?> temperaturaAcqua = const Value.absent(),
          Value<String?> vento = const Value.absent(),
          Value<double?> pressione = const Value.absent(),
          Value<String?> condizioni = const Value.absent(),
          Value<String?> faseLunare = const Value.absent(),
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FishingSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        spotId: spotId.present ? spotId.value : this.spotId,
        luogo: luogo ?? this.luogo,
        tipoPescata: tipoPescata ?? this.tipoPescata,
        latitudine: latitudine.present ? latitudine.value : this.latitudine,
        longitudine: longitudine.present ? longitudine.value : this.longitudine,
        data: data ?? this.data,
        oraInizio: oraInizio ?? this.oraInizio,
        oraFine: oraFine ?? this.oraFine,
        note: note.present ? note.value : this.note,
        temperatura: temperatura.present ? temperatura.value : this.temperatura,
        temperaturaAcqua: temperaturaAcqua.present
            ? temperaturaAcqua.value
            : this.temperaturaAcqua,
        vento: vento.present ? vento.value : this.vento,
        pressione: pressione.present ? pressione.value : this.pressione,
        condizioni: condizioni.present ? condizioni.value : this.condizioni,
        faseLunare: faseLunare.present ? faseLunare.value : this.faseLunare,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FishingSession copyWithCompanion(FishingSessionsCompanion data) {
    return FishingSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      luogo: data.luogo.present ? data.luogo.value : this.luogo,
      tipoPescata:
          data.tipoPescata.present ? data.tipoPescata.value : this.tipoPescata,
      latitudine:
          data.latitudine.present ? data.latitudine.value : this.latitudine,
      longitudine:
          data.longitudine.present ? data.longitudine.value : this.longitudine,
      data: data.data.present ? data.data.value : this.data,
      oraInizio: data.oraInizio.present ? data.oraInizio.value : this.oraInizio,
      oraFine: data.oraFine.present ? data.oraFine.value : this.oraFine,
      note: data.note.present ? data.note.value : this.note,
      temperatura:
          data.temperatura.present ? data.temperatura.value : this.temperatura,
      temperaturaAcqua: data.temperaturaAcqua.present
          ? data.temperaturaAcqua.value
          : this.temperaturaAcqua,
      vento: data.vento.present ? data.vento.value : this.vento,
      pressione: data.pressione.present ? data.pressione.value : this.pressione,
      condizioni:
          data.condizioni.present ? data.condizioni.value : this.condizioni,
      faseLunare:
          data.faseLunare.present ? data.faseLunare.value : this.faseLunare,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FishingSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spotId: $spotId, ')
          ..write('luogo: $luogo, ')
          ..write('tipoPescata: $tipoPescata, ')
          ..write('latitudine: $latitudine, ')
          ..write('longitudine: $longitudine, ')
          ..write('data: $data, ')
          ..write('oraInizio: $oraInizio, ')
          ..write('oraFine: $oraFine, ')
          ..write('note: $note, ')
          ..write('temperatura: $temperatura, ')
          ..write('temperaturaAcqua: $temperaturaAcqua, ')
          ..write('vento: $vento, ')
          ..write('pressione: $pressione, ')
          ..write('condizioni: $condizioni, ')
          ..write('faseLunare: $faseLunare, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      spotId,
      luogo,
      tipoPescata,
      latitudine,
      longitudine,
      data,
      oraInizio,
      oraFine,
      note,
      temperatura,
      temperaturaAcqua,
      vento,
      pressione,
      condizioni,
      faseLunare,
      synced,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FishingSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.spotId == this.spotId &&
          other.luogo == this.luogo &&
          other.tipoPescata == this.tipoPescata &&
          other.latitudine == this.latitudine &&
          other.longitudine == this.longitudine &&
          other.data == this.data &&
          other.oraInizio == this.oraInizio &&
          other.oraFine == this.oraFine &&
          other.note == this.note &&
          other.temperatura == this.temperatura &&
          other.temperaturaAcqua == this.temperaturaAcqua &&
          other.vento == this.vento &&
          other.pressione == this.pressione &&
          other.condizioni == this.condizioni &&
          other.faseLunare == this.faseLunare &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FishingSessionsCompanion extends UpdateCompanion<FishingSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> spotId;
  final Value<String> luogo;
  final Value<String> tipoPescata;
  final Value<double?> latitudine;
  final Value<double?> longitudine;
  final Value<DateTime> data;
  final Value<DateTime> oraInizio;
  final Value<DateTime> oraFine;
  final Value<String?> note;
  final Value<double?> temperatura;
  final Value<double?> temperaturaAcqua;
  final Value<String?> vento;
  final Value<double?> pressione;
  final Value<String?> condizioni;
  final Value<String?> faseLunare;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FishingSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.spotId = const Value.absent(),
    this.luogo = const Value.absent(),
    this.tipoPescata = const Value.absent(),
    this.latitudine = const Value.absent(),
    this.longitudine = const Value.absent(),
    this.data = const Value.absent(),
    this.oraInizio = const Value.absent(),
    this.oraFine = const Value.absent(),
    this.note = const Value.absent(),
    this.temperatura = const Value.absent(),
    this.temperaturaAcqua = const Value.absent(),
    this.vento = const Value.absent(),
    this.pressione = const Value.absent(),
    this.condizioni = const Value.absent(),
    this.faseLunare = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FishingSessionsCompanion.insert({
    required String id,
    required String userId,
    this.spotId = const Value.absent(),
    required String luogo,
    required String tipoPescata,
    this.latitudine = const Value.absent(),
    this.longitudine = const Value.absent(),
    required DateTime data,
    required DateTime oraInizio,
    required DateTime oraFine,
    this.note = const Value.absent(),
    this.temperatura = const Value.absent(),
    this.temperaturaAcqua = const Value.absent(),
    this.vento = const Value.absent(),
    this.pressione = const Value.absent(),
    this.condizioni = const Value.absent(),
    this.faseLunare = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        luogo = Value(luogo),
        tipoPescata = Value(tipoPescata),
        data = Value(data),
        oraInizio = Value(oraInizio),
        oraFine = Value(oraFine),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FishingSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? spotId,
    Expression<String>? luogo,
    Expression<String>? tipoPescata,
    Expression<double>? latitudine,
    Expression<double>? longitudine,
    Expression<DateTime>? data,
    Expression<DateTime>? oraInizio,
    Expression<DateTime>? oraFine,
    Expression<String>? note,
    Expression<double>? temperatura,
    Expression<double>? temperaturaAcqua,
    Expression<String>? vento,
    Expression<double>? pressione,
    Expression<String>? condizioni,
    Expression<String>? faseLunare,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (spotId != null) 'spot_id': spotId,
      if (luogo != null) 'luogo': luogo,
      if (tipoPescata != null) 'tipo_pescata': tipoPescata,
      if (latitudine != null) 'latitudine': latitudine,
      if (longitudine != null) 'longitudine': longitudine,
      if (data != null) 'data': data,
      if (oraInizio != null) 'ora_inizio': oraInizio,
      if (oraFine != null) 'ora_fine': oraFine,
      if (note != null) 'note': note,
      if (temperatura != null) 'temperatura': temperatura,
      if (temperaturaAcqua != null) 'temperatura_acqua': temperaturaAcqua,
      if (vento != null) 'vento': vento,
      if (pressione != null) 'pressione': pressione,
      if (condizioni != null) 'condizioni': condizioni,
      if (faseLunare != null) 'fase_lunare': faseLunare,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FishingSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? spotId,
      Value<String>? luogo,
      Value<String>? tipoPescata,
      Value<double?>? latitudine,
      Value<double?>? longitudine,
      Value<DateTime>? data,
      Value<DateTime>? oraInizio,
      Value<DateTime>? oraFine,
      Value<String?>? note,
      Value<double?>? temperatura,
      Value<double?>? temperaturaAcqua,
      Value<String?>? vento,
      Value<double?>? pressione,
      Value<String?>? condizioni,
      Value<String?>? faseLunare,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FishingSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spotId: spotId ?? this.spotId,
      luogo: luogo ?? this.luogo,
      tipoPescata: tipoPescata ?? this.tipoPescata,
      latitudine: latitudine ?? this.latitudine,
      longitudine: longitudine ?? this.longitudine,
      data: data ?? this.data,
      oraInizio: oraInizio ?? this.oraInizio,
      oraFine: oraFine ?? this.oraFine,
      note: note ?? this.note,
      temperatura: temperatura ?? this.temperatura,
      temperaturaAcqua: temperaturaAcqua ?? this.temperaturaAcqua,
      vento: vento ?? this.vento,
      pressione: pressione ?? this.pressione,
      condizioni: condizioni ?? this.condizioni,
      faseLunare: faseLunare ?? this.faseLunare,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (spotId.present) {
      map['spot_id'] = Variable<String>(spotId.value);
    }
    if (luogo.present) {
      map['luogo'] = Variable<String>(luogo.value);
    }
    if (tipoPescata.present) {
      map['tipo_pescata'] = Variable<String>(tipoPescata.value);
    }
    if (latitudine.present) {
      map['latitudine'] = Variable<double>(latitudine.value);
    }
    if (longitudine.present) {
      map['longitudine'] = Variable<double>(longitudine.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (oraInizio.present) {
      map['ora_inizio'] = Variable<DateTime>(oraInizio.value);
    }
    if (oraFine.present) {
      map['ora_fine'] = Variable<DateTime>(oraFine.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (temperatura.present) {
      map['temperatura'] = Variable<double>(temperatura.value);
    }
    if (temperaturaAcqua.present) {
      map['temperatura_acqua'] = Variable<double>(temperaturaAcqua.value);
    }
    if (vento.present) {
      map['vento'] = Variable<String>(vento.value);
    }
    if (pressione.present) {
      map['pressione'] = Variable<double>(pressione.value);
    }
    if (condizioni.present) {
      map['condizioni'] = Variable<String>(condizioni.value);
    }
    if (faseLunare.present) {
      map['fase_lunare'] = Variable<String>(faseLunare.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FishingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spotId: $spotId, ')
          ..write('luogo: $luogo, ')
          ..write('tipoPescata: $tipoPescata, ')
          ..write('latitudine: $latitudine, ')
          ..write('longitudine: $longitudine, ')
          ..write('data: $data, ')
          ..write('oraInizio: $oraInizio, ')
          ..write('oraFine: $oraFine, ')
          ..write('note: $note, ')
          ..write('temperatura: $temperatura, ')
          ..write('temperaturaAcqua: $temperaturaAcqua, ')
          ..write('vento: $vento, ')
          ..write('pressione: $pressione, ')
          ..write('condizioni: $condizioni, ')
          ..write('faseLunare: $faseLunare, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpotsTable extends Spots with TableInfo<$SpotsTable, Spot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudineMeta =
      const VerificationMeta('latitudine');
  @override
  late final GeneratedColumn<double> latitudine = GeneratedColumn<double>(
      'latitudine', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudineMeta =
      const VerificationMeta('longitudine');
  @override
  late final GeneratedColumn<double> longitudine = GeneratedColumn<double>(
      'longitudine', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferitoMeta =
      const VerificationMeta('preferito');
  @override
  late final GeneratedColumn<bool> preferito = GeneratedColumn<bool>(
      'preferito', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("preferito" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        nome,
        latitudine,
        longitudine,
        note,
        preferito,
        synced,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spots';
  @override
  VerificationContext validateIntegrity(Insertable<Spot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('latitudine')) {
      context.handle(
          _latitudineMeta,
          latitudine.isAcceptableOrUnknown(
              data['latitudine']!, _latitudineMeta));
    }
    if (data.containsKey('longitudine')) {
      context.handle(
          _longitudineMeta,
          longitudine.isAcceptableOrUnknown(
              data['longitudine']!, _longitudineMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('preferito')) {
      context.handle(_preferitoMeta,
          preferito.isAcceptableOrUnknown(data['preferito']!, _preferitoMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Spot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Spot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      latitudine: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitudine']),
      longitudine: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitudine']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      preferito: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}preferito'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SpotsTable createAlias(String alias) {
    return $SpotsTable(attachedDatabase, alias);
  }
}

class Spot extends DataClass implements Insertable<Spot> {
  final String id;
  final String userId;
  final String nome;
  final double? latitudine;
  final double? longitudine;
  final String? note;
  final bool preferito;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Spot(
      {required this.id,
      required this.userId,
      required this.nome,
      this.latitudine,
      this.longitudine,
      this.note,
      required this.preferito,
      required this.synced,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || latitudine != null) {
      map['latitudine'] = Variable<double>(latitudine);
    }
    if (!nullToAbsent || longitudine != null) {
      map['longitudine'] = Variable<double>(longitudine);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['preferito'] = Variable<bool>(preferito);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SpotsCompanion toCompanion(bool nullToAbsent) {
    return SpotsCompanion(
      id: Value(id),
      userId: Value(userId),
      nome: Value(nome),
      latitudine: latitudine == null && nullToAbsent
          ? const Value.absent()
          : Value(latitudine),
      longitudine: longitudine == null && nullToAbsent
          ? const Value.absent()
          : Value(longitudine),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      preferito: Value(preferito),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Spot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Spot(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      nome: serializer.fromJson<String>(json['nome']),
      latitudine: serializer.fromJson<double?>(json['latitudine']),
      longitudine: serializer.fromJson<double?>(json['longitudine']),
      note: serializer.fromJson<String?>(json['note']),
      preferito: serializer.fromJson<bool>(json['preferito']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'nome': serializer.toJson<String>(nome),
      'latitudine': serializer.toJson<double?>(latitudine),
      'longitudine': serializer.toJson<double?>(longitudine),
      'note': serializer.toJson<String?>(note),
      'preferito': serializer.toJson<bool>(preferito),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Spot copyWith(
          {String? id,
          String? userId,
          String? nome,
          Value<double?> latitudine = const Value.absent(),
          Value<double?> longitudine = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? preferito,
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Spot(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        nome: nome ?? this.nome,
        latitudine: latitudine.present ? latitudine.value : this.latitudine,
        longitudine: longitudine.present ? longitudine.value : this.longitudine,
        note: note.present ? note.value : this.note,
        preferito: preferito ?? this.preferito,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Spot copyWithCompanion(SpotsCompanion data) {
    return Spot(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nome: data.nome.present ? data.nome.value : this.nome,
      latitudine:
          data.latitudine.present ? data.latitudine.value : this.latitudine,
      longitudine:
          data.longitudine.present ? data.longitudine.value : this.longitudine,
      note: data.note.present ? data.note.value : this.note,
      preferito: data.preferito.present ? data.preferito.value : this.preferito,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Spot(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nome: $nome, ')
          ..write('latitudine: $latitudine, ')
          ..write('longitudine: $longitudine, ')
          ..write('note: $note, ')
          ..write('preferito: $preferito, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, nome, latitudine, longitudine,
      note, preferito, synced, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Spot &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nome == this.nome &&
          other.latitudine == this.latitudine &&
          other.longitudine == this.longitudine &&
          other.note == this.note &&
          other.preferito == this.preferito &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SpotsCompanion extends UpdateCompanion<Spot> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> nome;
  final Value<double?> latitudine;
  final Value<double?> longitudine;
  final Value<String?> note;
  final Value<bool> preferito;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SpotsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nome = const Value.absent(),
    this.latitudine = const Value.absent(),
    this.longitudine = const Value.absent(),
    this.note = const Value.absent(),
    this.preferito = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpotsCompanion.insert({
    required String id,
    required String userId,
    required String nome,
    this.latitudine = const Value.absent(),
    this.longitudine = const Value.absent(),
    this.note = const Value.absent(),
    this.preferito = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        nome = Value(nome),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Spot> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? nome,
    Expression<double>? latitudine,
    Expression<double>? longitudine,
    Expression<String>? note,
    Expression<bool>? preferito,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nome != null) 'nome': nome,
      if (latitudine != null) 'latitudine': latitudine,
      if (longitudine != null) 'longitudine': longitudine,
      if (note != null) 'note': note,
      if (preferito != null) 'preferito': preferito,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? nome,
      Value<double?>? latitudine,
      Value<double?>? longitudine,
      Value<String?>? note,
      Value<bool>? preferito,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SpotsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nome: nome ?? this.nome,
      latitudine: latitudine ?? this.latitudine,
      longitudine: longitudine ?? this.longitudine,
      note: note ?? this.note,
      preferito: preferito ?? this.preferito,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (latitudine.present) {
      map['latitudine'] = Variable<double>(latitudine.value);
    }
    if (longitudine.present) {
      map['longitudine'] = Variable<double>(longitudine.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (preferito.present) {
      map['preferito'] = Variable<bool>(preferito.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpotsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nome: $nome, ')
          ..write('latitudine: $latitudine, ')
          ..write('longitudine: $longitudine, ')
          ..write('note: $note, ')
          ..write('preferito: $preferito, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FishingSessionsTable fishingSessions =
      $FishingSessionsTable(this);
  late final $SpotsTable spots = $SpotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fishingSessions, spots];
}

typedef $$FishingSessionsTableCreateCompanionBuilder = FishingSessionsCompanion
    Function({
  required String id,
  required String userId,
  Value<String?> spotId,
  required String luogo,
  required String tipoPescata,
  Value<double?> latitudine,
  Value<double?> longitudine,
  required DateTime data,
  required DateTime oraInizio,
  required DateTime oraFine,
  Value<String?> note,
  Value<double?> temperatura,
  Value<double?> temperaturaAcqua,
  Value<String?> vento,
  Value<double?> pressione,
  Value<String?> condizioni,
  Value<String?> faseLunare,
  Value<bool> synced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FishingSessionsTableUpdateCompanionBuilder = FishingSessionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> spotId,
  Value<String> luogo,
  Value<String> tipoPescata,
  Value<double?> latitudine,
  Value<double?> longitudine,
  Value<DateTime> data,
  Value<DateTime> oraInizio,
  Value<DateTime> oraFine,
  Value<String?> note,
  Value<double?> temperatura,
  Value<double?> temperaturaAcqua,
  Value<String?> vento,
  Value<double?> pressione,
  Value<String?> condizioni,
  Value<String?> faseLunare,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FishingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FishingSessionsTable> {
  $$FishingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spotId => $composableBuilder(
      column: $table.spotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get luogo => $composableBuilder(
      column: $table.luogo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoPescata => $composableBuilder(
      column: $table.tipoPescata, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get oraInizio => $composableBuilder(
      column: $table.oraInizio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get oraFine => $composableBuilder(
      column: $table.oraFine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get temperatura => $composableBuilder(
      column: $table.temperatura, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get temperaturaAcqua => $composableBuilder(
      column: $table.temperaturaAcqua,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vento => $composableBuilder(
      column: $table.vento, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pressione => $composableBuilder(
      column: $table.pressione, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condizioni => $composableBuilder(
      column: $table.condizioni, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get faseLunare => $composableBuilder(
      column: $table.faseLunare, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FishingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FishingSessionsTable> {
  $$FishingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spotId => $composableBuilder(
      column: $table.spotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get luogo => $composableBuilder(
      column: $table.luogo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoPescata => $composableBuilder(
      column: $table.tipoPescata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get oraInizio => $composableBuilder(
      column: $table.oraInizio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get oraFine => $composableBuilder(
      column: $table.oraFine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get temperatura => $composableBuilder(
      column: $table.temperatura, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get temperaturaAcqua => $composableBuilder(
      column: $table.temperaturaAcqua,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vento => $composableBuilder(
      column: $table.vento, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pressione => $composableBuilder(
      column: $table.pressione, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condizioni => $composableBuilder(
      column: $table.condizioni, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get faseLunare => $composableBuilder(
      column: $table.faseLunare, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FishingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FishingSessionsTable> {
  $$FishingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get spotId =>
      $composableBuilder(column: $table.spotId, builder: (column) => column);

  GeneratedColumn<String> get luogo =>
      $composableBuilder(column: $table.luogo, builder: (column) => column);

  GeneratedColumn<String> get tipoPescata => $composableBuilder(
      column: $table.tipoPescata, builder: (column) => column);

  GeneratedColumn<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => column);

  GeneratedColumn<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get oraInizio =>
      $composableBuilder(column: $table.oraInizio, builder: (column) => column);

  GeneratedColumn<DateTime> get oraFine =>
      $composableBuilder(column: $table.oraFine, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get temperatura => $composableBuilder(
      column: $table.temperatura, builder: (column) => column);

  GeneratedColumn<double> get temperaturaAcqua => $composableBuilder(
      column: $table.temperaturaAcqua, builder: (column) => column);

  GeneratedColumn<String> get vento =>
      $composableBuilder(column: $table.vento, builder: (column) => column);

  GeneratedColumn<double> get pressione =>
      $composableBuilder(column: $table.pressione, builder: (column) => column);

  GeneratedColumn<String> get condizioni => $composableBuilder(
      column: $table.condizioni, builder: (column) => column);

  GeneratedColumn<String> get faseLunare => $composableBuilder(
      column: $table.faseLunare, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FishingSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FishingSessionsTable,
    FishingSession,
    $$FishingSessionsTableFilterComposer,
    $$FishingSessionsTableOrderingComposer,
    $$FishingSessionsTableAnnotationComposer,
    $$FishingSessionsTableCreateCompanionBuilder,
    $$FishingSessionsTableUpdateCompanionBuilder,
    (
      FishingSession,
      BaseReferences<_$AppDatabase, $FishingSessionsTable, FishingSession>
    ),
    FishingSession,
    PrefetchHooks Function()> {
  $$FishingSessionsTableTableManager(
      _$AppDatabase db, $FishingSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FishingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FishingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FishingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> spotId = const Value.absent(),
            Value<String> luogo = const Value.absent(),
            Value<String> tipoPescata = const Value.absent(),
            Value<double?> latitudine = const Value.absent(),
            Value<double?> longitudine = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<DateTime> oraInizio = const Value.absent(),
            Value<DateTime> oraFine = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<double?> temperatura = const Value.absent(),
            Value<double?> temperaturaAcqua = const Value.absent(),
            Value<String?> vento = const Value.absent(),
            Value<double?> pressione = const Value.absent(),
            Value<String?> condizioni = const Value.absent(),
            Value<String?> faseLunare = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FishingSessionsCompanion(
            id: id,
            userId: userId,
            spotId: spotId,
            luogo: luogo,
            tipoPescata: tipoPescata,
            latitudine: latitudine,
            longitudine: longitudine,
            data: data,
            oraInizio: oraInizio,
            oraFine: oraFine,
            note: note,
            temperatura: temperatura,
            temperaturaAcqua: temperaturaAcqua,
            vento: vento,
            pressione: pressione,
            condizioni: condizioni,
            faseLunare: faseLunare,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> spotId = const Value.absent(),
            required String luogo,
            required String tipoPescata,
            Value<double?> latitudine = const Value.absent(),
            Value<double?> longitudine = const Value.absent(),
            required DateTime data,
            required DateTime oraInizio,
            required DateTime oraFine,
            Value<String?> note = const Value.absent(),
            Value<double?> temperatura = const Value.absent(),
            Value<double?> temperaturaAcqua = const Value.absent(),
            Value<String?> vento = const Value.absent(),
            Value<double?> pressione = const Value.absent(),
            Value<String?> condizioni = const Value.absent(),
            Value<String?> faseLunare = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FishingSessionsCompanion.insert(
            id: id,
            userId: userId,
            spotId: spotId,
            luogo: luogo,
            tipoPescata: tipoPescata,
            latitudine: latitudine,
            longitudine: longitudine,
            data: data,
            oraInizio: oraInizio,
            oraFine: oraFine,
            note: note,
            temperatura: temperatura,
            temperaturaAcqua: temperaturaAcqua,
            vento: vento,
            pressione: pressione,
            condizioni: condizioni,
            faseLunare: faseLunare,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FishingSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FishingSessionsTable,
    FishingSession,
    $$FishingSessionsTableFilterComposer,
    $$FishingSessionsTableOrderingComposer,
    $$FishingSessionsTableAnnotationComposer,
    $$FishingSessionsTableCreateCompanionBuilder,
    $$FishingSessionsTableUpdateCompanionBuilder,
    (
      FishingSession,
      BaseReferences<_$AppDatabase, $FishingSessionsTable, FishingSession>
    ),
    FishingSession,
    PrefetchHooks Function()>;
typedef $$SpotsTableCreateCompanionBuilder = SpotsCompanion Function({
  required String id,
  required String userId,
  required String nome,
  Value<double?> latitudine,
  Value<double?> longitudine,
  Value<String?> note,
  Value<bool> preferito,
  Value<bool> synced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SpotsTableUpdateCompanionBuilder = SpotsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> nome,
  Value<double?> latitudine,
  Value<double?> longitudine,
  Value<String?> note,
  Value<bool> preferito,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SpotsTableFilterComposer extends Composer<_$AppDatabase, $SpotsTable> {
  $$SpotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get preferito => $composableBuilder(
      column: $table.preferito, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SpotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpotsTable> {
  $$SpotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get preferito => $composableBuilder(
      column: $table.preferito, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SpotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpotsTable> {
  $$SpotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<double> get latitudine => $composableBuilder(
      column: $table.latitudine, builder: (column) => column);

  GeneratedColumn<double> get longitudine => $composableBuilder(
      column: $table.longitudine, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get preferito =>
      $composableBuilder(column: $table.preferito, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SpotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpotsTable,
    Spot,
    $$SpotsTableFilterComposer,
    $$SpotsTableOrderingComposer,
    $$SpotsTableAnnotationComposer,
    $$SpotsTableCreateCompanionBuilder,
    $$SpotsTableUpdateCompanionBuilder,
    (Spot, BaseReferences<_$AppDatabase, $SpotsTable, Spot>),
    Spot,
    PrefetchHooks Function()> {
  $$SpotsTableTableManager(_$AppDatabase db, $SpotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<double?> latitudine = const Value.absent(),
            Value<double?> longitudine = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> preferito = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpotsCompanion(
            id: id,
            userId: userId,
            nome: nome,
            latitudine: latitudine,
            longitudine: longitudine,
            note: note,
            preferito: preferito,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String nome,
            Value<double?> latitudine = const Value.absent(),
            Value<double?> longitudine = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> preferito = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SpotsCompanion.insert(
            id: id,
            userId: userId,
            nome: nome,
            latitudine: latitudine,
            longitudine: longitudine,
            note: note,
            preferito: preferito,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpotsTable,
    Spot,
    $$SpotsTableFilterComposer,
    $$SpotsTableOrderingComposer,
    $$SpotsTableAnnotationComposer,
    $$SpotsTableCreateCompanionBuilder,
    $$SpotsTableUpdateCompanionBuilder,
    (Spot, BaseReferences<_$AppDatabase, $SpotsTable, Spot>),
    Spot,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FishingSessionsTableTableManager get fishingSessions =>
      $$FishingSessionsTableTableManager(_db, _db.fishingSessions);
  $$SpotsTableTableManager get spots =>
      $$SpotsTableTableManager(_db, _db.spots);
}
