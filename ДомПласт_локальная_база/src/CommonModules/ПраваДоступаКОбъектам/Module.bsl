////////////////////////////////////////////////////////////////////////////////
// <ПраваДоступаКОбъектамДругихПользователей: 
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик события формы ПриЧтенииНаСервере, который встраивается в формы документов, 
// чтобы заблокировать форму при наличии запрета редактирования данных.
//
// Параметры:
//  Форма               - ФормаКлиентскогоПриложения - форма объекта данных или записи регистра.
//
//  ТекущийОбъект       - ДокументОбъект.<Имя>,
//
Функция ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	Если НЕ ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Источник = ТекущийОбъект;
	ИдентификаторДанных = ТекущийОбъект.Ссылка;
	
	Если ЗапрещеноРедактированиеДокумента(Источник) Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецФункции

Процедура ПроверитьВозможностьРедактированияДокументовПользователяПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗапрещеноРедактированиеДокумента = ЗапрещеноРедактированиеДокумента(Источник);
	
	Если ЗапрещеноРедактированиеДокумента Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ЗапрещеноРедактированиеДокумента(Источник) Экспорт

	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Ложь;
	КонецЕсли;

	Если Источник.Метаданные().Реквизиты.Найти("Автор") = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапрещеноРедактироватьДокумент = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Автор
	|ИЗ
	|	Документ." + Источник.Метаданные().Имя + "
	|ГДЕ
	|	Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		ВыборкаРезультатов = Результат.Выбрать();
		ВыборкаРезультатов.Следующий();
		АвторДокумента = ВыборкаРезультатов.Автор;
		АвторДокументаТекст = СокрЛП(АвторДокумента);
		Если Не АвторДокумента.Пустая() Тогда
			Если РазрешеноРедактированиеДокументовПользователя(АвторДокумента) Тогда 
				ЗапрещеноРедактироватьДокумент = Ложь;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Редактирование документов пользователя ""%1"" запрещено'"),
						АвторДокументаТекст),
					,
					,
					"Объект",
					ЗапрещеноРедактироватьДокумент
				);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗапрещеноРедактироватьДокумент;
	
КонецФункции

Функция РазрешеноРедактированиеДокументовПользователя(ПользовательДокумента)
	
	Если ПользовательДокумента = Пользователи.ТекущийПользователь() Тогда
		Возврат Истина;
	КонецЕсли;
	
	РазрешеноРедактирование = Ложь;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПраваДоступаКДокументамДругихПользователей.ОбъектДоступа КАК ОбъектДоступа
	|ИЗ
	|	РегистрСведений.ПраваДоступаКДокументамДругихПользователей КАК ПраваДоступаКДокументамДругихПользователей
	|ГДЕ
	|	ПраваДоступаКДокументамДругихПользователей.Пользователь = &Пользователь";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ВыборкаРезультатов = Результат.Выбрать();
		Пока ВыборкаРезультатов.Следующий() Цикл
			ОбъектДоступа = ВыборкаРезультатов.ОбъектДоступа;
			Если ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Пользователи") Тогда
				Если ОбъектДоступа = ПользовательДокумента Тогда
					РазрешеноРедактирование = Истина;
					Прервать;
				КонецЕсли;
			ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				Если ОбъектДоступа = Справочники.ГруппыПользователей.ВсеПользователи Тогда
					РазрешеноРедактирование = Истина;
					Прервать;
				Иначе
					Если ОбъектДоступа.Состав.Найти(ПользовательДокумента, "Пользователь") <> Неопределено Тогда
						РазрешеноРедактирование = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат РазрешеноРедактирование;
	
КонецФункции
