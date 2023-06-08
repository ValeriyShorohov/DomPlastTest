#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		ДополнительныеСвойства.Вставить("ИзмениласьПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ИзмениласьПометкаУдаления") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭДПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	Справочник.ПакетОбменСБанкамиПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
		|ГДЕ
		|	ЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
		Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
		
		Результат = Запрос.Выполнить().Выбрать();
		Пока результат.Следующий() Цикл
			Объект = Результат.Ссылка.ПолучитьОбъект();
			Объект.ПометкаУдаления = ПометкаУдаления;
			Объект.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Иначе
	
#Область Инициализация
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецОбласти
	
#КонецЕсли