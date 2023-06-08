
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
	
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, НЕ Параметры.Ключ.Пустая());
	
	Если Параметры.Ключ.Пустая() Тогда
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
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, Объект.Ссылка, ЭтаФорма);
	
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, НЕ Параметры.Ключ.Пустая());
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ПараметрыЗаписи.Вставить("ДокументОснование", Объект.ДокументОснование);
	Оповестить("Запись_Сторнирование", ПараметрыЗаписи, Объект.Ссылка);
	ЭСФКлиент.ПослеЗаписиСторнирующегоДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
			
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьВидимостьСтраниц(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	КлючеваяОперация = "Документ ""сторнирование"" (запись)";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ТекстВопроса = НСтр("ru = 'Обновить дату записей регистров?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ДатаПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтотОбъект, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация Тогда
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(Результат);
		ИначеЕсли Результат.ИзмененоСтруктурноеПодразделение Тогда 
			Объект.СтруктурноеПодразделение = СтруктурноеПодразделениеОрганизация;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	МожноСторнироватьДокумент = СторнируемыйДокументПриИзмененииНаСервере(Объект.ДокументОснование);
	
	Если Не МожноСторнироватьДокумент Тогда
		ТекстСообщения =  НСтр("ru = 'Выбранный документ нельзя сторнировать!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю (ТекстСообщения);
		Объект.ДокументОснование = Неопределено;
		Возврат;
	КонецЕсли;

	
	ОбновитьДвиженияДокумента(Истина, Ложь);
	УправлениеФормой(ЭтотОбъект);
	УстановитьВидимостьСтраниц(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СторнируемыйДокументПриИзмененииНаСервере(СторнируемыйДокумент)
	               	
	Возврат РаботаСДиалогами.ПроверитьВозможностьКорректировкиДокумента(СторнируемыйДокумент) 
			  	
КонецФункции

&НаКлиенте
Процедура ОтображатьИспользуемыеРегистрыПриИзменении(Элемент)
	
	УстановитьВидимостьСтраниц(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


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

&НаСервере
Процедура РазблокироватьРеквизиты() Экспорт

КонецПроцедуры

&НаСервере
Функция РеквизитыЗаблокированы()
	
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "ПараметрыЗапретаРедактированияРеквизитов");
	
КонецФункции

// Управление формой

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ОбновитьДвиженияДокумента(Ложь, Параметры.Свойство("Основание") И Параметры.Основание <> Неопределено, НЕ ЗначениеЗаполнено(Объект.Ссылка));
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, Объект.Ссылка, ЭтотОбъект);

	УправлениеФормой(ЭтаФорма);
		
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.НадписьВыборДокументаОснования.Видимость = НЕ ЗначениеЗаполнено(Объект.ДокументОснование) ИЛИ Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы.Количество() = 0;
	Если ЗначениеЗаполнено(Объект.ДокументОснование) И Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы.Количество() = 0 Тогда
		ТекстЗаголовка = НСтр("ru = 'Документ не содержит движений по регистрам'");
	Иначе 
		ТекстЗаголовка = НСтр("ru = 'Необходимо выбрать документ для сторнирования. Для этого заполните реквизит ""Сторнируемый документ""'");
	КонецЕсли;
	Элементы.НадписьВыборДокументаОснования.Заголовок = ТекстЗаголовка;
	
	Элементы.ГруппаДвиженияДокумента.Видимость        = ЗначениеЗаполнено(Объект.ДокументОснование) И Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы.Количество() > 0;
	Элементы.ОтображатьИспользуемыеРегистры.Видимость = Элементы.ГруппаДвиженияДокумента.Видимость;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьСтраниц(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Элементы.ОтображатьИспользуемыеРегистры.Видимость Тогда 
		Для Каждого Страница Из Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы Цикл
			Если НЕ Форма.ОтображатьИспользуемыеРегистры Тогда 
				Страница.Видимость = Истина;
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТаблицаФормы Из Страница.ПодчиненныеЭлементы Цикл
				КоличествоСтрок = Объект.Движения[ТаблицаФормы.Имя].Количество();
				Если КоличествоСтрок = 0 Тогда 
					Страница.Видимость = Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

// При изменении реквизитов (на сервере)

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

// Обработчики, вызываемые после окончания интерактивных действий пользователя

&НаКлиенте
Процедура ДатаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбновитьПериодЗаписейДвижений();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Служебные процедуры и функции

&НаСервере
Процедура ОбновитьПериодЗаписейДвижений()
	
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	СторнированиеОбъект = РеквизитФормыВЗначение("Объект");
	
	Документы.Сторнирование.ОбновитьПериодЗаписейДвижений(СторнированиеОбъект);
	
	ЗначениеВРеквизитФормы(СторнированиеОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДвиженияДокумента(ВзятьДвиженияИзДокументаОснования = Истина, ЭтоВводНаОсновании = Ложь, ПереопределятьОрганизацию = Истина)
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""сторнирование"" (обновление движений документа)";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	// удаляем все страницы панели движений
	Элементы.ГруппаДвиженияДокумента.Видимость = Ложь;
	
	МассивУдаляемыхЭлементовФормы = Новый Массив;
	Для Каждого ПодчиненныйЭлемент Из Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы Цикл
		МассивУдаляемыхЭлементовФормы.Добавить(ПодчиненныйЭлемент);
	КонецЦикла;
	
	Для Каждого Элемент Из МассивУдаляемыхЭлементовФормы Цикл
		Элементы.Удалить(Элемент);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда

		ПроведениеСервер.УдалитьДвиженияРегистратора(Объект.Ссылка, Ложь);
		УправлениеФормой(ЭтотОбъект);
		
		Возврат;

	КонецЕсли;

	МетаданныеДокумент = Объект.ДокументОснование.Метаданные();

	СторнированиеОбъект = РеквизитФормыВЗначение("Объект");
	
	Для Каждого МетаданныеРегистр Из МетаданныеДокумент.Движения Цикл

		// если документ-сторно не может иметь таких движений - это не сторнируемый регистр
		Если НЕ Объект.Ссылка.Метаданные().Движения.Содержит(МетаданныеРегистр) Тогда
			Продолжить;
		КонецЕсли;

		НазваниеРегистра = МетаданныеРегистр.Представление();
		ИмяРегистра      = МетаданныеРегистр.Имя;

		// новая группа формы
		СтраницаДвижений = Элементы.Добавить("Группа" + ИмяРегистра, Тип("ГруппаФормы"), Элементы.ГруппаДвиженияДокумента);
		СтраницаДвижений.Заголовок = НазваниеРегистра;
		СтраницаДвижений.Вид = ВидГруппыФормы.Страница;

		// новое табличное поле
		ТекТаблица = Элементы.Добавить(ИмяРегистра, Тип("ТаблицаФормы"), СтраницаДвижений);
		ТекТаблица.ПутьКДанным         = "Объект.Движения." + ИмяРегистра;
		ТекТаблица.ТолькоПросмотр      = Истина;
		ТекТаблица.ИзменятьСоставСтрок = Ложь;
		СтраницаДвижений.ПутьКДаннымЗаголовка = ТекТаблица.ПутьКДанным + ".КоличествоСтрок";

		Если ВзятьДвиженияИзДокументаОснования Тогда
			СторнированиеОбъект.Движения[ИмяРегистра].Очистить();
			Документы.Сторнирование.ЗаполнитьНаборЗаписей(СторнированиеОбъект, СторнированиеОбъект.Движения[ИмяРегистра], МетаданныеРегистр);
		ИначеЕсли НЕ ЭтоВводНаОсновании Тогда
			СторнированиеОбъект.Движения[ИмяРегистра].Прочитать()
		КонецЕсли;

		// Определяем набор колонок для таблицы, соответствующих метаданным регистра
		Если ОбщегоНазначения.ЭтоРегистрРасчета(МетаданныеРегистр) Тогда
			НаборЗаписей = РегистрыРасчета[ИмяРегистра].СоздатьНаборЗаписей();
		ИначеЕсли ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеРегистр) Тогда
			НаборЗаписей = РегистрыБухгалтерии[ИмяРегистра].СоздатьНаборЗаписей();
		ИначеЕсли ОбщегоНазначения.ЭтоРегистрНакопления(МетаданныеРегистр) Тогда
			НаборЗаписей = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
		ИначеЕсли ОбщегоНазначения.ЭтоРегистрСведений(МетаданныеРегистр) Тогда
			НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		КонецЕсли;
		
		РеквизитыНабораЗаписей = НаборЗаписей.ВыгрузитьКолонки();

		// Некоторые колонки не надо показывать
		Если РеквизитыНабораЗаписей.Колонки.Найти("Регистратор") <> Неопределено Тогда
			РеквизитыНабораЗаписей.Колонки.Удалить("Регистратор");
		КонецЕсли;
		
		Если РеквизитыНабораЗаписей.Колонки.Найти("МоментВремени") <> Неопределено Тогда
			РеквизитыНабораЗаписей.Колонки.Удалить("МоментВремени");
		КонецЕсли;
	
		// Создаем колонки таблицы
		Для каждого КолонкаРеквизита Из РеквизитыНабораЗаписей.Колонки Цикл
			Если Найти(КолонкаРеквизита.Имя, "ВидСубконто") > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяКолонки = ИмяРегистра + КолонкаРеквизита.Имя;
			ТекКолонка = Элементы.Найти(ИмяКолонки);
			Если ТекКолонка = Неопределено Тогда
				ТекКолонка = Элементы.Добавить(ИмяКолонки, Тип("ПолеФормы"), ТекТаблица);
			КонецЕсли;
			ТекКолонка.ПутьКДанным = ТекТаблица.ПутьКДанным + "." + КолонкаРеквизита.Имя;
			
			Если Найти(ИмяКолонки,"Активность") <> 0 Тогда
				ТекКолонка.Вид = ВидПоляФормы.ПолеФлажка;
			Иначе
				ТекКолонка.Вид = ВидПоляФормы.ПолеВвода;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;

	// движений нет
	Если Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаДвиженияДокумента.ТекущаяСтраница = Элементы.ГруппаДвиженияДокумента.ПодчиненныеЭлементы[0];

	ЗначениеВРеквизитФормы(СторнированиеОбъект, "Объект");
	
	Если ПереопределятьОрганизацию 
		И ОбщегоНазначенияБК.ЕстьРеквизитДокумента("Организация", МетаданныеДокумент)
		И НЕ Объект.ДокументОснование.Организация = Объект.Организация Тогда
		
		Объект.Организация = Объект.ДокументОснование.Организация;
		Если ОбщегоНазначенияБК.ЕстьРеквизитДокумента("СтруктурноеПодразделение", МетаданныеДокумент) Тогда 
			Объект.СтруктурноеПодразделение = Объект.ДокументОснование.СтруктурноеПодразделение;
		Иначе 
			Объект.СтруктурноеПодразделение = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.СтруктурноеПодразделение) Тогда 
			СтруктурноеПодразделениеОрганизация = Объект.СтруктурноеПодразделение;
		Иначе 
			СтруктурноеПодразделениеОрганизация = Объект.Организация;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимостьСтраниц(ЭтотОбъект);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры
