
#Область СлужебныйПрограммныйИнтерфейс

// Обработчик команды формы отчета.
//
// Параметры:
//   Форма     - ФормаКлиентскогоПриложения - Форма отчета.
//   Команда   - КомандаФормы     - Команда, которая была вызвана.
//
// Места использования:
//   ОбщаяФорма.ФормаОтчета.Подключаемый_Команда().
//
Процедура НастроитьРассылкуИзОтчета(Форма) Экспорт
	
	НастройкиОтчета = Форма.НастройкиОтчета;
	РежимВариантаОтчета = (ТипЗнч(Форма.КлючТекущегоВарианта) = Тип("Строка") И Не ПустаяСтрока(Форма.КлючТекущегоВарианта));
	
	НастройкиКомпоновщика = Форма.Отчет.КомпоновщикНастроек.Настройки;
	НастройкиКомпоновщика.Отбор.ИдентификаторПользовательскойНастройки              = "Отбор";
	НастройкиКомпоновщика.Порядок.ИдентификаторПользовательскойНастройки            = "Порядок";
	НастройкиКомпоновщика.УсловноеОформление.ИдентификаторПользовательскойНастройки = "УсловноеОформление";
	
	СтрокаОтчетыПараметры = Новый Структура("ОтчетПолноеИмя, КлючВарианта, ВариантСсылка, Настройки, АдресНастроекОтчета");
	СтрокаОтчетыПараметры.ОтчетПолноеИмя = НастройкиОтчета.ПолноеИмя;
	СтрокаОтчетыПараметры.КлючВарианта   = Форма.КлючТекущегоВарианта;
	СтрокаОтчетыПараметры.ВариантСсылка  = НастройкиОтчета.ВариантСсылка;
	ПользовательскиеНастройки = Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	Если РежимВариантаОтчета Тогда
		СтрокаОтчетыПараметры.Настройки = Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
		СтрокаОтчетыПараметры.АдресНастроекОтчета = НастройкиОтчета.АдресНастроекОтчета;
	Иначе
		СтрокаОтчетыПараметры.Настройки = ПользовательскиеНастройки.ДополнительныеСвойства.ДанныеОтчетаРассылка;
		СтрокаОтчетыПараметры.АдресНастроекОтчета = НастройкиОтчета.АдресНастроекОтчета;
	КонецЕсли;
	
	ПрисоединяемыеОтчеты = Новый Массив;
	ПрисоединяемыеОтчеты.Добавить(СтрокаОтчетыПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединяемыеОтчеты", ПрисоединяемыеОтчеты);
	ПараметрыФормы.Вставить("ТабличныйДокумент", Форма.Результат);
	
	Если НастройкиОтчета.Свойство("РассылкаОтчетаСсылка") И ЗначениеЗаполнено(НастройкиОтчета.РассылкаОтчетаСсылка) Тогда
		ПараметрыФормы.Вставить("Ключ", НастройкиОтчета.РассылкаОтчетаСсылка);
	КонецЕсли;
	
	Если НастройкиОтчета.Свойство("ВариантРасписания") Тогда
		ПараметрыФормы.Вставить("ВариантРасписания", НастройкиОтчета.ВариантРасписания);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.РассылкиОтчетов.Форма.НастройкаРассылкиБК",
		ПараметрыФормы,
		Форма,
		Строка(Форма.УникальныйИдентификатор) + ".ОткрытьРассылкуОтчетов");
	
КонецПроцедуры

Процедура ПередЗакрытием(Форма) Экспорт
		
	Форма.ПользовательскиеНастройкиМодифицированы = Ложь;
	НастройкиОтчета = Форма.НастройкиОтчета;
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("АдресНастроек", НастройкиОтчета.АдресНастроекОтчета);
	ПараметрыОповещения.Вставить("ИдентификаторСтрокиОтчета" , НастройкиОтчета.ИдентификаторСтрокиОтчета);
	ПараметрыОповещения.Вставить("ИдентификаторФормыРассылки", НастройкиОтчета.ИдентификаторФормыРассылки);
	ПараметрыОповещения.Вставить("ПолноеИмя", НастройкиОтчета.ПолноеИмя);
	Оповестить("Рассылки_ЗакрытиеОтчета", ПараметрыОповещения); 
		
КонецПроцедуры

#КонецОбласти
