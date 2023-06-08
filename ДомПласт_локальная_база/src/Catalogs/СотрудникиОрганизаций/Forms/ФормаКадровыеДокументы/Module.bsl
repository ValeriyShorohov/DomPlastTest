
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СсылкаНаСотрудника",СсылкаНаСотрудника);
	Если Не ЗначениеЗаполнено(СсылкаНаСотрудника) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	СсылкаНаСотрудника = Параметры.СсылкаНаСотрудника;
	СформироватьСписокКадровыхДокументов();

КонецПроцедуры

&НаСервере
Процедура СформироватьСписокКадровыхДокументов()
	
	КадровыеДокументы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка КАК Ссылка,
	|	КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка.Дата КАК Дата,
	|	КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка.Номер КАК Номер,
	|	ВЫБОР
	|		КОГДА КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.ПриемНаРаботуВОрганизацию
	|			ТОГДА ""Прием на работу в организации""
	|		КОГДА КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.КадровоеПеремещениеОрганизаций
	|			ТОГДА ""Кадровое перемещение организаций""
	|		КОГДА КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.УвольнениеИзОрганизаций
	|			ТОГДА ""Увольнение из организаций""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ТипДокумента
	|ИЗ
	|	КритерийОтбора.ДокументыПоСотрудникуОрганизации(&Сотрудник) КАК КритерийОтбораДокументыПоСотрудникуОрганизации
	|ГДЕ
	|	(КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.ПриемНаРаботуВОрганизацию
	|			ИЛИ КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.КадровоеПеремещениеОрганизаций
	|			ИЛИ КритерийОтбораДокументыПоСотрудникуОрганизации.Ссылка ССЫЛКА Документ.УвольнениеИзОрганизаций)";
	
	Запрос.УстановитьПараметр("Сотрудник", СсылкаНаСотрудника);
	
	КадровыеДокументы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
