///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПВХ.Ссылка       КАК Значение,
		|	ПВХ.Наименование КАК Представление,
		|	ВЫБОР
		|		КОГДА ПВХ.Ссылка В (&МассивКатегорийНовостей)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Пометка
		|ИЗ
		|	ПланВидовХарактеристик.КатегорииНовостей КАК ПВХ
		|ГДЕ
		|	ПВХ.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПВХ.Наименование
		|";
	Запрос.УстановитьПараметр("МассивКатегорийНовостей", Параметры.СписокКатегорийНовостей.ВыгрузитьЗначения());

	Результат = Запрос.Выполнить(); // ПриСозданииНаСервере()
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока Выборка.Следующий() Цикл
			ЭтотОбъект.КатегорииНовостей.Добавить(
				Выборка.Значение,
				Выборка.Представление,
				Выборка.Пометка);
		КонецЦикла;
	Иначе
		Отказ = Истина;
	КонецЕсли;

	Если Параметры.Свойство("ОткрытаИзОбработки_УправлениеНовостями") Тогда
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;
	Иначе
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Ложь;
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Обновились данные классификаторов новостей с сервера 1С" Тогда // Идентификатор.
		Элементы.КатегорииНовостей.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылкаФорматированнойСтроки) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ОткрытьФорму(
			"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
			Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
			ЭтотОбъект,
			"");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)

	МассивВыбранныхЗначений = Новый Массив();

	Для каждого ТекущаяСтрока Из ЭтотОбъект.КатегорииНовостей Цикл
		Если ТекущаяСтрока.Пометка Тогда
			МассивВыбранныхЗначений.Добавить(ТекущаяСтрока.Значение);
		КонецЕсли;
	КонецЦикла;

	ЭтотОбъект.Закрыть(МассивВыбранныхЗначений);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

	ТребуетсяОбновление = Ложь;

	Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
	Запись.Список = "Список категорий новостей"; // Идентификатор.
	Запись.Прочитать(); // Только чтение, без последующей записи.

	Если Запись.Выбран() Тогда
		Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Данные актуальны и соответствуют данным с сервера от %1.'"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Ложь;
		Иначе // Устарели
			Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
				ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера,
					|а на сервере уже версия от %2.'");
			Иначе
				ТекстНадписи = НСтр("ru='Последний раз данные обновлялись с сервера %1,
					|а на сервере уже версия от %2.'");
			КонецЕсли;
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстНадписи,
				Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера.'");
		ТребуетсяОбновление = Истина;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
		Если (ЭтотОбъект.РольДоступнаАдминистратор = Истина) Тогда
			// Если эта форма открыта из формы обработки "Управление новостями", то
			//  не давать снова открывать форму обработки.
			Если ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
				Если ТребуетсяОбновление = Истина Тогда
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				Иначе
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
				КонецЕсли;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = Новый ФорматированнаяСтрока(
					ТекстНадписи + " ",
					Новый ФорматированнаяСтрока(
						НСтр("ru='Проверить обновления.'"),
						,
						ЦветаСтиля.ГиперссылкаЦвет,
						,
						"Update"));
			КонецЕсли;
		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = ТекстНадписи;
			Если ТребуетсяОбновление = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

#КонецОбласти
