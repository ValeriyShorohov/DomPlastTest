////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяПредопределенногоЭлемента = Объект.Ссылка.ИмяПредопределенныхДанных;
	
	Текст = НСтр("ru = 'Обработка ""%1"", встроенная в конфигурацию.'");
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, ИмяПредопределенногоЭлемента);
	Элементы.ИмяОбработки.Заголовок = Текст;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДвоичныеДанныеФайла = ТекущийОбъект.ХранилищеОбработки.Получить();
	
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		АдресФайла = "";	
	Иначе
		АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, ЭтаФорма.УникальныйИдентификатор);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.БезопасныйРежим = Ложь;
	Объект.ИмяОбъекта = ИмяПредопределенногоЭлемента;
	Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	Объект.Публикация = ПредопределенноеЗначение("Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(АдресФайла) И Объект.ВнешнийОбъектИспользовать = 1 Тогда
		
		ТекстСообщения = НСтр("ru = 'Выбран режим использования обработки ""Файл"", но не указан файл обработки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ИмяФайла", , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПустаяСтрока(АдресФайла) Тогда
		ТекущийОбъект.ХранилищеОбработки = Неопределено;
	Иначе
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
		ТекущийОбъект.ХранилищеОбработки = Новый ХранилищеЗначения(ДвоичныеДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);	
	НачатьПомещениеФайла(ОписаниеЗавершения, , , Истина, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		АдресФайла = Адрес;
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВыбранноеИмяФайла, "\");
		Объект.ИмяФайла = МассивПодстрок.Получить(МассивПодстрок.ВГраница());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ЗначениеЗаполнено(АдресФайла) Тогда
		ПолучитьФайл(АдресФайла, Объект.ИмяФайла, Истина);	
	Иначе
		Сообщить(НСтр("ru = 'Отсутствует файл внешней обработки для сохранения.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	АдресФайла = "";
	Объект.ИмяФайла = "";
	
КонецПроцедуры
