
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = Справочники.Организации.ОрганизацияПоУмолчанию(Запись.Организация);
		КонецЕсли;
		
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка И НЕ ЗначениеЗаполнено(Запись.ВариантУчетаКадровыхПерестановок) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru = 'Вариант учета кадровых перестановок'")),
			,
			"ВариантУчетаКадровыхПерестановок",
			"Запись",
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	НеобходимоПереключениеГоловнойОрганизации = НеобходимоПереключениеГоловнойОрганизации();
	
	// Установка монопольного режима если требуется менять режим внутреннего совместительства.
	Если НеобходимоПереключениеГоловнойОрганизации Тогда
		
		Если НЕ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
			
			Попытка
				УстановитьМонопольныйРежим(Истина);
			Исключение
								
				ТекстСообщения = НСтр(
					"ru = 'Не удалось установить монопольный режим для изменения учетной политики по персоналу!
	                 |Запись изменений невозможна по причине:
	                 |%1'"
				);
				
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КраткоеПредставлениеОшибки);
				
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					,
					,
					"Запись",
					Отказ
				);				
				
			КонецПопытки;
		
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущийОбъект.РасчетКоэффициентаНарастающимИтогом = Булево(РасчетКоэффициента);
	ТекущийОбъект.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок = Булево(РасчетКоэффициентаВПределахДолжности);
		
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НеобходимоПереключениеГоловнойОрганизации Тогда 
		Если Запись.ВестиУчетПоГоловнойОрганизации Тогда
			Отказ = НЕ РегистрыСведений.УчетнаяПолитикаПоПерсоналуОрганизаций.ВключениеВеденияУчетаПоГоловнойОрганизации(Запись.Организация);
		Иначе
			Отказ = НЕ РегистрыСведений.УчетнаяПолитикаПоПерсоналуОрганизаций.ВыключениеВеденияУчетаПоГоловнойОрганизации(Запись.Организация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Если НЕ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;	
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВестиУчетПоГоловнойОрганизацииПриИзменении(Элемент)
	
	ОбработатьИзменениеРеквизитов(Запись.ВестиУчетПоГоловнойОрганизации);

КонецПроцедуры

&НаКлиенте
Процедура ГоловнаяОрганизацияНажатие(Элемент)
	
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		ПоказатьЗначение(, ГоловнаяОрганизация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработкаПриИзменении(Элемент)
	
	УстановитьВариантУчетаКадровыхПерестановок(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
    УстановитьРасчетКоэффициентаВПределахДолжности(ЭтотОбъект);	
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработкаПоГоловеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УчетПоВсемОрганизациям = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(
		ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям");
	
	ПредыдущаяОрганизация = Запись.Организация;
	
	СписокГоловныхОрганизаций.ЗагрузитьЗначения(Справочники.Организации.СписокГоловныхОрганизаций());
	
	ОбработатьИзменениеРеквизитов();
	
	УстановитьВариантУчетаКадровыхПерестановок(ЭтотОбъект);
	
	УстановитьРасчетКоэффициента(ЭтотОбъект);
	
	УстановитьРасчетКоэффициентаВПределахДолжности(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Запись   = Форма.Запись;
	Элементы = Форма.Элементы;
	
	Элементы.Организация.ТолькоПросмотр = НЕ Форма.УчетПоВсемОрганизациям;
	
	УстановитьВидимостьРасчетКоэффициентаВПределахДолжности(Форма);
			
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеРеквизитов(ИзменятьДанные = Ложь);
	
	Элементы.ГруппаДанныеПоГоловнойОрганизации.Видимость  = Ложь;
	Элементы.ГруппаДанныеПоВыбраннойОрганизации.Видимость = Истина;
	
	Если ЗначениеЗаполнено(Запись.Организация) Тогда
		
		// проверим наша организация головная или нет по реквизиту "Головная органзация" из справочника "Организации"
		Если СписокГоловныхОрганизаций.НайтиПоЗначению(Запись.Организация) = Неопределено Тогда // "Головная организация" отлична от организации
			
			//организация - филиал, которая может вести учет по голове и может не вести
			Если Запись.ВестиУчетПоГоловнойОрганизации Тогда
				
				Элементы.ГруппаДанныеПоГоловнойОрганизации.Видимость  = Истина;
				Элементы.ГруппаДанныеПоВыбраннойОрганизации.Видимость = Ложь;
				
				Запрос = Новый Запрос(
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	Организации.Ссылка КАК Организация,
					|	ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка, ЛОЖЬ) КАК УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка,
					|	ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.ВариантУчетаКадровыхПерестановок, ЗНАЧЕНИЕ(Перечисление.ВариантыУчетаКадровыхПерестановок.ПустаяСсылка)) КАК ВариантУчетаКадровыхПерестановок,
					|	ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.РасчетКоэффициентаНарастающимИтогом, ЛОЖЬ) КАК РасчетКоэффициентаНарастающимИтогом,
					|	ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок, ЛОЖЬ) КАК РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок
					|ИЗ
					|	Справочник.Организации КАК Организации
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаПоПерсоналуОрганизаций КАК УчетнаяПолитикаПоПерсоналуОрганизаций
					|		ПО Организации.ГоловнаяОрганизация = УчетнаяПолитикаПоПерсоналуОрганизаций.Организация
					|ГДЕ					
					|	Организации.Ссылка = &парамОрганизация");					
					
					Запрос.УстановитьПараметр("парамОрганизация", Запись.Организация);

				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда						
					УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработкаПоГолове = Выборка.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка;
					ВариантУчетаКадровыхПерестановокПоГолове = Выборка.ВариантУчетаКадровыхПерестановок;
					РасчетКоэффициентаГоловнаяОрганизация = ?(Выборка.РасчетКоэффициентаНарастающимИтогом, 1, 0);
					РасчетКоэффициентаВПределахДолжностиГоловнаяОрганизация = ?(Выборка.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок, 1, 0);
					Если ИзменятьДанные Тогда //установим параметры текущей записи по параметрам головной организации
						Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка = Выборка.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка;
						Запись.ВариантУчетаКадровыхПерестановок = Выборка.ВариантУчетаКадровыхПерестановок;
						Запись.РасчетКоэффициентаНарастающимИтогом = Выборка.РасчетКоэффициентаНарастающимИтогом;
						Запись.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок = Выборка.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок;
					КонецЕсли;
				Иначе // для головной не определена учетная политика, устанавливаем значения по умолчанию
					Если ИзменятьДанные Тогда //установим параметры текущей записи по параметрам головной организации
						Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка = Ложь;
						Запись.ВариантУчетаКадровыхПерестановок = Перечисления.ВариантыУчетаКадровыхПерестановок.ПустаяСсылка();
						Запись.РасчетКоэффициентаНарастающимИтогом = Ложь;
						Запись.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок = Ложь;
					КонецЕсли;
				КонецЕсли;

			КонецЕсли;
			
		КонецЕсли;
		
		ЗначенияРеквизитовОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Организация, "ГоловнаяОрганизация, ГоловнаяОрганизация.Наименование");
		ГоловнаяОрганизация = ЗначенияРеквизитовОбъекта.ГоловнаяОрганизация;
		
		Элементы.НадписьГоловнаяОрганизацияСсылка.Заголовок = """" + ЗначенияРеквизитовОбъекта.ГоловнаяОрганизацияНаименование + """";
	Иначе
		Элементы.НадписьГоловнаяОрганизацияСсылка.Заголовок = НСтр("ru = 'не указана'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	СписокГоловныхОрганизаций.ЗагрузитьЗначения(Справочники.Организации.СписокГоловныхОрганизаций());
	
	ОбработатьИзменениеРеквизитов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВариантУчетаКадровыхПерестановок(Форма)
	
	Элементы = Форма.Элементы;
	Запись   = Форма.Запись;
	
	Элементы.ВариантУчетаКадровыхПерестановок.Доступность = Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка;
	Если НЕ Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка И ЗначениеЗаполнено(Запись.ВариантУчетаКадровыхПерестановок) Тогда
		Запись.ВариантУчетаКадровыхПерестановок = ПредопределенноеЗначение("Перечисление.ВариантыУчетаКадровыхПерестановок.ПустаяСсылка");
	ИначеЕсли Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка И НЕ ЗначениеЗаполнено(Запись.ВариантУчетаКадровыхПерестановок) Тогда
		Запись.ВариантУчетаКадровыхПерестановок = ПредопределенноеЗначение("Перечисление.ВариантыУчетаКадровыхПерестановок.ПодразделениеИДолжность");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРасчетКоэффициента(Форма)
	
	Запись = Форма.Запись;
	Форма.РасчетКоэффициента = ?(Запись.РасчетКоэффициентаНарастающимИтогом, 1, 0);
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРасчетКоэффициентаВПределахДолжности(Форма)
	
	Запись = Форма.Запись;
	Форма.РасчетКоэффициентаВПределахДолжности = ?(Запись.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок, 1, 0);

КонецПроцедуры

&НаСервере
Функция НеобходимоПереключениеГоловнойОрганизации()
	
	Если (ПредыдущаяОрганизация <> Запись.Организация И ПредыдущаяОрганизация <> Справочники.Организации.ПустаяСсылка()) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// проверим прежнее значение по выбранной организации
	УстановитьПривилегированныйРежим(Истина);
	
	Отбор = Новый Структура("Организация", Запись.Организация);
	ПрежнееЗначение = РегистрыСведений.УчетнаяПолитикаПоПерсоналуОрганизаций.Получить(Отбор).ВестиУчетПоГоловнойОрганизации;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ПрежнееЗначение <> Запись.ВестиУчетПоГоловнойОрганизации И ПрежнееЗначение <> Null Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура  УстановитьВидимостьРасчетКоэффициентаВПределахДолжности(Форма)
	
	Элементы = Форма.Элементы;
	Запись = Форма.Запись;
	
	Если ЗначениеЗаполнено(Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка) Тогда
		Элементы.РасчетКоэффициентаВПределахДолжности.Видимость = Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка;
		Запись.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок = Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка;
	Иначе 
		Элементы.РасчетКоэффициентаВПределахДолжностиГоловнаяОрганизация.Видимость = Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработкаПоГолове;
		Запись.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок = Запись.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработкаПоГолове;
	КонецЕсли;

КонецПроцедуры

