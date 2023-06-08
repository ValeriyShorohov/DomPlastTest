#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ Значение Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиПользователей.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
		|ГДЕ
		|	НастройкиПользователей.Настройка = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НастройкиПользователей.УчетПоВсемОрганизациям)
		|	И НастройкиПользователей.Значение = ИСТИНА";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
			
			НаборЗаписей.Отбор.Пользователь.Установить(ВыборкаДетальныеЗаписи.Пользователь);
			НаборЗаписей.Отбор.Настройка.Установить(ПланыВидовХарактеристик.НастройкиПользователей.УчетПоВсемОрганизациям);
			НаборЗаписей.Записать();
			
			Запись = НаборЗаписей.Добавить();
			
			Запись.Пользователь = ВыборкаДетальныеЗаписи.Пользователь;
			Запись.Настройка    = ПланыВидовХарактеристик.НастройкиПользователей.УчетПоВсемОрганизациям;
			Запись.Значение     = Ложь;
			
			Попытка
				НаборЗаписей.Записать();
			Исключение
				ТекстСообщения = НСтр("ru='При установке в настройках пользователя %1 значения учета по всем организациям произошла ошибка: %2'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаДетальныеЗаписи.Пользователь, ОписаниеОшибки());
				ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Константы.НеИспользоватьНесколькоОрганизаций.Установить(НЕ ЭтотОбъект.Значение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
