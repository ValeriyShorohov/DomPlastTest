
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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	Если Параметры.Ключ.Пустая() Тогда 
		ПодготовитьФормуНаСервере();
		ПодразделениеОрганизацииСсылка = Справочники.ПодразделенияОрганизаций.ПолучитьСсылку();
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
	
	ПодразделениеОрганизацииСсылка = Объект.Ссылка;
	РедактированиеПериодическихСведенийСервер.ИнициализироватьЗаписьДляОтображенияНаФорме(ЭтотОбъект, "УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации", ПодразделениеОрганизацииСсылка);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Для нового подразделения организации устанавливаем ссылку
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(ПодразделениеОрганизацииСсылка);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства 

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПравоДоступа("Изменение", Метаданные.РегистрыСведений.УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации)
			И УчетОсновногоЗаработкаРаботниковПодразделенияОрганизацииНаборЗаписейПрочитан Тогда
		// Учет основного заработка сотрудников подразделений организации
		ТаблицаНабораЗаписей = УчетОсновногоЗаработкаРаботниковПодразделенияОрганизацииНаборЗаписей.Выгрузить();
		ТаблицаНабораЗаписей.ЗаполнитьЗначения(Объект.Владелец, "Организация");
		
		НаборОтражениеЗарплатыВУчете = РегистрыСведений.УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации.СоздатьНаборЗаписей();
		НаборОтражениеЗарплатыВУчете.Отбор.Организация.Установить(ТекущийОбъект.Владелец);
		НаборОтражениеЗарплатыВУчете.Отбор.ПодразделениеОрганизации.Установить(ТекущийОбъект.Ссылка);
		НаборОтражениеЗарплатыВУчете.Загрузить(ТаблицаНабораЗаписей);
		НаборОтражениеЗарплатыВУчете.Записать(Истина);
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

	ПроверитьРегламентированныеДанные(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
	ОбновитьОтборыДинамическихСписков(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" И Источник = ПодразделениеОрганизацииСсылка Тогда
		РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтотОбъект, ПодразделениеОрганизацииСсылка, ИмяСобытия, Параметр, Источник);
		ОбновитьПредставлениеЭлемента(ЭтотОбъект, Параметр.ИмяРегистра);
	ИначеЕсли ИмяСобытия = "ОбновитьФорму" Тогда 
		Если Источник = Объект.ОсновнойВидДеятельности Тогда
			ОбновитьПредставлениеВидаДеятельности();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "УстановкаОсновногоБанковскогоСчета"
		ИЛИ ИмяСобытия = "УстановкаОсновногоБанковскогоСчетаПриЗаписи" Тогда
		Если Не ТолькоПросмотр Тогда
			
			Если Объект.Ссылка = Параметр.КонтрагентОрганизация Тогда
				
				УстановитьОсновнойБанковскийСчет(Параметр.ОсновнойБанковскийСчет);
				
				ОповеститьВФорме("УстановкаОсновногоБанковскогоСчетаВыполнена");
				
				УправлениеФормой(ЭтотОбъект);
				
				Записать(); 
				
			КонецЕсли;
			
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "УстановкаОсновнойКассы"
		ИЛИ ИмяСобытия = "УстановкаОсновнойКассыПриЗаписи" Тогда
		Если Не ТолькоПросмотр Тогда
			
			Если Объект.Ссылка = Параметр.КонтрагентОрганизация Тогда
				
				УстановитьОсновнуюКассу(Параметр.ОсновнаяКасса);
				
				ОповеститьВФорме("УстановкаОсновнойКассыВыполнена");
				
				УправлениеФормой(ЭтотОбъект);
				
				Записать(); 
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ОрганизацияИзменилась_БанковскийСчет" Тогда
		
		Если Не ТолькоПросмотр Тогда
			
			Если Объект.ОсновнойБанковскийСчет = Параметр.БанковскийСчет Тогда
				
				Объект.ОсновнойБанковскийСчет = ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка");
				
				УправлениеФормой(ЭтотОбъект);
				
				Записать();
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ОрганизацияИзменилась_Касса" Тогда
		
		Если Не ТолькоПросмотр Тогда
			
			Если Объект.ОсновнаяКасса = Параметр.Касса Тогда
				
				Объект.ОсновнаяКасса = ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
				
				УправлениеФормой(ЭтотОбъект);
				
				Записать();
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр)Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Оповестить("Запись_ПодразделениеОрганизации", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства 
	
	Если Объект.УчетПоМестнымБюджетам И НЕ ЗначениеЗаполнено(Объект.МестныйБюджет) Тогда
		ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не заполнен аппарат акима для форм налоговой отчетности'"),,"Объект.МестныйБюджет",, Отказ);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЯвляетсяСтруктурнымПодразделениемПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьРеквизитыГоловнойОрганизацииПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификационныйНомерПриИзменении(Элемент)
	ПроверитьРегламентированныеДанные(ЭтотОбъект, "БИН");
КонецПроцедуры

&НаКлиенте
Процедура РННПриИзменении(Элемент)
	ПроверитьРегламентированныеДанные(ЭтотОбъект, "РНН");
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойВидДеятельностиПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаДеятельности();

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеЗарплатыВУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактированиеПериодическихСведенийКлиент.ОткрытьФормуРедактированияИстории("УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации", ПодразделениеОрганизацииСсылка, ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьКассы(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Объект.Владелец));
	ПараметрыФормы.Вставить("ВладелецПодразделение", Объект.Ссылка);
	ОткрытьФорму("Справочник.Кассы.ФормаСписка",
	ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБанковскиеСчета(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Объект.Владелец));
	ПараметрыФормы.Вставить("ВладелецПодразделение", Объект.Ссылка);
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаСписка",
	ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

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

// Управление формой

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ОбновитьОтборыДинамическихСписков(ЭтотОбъект);
	
	ПроверитьРегламентированныеДанные(ЭтотОбъект);
	
	ОбновитьПредставлениеВидаДеятельности();
	
	ОбновитьПредставлениеЭлемента(ЭтотОбъект, "УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации");
	
	Элементы.Кассы.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.Кассы);
	Элементы.БанковскиеСчета.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.БанковскиеСчета);
	Элементы.ОтражениеЗарплатыВУчете.Видимость = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации);
	
	УправлениеФормой(ЭтотОбъект);
	
	ДанныеЗапретаИзменения = ДатыЗапретаИзмененияБК.ЗапретИзменения("РегистрСведений.ГражданствоФизЛиц");
	Если ДанныеЗапретаИзменения.ЗапретНайден Тогда
		ДатаЗапретаИзмененияДанных = ДанныеЗапретаИзменения.ДатаЗапрета;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПрочиеРеквизиты.Видимость = Объект.ЯвляетсяСтруктурнымПодразделением;
	Элементы.ГруппаОсновные.Видимость = Объект.ЯвляетсяСтруктурнымПодразделением;
	Элементы.ГруппаДополнительнаяИнформация.Видимость = Объект.ЯвляетсяСтруктурнымПодразделением;
	
	ДоступностьЭлемента = НЕ Объект.УказыватьРеквизитыГоловнойОрганизации;
	Элементы.ГруппаПрочиеРеквизиты.Доступность    = ДоступностьЭлемента;
	Элементы.ГруппаКоды.Видимость 		          = ДоступностьЭлемента;
	Элементы.НалоговыйКомитет.Доступность 		  = ДоступностьЭлемента;

	Элементы.Владелец.Видимость = НЕ ЗначениеЗаполнено(Объект.Владелец);
	
	Элементы.МестныйБюджет.Видимость = Объект.УчетПоМестнымБюджетам;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтборыДинамическихСписков(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.БанковскиеСчета, 
		"Владелец", 
		Форма.Объект.Владелец, 
		ВидСравненияКомпоновкиДанных.Равно,
		НСтр("ru = 'Отбор по владельцу'"),
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Кассы, 
		"Владелец", 
		Форма.Объект.Владелец, 
		ВидСравненияКомпоновкиДанных.Равно,
		НСтр("ru = 'Отбор по владельцу'"),
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьРегламентированныеДанные(Форма, ПроверяемыеДанные = "БИН, РНН")
	
	МассивПроверяемыхДанных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПроверяемыеДанные, ",", , Истина);
	Для Каждого Элемент Из МассивПроверяемыхДанных Цикл
		ИмяЭлементаНадписи = "НадписьПоясненияНекорректного" + Элемент;
		ТекстСообщения     = "";
		Если Форма.Элементы.Найти(ИмяЭлементаНадписи) <> Неопределено Тогда 
			Если Элемент = "БИН" Тогда 
				Если НЕ ЗначениеЗаполнено(Форма.Объект.ИдентификационныйНомер) 
					ИЛИ РегламентированныеДанныеКлиентСервер.ИИНБИНСоответствуетТребованиям(Форма.Объект.ИдентификационныйНомер, ТекстСообщения) Тогда 
					ТекстСообщения = "";
				КонецЕсли;
			ИначеЕсли Элемент = "РНН" Тогда 
				Если НЕ ЗначениеЗаполнено(Форма.Объект.РНН) 
					ИЛИ РегламентированныеДанныеКлиентСервер.РННСоответствуетТребованиям(Форма.Объект.РНН, ТекстСообщения) Тогда 
					ТекстСообщения = "";
				КонецЕсли;
			КонецЕсли;
			Форма[ИмяЭлементаНадписи] = ТекстСообщения;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеЭлемента(Форма, ИмяОбновляемогоЭлемента)
	
	Если ИмяОбновляемогоЭлемента = "УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации" Тогда
		УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации = Форма.УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации;
		Если ЗначениеЗаполнено(УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации.СпособОтраженияВБухучете) Тогда
			ПредставлениеЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Начиная с %1 заработная плата в бух. учете отражается по способу 
						   |""%2""'"),
				Формат(УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации.Период, "ДЛФ=D"),
				УчетОсновногоЗаработкаРаботниковПодразделенияОрганизации.СпособОтраженияВБухучете);
		Иначе
			ПредставлениеЗаписи = НСтр("ru = 'Способ отражения заработной платы в бух. учете не задан'");
		КонецЕсли;
		Форма.УчетОсновногоЗаработкаРаботниковПодразделенияОрганизацииПредставлениеЗаписи = ПредставлениеЗаписи;
	КонецЕсли;
	
КонецПроцедуры

// При изменении реквизитов (служебные)

&НаСервере
Процедура ОбновитьПредставлениеВидаДеятельности()
	Если НЕ ЗначениеЗаполнено(Объект.ОсновнойВидДеятельности) Тогда
		КодОКЭД = НСтр("ru = '<укажите вид деятельности>'");
		НаименованиеОКЭД = НСтр("ru = '<укажите вид деятельности>'");
	Иначе
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ОсновнойВидДеятельности, "КодОКЭД, ПолноеНаименование");
		
		КодОКЭД = ?(НЕ ЗначениеЗаполнено(ЗначенияРеквизитов.КодОКЭД), НСтр("ru = '<не указан код ОКЭД для вида деятельности>'"),ЗначенияРеквизитов.КодОКЭД);
		НаименованиеОКЭД = ?(НЕ ЗначениеЗаполнено(ЗначенияРеквизитов.ПолноеНаименование), НСтр("ru = '<не указано полное наименование вида деятельности>'"),ЗначенияРеквизитов.ПолноеНаименование);
	КонецЕсли;	
КонецПроцедуры

// Обработка завершения интерактивных действий пользователя

////////////////////////////////////////////////////////////////////////////////
// Редактирование периодических сведений

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведенийСервер.ПрочитатьНаборЗаписей(ЭтотОбъект, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

// Служебные процедуры и функции

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УчетПоМестнымБюджетамПриИзменении(Элемент)
	
	Если НЕ Объект.УчетПоМестнымБюджетам Тогда
		Объект.МестныйБюджет = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОповеститьВФорме(ИмяСобытия, Параметр = Неопределено, Источник = Неопределено) 
	
	// +++ Проверка заполненности реквизитов организации (банковский счет)
	РассылкаОповещенияИзТекущейФормы = Истина;
	Оповестить(ИмяСобытия, Параметр, Источник);
	РассылкаОповещенияИзТекущейФормы = Ложь;
	// --- Проверка заполненности реквизитов организации (банковский счет)
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОсновнойБанковскийСчет()
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Справочники.БанковскиеСчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ОсновнойБанковскийСчет) Тогда
		ОсновнойБанковскийСчетОбъект = Объект.ОсновнойБанковскийСчет.ПолучитьОбъект();
	ИначеЕсли ПравоДоступа("Добавление", Метаданные.Справочники.БанковскиеСчета) Тогда
		ОсновнойБанковскийСчетОбъект = Справочники.БанковскиеСчета.СоздатьЭлемент();
	Иначе
		ОсновнойБанковскийСчетОбъект = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойБанковскийСчет(ОсновнойБанковскийСчет)
	
	Прочитать();
	
	// Если основным назначен другой банковский счет, то разблокируем предыдущий основной
	Если Объект.ОсновнойБанковскийСчет <> ОсновнойБанковскийСчет
		И БанковскийСчетЗаблокирован Тогда
		
		РазблокироватьРеквизитПриРедактированииНаСервере(Объект.ОсновнойБанковскийСчет, УникальныйИдентификатор);
		БанковскийСчетЗаблокирован = Ложь;
		
	КонецЕсли;
	
	Объект.ОсновнойБанковскийСчет = ОсновнойБанковскийСчет;
	
	ПрочитатьОсновнойБанковскийСчет();
	
	Если Не Модифицированность Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнуюКассу(ОсновнаяКасса)
	
	Прочитать();
	
	// Если основным назначена другая касса, то разблокируем предыдущую основную
	Если Объект.ОсновнаяКасса <> ОсновнаяКасса
		И КассаЗаблокирована Тогда
		
		РазблокироватьРеквизитПриРедактированииНаСервере(Объект.ОсновнаяКасса, УникальныйИдентификатор);
		КассаРазблокирована = Ложь;
		
	КонецЕсли;
	
	Объект.ОсновнаяКасса = ОсновнаяКасса;
	
	ПрочитатьОсновнуюКассу();
	
	Если Не Модифицированность Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазблокироватьРеквизитПриРедактированииНаСервере(Ссылка, ИдентификаторФормы)
	
	РазблокироватьДанныеДляРедактирования(Ссылка, ИдентификаторФормы);
	
КонецФункции

&НаСервере
Процедура ПрочитатьОсновнуюКассу()
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Справочники.Кассы) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ОсновнаяКасса) Тогда
		ОсновнаяКассаОбъект = Объект.ОсновнаяКасса.ПолучитьОбъект();
	ИначеЕсли ПравоДоступа("Добавление", Метаданные.Справочники.Кассы) Тогда
		ОсновнаяКассаОбъект = Справочники.Кассы.СоздатьЭлемент();
	Иначе
		ОсновнаяКассаОбъект = Неопределено;
	КонецЕсли;
	
КонецПроцедуры


