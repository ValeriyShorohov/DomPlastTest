////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭСФСерверПереопределяемый.ПроверкаПоддержкиМеханизмаВАвтономномРабочемМесте() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	СтруктурнаяЕдиница = ЭСФСерверПереопределяемый.ПолучитьОрганизациюпоУмолчанию();
	
	Если НЕ ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru = 'Организация'");
		Элементы.СтруктурнаяЕдиница.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		Элементы.ЗагружаемыеЭСФСтруктурноеПодразделение.Видимость = Ложь;
	КонецЕсли;
	
	СтараяСтруктурнаяЕдиница = СтруктурнаяЕдиница;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	Если СтруктурнаяЕдиница <> СтараяСтруктурнаяЕдиница И ЗагружаемыеЭСФ.Количество() <> 0 Тогда 
		
		ТекстВопроса = НСтр(
			"ru = 'Таблица загруженных электронных счетов-фактур будет очищена.
			|Продолжить?'");
			
		ОчисткаТаблицыЭСФЗавершение = Новый ОписаниеОповещения("ОчисткаТаблицыЭСФЗавершение", ЭтаФорма);
		ПоказатьВопрос(ОчисткаТаблицыЭСФЗавершение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.Отмена);
		
	ИначеЕсли ЗагружаемыеЭСФ.Количество() = 0 Тогда
		
		СтараяСтруктурнаяЕдиница = СтруктурнаяЕдиница;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаТаблицыЭСФЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		СтруктурнаяЕдиница = СтараяСтруктурнаяЕдиница;
		Возврат;
	КонецЕсли;
	
	ЗагружаемыеЭСФ.Очистить();
	СтараяСтруктурнаяЕдиница = СтруктурнаяЕдиница;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНедоступныеРеквизитыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		СтараяСтруктурнаяЕдиница = СтруктурнаяЕдиница;
		ЗагружаемыеЭСФ.Очистить();
	Иначе
		СтруктурнаяЕдиница = СтараяСтруктурнаяЕдиница;
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура ЗагружаемыеЭСФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ЗагружаемыеЭСФ.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если ТекущиеДанные <> Неопределено Тогда
				
		Если Поле.Имя = "ЗагружаемыеЭСФЭСФ" Тогда
			
			ОткрытьЭСФ();
			
		ИначеЕсли Поле.Имя <> "ЗагружаемыеЭСФПометка" Тогда
			
			ПредварительныйПросмотрНаКлиенте();			
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагружаемыеЭСФПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если НЕ Копирование Тогда
		ЗагрузитьИзФайловНаКлиенте();	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьИзФайлов(Команда)
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда 
		ЗагрузитьИзФайловНаКлиенте();
	Иначе
		ТекстСообщения = НСтр("ru = 'Поле ""[СтруктурнаяЕдиница]"" не заполнено.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "[СтруктурнаяЕдиница]", Элементы.СтруктурнаяЕдиница.Заголовок);
		ЭСФКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОбновитьДокументыЭСФ(Команда)
	
	МассивПомеченныхСтрок = МассивПомеченныхСтрокТаблицыЗагружаемыеЭСФ();
	Если МассивПомеченныхСтрок.Количество() = 0 Тогда
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выберите хотя бы один электронный счет-фактуру для создания и обновления.'"));
		Возврат;
	КонецЕсли;	
	
	ТекстВопроса = НСтр("ru = 'Создать новые и обновить существующие электронные счета-фактуры?'");
	СоздатьОбновитьДокументыЭСФЗавершение = Новый ОписаниеОповещения("СоздатьОбновитьДокументыЭСФЗавершение", ЭтаФорма);
	ПоказатьВопрос(СоздатьОбновитьДокументыЭСФЗавершение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОбновитьДокументыЭСФЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		
		СоздатьОбновитьДокументыЭСФНаСервере();
		
		ЭСФКлиент.ОповеститьФормы(ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ());
		
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Создание новых и обновление существующих электронных счетов-фактур успешно завершено.'"));
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СоздатьОбновитьДокументыЭСФНаСервере()

	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	ТабЗначЗагружаемыеЭСФ = РеквизитФормыВЗначение("ЗагружаемыеЭСФ");
	
	ОбработкаОбменЭСФ.СоздатьОбновитьЗагружаемыеЭСФ(СтруктурнаяЕдиница, ТабЗначЗагружаемыеЭСФ);	
	
	ЗначениеВРеквизитФормы(ТабЗначЗагружаемыеЭСФ, "ЗагружаемыеЭСФ");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого СтрокаЗагружаемыеЭСФ Из ЗагружаемыеЭСФ Цикл 
		СтрокаЗагружаемыеЭСФ.Пометка = Истина;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого СтрокаЗагружаемыеЭСФ Из ЗагружаемыеЭСФ Цикл 
		СтрокаЗагружаемыеЭСФ.Пометка = Ложь;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСозданныйЭСФ(Команда)
	
	ОткрытьЭСФ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	ПредварительныйПросмотрНаКлиенте();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗагрузитьИзФайловНаКлиенте()
	
	#Если ВебКлиент Тогда
		
	АдресФайла = "";
	ВыбранноеИмяФайла = "";
	ПомещениеФайлаЗавершение = Новый ОписаниеОповещения("ЗагрузитьИзФайловНаВебКлиентеЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(ПомещениеФайлаЗавершение,АдресФайла, ,,Новый УникальныйИдентификатор)
	
	#Иначе
		
		МассивАдресовЗагружаемыхФайлов = МассивАдресовДвоичныхДанныхЗагружаемыхФайлов();
		
		Если МассивАдресовЗагружаемыхФайлов.Количество() <> 0 Тогда
			ЗагрузитьИзФайловНаСервере(МассивАдресовЗагружаемыхФайлов);
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайловНаВебКлиентеЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		МассивФайлов = Новый Массив;
		
		Файл = ЭСФВызовСервера.ИнфомацияПоФайлу(ВыбранноеИмяФайла);
		
		Если Файл.Расширение = ".xml" ИЛИ Файл.Расширение = ".txt" Тогда
			ОписаниеФайла = Новый Структура("Имя, Адрес", ВыбранноеИмяФайла, Адрес);
			МассивФайлов.Добавить(ОписаниеФайла);	
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Выбран некорректный файл. Необходимо выбрать файл с расширением ""xml"".'"));
		КонецЕсли;
		
		Если МассивФайлов.Количество() <> 0 Тогда
			ЗагрузитьИзФайловНаСервере(МассивФайлов);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры


&НаСервере
Процедура ЗагрузитьИзФайловНаСервере(Знач МассивАдресовЗагружаемыхФайлов)
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	
	ТабЗначЗагружаемыеЭСФ = РеквизитФормыВЗначение("ЗагружаемыеЭСФ");
	
	ОбработкаОбменЭСФ.ЗаполнитьТаблицуЗагружаемыеЭСФ(МассивАдресовЗагружаемыхФайлов, СтруктурнаяЕдиница, ТабЗначЗагружаемыеЭСФ);
	
	ЗначениеВРеквизитФормы(ТабЗначЗагружаемыеЭСФ, "ЗагружаемыеЭСФ");
	
КонецПроцедуры

// Возвращает массив, каждый элемент которого содержит имя и данные файла.
//
// Возвращаемое значение:
//  Массив - Описание выбранных файлов. Каждый элемент массива:
//   Структура
//    |- Имя - Строка - Полное имя файла на клиенте, включая расширение.
//    |- Адрес - Строка - Адрес двоичных данных файла во временном хранилище.
//
&НаКлиенте
Функция МассивАдресовДвоичныхДанныхЗагружаемыхФайлов()
	
	МассивФайлов = Новый Массив;
	
	#Если ВебКлиент Тогда
		
		АдресФайла = "";
		ВыбранноеИмяФайла = "";
		
		Если ПоместитьФайл(АдресФайла, , ВыбранноеИмяФайла, , Новый УникальныйИдентификатор) Тогда 
			
			Файл = ЭСФВызовСервера.ИнфомацияПоФайлу(ВыбранноеИмяФайла);
			
			Если Файл.Расширение = ".xml" ИЛИ Файл.Расширение = ".txt" Тогда
				ОписаниеФайла = Новый Структура("Имя, Адрес", ВыбранноеИмяФайла, АдресФайла);
				МассивФайлов.Добавить(ОписаниеФайла);	
			Иначе
				ПоказатьПредупреждение(, НСтр("ru = 'Выбран некорректный файл. Необходимо выбрать файл с расширением ""xml"".'"));
			КонецЕсли;
			
		КонецЕсли;
		
	#Иначе
		
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);	
		ДиалогВыбораФайла.Фильтр = "Пакет электронных счетов-фактур (*.xml)|*.xml"; 
		ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
		ДиалогВыбораФайла.МножественныйВыбор = Истина;
		
		Если ДиалогВыбораФайла.Выбрать() Тогда
			Для Каждого ПолноеИмяФайла Из ДиалогВыбораФайла.ВыбранныеФайлы Цикл
				ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
				АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные); 
				ОписаниеФайла = Новый Структура("Имя, Адрес", ПолноеИмяФайла, АдресФайла);
				МассивФайлов.Добавить(ОписаниеФайла);	
			КонецЦикла;
		КонецЕсли;	
		
	#КонецЕсли
	
	Возврат МассивФайлов;
	
КонецФункции

&НаКлиенте
Функция МассивПомеченныхСтрокТаблицыЗагружаемыеЭСФ()
	
	МассивПомеченныхСтрок = Новый Массив;
	
	Для Каждого СтрокаЗагружаемыеЭСФ Из ЗагружаемыеЭСФ Цикл
		Если СтрокаЗагружаемыеЭСФ.Пометка Тогда
			МассивПомеченныхСтрок.Добавить(СтрокаЗагружаемыеЭСФ);	
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивПомеченныхСтрок;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьЭСФ()
	
	ТекущиеДанные = Элементы.ЗагружаемыеЭСФ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ЭСФ) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ЭСФ);
		Иначе
			ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для загружаемого ЭСФ в информационной базе отсутствует созданный ЭСФ.'"));			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрНаКлиенте()
	
	ТекущиеДанные = Элементы.ЗагружаемыеЭСФ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
		
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("Организация", ТекущиеДанные.Организация);
		Реквизиты.Вставить("СтруктурноеПодразделение", ТекущиеДанные.СтруктурноеПодразделение);
		Реквизиты.Вставить("Состояние", ТекущиеДанные.Состояние);
		Реквизиты.Вставить("Направление", ТекущиеДанные.Направление);
		
		Основание = Новый Структура;
		Основание.Вставить("ПросмотрЗагружаемогоЭСФ", Истина);
		Основание.Вставить("XML", ТекущиеДанные.XML);
		Основание.Вставить("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
		Основание.Вставить("Реквизиты", Реквизиты);
		
		ПараметрыФормы.Вставить("Основание", Основание);
		
		ОткрытьФорму("Документ.ЭСФ.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, ТекущиеДанные.Идентификатор);
		
	КонецЕсли;
	
КонецПроцедуры
