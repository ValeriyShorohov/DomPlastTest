#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение(Объект) Экспорт
	
	ГоловнаяОрганизация = ОбщегоНазначенияБКВызовСервера.ГоловнаяОрганизацияДляУчетаЗарплаты(Объект.Организация);
	
	// Виды платежей по ОПВ, по которым будет считаться пеня (чтобы не начислять пени на сумму самой пени)
	СписокВидовПлатежей = Новый СписокЗначений;	
	СписокВидовПлатежей.Добавить(Перечисления.ВидыПлатежейВБюджетИФонды.Налог);
	СписокВидовПлатежей.Добавить(Перечисления.ВидыПлатежейВБюджетИФонды.НалогАкт);
	СписокВидовПлатежей.Добавить(Перечисления.ВидыПлатежейВБюджетИФонды.НалогСам);
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("парамНачало" 				 , Объект.ДатаНачала);
	Запрос.УстановитьПараметр("парамКонец" 					 , КонецДня(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("парамПослеКонца" 			 , КонецДня(Объект.ДатаОкончания)+1);
	Запрос.УстановитьПараметр("парамПериодРегистрации" 		 , Объект.ПериодРегистрации);
	Запрос.УстановитьПараметр("парамОрганизация" 			 , Объект.Организация);
	Запрос.УстановитьПараметр("парамСтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("парамГоловнаяОрганизация" 	 , ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("парамПользователь" 			 , Объект.Ответственный);
	Запрос.УстановитьПараметр("парамПодразделение" 			 , Объект.ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("Уволен"						 , Перечисления.ПричиныИзмененияСостояния.Увольнение);
	Запрос.УстановитьПараметр("Принят"						 , Перечисления.ПричиныИзмененияСостояния.ПриемНаРаботу);
	Запрос.УстановитьПараметр("парамПриход"					 , ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("парамРасход"					 , ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("парамНалогВзнос"				 , Перечисления.ВидыПлатежейВБюджетИФонды.Налог);
	Запрос.УстановитьПараметр("парамИсчисление"				 , Перечисления.РасчетыСБюджетомФондамиВидСтроки.Исчисление);
	Запрос.УстановитьПараметр("парамПеречисление"			 , Перечисления.РасчетыСБюджетомФондамиВидСтроки.Перечисление);
	Запрос.УстановитьПараметр("ВнутреннееСовместительство"	 , Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);
	Запрос.УстановитьПараметр("СрокПоМесяцуВыплатыДоходов"	 , Перечисления.ПорядокОпределенияСрокаПеречисления.ПоМесяцуВыплатыДоходов);
	Запрос.УстановитьПараметр("ПустаяОрганизация"			 , Справочники.Организации.ПустаяСсылка());
	Запрос.УстановитьПараметр("СписокВидовПлатежей"			 , СписокВидовПлатежей);
	Запрос.УстановитьПараметр("ВидПени"						 , Объект.ВидПлатежа);
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОПВ
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВ Тогда
		Запрос.УстановитьПараметр("НалогСборОтчисление", Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы);
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениСО
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениСО Тогда
		Запрос.УстановитьПараметр("НалогСборОтчисление", Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления);
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОППВ
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОППВ Тогда
		Запрос.УстановитьПараметр("НалогСборОтчисление", Справочники.НалогиСборыОтчисления.ОбязательныеПрофессиональныеПенсионныеВзносы);
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениВОСМС
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениВОСМС Тогда
		Запрос.УстановитьПараметр("НалогСборОтчисление", Справочники.НалогиСборыОтчисления.ВзносыОбязательноеСоциальноеМедицинскоеСтрахование);
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениООСМС
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениООСМС Тогда
		Запрос.УстановитьПараметр("НалогСборОтчисление", Справочники.НалогиСборыОтчисления.ОтчисленияОбязательноеСоциальноеМедицинскоеСтрахование);
	КонецЕсли;
	
	ПустоеПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	
	Если Объект.ПодразделениеОрганизации = ПустоеПодразделение Тогда
		ПоВсемПодразделениямОрганизации = Истина;
		УсловиеНаПодразделение = "СписокФизЛиц.Подразделение.Владелец = &парамОрганизация";
	Иначе
		ПоВсемПодразделениямОрганизации = Ложь;
		УсловиеНаПодразделение = "СписокФизЛиц.Подразделение В ИЕРАРХИИ (&парамПодразделение)";
	КонецЕсли;
	
	// условие структурное подразделение
	УсловиеНаПодразделение = УсловиеНаПодразделение + " И СписокФизЛиц.СтруктурноеПодразделение = &парамСтруктурноеПодразделение";
	
	// определим работников, работающих в указанном подразделении на конец периода
	СписокРаботниковТекст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РаботникиОрганизации.Сотрудник.Физлицо КАК ФизЛицо,
	|	РаботникиОрганизации.ПодразделениеОрганизации КАК Подразделение,
	|	РаботникиОрганизации.СтруктурноеПодразделение КАК СтруктурноеПодразделение
	|ИЗ
	|	(ВЫБРАТЬ
	|		РаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|		МАКСИМУМ(ВЫБОР
	|				КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = &Уволен
	|					ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|				ИНАЧЕ РаботникиОрганизации.Период
	|			КОНЕЦ) КАК Период
	|	ИЗ
	|		РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|	ГДЕ
	|		РаботникиОрганизации.Организация = &парамГоловнаяОрганизация
	|		И РаботникиОрганизации.ОбособленноеПодразделение = &парамОрганизация
	|		И РаботникиОрганизации.Период <= &парамКонец
	|		И РаботникиОрганизации.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство
	|		И РаботникиОрганизации.Активность
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиОрганизации.Сотрудник.Физлицо) КАК ДатыПоследнихНазначений
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|		ПО ДатыПоследнихНазначений.Физлицо = РаботникиОрганизации.Сотрудник.Физлицо
	|			И (ДатыПоследнихНазначений.Период = ВЫБОР
	|				КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = &Уволен
	|					ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|				ИНАЧЕ РаботникиОрганизации.Период
	|			КОНЕЦ)
	|			И (РаботникиОрганизации.Организация = &парамГоловнаяОрганизация)
	|			И (РаботникиОрганизации.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство)
	|			И РаботникиОрганизации.Активность
	|";
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОПВ
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениСО
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОППВ
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениВОСМС
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениООСМС Тогда
		
		// определяем тех физлиц, по которым производилось исчисление взносов и отчислений за указанный пользователем период
		Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОПВ Тогда
			ИмяРегистра = "ОПВРасчетыСФондами";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениСО Тогда
			ИмяРегистра = "СОРасчетыСФондами";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОППВ Тогда
			ИмяРегистра = "ОППВРасчетыСФондами";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениВОСМС Тогда
			ИмяРегистра = "ВОСМСРасчетыСФондами";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениООСМС Тогда
			ИмяРегистра = "ООСМСРасчетыСФондами";
		КонецЕсли;
		
		ДанныеРегистраТекст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Регистр.Физлицо,
		|	НАЧАЛОПЕРИОДА(Регистр.МесяцНалоговогоПериода, МЕСЯЦ) КАК МесяцНалоговогоПериода,
		|	&парамНачало КАК СрокПеречисления // в данном запросе значение не важно, любое кроме NULL - потом используется для проверки заполненности
		|ИЗ
		|	РегистрНакопления." + ИмяРегистра + " КАК Регистр
		|ГДЕ
		|	Регистр.Организация = &парамОрганизация
		|	И Регистр.Период МЕЖДУ &парамНачало И &парамКонец
		|	И Регистр.ВидПлатежа = &парамНалогВзнос
		|	И Регистр.ВидСтроки = &парамИсчисление
		|	И Регистр.Активность
		|";	
		
	Иначе // авторасчет
		
		Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВ Тогда
			ИмяРегистра = "ОПВПодлежитПеречислениюВФонды";
			ПолеМесяцВыплатыДоходов = "МесяцВыплатыДоходов";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениСО Тогда
			ИмяРегистра = "СОРасчетыСФондами";
			ПолеМесяцВыплатыДоходов = "МесяцНалоговогоПериода";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОППВ Тогда 
			ИмяРегистра = "ОППВРасчетыСФондами";
			ПолеМесяцВыплатыДоходов = "МесяцНалоговогоПериода";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениВОСМС Тогда 
			ИмяРегистра = "ВОСМСПодлежитПеречислениюВФонды";
			ПолеМесяцВыплатыДоходов = "МесяцНалоговогоПериода";
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениООСМС Тогда 
			ИмяРегистра = "ООСМСРасчетыСФондами";
			ПолеМесяцВыплатыДоходов = "МесяцНалоговогоПериода";
		КонецЕсли;
		
		// сроки перечисления 
		СрокиПеречисленияТекст = "
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.Месяц,
		|	СрокиПеречисленияНалоговСборовОтчислений.СрокПеречисления,
		|	СрокиПеречисленияНалоговСборовОтчислений.ПорядокОпределенияСрокаПеречисления
		|ИЗ
		|	(ВЫБРАТЬ
		|		МИНИМУМ(ВложенныйЗапрос.Приоритет) КАК Приоритет,
		|		ВложенныйЗапрос.Месяц КАК Месяц
		|	ИЗ
		|		(ВЫБРАТЬ
		|			1 КАК Приоритет,
		|			НАЧАЛОПЕРИОДА(СрокиПеречисления.Месяц, МЕСЯЦ) КАК Месяц
		|		ИЗ
		|			РегистрСведений.СрокиПеречисленияНалоговСборовОтчислений КАК СрокиПеречисления
		|		ГДЕ
		|			СрокиПеречисления.ВидНалога = &НалогСборОтчисление
		|			И СрокиПеречисления.Организация = &парамОрганизация
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			2,
		|			НАЧАЛОПЕРИОДА(СрокиПеречисления.Месяц, МЕСЯЦ)
		|		ИЗ
		|			РегистрСведений.СрокиПеречисленияНалоговСборовОтчислений КАК СрокиПеречисления
		|		ГДЕ
		|			СрокиПеречисления.ВидНалога = &НалогСборОтчисление
		|			И СрокиПеречисления.Организация = &ПустаяОрганизация) КАК ВложенныйЗапрос
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВложенныйЗапрос.Месяц) КАК ВложенныйЗапрос
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиПеречисленияНалоговСборовОтчислений КАК СрокиПеречисленияНалоговСборовОтчислений
		|		ПО ВложенныйЗапрос.Месяц = НАЧАЛОПЕРИОДА(СрокиПеречисленияНалоговСборовОтчислений.Месяц, МЕСЯЦ)
		|			И (ВЫБОР
		|				КОГДА ВложенныйЗапрос.Приоритет = 1
		|					ТОГДА СрокиПеречисленияНалоговСборовОтчислений.Организация = &парамОрганизация
		|				ИНАЧЕ СрокиПеречисленияНалоговСборовОтчислений.Организация = &ПустаяОрганизация
		|			КОНЕЦ)
		|			И (СрокиПеречисленияНалоговСборовОтчислений.ВидНалога = &НалогСборОтчисление)";
		
		// Физлица, по которым было перечисление взносов и отчислений с истекшим сроком за указанный пользователем в документе период 
		// либо по которым остались просроченные взносов и отчислений на конец периода
		
		ДанныеРегистраТекст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Регистр.ФизЛицо,
		|	НАЧАЛОПЕРИОДА(Регистр.МесяцНалоговогоПериода, МЕСЯЦ) КАК МесяцНалоговогоПериода,
		|	СрокиПеречисления.СрокПеречисления
		|ИЗ
		|	РегистрНакопления." + ИмяРегистра + " КАК Регистр
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ (" + СрокиПеречисленияТекст + ") КАК СрокиПеречисления
		|		ПО ВЫБОР
		|				КОГДА СрокиПеречисления.ПорядокОпределенияСрокаПеречисления = &СрокПоМесяцуВыплатыДоходов
		|					ТОГДА НАЧАЛОПЕРИОДА(Регистр." + ПолеМесяцВыплатыДоходов + ", МЕСЯЦ) = СрокиПеречисления.Месяц
		|				ИНАЧЕ НАЧАЛОПЕРИОДА(Регистр.МесяцНалоговогоПериода, МЕСЯЦ) = СрокиПеречисления.Месяц
		|			КОНЕЦ
		|ГДЕ
		|	Регистр.Период МЕЖДУ &парамНачало И &парамКонец
		|	И Регистр.Организация = &парамОрганизация
		|	И Регистр.ВидСтроки = &парамПеречисление
		|	И (СрокиПеречисления.СрокПеречисления ЕСТЬ NULL
		|		ИЛИ НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) > СрокиПеречисления.СрокПеречисления)
		|	И Регистр.Активность
		|	" + ?(ИмяРегистра = "СОРасчетыСФондами", "
		|	И Регистр.ВидПлатежа В (&СписокВидовПлатежей)", "") + "
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Регистр.ФизЛицо,
		|	НАЧАЛОПЕРИОДА(Регистр.МесяцНалоговогоПериода, МЕСЯЦ) КАК МесяцНалоговогоПериода,
		|	СрокиПеречисления.СрокПеречисления
		|ИЗ
		|	РегистрНакопления." + ИмяРегистра + ".Остатки(
		|			&парамПослеКонца,
		|			Организация = &парамОрганизация
		|			" + ?(ИмяРегистра = "СОРасчетыСФондами", " И ВидПлатежа В (&СписокВидовПлатежей)", "") + " 
		|			) КАК Регистр
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ (" + СрокиПеречисленияТекст + ") КАК СрокиПеречисления
		|		ПО ВЫБОР
		|				КОГДА СрокиПеречисления.ПорядокОпределенияСрокаПеречисления = &СрокПоМесяцуВыплатыДоходов
		|					ТОГДА НАЧАЛОПЕРИОДА(Регистр." + ПолеМесяцВыплатыДоходов + ", МЕСЯЦ) = СрокиПеречисления.Месяц
		|				ИНАЧЕ НАЧАЛОПЕРИОДА(Регистр.МесяцНалоговогоПериода, МЕСЯЦ) = СрокиПеречисления.Месяц
		|			КОНЕЦ
		|ГДЕ
		|	(СрокиПеречисления.СрокПеречисления ЕСТЬ NULL
		|		ИЛИ НАЧАЛОПЕРИОДА(&парамКонец, ДЕНЬ) > СрокиПеречисления.СрокПеречисления)
		|";
		
	КонецЕсли;
	
	// Окончательный список физлиц с учетом подразделения
	// Также выбираем тех физлиц, кто вообще не является работником,
	// но по ним возникли просроченные суммы ОПВ (ОППВ, СО) и не было за период начисления пени
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОПВ
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВ Тогда
		ИмяРегистра = "ОПВРасчетыСФондами";
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениСО
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениСО Тогда
		ИмяРегистра = "СОРасчетыСФондами";
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОППВ
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОППВ Тогда 
		ИмяРегистра = "ОППВРасчетыСФондами";
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениВОСМС
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениВОСМС Тогда 
		ИмяРегистра = "ВОСМСРасчетыСФондами";
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениООСМС
		Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениООСМС Тогда 
		ИмяРегистра = "ООСМСРасчетыСФондами";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеРегистра.Физлицо,
	|	ДанныеРегистра.МесяцНалоговогоПериода,
	|	МИНИМУМ(ДанныеРегистра.СрокПеречисления) КАК СрокПеречисления,
	|	&парамНачало КАК ДатаНачала,
	|	&парамКонец КАК ДатаОкончания
	|ИЗ
	|	(" + ДанныеРегистраТекст + ") КАК ДанныеРегистра
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (" + СписокРаботниковТекст + ") КАК СписокФизЛиц
	|		ПО ДанныеРегистра.ФизЛицо = СписокФизЛиц.ФизЛицо
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				&парамКонец, 
	|				Организация = &парамГоловнаяОрганизация 
	|				И Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство) КАК РаботникиОрганизации
	|		ПО ДанныеРегистра.ФизЛицо = РаботникиОрганизации.Сотрудник.ФизЛицо
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления." + ИмяРегистра + " КАК РасчетыСФондами
	|		ПО ДанныеРегистра.ФизЛицо = РасчетыСФондами.ФизЛицо
	|			И РасчетыСФондами.Организация = &парамОрганизация
	|			И РасчетыСФондами.Период МЕЖДУ &парамПериодРегистрации И КОНЕЦПЕРИОДА(&парамПериодРегистрации, МЕСЯЦ)
	|			И РасчетыСФондами.ВидПлатежа = &ВидПени
	|			И РасчетыСФондами.ВидДвижения = &парамПриход
	|			И РасчетыСФондами.ВидСтроки = &парамИсчисление
	|			И РасчетыСФондами.ДатаНачала >= &парамНачало
	|			И РасчетыСФондами.ДатаОкончания <= &парамКонец
	|			И РасчетыСФондами.Активность
	|
	|ГДЕ
	|   (" + УсловиеНаПодразделение + ") 
	|
	|	ИЛИ (РаботникиОрганизации.Сотрудник ЕСТЬ NULL
	|			И РасчетыСФондами.ФизЛицо ЕСТЬ NULL)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Физлицо,
	|	ДанныеРегистра.МесяцНалоговогоПериода
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеРегистра.Физлицо.Наименование,
	|	ДанныеРегистра.МесяцНалоговогоПериода
	|";
	
	Запрос.Текст = ТекстЗапроса;
	ТЗИсчислениеПени = Запрос.Выполнить().Выгрузить();
	
	СоответствиеПройденныеМесяцаНалоговогоПериода = Новый Соответствие;
	
	Для Каждого СтрокаТЗ Из ТЗИсчислениеПени Цикл
		Если СтрокаТЗ.СрокПеречисления = NULL Тогда
			Если СоответствиеПройденныеМесяцаНалоговогоПериода.Получить(Год(СтрокаТЗ.МесяцНалоговогоПериода)) = Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнены сроки перечисления налогов, сборов, отчислений за %1 год!'"),
				Формат(СтрокаТЗ.МесяцНалоговогоПериода, "ДФ=гггг"));
				ВызватьИсключение(ТекстСообщения);
				СоответствиеПройденныеМесяцаНалоговогоПериода.Вставить(Год(СтрокаТЗ.МесяцНалоговогоПериода), 1);
			КонецЕсли;
		Иначе
			НоваяСтрока = Объект.ИсчислениеПени.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

// Процедура выполняет расчет строк табличной части документа по данным регистров.
//
// Параметры: ВариантРасчета = "НаДатуДокумента" на дату, "НаКонецМесяца" на конец месяца
//            Исчисление (тип "Булево") = Истина в случае заполнения исчисленными суммами ОПВ
//            							  Ложь в случае заполнения удержанными суммами ОПВ по НУ (суммы к перечислению)
//
Процедура Рассчитать(Объект) Экспорт
	
	ДокументОбъект = Объект.Ссылка.ПолучитьОбъект();
	
	// расчет связан с записью документа и его движений, поэтому выполняется в транзакции
	НачатьТранзакцию();
	
	Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
		ОтменитьТранзакцию();
		Возврат;
	КонецЕсли;
	
	// список физлиц, по которым выполняется расчет
	СписокФизЛицТекст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтрокиТЧ.Физлицо
	|ИЗ
	|	Документ.РасчетПениОПВиСО.ИсчислениеПени КАК СтрокиТЧ
	|ГДЕ
	|	СтрокиТЧ.Ссылка = &парамРегистратор
	|";
	
	// Выполняем расчет в зависимости от вида операции
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВ
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениСО
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОППВ
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениВОСМС
			Или Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениООСМС Тогда
	
		// автоматический расчет пени
			
		ДанныеРасчетаПени = ПроведениеРасчетовСервер.ПолучитьДанныеДляРасчетаПениОПВиСО(Объект.ВидОперации, Объект.Организация, Объект.ДатаНачала, Объект.ДатаОкончания, СписокФизЛицТекст, Новый Структура("парамРегистратор", Объект.Ссылка));
		Если ДанныеРасчетаПени <> Неопределено Тогда
			ПроведениеРасчетовСервер.ЗаполнитьТабличнуюЧастьПоДаннымРасчетаПениОПВиСО(Объект.ВидОперации, Объект.ПериодРегистрации, Объект.ИсчислениеПени, ДанныеРасчетаПени);
		КонецЕсли;
	
	Иначе
	
		Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОПВ Тогда
			ИмяРегистра = "ОПВРасчетыСФондами";
			ИмяРесурса 	= "Взнос";
			
			ПравилоОкругления = ПроведениеРасчетовСервер.ПолучитьПравилоОкругленияВидаРасчета(Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы, Объект.ПериодРегистрации);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениСО Тогда
			ИмяРегистра = "СОРасчетыСФондами";
			ИмяРесурса 	= "Отчисление";
			
			ПравилоОкругления = ПроведениеРасчетовСервер.ПолучитьПравилоОкругленияВидаРасчета(Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления, Объект.ПериодРегистрации);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениОППВ Тогда
 
			ИмяРегистра = "ОППВРасчетыСФондами";
			ИмяРесурса 	= "Взнос";
			
			ПравилоОкругления = ПроведениеРасчетовСервер.ПолучитьПравилоОкругленияВидаРасчета(Справочники.НалогиСборыОтчисления.ОбязательныеПрофессиональныеПенсионныеВзносы, Объект.ПериодРегистрации);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениВОСМС Тогда
 
			ИмяРегистра = "ВОСМСРасчетыСФондами";
			ИмяРесурса 	= "Взнос";
			
			ПравилоОкругления = ПроведениеРасчетовСервер.ПолучитьПравилоОкругленияВидаРасчета(Справочники.НалогиСборыОтчисления.ВзносыОбязательноеСоциальноеМедицинскоеСтрахование, Объект.ПериодРегистрации);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениООСМС Тогда
 
			ИмяРегистра = "ООСМСРасчетыСФондами";
			ИмяРесурса 	= "Отчисление";
			
			ПравилоОкругления = ПроведениеРасчетовСервер.ПолучитьПравилоОкругленияВидаРасчета(Справочники.НалогиСборыОтчисления.ОтчисленияОбязательноеСоциальноеМедицинскоеСтрахование, Объект.ПериодРегистрации);
			
		КонецЕсли;
	
		// распределить сумму документа на физлиц
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("парамРегистратор", Объект.Ссылка);
		Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Объект.ДатаНачала));
		Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.ДатаОкончания));
		Запрос.УстановитьПараметр("Приход", ВидДвиженияНакопления.Приход);
		Запрос.УстановитьПараметр("Исчисление", Перечисления.РасчетыСБюджетомФондамиВидСтроки.Исчисление);
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("НалогВзнос", Перечисления.ВидыПлатежейВБюджетИФонды.Налог);
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СписокФизЛиц.ФизЛицо,
		|	РасчетыСФондамиФЛ.СтруктурнаяЕдиница,
		|	РасчетыСФондамиФЛ.ПодразделениеОрганизации,
		|	РасчетыСФондамиФЛ.МесяцНалоговогоПериода,
		|	ЕСТЬNULL(РасчетыСФондамиФЛ.Сумма, 0) КАК Сумма
		|ИЗ
		|	(" + СписокФизлицТекст + ") КАК СписокФизЛиц
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|							РасчетыСФондами.ФизЛицо,
		|							РасчетыСФондами.СтруктурнаяЕдиница,
		|							РасчетыСФондами.ПодразделениеОрганизации,
		|							НАЧАЛОПЕРИОДА(РасчетыСФондами.МесяцНалоговогоПериода, МЕСЯЦ) КАК МесяцНалоговогоПериода,
		|							СУММА(РасчетыСФондами." + ИмяРесурса + ") КАК Сумма
		|						ИЗ
		|							РегистрНакопления." + ИмяРегистра + " КАК РасчетыСФондами
		|							ВНУТРЕННЕЕ СОЕДИНЕНИЕ (" + СписокФизлицТекст + ") КАК СписокФизЛиц
		|								ПО РасчетыСФондами.ФизЛицо = СписокФизЛиц.ФизЛицо
		|						ГДЕ
		|							РасчетыСФондами.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|							И РасчетыСФондами.Организация = &Организация
		|							И РасчетыСФондами.ВидДвижения = &Приход
		|							И РасчетыСФондами.ВидПлатежа = &НалогВзнос
		|							И РасчетыСФондами.ВидСтроки = &Исчисление
		|							И РасчетыСФондами.Активность
		|						СГРУППИРОВАТЬ ПО
		|							РасчетыСФондами.ФизЛицо,
		|							РасчетыСФондами.СтруктурнаяЕдиница,
		|							РасчетыСФондами.ПодразделениеОрганизации,
		|							НАЧАЛОПЕРИОДА(РасчетыСФондами.МесяцНалоговогоПериода, МЕСЯЦ)) КАК РасчетыСФондамиФЛ
		|		ПО СписокФизЛиц.ФизЛицо = РасчетыСФондамиФЛ.Физлицо
		|			И РасчетыСФондамиФЛ.Сумма > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	СписокФизЛиц.ФизЛицо,
		|	РасчетыСФондамиФЛ.МесяцНалоговогоПериода
		|
		|ИТОГИ СУММА(Сумма)	ПО Общие
		|";
	
		ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если ВыборкаИтоги.Следующий() Тогда
			
			ОбщаяСумма = ВыборкаИтоги.Сумма;
			
			Если ОбщаяСумма = 0 Тогда
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Общая сумма взносов (отчислений) за период %1 по %2 равна нулю. Нет базы для распределения суммы пени!'"), 
								Формат(Объект.ДатаНачала, "ДФ=dd.MM.yyyy"), 
								Формат(Объект.ДатаОкончания, "ДФ=dd.MM.yyyy"));
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");

			Иначе
			
				Объект.ИсчислениеПени.Очистить();
					
				РаспределеннаяСумма = 0;
					
				Выборка = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.Прямой);
				Пока Выборка.Следующий() Цикл
						
					Если Выборка.Сумма <> 0 И Выборка.Сумма <> NULL Тогда
						СтрокаТЧ 						= Объект.ИсчислениеПени.Добавить();
						СтрокаТЧ.ФизЛицо 				= Выборка.ФизЛицо;
						СтрокаТЧ.МесяцНалоговогоПериода = Выборка.МесяцНалоговогоПериода;
						СтрокаТЧ.СтруктурнаяЕдиница		= Выборка.СтруктурнаяЕдиница;
						СтрокаТЧ.ПодразделениеОрганизации = Выборка.ПодразделениеОрганизации;
						СтрокаТЧ.Сумма					= ОбщегоНазначенияБККлиентСервер.ОкруглитьЧисло(Объект.СуммаДокумента * Выборка.Сумма / ОбщаяСумма, ПравилоОкругления.ПорядокОкругления, ПравилоОкругления.МетодОкругления);
						СтрокаТЧ.ДатаНачала 			= НачалоМесяца(Выборка.МесяцНалоговогоПериода);
						СтрокаТЧ.ДатаОкончания 			= КонецМесяца(Выборка.МесяцНалоговогоПериода);
						
						РаспределеннаяСумма 			= РаспределеннаяСумма + СтрокаТЧ.Сумма;
					КонецЕсли;						
					
				КонецЦикла;
			
				Если (РаспределеннаяСумма <> Объект.СуммаДокумента) И (Объект.ИсчислениеПени.Количество() > 0) Тогда
					// остаток на последнюю строку
					СтрокаТЧ = Объект.ИсчислениеПени[Объект.ИсчислениеПени.Количество() - 1];
					СтрокаТЧ.Сумма = СтрокаТЧ.Сумма + (Объект.СуммаДокумента - РаспределеннаяСумма);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
		
	Объект.СуммаДокумента = Объект.ИсчислениеПени.Итог("Сумма");
	
	// Завершаем транзакцию
	ЗафиксироватьТранзакцию();	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(Ссылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Ссылка.ПериодРегистрации);
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	Реквизиты.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	ПараметрыПроведения.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	Запрос.УстановитьПараметр("ПоддержкаРаботыСоСтруктурнымиПодразделениями", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	Запрос.УстановитьПараметр("Организация", 			   Реквизиты.ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ОбособленноеПодразделение", Реквизиты.Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение",  Реквизиты.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации",  Реквизиты.ПодразделениеОрганизации);
	
	// массив пустых значений СтруктурнойЕдиницы
	МассивПустыеСтруктурныеЕдиницы = Новый Массив();
	МассивПустыеСтруктурныеЕдиницы.Добавить(Неопределено);
	МассивПустыеСтруктурныеЕдиницы.Добавить(Справочники.Организации.ПустаяСсылка());
	МассивПустыеСтруктурныеЕдиницы.Добавить(Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустыеСтруктурныеЕдиницы", МассивПустыеСтруктурныеЕдиницы);

	ПодготовитьТаблицыДокумента(Запрос, Реквизиты);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаИсчислениеПени(НомераТаблиц, Реквизиты);

	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда 
		Результат = Запрос.ВыполнитьПакет();
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
	КонецЕсли;
			
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц) 
	
	НомераТаблиц.Вставить("ВременнаяТаблица_ДанныеДокумента", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ВременнаяТаблица_Реквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасчетПениОПВиСО.Дата,
		|	РасчетПениОПВиСО.Организация,
		|	РасчетПениОПВиСО.ПодразделениеОрганизации,
		|	ЕСТЬNULL(РасчетПениОПВиСО.ПодразделениеОрганизации.ЯвляетсяСтруктурнымПодразделением, ЛОЖЬ) КАК ЯвляетсяСтруктурнымПодразделением,
		|	РасчетПениОПВиСО.СтруктурноеПодразделение,
		|	РасчетПениОПВиСО.ПериодРегистрации,
		|	РасчетПениОПВиСО.Ссылка,
		|	РасчетПениОПВиСО.ВидПлатежа,
		|	РасчетПениОПВиСО.ВидОперации
		|ПОМЕСТИТЬ ВТ_ДанныеДокумента
		|ИЗ
		|	Документ.РасчетПениОПВиСО КАК РасчетПениОПВиСО
		|ГДЕ
		|	РасчетПениОПВиСО.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.ПодразделениеОрганизации,
		|	ДанныеДокумента.ЯвляетсяСтруктурнымПодразделением,
		|	ДанныеДокумента.СтруктурноеПодразделение,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(УчетнаяПолитикаПоПерсоналуОрганизаций.ВестиУчетПоГоловнойОрганизации, ИСТИНА)
		|			ТОГДА ВЫБОР
		|					КОГДА ДанныеДокумента.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|						ТОГДА ДанныеДокумента.Организация
		|					ИНАЧЕ ДанныеДокумента.Организация.ГоловнаяОрганизация
		|				КОНЕЦ
		|		ИНАЧЕ ДанныеДокумента.Организация
		|	КОНЕЦ КАК ГоловнаяОрганизация,
		|	ДанныеДокумента.ПериодРегистрации,
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.ВидПлатежа,
		|	ДанныеДокумента.ВидОперации,
		|	УчетнаяПолитикаНалоговыйУчет.РаспределятьНалогиПоСтруктурнымЕдиницам,
		|	УчетнаяПолитикаНалоговыйУчет.РаспределятьНалогиПоПодразделениямОрганизаций,
		|	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяВкладчикомОППВ,
		|	ЛОЖЬ КАК ПоддержкаРаботыСоСтруктурнымиПодразделениями
		|ПОМЕСТИТЬ ВТ_Реквизиты
		|ИЗ
		|	ВТ_ДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаПоПерсоналуОрганизаций КАК УчетнаяПолитикаПоПерсоналуОрганизаций
		|		ПО ДанныеДокумента.Организация = УчетнаяПолитикаПоПерсоналуОрганизаций.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаНалоговыйУчет.СрезПоследних(&Период, ) КАК УчетнаяПолитикаНалоговыйУчет
		|		ПО ДанныеДокумента.Организация = УчетнаяПолитикаНалоговыйУчет.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Реквизиты.Дата,
		|	Реквизиты.Организация,
		|	Реквизиты.ПодразделениеОрганизации,
		|	Реквизиты.ЯвляетсяСтруктурнымПодразделением,
		|	Реквизиты.СтруктурноеПодразделение,
		|	Реквизиты.ГоловнаяОрганизация,
		|	Реквизиты.ПериодРегистрации,
		|	Реквизиты.Ссылка,
		|	Реквизиты.ВидПлатежа,
		|	Реквизиты.ВидОперации,
		|	Реквизиты.РаспределятьНалогиПоСтруктурнымЕдиницам,
		|	Реквизиты.РаспределятьНалогиПоПодразделениямОрганизаций,
		|	Реквизиты.ОрганизацияЯвляетсяВкладчикомОППВ,
		|	Реквизиты.ПоддержкаРаботыСоСтруктурнымиПодразделениями
		|ИЗ
		|	ВТ_Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Процедура ПодготовитьТаблицыДокумента(Запрос, Реквизиты)
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсчислениеПени.НомерСтроки,
		|	ИсчислениеПени.ФизЛицо,
		|	ИсчислениеПени.МесяцНалоговогоПериода,
		|	ИсчислениеПени.СтруктурнаяЕдиница,
		|	ИсчислениеПени.ПодразделениеОрганизации,
		|	ИсчислениеПени.Сумма,
		|	ИсчислениеПени.ДатаНачала,
		|	ИсчислениеПени.ДатаОкончания
		|ПОМЕСТИТЬ ВТ_ИсчислениеПени
		|ИЗ
		|	Документ.РасчетПениОПВиСО.ИсчислениеПени КАК ИсчислениеПени
		|ГДЕ
		|	ИсчислениеПени.Ссылка = &Ссылка
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|	ИсчислениеПени.ФизЛицо,
		|	ИсчислениеПени.МесяцНалоговогоПериода КАК Период
		|ПОМЕСТИТЬ ВТ_ПериодыСотрудников
		|ИЗ 
		|	ВТ_ИсчислениеПени КАК ИсчислениеПени
		|";
			
	Запрос.Текст = Запрос.Текст + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета()
				 + РасчетЗарплатыСервер.СформироватьТекстЗапросаСтруктурныеЕдиницы("ВТ_ПериодыСотрудников", Истина, Реквизиты.ПоддержкаРаботыСоСтруктурнымиПодразделениями И НЕ Реквизиты.РаспределятьНалогиПоСтруктурнымЕдиницам);
	Результат = Запрос.Выполнить();
	                                                 
КонецПроцедуры

Функция ТекстЗапросаИсчислениеПени(НомераТаблиц, Реквизиты) 
	
	НомераТаблиц.Вставить("ИсчислениеПени", НомераТаблиц.Количество());
	ТекстЗапроса =  
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОНЕЦПЕРИОДА(Реквизиты.ПериодРегистрации, МЕСЯЦ) КАК Период,
		|	Реквизиты.ВидПлатежа КАК ВидПлатежа,
		|	СтрокаИсчислениеПени.ФизЛицо,
		|	СтрокаИсчислениеПени.МесяцНалоговогоПериода,
		|	СтрокаИсчислениеПени.Сумма КАК Взнос,
		|	СтрокаИсчислениеПени.Сумма КАК Отчисление,
		|	СтрокаИсчислениеПени.ДатаНачала,
		|	ЗНАЧЕНИЕ(Перечисление.РасчетыСБюджетомФондамиВидСтроки.Исчисление) КАК ВидСтроки,
		|	СтрокаИсчислениеПени.ДатаОкончания,
		|	СтрокаИсчислениеПени.НомерСтроки,
		|	ВЫБОР
		|		КОГДА Реквизиты.РаспределятьНалогиПоСтруктурнымЕдиницам И &ПоддержкаРаботыСоСтруктурнымиПодразделениями
		|			ТОГДА
		|				ВЫБОР
		|					КОГДА СтрокаИсчислениеПени.ПодразделениеОрганизации.ЯвляетсяСтруктурнымПодразделением
		|						ТОГДА СтрокаИсчислениеПени.ПодразделениеОрганизации
		|					КОГДА СтрокаИсчислениеПени.СтруктурнаяЕдиница НЕ В (&ПустыеСтруктурныеЕдиницы)
		|						ТОГДА СтрокаИсчислениеПени.СтруктурнаяЕдиница
		|					ИНАЧЕ Реквизиты.Организация
		|				КОНЕЦ
		|		КОГДА &ПоддержкаРаботыСоСтруктурнымиПодразделениями 
		|			ТОГДА
		|				ВЫБОР
		|					КОГДА СтрокаИсчислениеПени.СтруктурнаяЕдиница НЕ В (&ПустыеСтруктурныеЕдиницы)
		|						ТОГДА СтрокаИсчислениеПени.СтруктурнаяЕдиница
		|					КОГДА НЕ(МестоРаботы.СтруктурнаяЕдиница ЕСТЬ NULL)
		|						ТОГДА МестоРаботы.СтруктурнаяЕдиница
		|					ИНАЧЕ Реквизиты.Организация
		|				КОНЕЦ
		|		ИНАЧЕ Реквизиты.Организация
		|	КОНЕЦ КАК СтруктурнаяЕдиница,
		|   ВЫБОР 
		|		КОГДА Реквизиты.РаспределятьНалогиПоПодразделениямОрганизаций И СтрокаИсчислениеПени.ПодразделениеОрганизации <> ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
		|			ТОГДА СтрокаИсчислениеПени.ПодразделениеОрганизации
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
		|	КОНЕЦ КАК ПодразделениеОрганизации
		|
		|ИЗ
		|	ВТ_ИсчислениеПени КАК СтрокаИсчислениеПени
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Реквизиты КАК Реквизиты
		|		ПО ИСТИНА
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МестоРаботы КАК МестоРаботы
		|		ПО СтрокаИсчислениеПени.ФизЛицо = МестоРаботы.ФизЛицо
		|			И СтрокаИсчислениеПени.МесяцНалоговогоПериода = МестоРаботы.Период
		|
		|ГДЕ
		|	СтрокаИсчислениеПени.Сумма <> 0
		|
		|УПОРЯДОЧИТЬ ПО 
		|	СтрокаИсчислениеПени.НомерСтроки
		|";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецЕсли