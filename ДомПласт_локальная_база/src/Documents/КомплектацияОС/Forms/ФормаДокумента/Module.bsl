////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
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
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Оповестить("Запись_КомплектацияОС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаПодбора" Тогда 
		ОбработкаВыбораПодборОСНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ОбработанаТабличнаяЧасть" И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		ОбработкаОповещенияОбработкиТабличнойЧастиНаСервере(Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""комплектация ос"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОС

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;

	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ОсновноеСредство) Тогда

		СтрокаТабличнойЧасти.СостояниеВСоставеОС = ОСОсновноеСредствоПриИзмененииНаСервере(Объект.РодительскоеОсновноеСредство, 
																						   Объект.Дата, 
																						   СтрокаТабличнойЧасти.ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ОС.Количество()> 0 Тогда
		
		ТекстСообщения = НСтр("ru='При заполнении существующие данные табличной части были очищены!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Объект.ОС.Очистить();
		
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбораОС("ОС");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Справочник.ОсновныеСредства.Форма.ФормаПодбора", ПараметрыПодбора, ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОС(Команда)
	
	ИзменитьТабличнуюЧасть("ОС", "Основные средства");
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	НастройкиПользователя = ПользователиБКВызовСервераПовтИсп.ЗначенияНастроекПользователя(
								Пользователи.ТекущийПользователь(), "УчетПоВсемОрганизациям");
	
	Элементы.СтруктурноеПодразделениеОрганизация.ТолькоПросмотр = НЕ НастройкиПользователя.УчетПоВсемОрганизациям;
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
		
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Документы.КомплектацияОС.ЗаполнитьТаблицуОС(Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОСОсновноеСредствоПриИзмененииНаСервере(РодительскоеОсновноеСредство, Дата, ОсновноеСредство)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РодительскоеОС", РодительскоеОсновноеСредство);
	Запрос.УстановитьПараметр("ДатаДок",        Дата);
	Запрос.УстановитьПараметр("ТекущееОС",      ОсновноеСредство);
	
	Запрос.Текст ="ВЫБРАТЬ
	              |	СоставОССрезПоследних.СостояниеВСоставеОС
	              |ИЗ
	              |	РегистрСведений.СоставОС.СрезПоследних(&ДатаДок, (ВСоставеОС = &РодительскоеОС) И (ОсновноеСредство = &ТекущееОС) ) КАК СоставОССрезПоследних";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий()  Тогда 
		Возврат Выборка.СостояниеВСоставеОС;
	Иначе
		Возврат Перечисления.ВидыСостоянийВСоставеОС.ВключеноВСостав;
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыПодбораОС(ИмяТаблицы)
    
	ДатаРасчетов		 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	                                                                                          
	ЗаголовокПодбора	 = НСтр("ru = 'Подбор основных средств в %1 (%2)'");
	ПредставлениеТаблицы = НСтр("ru = '" + ИмяТаблицы + "'");
	
	ЗаголовокПодбора     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов",             ДатаРасчетов);
	ПараметрыФормы.Вставить("Организация",              Объект.Организация);
	ПараметрыФормы.Вставить("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
	ПараметрыФормы.Вставить("Заголовок",                ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВыбиратьВсе",              Истина);	
	ПараметрыФормы.Вставить("ОбъектСсылка",             Объект.Ссылка);
	ПараметрыФормы.Вставить("ИмяТаблицы",               ИмяТаблицы);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборОСНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	Если ИмяТаблицы <> "ОС" Тогда
        // Ошибочное имя табличной части
		Возврат;
	КонецЕсли;

	ТаблицаОС = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобранныхОСВХранилище);
	
	Для каждого СтрокаОС Из ТаблицаОС Цикл
		
		// Ищем выбранную позицию в таблице подобранной номенклатуры.
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("ОсновноеСредство", СтрокаОС.ОсновноеСредство);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, ИмяТаблицы, СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаОС);						
		Иначе
			ТекстСообщения = НСтр("ru='Основное средство - %1 уже подобрано!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаОС.ОсновноеСредство);
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, Поле, "Объект"); 
		КонецЕсли;
		
	КонецЦикла;

	УдалитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобранныхОСВХранилище);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ИзменитьТабличнуюЧасть(ИмяТабличнойЧасти, СинонимТабличнойЧасти)
	
	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧасти(ИмяТабличнойЧасти, СинонимТабличнойЧасти);
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ОбработкаТабличнойЧастиДокументов.Форма.Форма", ПараметрыФормы,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОбработкиТабличнойЧасти(ИмяТабличнойЧасти, СинонимТабличнойЧасти)
	
	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТабличнойЧасти", ПоместитьТабличнуюЧастьВоВременноеХранилищеНаСервере(ИмяТабличнойЧасти));
	ПараметрыОбработки.Вставить("ДокументСсылка"              , Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата"                , Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументВалюта"              , Справочники.Валюты.ПустаяСсылка());
	ПараметрыОбработки.Вставить("ДокументКурс"                , 1);
	ПараметрыОбработки.Вставить("ДокументКратность"           , 1);
	ПараметрыОбработки.Вставить("ДокументСуммаВключаетНДС"    , Ложь);
	ПараметрыОбработки.Вставить("ДокументУчитыватьНДС"        , Ложь);
	ПараметрыОбработки.Вставить("ДокументНДСВключенВСтоимость", Ложь);
	ПараметрыОбработки.Вставить("ИмяТаблицы"                  , ИмяТабличнойЧасти);
	ПараметрыОбработки.Вставить("Заголовок"                   , СинонимТабличнойЧасти);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("СостояниеВСоставеОС");
	
	СтруктураСвязанныхРеквизитов = Новый Структура;	
	
	ПараметрыОбработки.Вставить("СтруктураРеквизитов", СтруктураРеквизитов);
	ПараметрыОбработки.Вставить("СтруктураСвязанныхРеквизитов", СтруктураСвязанныхРеквизитов);
	
	ВидимыеКолонки = Новый Массив;
	ПолучитьВидимыеКолонкиТабличнойЧасти(Элементы[ИмяТабличнойЧасти], Элементы[ИмяТабличнойЧасти].ПутьКДанным + ".", ВидимыеКолонки);
	ПараметрыОбработки.Вставить("ВидимыеКолонки", ВидимыеКолонки);

	Возврат ПараметрыОбработки;
	
КонецФункции

&НаСервере
Функция ПоместитьТабличнуюЧастьВоВременноеХранилищеНаСервере(ИмяТабличнойЧасти)

	Возврат ПоместитьВоВременноеХранилище(Объект[ИмяТабличнойЧасти].Выгрузить(), УникальныйИдентификатор);

КонецФункции

&НаСервере
Функция ПолучитьВидимыеКолонкиТабличнойЧасти(ЭлементТабличнаяЧасть, ПутьКДаннымТаблицы, МассивКолонок)
	
	Для Каждого Элемент Из ЭлементТабличнаяЧасть.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			ПолучитьВидимыеКолонкиТабличнойЧасти(Элемент, ПутьКДаннымТаблицы, МассивКолонок);
		ИначеЕсли ТипЗнч(Элемент) = Тип("ПолеФормы") И Элемент.Видимость Тогда
			МассивКолонок.Добавить(СтрЗаменить(Элемент.ПутьКДанным, ПутьКДаннымТаблицы, ""));
		КонецЕсли;
	КонецЦикла;

КонецФункции

&НаСервере
Процедура ОбработкаОповещенияОбработкиТабличнойЧастиНаСервере(Параметры)

	ТаблицаОбработки  = ПолучитьИзВременногоХранилища(Параметры.АдресОбработаннойТабличнойЧастиВХранилище);
	ИмяТабличнойЧасти = Параметры.ИмяТаблицы;
	
	Объект[ИмяТабличнойЧасти].Загрузить(ТаблицаОбработки);
		
	Модифицированность = Истина;
	
КонецПроцедуры
