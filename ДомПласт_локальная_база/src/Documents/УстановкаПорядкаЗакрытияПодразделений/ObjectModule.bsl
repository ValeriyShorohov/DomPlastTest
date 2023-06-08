#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

КонецПроцедуры   

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверитьЗаполнениеТабличнойЧастиПострочно(ПорядокЗакрытия, "ПорядокЗакрытия", Отказ);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.УстановкаПорядкаЗакрытияПодразделений.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	Документы.УстановкаПорядкаЗакрытияПодразделений.СформироватьДвиженияПорядокЗакрытияПодразделений(ПараметрыПроведения.ТаблицаПодразделения,
		ПараметрыПроведения.ТаблицаРеквизитов, Движения, Отказ);
		
КонецПроцедуры     

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ)
	
	ТаблицаПодразделений = Новый Массив;
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		Если ТаблицаПодразделений.Найти(СтрокаТабличнойЧасти.Подразделение) = Неопределено Тогда
			ТаблицаПодразделений.Добавить(СтрокаТабличнойЧасти.Подразделение);
		Иначе		
			ТекстСообщения = НСтр("ru='В строке «%1» дублируется подразделение, введенное ранее в табличной части «%2»'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ТекстСообщения,
							СтрокаТабличнойЧасти.НомерСтроки,
							"Порядок закрытия");

			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Подразделение";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;     		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
