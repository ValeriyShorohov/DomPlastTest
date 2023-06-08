#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийОтражениеЗарплатыВБухучете.ОтражениеОценочныхОбязательств 
		ИЛИ НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, ПериодРегистрации) Тогда		
		ОборотПоПриобретеннымУслугамГПХВЦеляхНДС.Очистить();
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(НачисленнаяЗарплатаИВзносы);
	МассивТЧ.Добавить(УдержаннаяЗарплата);
	МассивТЧ.Добавить(ФизическиеЛица);
	МассивТЧ.Добавить(РегламентированныеУдержания);
	МассивТЧ.Добавить(ПеняПоВзносамИОтчислениям);
	МассивТЧ.Добавить(ОценочныеОбязательства);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналомСервер.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "ФизическоеЛицо");

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОтражениеЗарплатыВБухучете.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	//ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	Если ПараметрыПроведения.ТаблицаОтражениеВУчетеБУ.Количество() <> 0 
		И ПараметрыПроведения.ТаблицаОтражениеВУчетеНУ.Количество() <> 0 Тогда 
		
		ТаблицаПоБУ = ПараметрыПроведения.ТаблицаОтражениеВУчетеБУ;
		ТаблицаПоНУ = ПараметрыПроведения.ТаблицаОтражениеВУчетеНУ;
								
		// по БУ		
		СформироватьДвиженияПоОтражениюВУчетеВБУ(ПараметрыПроведения.Реквизиты, ТаблицаПоБУ, Движения, Отказ);		
		
		// по НУ		
		СформироватьДвиженияПоОтражениюВУчетеВНУ(ПараметрыПроведения.Реквизиты, ТаблицаПоНУ, Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ТаблицаОборотПоПриобретеннымУслугамГПХВЦеляхНДС.Количество() <> 0 Тогда
		СформироватьДвиженияПоОборотуПоПриобретеннымУслугамГПХВЦеляхНДС(ПараметрыПроведения.РеквизитыОборотПоПриобретеннымУслугамГПХВЦеляхНДС, ПараметрыПроведения.ТаблицаОборотПоПриобретеннымУслугамГПХВЦеляхНДС, Движения, Отказ);	
    КонецЕсли;
    
    Если ПараметрыПроведения.ВзаиморасчетыСПолучателямиИЛ.Количество() <> 0 Тогда 
        РеквизитыВзаиморасчетыСПолучателямиИЛ = ПараметрыПроведения.РеквизитыВзаиморасчетыСПолучателямиИЛ[0];
        // Взаиморасчеты с получателями ИЛ	
        ТаблицаВзаиморасчетыСПолучателямиИЛ = РасчетЗарплатыСервер.ПодготовитьТаблицуВзаиморасчеты(РеквизитыВзаиморасчетыСПолучателямиИЛ,
                                                                                                    ПараметрыПроведения.ВзаиморасчетыСПолучателямиИЛ,
                                                                                                    Движения.ВзаиморасчетыОрганизацийСПолучателямиИЛ.ВыгрузитьКолонки(),
                                                                                                    ВидДвиженияНакопления.Приход,
                                                                                                    Отказ);
        РасчетЗарплатыСервер.СформироватьДвижения(ТаблицаВзаиморасчетыСПолучателямиИЛ, 	"ВзаиморасчетыОрганизацийСПолучателямиИЛ",  Движения, Отказ);
    КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНУ, ПроверятьЗаполнениеКонтрагента",
													НачисленнаяЗарплатаИВзносы.Количество() > 0, ОборотПоПриобретеннымУслугамГПХВЦеляхНДС.Количество() > 0);

	НеобходимаПострочнаяПроверка = Ложь;
	Для Каждого КлючЗначение Из ПараметрыПострочнойПроверки Цикл
		Если КлючЗначение.Значение Тогда 
			НеобходимаПострочнаяПроверка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеобходимаПострочнаяПроверка Тогда 
		Если НачисленнаяЗарплатаИВзносы.Количество() > 0 Тогда
			ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Истина);
			ПроверитьЗаполнениеТабличнойЧастиПострочно(НачисленнаяЗарплатаИВзносы, "НачисленнаяЗарплатаИВзносы", Отказ, ПараметрыПострочнойПроверки);
		КонецЕсли;
		Если ПеняПоВзносамИОтчислениям.Количество() > 0 Тогда
			ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Истина);
			ПроверитьЗаполнениеТабличнойЧастиПострочно(ПеняПоВзносамИОтчислениям    ,     "ПеняПоВзносамИОтчислениям", Отказ, ПараметрыПострочнойПроверки);
		КонецЕсли;
		Если ОборотПоПриобретеннымУслугамГПХВЦеляхНДС.Количество() > 0 Тогда
			ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеКонтрагента", Истина);
			ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеДоговора", Истина);
			ПараметрыПострочнойПроверки.Вставить("ПроверятьАгентскийДоговор", Истина);
			ПроверитьЗаполнениеТабличнойЧастиПострочно(ОборотПоПриобретеннымУслугамГПХВЦеляхНДС, "ОборотПоПриобретеннымУслугамГПХВЦеляхНДС", Отказ, ПараметрыПострочнойПроверки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	ЗарплатаОтраженаВБухучете = Ложь;
	Бухгалтер = Справочники.Пользователи.ПустаяСсылка();
	Автор = Справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры  

Процедура СформироватьДвиженияПоОтражениюВУчетеВБУ(ТаблицаРеквизиты, ТаблицаОтражениеВУчете, Движения, Отказ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	ТаблицаФормированияПроводок = ТаблицаОтражениеВУчете;
	
	ВедениеУчетаПоСотрудникам = Реквизиты.ВедениеУчетаПоСотрудникам;
	Если НЕ ВедениеУчетаПоСотрудникам Тогда
		ТаблицаФормированияПроводок.Свернуть("ВидПлатежа, ВидОперации,  
											|СчетДт, СубконтоДт1, ДтВидСубконто1, СубконтоДт2, ДтВидСубконто2, СубконтоДт3, ДтВидСубконто3,
											|СчетКт, СубконтоКт1, КтВидСубконто1, СубконтоКт2, КтВидСубконто2, СубконтоКт3, КтВидСубконто3,
											|СтруктурноеПодразделение", "Сумма");
	КонецЕсли;
		
	Для Каждого СтрокаДанных Из ТаблицаФормированияПроводок Цикл

		// Формируем проводки 
		Если СтрокаДанных.Сумма <> 0 
			И ЗначениеЗаполнено(СтрокаДанных.СчетДт) 
			И СтрокаДанных.СчетДт <> ПредопределенноеЗначение("ПланСчетов.Типовой.ПустаяСсылка") Тогда
			
			Проводка = Движения.Типовой.Добавить();
			
			Проводка.Период      = Реквизиты.Период;
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Сумма       = СтрокаДанных.Сумма;
			
			// бухучет
			Проводка.СчетДт       = СтрокаДанных.СчетДт;
			Проводка.СчетКт       = СтрокаДанных.СчетКт;
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаДанных.СубконтоДт1);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаДанных.СубконтоДт2);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаДанных.СубконтоДт3);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаДанных.СубконтоКт1);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаДанных.СубконтоКт2);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтрокаДанных.СубконтоКт3);
	
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(Проводка, СтрокаДанных.СтруктурноеПодразделение, СтрокаДанных.СтруктурноеПодразделение);
			 				
			Если Проводка.СчетДт.Валютный Тогда
				Проводка.ВалютаДт = Реквизиты.ВалютаРеглУчета;
				Проводка.ВалютнаяСуммаДт = СтрокаДанных.Сумма;
			КонецЕсли;
			
			Если Проводка.СчетКт.Валютный Тогда
				Проводка.ВалютаКт 			= Реквизиты.ВалютаРеглУчета;
				Проводка.ВалютнаяСуммаКт 	= СтрокаДанных.Сумма;
			КонецЕсли;
			
		Иначе
			
			Если СтрокаДанных.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВОСМСДоходыСубъектаПредпринимательства
				ИЛИ СтрокаДанных.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ОПВДоходыСубъектаПредпринимательства
				ИЛИ СтрокаДанных.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ИПНДоходыСубъектаПредпринимательства Тогда
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для вида операции ""%1"" по физическому лицу %2 проводка не сформирована (не указан счет)'"), СтрокаДанных.ВидОперации, СтрокаДанных.ФизическоеЛицо);
				
				ОбщегоНазначенияБККлиентСервер.СообщитьОбОшибке(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЕсли;

	КонецЦикла;
	
	Движения.Типовой.Записать(Истина);

КонецПроцедуры

Процедура СформироватьДвиженияПоОтражениюВУчетеВНУ(ТаблицаРеквизиты, ТаблицаОтражениеВУчете, Движения, Отказ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	ТаблицаФормированияПроводок = ТаблицаОтражениеВУчете;
	
	ВедениеУчетаПоСотрудникам = Реквизиты.ВедениеУчетаПоСотрудникам;
	Если НЕ ВедениеУчетаПоСотрудникам Тогда
		ТаблицаФормированияПроводок.Свернуть("СчетДтНУ, СубконтоДтНУ1, ДтВидСубконтоНУ1, СубконтоДтНУ2, ДтВидСубконтоНУ2, СубконтоДтНУ3, ДтВидСубконтоНУ3,
											|СчетКтНУ, СубконтоКтНУ1, КтВидСубконтоНУ1, СубконтоКтНУ2, КтВидСубконтоНУ2, СубконтоКтНУ3, КтВидСубконтоНУ3,
											|СтруктурноеПодразделение, ВидУчетаДт, ВидУчетаКт", "Сумма");
	КонецЕсли;
	
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Дата);

	Для Каждого СтрокаДанных Из ТаблицаФормированияПроводок Цикл

		Если (ОрганизацияПлательщикНалогаНаПрибыль) И (ЗначениеЗаполнено(СтрокаДанных.СчетДтНУ) ИЛИ ЗначениеЗаполнено(СтрокаДанных.СчетКтНУ)) Тогда
			
			// Формируем проводки 
			Если СтрокаДанных.Сумма <> 0 
				И ЗначениеЗаполнено(СтрокаДанных.СчетДтНУ) 
				И СтрокаДанных.СчетДтНУ <> ПредопределенноеЗначение("ПланСчетов.Налоговый.ПустаяСсылка") Тогда
				
				ПроводкаНУ = Движения.Налоговый.Добавить();
				
				ПроводкаНУ.Период      = Реквизиты.Период;
				ПроводкаНУ.Организация = Реквизиты.Организация;
				ПроводкаНУ.Сумма       = СтрокаДанных.Сумма;
				
				// бухучет
				ПроводкаНУ.СчетДт       = СтрокаДанных.СчетДтНУ;
				ПроводкаНУ.СчетКт       = СтрокаДанных.СчетКтНУ;
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 1, СтрокаДанных.СубконтоДтНУ1);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 2, СтрокаДанных.СубконтоДтНУ2);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 3, СтрокаДанных.СубконтоДтНУ3);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 1, СтрокаДанных.СубконтоКтНУ1);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 2, СтрокаДанных.СубконтоКтНУ2);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 3, СтрокаДанных.СубконтоКтНУ3);
				ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ,  Справочники.ВидыУчетаНУ.НУ);
				
				// Заполнем уже известные виды учета
				Если ЗначениеЗаполнено(СтрокаДанных.ВидУчетаДт) Тогда
					ПроводкаНУ.ВидУчетаДт = СтрокаДанных.ВидУчетаДт;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаДанных.ВидУчетаКт) Тогда
					ПроводкаНУ.ВидУчетаКт = СтрокаДанных.ВидУчетаКт;
				КонецЕсли;

				ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(ПроводкаНУ, СтрокаДанных.СтруктурноеПодразделение, СтрокаДанных.СтруктурноеПодразделение);
		        			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.Налоговый.Записать(Истина);

КонецПроцедуры

Процедура СформироватьДвиженияПоОборотуПоПриобретеннымУслугамГПХВЦеляхНДС(ТаблицаРеквизиты, ТаблицаОборотПоПриобретеннымУслугамГПХВЦеляхНДС, Движения, Отказ)
	
	УчетНДСИАкциза.СформироватьДвиженияОтражениеЗарплатыВБухучете(ТаблицаОборотПоПриобретеннымУслугамГПХВЦеляхНДС,
			ТаблицаРеквизиты, Движения, Отказ);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата);

	Если ИмяТабличнойЧасти = "НачисленнаяЗарплатаИВзносы" Тогда
		СинонимТабличнойЧасти =  НСтр("ru = 'Начисленная зарплата и взносы'");
	ИначеЕсли ИмяТабличнойЧасти = "ПеняПоВзносамИОтчислениям" Тогда
		СинонимТабличнойЧасти =  НСтр("ru = 'Пеня по взносам и отчислениям'");
	ИначеЕсли ИмяТабличнойЧасти = "ОборотПоПриобретеннымУслугамГПХВЦеляхНДС" Тогда
		СинонимТабличнойЧасти =  НСтр("ru = 'Регистрация оборота НДС с доходов ГПХ'");
	КонецЕсли; 
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ИмяТабличнойЧасти <> "ОборотПоПриобретеннымУслугамГПХВЦеляхНДС" И ПараметрыПроверки <> Неопределено
			И ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СпособОтраженияЗарплатыВБухучете)
			И НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.СпособОтраженияЗарплатыВБухучете, "СчетБУ")) Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнен ""Счет учета (БУ)"" для ""Способа отражения"" в строке %1 списка ""%2""'");
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СпособОтраженияЗарплатыВБухучете";
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаТабличнойЧасти.НомерСтроки, СинонимТабличнойЧасти),
						ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

		Если ОрганизацияПлательщикНалогаНаПрибыль Тогда 
			Если ИмяТабличнойЧасти <> "ОборотПоПриобретеннымУслугамГПХВЦеляхНДС" И ПараметрыПроверки <> Неопределено
				И ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
				И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СпособОтраженияЗарплатыВБухучете)
				И ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.СпособОтраженияЗарплатыВБухучете, "СчетБУ"))
				И НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.СпособОтраженияЗарплатыВБухучете, "СчетНУ")) Тогда
				
				ТекстСообщения = НСтр("ru = 'Не заполнен ""Счет учета (НУ)"" для ""Способа отражения"" в строке %1 списка ""%2""'");
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СпособОтраженияЗарплатыВБухучете";
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,СтрокаТабличнойЧасти.НомерСтроки, СинонимТабличнойЧасти),
						ЭтотОбъект, Поле, "Объект", Отказ);

			КонецЕсли;
		КонецЕсли;

		Если ИмяТабличнойЧасти = "ОборотПоПриобретеннымУслугамГПХВЦеляхНДС" И ПараметрыПроверки <> Неопределено Тогда
			
			Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеКонтрагента") И ПараметрыПроверки.ПроверятьЗаполнениеКонтрагента
			И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Контрагент) Тогда
			
				ТекстСообщения = НСтр("ru = 'Не заполнен ""Контрагент"" в строке %1 списка ""%2""'");
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Контрагент";
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаТабличнойЧасти.НомерСтроки, СинонимТабличнойЧасти),
				ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеДоговора") И ПараметрыПроверки.ПроверятьЗаполнениеДоговора
			И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента) Тогда
			
				ТекстСообщения = НСтр("ru = 'Не заполнен ""Договор контрагента"" в строке %1 списка ""%2""'");
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорКонтрагента";
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаТабличнойЧасти.НомерСтроки, СинонимТабличнойЧасти),
				ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;

			Если ПараметрыПроверки.Свойство("ПроверятьАгентскийДоговор") И ПараметрыПроверки.ПроверятьАгентскийДоговор
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента) И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТабличнойЧасти.ДоговорКонтрагента, "УчетАгентскогоНДС") Тогда
			
				ТекстСообщения = НСтр("ru = 'В табличной части ""%2"" для строки %1 указан договор требующий регистрации агентского НДС. Регистрация НДС в данном документе не требуется.'");
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорКонтрагента";
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаТабличнойЧасти.НомерСтроки, СинонимТабличнойЧасти),
				ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли