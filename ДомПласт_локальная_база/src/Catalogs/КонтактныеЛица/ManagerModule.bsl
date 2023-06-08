#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавленноеКонтактноеЛицо(ДанныеЗаполнения)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Фамилия КАК Фамилия,
	|	КонтактныеЛица.Имя КАК Имя,
	|	КонтактныеЛица.Отчество КАК Отчество,
	|	КонтактныеЛица.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ГДЕ
	|	КонтактныеЛица.ОбъектВладелец = &ОбъектВладелец
	|	И НЕ КонтактныеЛица.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ОбъектВладелец", ДанныеЗаполнения.Владелец);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Врег(ВыборкаДетальныеЗаписи.Фамилия)   = Врег(ДанныеЗаполнения.Фамилия)
			И Врег(ВыборкаДетальныеЗаписи.Имя)      = Врег(ДанныеЗаполнения.Имя)
			И Врег(ВыборкаДетальныеЗаписи.Отчество) = Врег(ДанныеЗаполнения.Отчество) Тогда
			Возврат Неопределено;
		КонецЕсли; 
	КонецЦикла;
	
	ОбъектКИ = Справочники.КонтактныеЛица.СоздатьЭлемент();
	ОбъектКИ.ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента;
	ОбъектКИ.ОбъектВладелец = ДанныеЗаполнения.Владелец;
	ОбъектКИ.Фамилия 		= ?(ДанныеЗаполнения.Свойство("Фамилия"), ДанныеЗаполнения.Фамилия, Неопределено);
	ОбъектКИ.Имя 			= ?(ДанныеЗаполнения.Свойство("Имя"), ДанныеЗаполнения.Имя, Неопределено);
	ОбъектКИ.Отчество 		= ?(ДанныеЗаполнения.Свойство("Отчество"), ДанныеЗаполнения.Отчество, Неопределено);
	ОбъектКИ.Наименование 	= ОбъектКИ.Фамилия+" "+ОбъектКИ.Имя+" "+ОбъектКИ.Отчество;
	ОбъектКИ.Должность		= "Руководитель организации";  
	
	ОбъектКИ.Записать();
	
	Возврат ОбъектКИ.Ссылка;
	
КонецФункции
#КонецЕсли
